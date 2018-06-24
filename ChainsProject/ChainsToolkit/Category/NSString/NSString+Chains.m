//
//  NSString+Chains.m
//  MyConclusion
//
//  Created by 马腾飞 on 15/8/21.
//  Copyright (c) 2015年 mtf. All rights reserved.
//

#import "NSString+Chains.h"
#import <CommonCrypto/CommonDigest.h>

#import <objc/runtime.h>

#define ASSOCIATIVE_CURRENT_DICTIONARY_KEY @"ASSOCIATIVE_CURRENT_DICTIONARY_KEY"
#define ASSOCIATIVE_CURRENT_TEXT_KEY @"ASSOCIATIVE_CURRENT_TEXT_KEY"

@interface NSString () <NSXMLParserDelegate>

@property(nonatomic, retain)NSMutableArray *currentDictionaries;
@property(nonatomic, retain)NSMutableString *currentText;

@end

@implementation NSString (Chains)

#pragma mark - 加解密,编解码
- (NSString *)chains_URLEncoding
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 CFSTR("!*'\"();:@&=+$,/?%#[]% "),
                                                                                 kCFStringEncodingUTF8));;
}

- (NSString *)chains_URLDecoding
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                 (CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8));
}

- (NSString *)chains_md5Str
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)chains_GBKDecode
{
    NSLog(@"解码前:%@",self);
    NSData *data=[self dataUsingEncoding:NSUTF8StringEncoding];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    if (retStr)
    {
        NSInteger max = [self length];
        char *nbytes = malloc(max + 1);
        for (int p=0;p < max; p++)
        {
            unichar ch = [self characterAtIndex:p];
            nbytes[p] = (char) ch;
        }
        nbytes[max] = '\0';
        retStr = [NSString stringWithCString: nbytes
                                    encoding: enc];
        NSLog(@"解码后:%@",retStr);
    }
    return retStr;
}

+ (NSData *)chains_AES256Encrypt:(NSString*)strSource withKey:(NSString*)key
{
    NSData *data = [strSource dataUsingEncoding:NSUTF8StringEncoding];
    return [data chains_AES256EncryptWithKey:[key chains_md5Str]];
}

+ (NSString*)chains_AES256Decrypt:(NSData*)dataSource withKey:(NSString*)key
{
    NSData *decryptData = [dataSource chains_AES256DecryptWithKey:[key chains_md5Str]];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}

+ (BOOL)chains_isEmpty:(NSString *)str
{
    if (str == nil || str == NULL) return YES;
    if ([str isKindOfClass:[NSNull class]]) return YES;
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) return YES;
    if ([str isEqualToString:@"(null)"]) return YES;
    if ([str isEqualToString:@"<null>"]) return YES;
    if ([str isEqualToString:@""]) return YES;
    return NO;
}

- (NSDictionary *)chains_transformURLQueryToParamsDic
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *nameValues = [self componentsSeparatedByString:@"&"];
    for (NSString *nameValue in nameValues) {
        NSArray *components = [nameValue componentsSeparatedByString:@"="];
        if ([components count] == 2) {
            NSString *name = [[components objectAtIndex:0] chains_URLDecoding];
            NSString *value = [[components objectAtIndex:1] chains_URLDecoding];
            if (name && value) {
                [dict setObject:value forKey:name];
            }
        }
    }
    return dict;
}


- (NSData *)chains_transformToData
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)chains_transformJsonStringToDictionary
{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (float)chains_extractNumber
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    float number;
    [scanner scanFloat:&number];
    NSLog(@"number : %f", number);
    return number;
}

- (BOOL)chains_includeChineseString
{
    NSUInteger length = [self length];
    for (NSUInteger i = 0; i < length; i++)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)chains_inversionOutputString:(NSString *)str
{
    NSMutableString* reverseString = [[NSMutableString alloc] init];
    NSInteger charIndex = [str length];
    while (charIndex > 0) {
        charIndex --;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reverseString appendString:[str substringWithRange:subStrRange]];
    }
    return reverseString;
}

- (NSString *)chains_deleteString:(NSString *)str
{
    NSMutableString *mutableStr = [NSMutableString stringWithString:self];
    [mutableStr deleteCharactersInRange:[mutableStr rangeOfString:str]];
    return [NSString stringWithString:mutableStr];
}

- (NSMutableAttributedString *)chains_setAttributedWithIdentifyStringArray:(NSArray *)identifyStringArray color:(UIColor *)color font:(UIFont *)font
{
    if (!self && !identifyStringArray) {
        return nil;
    }
    
    if (!identifyStringArray.count) {
        return nil;
    }
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    for (NSString *identifyString in identifyStringArray) {
        NSRange range = [self rangeOfString:identifyString];
        if (font) {
            [attributedStr addAttribute:NSFontAttributeName value:font range:range];
        }
        if (color) {
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
    }
    
    return attributedStr;
}

- (BOOL)chains_regularExpressionMatchWithExpression:(NSString *)expression
{
    NSError *error;
    NSRegularExpression * regex = [[NSRegularExpression alloc]initWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
//    NSMutableArray *resultArr = [NSMutableArray array];
//    [regex enumerateMatchesInString:self
//                            options:NSMatchingReportProgress
//                              range:NSMakeRange(0, [self length])
//                         usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
//                             NSString *matchResult = [self substringWithRange:result.range];
//                             NSLog(@"Match Result:%@\n", matchResult);
//                             [resultArr addObject:matchResult];
//                         }];
//    NSLog(@"ResultArr:%@",resultArr);
//    return (resultArr && resultArr.count > 0);
    NSArray *textCheckingResultArr = [regex matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, [self length])];
    return (textCheckingResultArr && textCheckingResultArr.count > 0);
}

- (void)chains_regularExpressionMatchWithExpression:(NSString *)expression complete:(void (^)(BOOL, NSArray *))complete
{
    NSError *error;
    NSRegularExpression * regex = [[NSRegularExpression alloc]initWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSMutableArray *resultArr = [NSMutableArray array];
    
    NSArray *textCheckingResultArr = [regex matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, [self length])];
    [textCheckingResultArr enumerateObjectsUsingBlock:^(NSTextCheckingResult *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *matchResult = [self substringWithRange:obj.range];
        NSLog(@"Match Result:%@\n", matchResult);
        [resultArr addObject:matchResult];
    }];
    
    if (complete) complete((resultArr.count>0),resultArr);
}


- (NSDictionary *)chains_dictionaryFromXML
{
    //TURN THE STRING INTO DATA
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    //INTIALIZE NECESSARY HELPER VARIABLES
    self.currentDictionaries = [[NSMutableArray alloc] init] ;
    self.currentText = [[NSMutableString alloc] init];
    
    //INITIALIZE WITH A DICTIONARY TO START WITH
    [self.currentDictionaries addObject:[NSMutableDictionary dictionary]];
    
    //DO PARSING
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];
    
    //RETURNS
    if(success)
        return [self.currentDictionaries objectAtIndex:0];
    else
        return nil;
}


#pragma mark -
#pragma mark ASSOCIATIVE OVERRIDES

- (void)setCurrentDictionaries:(NSMutableArray *)currentDictionaries
{
    objc_setAssociatedObject(self, ASSOCIATIVE_CURRENT_DICTIONARY_KEY, currentDictionaries, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)currentDictionaries
{
    return objc_getAssociatedObject(self, ASSOCIATIVE_CURRENT_DICTIONARY_KEY);
}

- (void)setCurrentText:(NSMutableString *)currentText
{
    objc_setAssociatedObject(self, ASSOCIATIVE_CURRENT_TEXT_KEY, currentText, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableString *)currentText
{
    return objc_getAssociatedObject(self, ASSOCIATIVE_CURRENT_TEXT_KEY);
}

#pragma mark -
#pragma mark NSXMLPARSER DELEGATE

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //GET THE LAST DICTIONARY
    NSMutableDictionary *parent = [self.currentDictionaries lastObject];
    
    //CREATE A NEW DICTIONARY AND SET ALL THE ATTRIBUTES
    NSMutableDictionary *child = [NSMutableDictionary dictionary];
    [child addEntriesFromDictionary:attributeDict];
    
    id currentValue = [parent objectForKey:elementName];
    
    //SHOULD BE AN ARRAY IF WE ALREADY HAVE ONE FOR THIS KEY, OTHERWISE JUST ADD IT IN
    if (currentValue)
    {
        NSMutableArray *array = nil;
        
        //IF CURRENTVALUE IS ALREADY AN ARRAY USE IT, OTHERWISE, MAKE ONE
        if ([currentValue isKindOfClass:[NSMutableArray class]])
            array = (NSMutableArray *) currentValue;
        else
        {
            array = [NSMutableArray array];
            [array addObject:currentValue];
            
            //REPLACE DICTIONARY WITH ARRAY IN PARENT
            [parent setObject:array forKey:elementName];
        }
        
        [array addObject:child];
    }
    else
        [parent setObject:child forKey:elementName];
    
    //ADD NEW OBJECT
    [self.currentDictionaries addObject:child];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //UPDATE PARENT INFO
    NSMutableDictionary *dictInProgress = [self.currentDictionaries lastObject];
    
    if ([self.currentText length] > 0)
    {
        //REMOVE WHITE SPACE
        [dictInProgress setObject:self.currentText forKey:@"text"];
        
        self.currentText = nil;
        self.currentText = [[NSMutableString alloc] init];
    }
    
    //NO LONGER NEED THIS DICTIONARY, AS WE'RE DONE WITH IT
    [self.currentDictionaries removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.currentText appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    //WILL RETURN NIL FOR ERROR
}

@end
