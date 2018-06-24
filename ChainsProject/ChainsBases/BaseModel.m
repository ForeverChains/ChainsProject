//
//  BaseModel.m
//  Summary
//
//  Created by 马腾飞 on 16/4/27.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "BaseModel.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation BaseModel

#pragma mark - 字典转模型
- (instancetype)initWithDic:(NSDictionary *)dic replacedSpecialKeyDic:(NSDictionary *)specialKeyDic
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    //获取所有属性
    NSArray *propertyArray = [[self propertyClassesByName] allKeys];
    //遍历属性数组，在字典里根据属性名得到值，进行赋值  *注意：特殊键名需要进行特殊处理，如果dic[propertyName]不存在，则遍历specialKeyDic看是否存在匹配值
    [propertyArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull propertyName, NSUInteger idx, BOOL * _Nonnull stop) {
        //判断值是否存在，若存在则进行赋值
        if(dic){
            if (dic[propertyName])
            {
                [self setValue:dic[propertyName] forKey:propertyName];
            }
            else if (specialKeyDic)
            {
                if ([[specialKeyDic allKeys] containsObject:propertyName] && dic[specialKeyDic[propertyName]])
                {
                    [self setValue:dic[specialKeyDic[propertyName]] forKey:propertyName];
                }
            }
        }
        
    }];
    
    return self;
}

//含特殊键需重写覆盖该方法
+ (instancetype)modelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic replacedSpecialKeyDic:nil];
}

#pragma mark - 模型转字典
- (NSMutableDictionary *)keyValues
{
    id keyValues = [NSMutableDictionary dictionary];
    
    //获取支持kvc的属性
    NSDictionary *propertyDic = [self propertyClassesByName];
    [propertyDic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, Class  _Nonnull c, BOOL * _Nonnull stop) {
        //取值
        id value = [self valueForKey:key];
        //如果为对象类型，判断是否为模型
        if ([c isSubclassOfClass:[NSObject class]])
        {
            if ([c isSubclassOfClass:[BaseModel class]])
            {
                //模型
                value = [value keyValues];
            }
            else if ([value isKindOfClass:[NSArray class]])
            {
               //处理数组里面有模型的情况
                NSMutableArray *keyValuesArray = [NSMutableArray array];
                for (id object in value)
                {
                    if ([object isKindOfClass:[BaseModel class]])
                    {
                        [keyValuesArray addObject:[object keyValues]];
                    }
                    else
                    {
                        [keyValuesArray addObject:object];
                    }
                }
                value = keyValuesArray;
            }
            else if (c == [NSURL class])
            {
                value = [value absoluteString];
            }
        }
        
        //赋值
        if (value) [keyValues setObject:value forKey:key];
    }];
    
    return keyValues;
}

//Ivar：定义对象的实例变量，包括类型和名字。
/*
 @synthesize foo = foo; // This *will* be encoded
 @synthesize foo = _foo; // So will this
 @synthesize foo = foo_; // But this *won't* be
 @synthesize foo = bar; // Nor will this
 */

#pragma mark - 归档与解档
//支持NSSecureCoding
+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (!self)
    {
        return nil;
    }
    
    [[self propertyClassesByName] enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, Class  _Nonnull propertyClass, BOOL * _Nonnull stop) {
        id object = [aDecoder decodeObjectOfClass:propertyClass forKey:key];
        if (object) [self setValue:object forKey:key];
    }];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in [[self propertyClassesByName] allKeys])
    {
        id object = [self valueForKey:key];
        if (object) [aCoder encodeObject:object forKey:key];
    }
}

/*
 对象归档
 BOOL archiverSuccess = [NSKeyedArchiver archiveRootObject:model toFile:path];
 NSLog(@"存储对象:%d",archiverSuccess);
 
 对象解档
 NSObject *model = [NSKeyedUnarchiver unarchiveObjectWithFile:userPath];
 */

#pragma mark - description
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@:\n%@",[self class],[self keyValues]];
}

#pragma mark - 属性及类型获取
//_cmd在Objective-C的方法中表示当前方法的selector,常见用于NSStringFromSelector(_cmd)
//为了支持NSSecureCoding，获取属性类型
- (NSDictionary *)propertyClassesByName
{
    // Check for a cached value (we use _cmd as the cache key,
    // which represents @selector(propertyNames))
    NSMutableDictionary *dictionary = objc_getAssociatedObject([self class], _cmd);
    if (dictionary)
    {
        return dictionary;
    }
    
    // Loop through our superclasses until we hit NSObject
    dictionary = [NSMutableDictionary dictionary];
    Class subclass = [self class];
    while (subclass != [NSObject class])
    {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(subclass,
                                                             &propertyCount);
        for (int i = 0; i < propertyCount; i++)
        {
            // Get property name
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *key = @(propertyName);
            
            // Check if there is a backing ivar
            char *ivar = property_copyAttributeValue(property, "V");
            if (ivar)
            {
                // Check if ivar has KVC-compliant name
                NSString *ivarName = @(ivar);
                if ([ivarName isEqualToString:key] ||
                    [ivarName isEqualToString:[@"_" stringByAppendingString:key]])
                {
                    // Get type
                    Class propertyClass = nil;
                    char *typeEncoding = property_copyAttributeValue(property, "T");
                    switch (typeEncoding[0])
                    {
                        case 'c': // Numeric types
                        case 'i':
                        case 's':
                        case 'l':
                        case 'q':
                        case 'C':
                        case 'I':
                        case 'S':
                        case 'L':
                        case 'Q':
                        case 'f':
                        case 'd':
                        case 'B':
                        {
                            propertyClass = [NSNumber class];
                            break;
                        }
                        case '*': // C-String
                        {
                            propertyClass = [NSString class];
                            break;
                        }
                        case '@': // Object
                        {
                            //如果要处理’@’类型，则需要提取出类名。类名可能包括协议（实际上我们并不需要用到），所以分割字符串拿准确的类名，然后使用NSClassFromString得到类
                            
                            // The objcType for classes will always be at least 3 characters long
                            if (strlen(typeEncoding) >= 3)
                            {
                                // Copy the class name as a C-String
                                char *cName = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                                
                                // Convert to an NSString for easier manipulation
                                NSString *name = @(cName);
                                
                                // Strip out and protocols from the end of the class name
                                NSRange range = [name rangeOfString:@"<"];
                                if (range.location != NSNotFound)
                                {
                                    name = [name substringToIndex:range.location];
                                }
                                
                                // Get class from name, or default to NSObject if no name is found
                                propertyClass = NSClassFromString(name) ?: [NSObject class];
                                free(cName);
                            }
                            break;
                        }
                        case '{': // Struct
                        {
                            propertyClass = [NSValue class];
                            break;
                        }
                        case '[': // C-Array
                        case '(': // Enum
                        case '#': // Class
                        case ':': // Selector
                        case '^': // Pointer
                        case 'b': // Bitfield
                        case '?': // Unknown type
                        default:
                        {
                            propertyClass = nil; // Not supported by KVC
                            break;
                        }
                    }
                    free(typeEncoding);
                    
                    // If known type, add to dictionary
                    if (propertyClass) dictionary[key] = propertyClass;
                }
                free(ivar);
            }
        }
        free(properties);
        subclass = [subclass superclass];
    }
    
    // Cache and return dictionary 运行时添加关联进行缓存
    /*
     objc_setAssociatedObject需要四个参数：源对象，关键字，关联的对象和一个关联策略。
     
     1 源对象alert
     2 关键字 唯一静态变量key associatedkey
     3 关联的对象 sender
     4 关键策略  OBJC_ASSOCIATION_ASSIGN
     */
    objc_setAssociatedObject([self class], _cmd, dictionary,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dictionary;
}

//参考文献
//http://iosdevelopertips.com/cocoa/nscoding-without-boilerplate.html
//http://www.cocoachina.com/industry/20140516/8445.html

@end
