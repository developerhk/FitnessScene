//
//  FMUString.m
//  FMLibrary
//
//  Created by leks on 13-3-22.
//  Copyright (c) 2013年 House365. All rights reserved.
//

#import "FMUString.h"

//暴雪MPQ HASH算法
#define HASH_MAX_LENGTH 2*1024	//最大字符串长度(字节)
typedef unsigned int DWORD;		//类型定义
static DWORD cryptTable[0x500];		//哈希表
static bool HASH_TABLE_INITED = false;
static void prepareCryptTable();
DWORD HashString(const char *lpszFileName,DWORD dwCryptIndex);

@implementation FMUString

#pragma mark - Base
+ (BOOL)isEmptyString:(NSString *)_str
{
    if ([_str isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([_str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([_str isEqualToString:@""]) {
        return YES;
    }
    if (_str == nil) {
        return YES;
    }
    if (_str == NULL) {
        return YES;
    }
    if ((NSNull*)_str == [NSNull null]) {
        return YES;
    }
    return NO;
}

//全是空格
+ (BOOL)isEmptyStringBySpace:(NSString*)_str
{
    //全是空格不可完成提交
    if ([[_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isEmptyStringFilterBlank:(NSString *)_str
{
    if ([self isEmptyString:_str]) {
        return YES;
    }
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@",_str];
    [string replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    if (string.length == 0) {
        return YES;
    }
    return NO;
}

+(NSString*)bytesSizeText:(double)bytes
{
    NSString *ret = nil;
    double size = bytes;
    if (size > 1024*1024)
    {
        ret = [NSString stringWithFormat:@"%.1fMB", size / 1024.0 / 1024.0];
    }
    else if (size > 1024)
    {
        ret = [NSString stringWithFormat:@"%.0fKB", size / 1024.0];
    }
    else
    {
        ret = [NSString stringWithFormat:@"%.0f字节", size];
    }
    
    return ret;
}

+ (int)textLengthWithChineseAndEnglish:(NSString *)text
{
    int strlength = 0;
    char* p = (char*)[text cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

+ (NSInteger)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}

+ (NSUInteger)theLenthOfStringFilterBlank:(NSString *)_str
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@",_str];
    [string replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    return string.length;
}

+ (CGFloat)heightForText:(NSString*)text withTextWidth:(CGFloat)textWidth withFont:(UIFont*)aFont {
    CGSize size = [text sizeWithFont:aFont constrainedToSize:CGSizeMake(textWidth, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
}

+ (CGFloat)widthForText:(NSString*)text withTextHeigh:(CGFloat)textHeigh withFont:(UIFont*)aFont
{
    CGSize size = [text sizeWithFont:aFont constrainedToSize:CGSizeMake(MAXFLOAT, textHeigh) lineBreakMode:UILineBreakModeWordWrap];
    return size.width;
}

+ (BOOL)inputView:(id)inputView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text maxLength:(NSInteger)maxlength
{
    if (![inputView isKindOfClass:[UITextView class]] &&
        ![inputView isKindOfClass:[UITextField class]] &&
        ![inputView isKindOfClass:[UISearchBar class]]) {
        return NO;
    }
    
    if (range.length == 1 && text.length == 0) { //退格键
        return YES;
    }
    else {
        if (range.location < maxlength) {
            NSInteger re_length = maxlength - range.location;
            if (text.length > re_length) {
                NSRange liRange = NSMakeRange(0, re_length);
                NSString *liString = [text substringWithRange:liRange];
                
                if ([inputView isKindOfClass:[UITextView class]]) {
                    UITextView *textView = (UITextView *)inputView;
                    textView.text = [textView.text stringByReplacingCharactersInRange:range withString:liString];
                }
                else if ([inputView isKindOfClass:[UITextField class]])
                {
                    UITextField *textField = (UITextField *)inputView;
                    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:liString];
                }
                else if ([inputView isKindOfClass:[UISearchBar class]])
                {
                    UISearchBar *searchBar = (UISearchBar *)inputView;
                    searchBar.text = [searchBar.text stringByReplacingCharactersInRange:range withString:liString];
                }
                
                return NO;
            }
            return YES;
        }
        return NO;
    }
}

+(void)sizeToFitWebView:(UIWebView*)webview
{
    //    webview.scalesPageToFit = NO;
    CGRect rect = webview.frame;
    rect.size.height = 1;
    webview.frame = rect;
    
    int content_height = [[webview stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] integerValue];
    
    rect.size.height = content_height;
    webview.frame = rect;
    //    webview.scalesPageToFit = YES;
}

//判断是否为数字
+ (BOOL)isNumberVaild:(NSString *)aString
{
    NSString *Regex = @"^[0-9]*$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [phoneTest evaluateWithObject:aString];
}

+ (BOOL)hasChineseCharacter:(NSString *)aString {
    NSString *Regex = @"[\u4e00-\u9fa5\u30a1-\u30f6\u3041-\u3093\uFF00-\uFFFF]";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [phoneTest evaluateWithObject:aString];
}

+ (BOOL)isFloatVaild:(NSString *)aString
{
    NSString *Regex = @"^[0-9]+(.[0-9]{2})?$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [phoneTest evaluateWithObject:aString];
}
+(BOOL)digitACharacterAuth:(NSString*)password min:(NSInteger)min max:(NSInteger)max
{
    //6-16位数字或者英文字母
    if (password.length < min || password.length >max) {
        return NO;
    }
    NSString *Regex = @"^[a-zA-Z0-9]+$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [pwdTest evaluateWithObject:password];
}

//判断字数，包含中英文
+(CGFloat)unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    float unicodeLength = asciiLength / 2;
    if(asciiLength % 2) {
        unicodeLength++;
    }
    return unicodeLength;
}

#pragma mark - Time
//NSDate 2013-5-8 19:09 45 => yyyy-MM-dd
+ (NSString *)timeSinceDate:(NSDate *)date format:(NSString*)formatestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatestr];
    NSString *ret = [formatter stringFromDate:date];
    return ret;
}

//1233444s => "YYYY/MM/dd(formatestr)"
+ (NSString *)timeIntervalSince1970:(NSTimeInterval)secs Format:(NSString*)formatestr
{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    return [self timeSinceDate:date format:formatestr];
}

//"YYYY/MM/dd(formatestr)" => 1233444s
+ (NSTimeInterval)secTimeInterValSice1970:(NSString *)string Format:(NSString *)formatestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatestr];
    NSDate *date = [formatter dateFromString:string];
    
    NSTimeInterval sec = [date timeIntervalSince1970];
    
    return sec;
}

//NSDate 2013-5-8 19:09 45 => ***前 或 yyyy-MM-dd
+ (NSString*)cusTimeSinceDate:(NSDate*)date format:(NSString*)formatestr
{
    NSDate *now_dt = [NSDate date];
    
    NSTimeInterval real_seconds = [now_dt timeIntervalSinceDate:date];
    
	NSUInteger ttext = 0;
	NSString *ret = nil;
    
	if (real_seconds > 60*60*24)
	{
		ttext = real_seconds/60/60/24;
        if (ttext <= 2) {
            ret = [NSString stringWithFormat:@"%d天前", ttext];
        }
        else
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:formatestr];
            ret = [formatter stringFromDate:date];
        }
        
	}
	else if (real_seconds > 60*60)
	{
		ttext = real_seconds/60/60;
        ret = [NSString stringWithFormat:@"%d小时前", ttext];
	}
	else
	{
		ttext = real_seconds/60;
        ret = [NSString stringWithFormat:@"%d分钟前", ttext];
	}
    return ret;
}

//NSDate 2013-5-8 19:09 45 => ***前 或 yyyy-MM-dd hh:mm 为了适应新的时间规则增加的方法
/*
 //规则：当天：1分钟以内：刚刚
             1小时以内：xx分钟前
             超过1小时：hh:mm
        非当天：昨天、前天、日期
 */
+ (NSString*)cusTimeSinceDateNewRole:(NSDate*)date format:(NSString*)formatestr
{
    NSDate *now_dt = [NSDate date];
    
    NSTimeInterval real_seconds = [now_dt timeIntervalSinceDate:date];
    
	NSUInteger ttext = 0;
	NSString *ret = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatestr];
    
    NSString * time = [formatter stringFromDate:date];
    
    
    if(real_seconds > 60*60*24)
    {
        ttext = real_seconds/60/60/24;
        if (ttext <= 1) {
            ret = [NSString stringWithFormat:@"%@",@"昨天"];
        }
        else if (ttext > 1 && ttext <= 2)
        {
            ret = [NSString stringWithFormat:@"%@",@"前天"];
        }
        else
        {
            ret = [NSString stringWithFormat:@"%@",[time substringWithRange:NSMakeRange(0, 8)]];
            
        }
    }
    else if (real_seconds >= 60* 60)
    {
        ret = [NSString stringWithFormat:@"%@",[time substringWithRange:NSMakeRange(9, 5)]];
    }
    else if (real_seconds > 60 &&
             real_seconds < 60*60)
    {
        ttext = real_seconds/60;
        ret = [NSString stringWithFormat:@"%d分钟前", ttext];
    }
    else if (real_seconds <=60 ) {
        ret = [NSString stringWithFormat:@"刚刚"];
    }

    return ret;
}

//"YYYY/MM/dd(formatestr)" => ***前 或 yyyy-MM-dd(formatestr)
+ (NSString*)cusTimeSinceDateString:(NSString*)datestr Format:(NSString*)formatestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formatestr];
	NSDate *pub_dt = [formatter dateFromString:datestr];

    return [self cusTimeSinceDate:pub_dt format:formatestr];
}

#pragma mark - URL
//是否为url
+ (BOOL)isURL:(NSString*)url
{
    NSString *regex = @"(http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?";
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [urlPredicate evaluateWithObject:url];
    return result;
}


//解析url参数
+ (NSDictionary *)getParamsFromUrl:(NSString*)urlQuery
{
    NSArray *pairs = [urlQuery componentsSeparatedByString:@"&"];
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:10];
    for (int i=0; i<pairs.count; i++)
    {
        NSString *pair = [pairs objectAtIndex:i];
        NSArray *tmp = [pair componentsSeparatedByString:@"="];
        if (tmp.count > 1)
        {
            [md setObject:[tmp objectAtIndex:1] forKey:[tmp objectAtIndex:0]];
        }
    }
    return md;
}

//解析url参数
+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

#pragma mark - HTML
+ (NSString*)filterHtml:(NSString*)str
{
    if (!str) {
        return nil;
    }
    
    NSMutableString *ms = [NSMutableString stringWithCapacity:10];
    [ms setString:str];
    [ms replaceOccurrencesOfString:@"<p>" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"</p>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"<br />" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"<br>" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"<br/>" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&nbsp;" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"\t" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&#8226;" withString:@"•" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&#" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&ldquo;" withString:@"“" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&rdquo;" withString:@"”" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&mdash;" withString:@"—" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&lsquo;" withString:@"‘" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&rsquo;" withString:@"’" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];

    
    while ([ms hasPrefix:@"\r\n"])
    {
        [ms replaceOccurrencesOfString:@"\r\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, ms.length>5?5:ms.length)];
    }
    
    while ([ms replaceOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)] > 0)
    {
        
    }
    
    while ([ms replaceOccurrencesOfString:@"\n\n" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)] > 0)
    {
        
    }
    
    return ms;
}

//过滤HTML标签
+ (NSString *)flattenHTML:(NSString *)html
{
	if (!html)
	{
		return nil;
	}
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    NSString *ret = [NSString stringWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        ret = [ret stringByReplacingOccurrencesOfString:
               [ NSString stringWithFormat:@"%@>", text]
                                             withString:@" "];
        
    } // while //
    
    return ret;
}

+ (NSString*)encodeBase64:(NSData*)input
{
    //NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
//    NSData *data = [GTMBase64 encodeData:input];
//    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return [base64String autorelease];
    return nil;
}

#pragma mark - Phone
+ (BOOL)isPhoneNumber:(NSString *)mobileNum {
    //电话号码，包括手机号，坐机号，400电话
    NSArray *nums = [mobileNum componentsSeparatedByString:@","];
    NSString *filterMobileNum = [nums objectAtIndex:0];
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,181,189
     */
    
    NSString * PHONE = @"^\\d{11}$";  //11位手机号
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,181,189
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSString * PHSS = @"^\\d{7,8}$";   //8位不带区号
    NSString * SERVICE = @"^\\d{5}$";  //5位客服
    
    NSPredicate *regextestPhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHONE];
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    NSPredicate *regextestphss = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHSS];
    NSPredicate *regextestser = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", SERVICE];
    
    if (([regextestPhone evaluateWithObject:filterMobileNum] == YES)
        || ([regextestmobile evaluateWithObject:filterMobileNum] == YES)
        || ([regextestcm evaluateWithObject:filterMobileNum] == YES)
        || ([regextestct evaluateWithObject:filterMobileNum] == YES)
        || ([regextestcu evaluateWithObject:filterMobileNum] == YES)
        || ([regextestphs evaluateWithObject:filterMobileNum] == YES)
        || ([regextestphss evaluateWithObject:filterMobileNum] == YES)
        || ([regextestser evaluateWithObject:filterMobileNum] == YES))
    {
        return YES;
    }
    //对14开头的号码，认为是合法的
    if ([[filterMobileNum substringToIndex:2]isEqualToString:@"14"]) {
        return YES;
    }
    //400电话认为是合法的
    if ([[filterMobileNum substringToIndex:3]isEqualToString:@"400"]) {
        return YES;
    }
    
    else
    {
        return NO;
    }
}
/**
 * 手机号码
 * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
 * 联通：130,131,132,152,155,156,185,186
 * 电信：133,1349,153,180,189
 */
+(BOOL)isMobileNumber:(NSString *)text
{
    //手机号码，11位
    NSString *Regex = @"^((13[0-9]{1})|(14[5-7]{1})|(15[0-9]{1})|(18[0-9]{1})|(170))[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [phoneTest evaluateWithObject:text];
    
//    NSString * MOBILE = @"^0{0,1}(13[0-9]|15[7-9]|153|156|18[7-9])[0-9]{8}$";
//        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//
//    if (([regextestmobile evaluateWithObject:text] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
    
}

+ (BOOL)telePhoneCall:(NSString*)telno
{
    if(![[[UIDevice currentDevice] model] isEqual:@"iPhone"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的设备不能拨打电话" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    NSString *phoneNum = telno;
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"\u8f6c" withString:@","];
    
    NSArray *nums = [phoneNum componentsSeparatedByString:@"/"];
    phoneNum = [nums objectAtIndex:0];
    
    if (phoneNum == nil || [phoneNum isEqualToString:@""]) {
        phoneNum = @"400-8181-365";
    }
    
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNum]];
    [[UIApplication sharedApplication] openURL:telURL];
    return YES;
}

@end

#pragma mark - //暴雪MPQ HASH算法
//生成哈希表
static void prepareCryptTable()
{
	DWORD dwHih, dwLow,seed = 0x00100001,index1 = 0,index2 = 0, i;
	for(index1 = 0; index1 < 0x100; index1++)
	{
		for(index2 = index1, i = 0; i < 5; i++, index2 += 0x100)
		{
			seed = (seed * 125 + 3) % 0x2AAAAB;
			dwHih= (seed & 0xFFFF) << 0x10;
			seed = (seed * 125 + 3) % 0x2AAAAB;
			dwLow= (seed & 0xFFFF);
			cryptTable[index2] = (dwHih| dwLow);
		}
	}
}

//生成HASH值
DWORD HashString(const char *lpszFileName,DWORD dwCryptIndex)
{
	if (!HASH_TABLE_INITED)
	{
		prepareCryptTable();
		HASH_TABLE_INITED = true;
	}
	unsigned char *key = (unsigned char *)lpszFileName;
	DWORD seed1 = 0x7FED7FED, seed2 = 0xEEEEEEEE;
	int ch;
	while(*key != 0)
	{
		ch = *key++;
		seed1 = cryptTable[(dwCryptIndex<< 8) + ch] ^ (seed1 + seed2);
		seed2 = ch + seed1 + seed2 + (seed2 << 5) + 3;
	}
	return seed1;
}
