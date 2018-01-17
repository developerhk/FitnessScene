//
//  FMUString.h
//  FMLibrary
//
//  Created by leks on 13-3-22.
//  Copyright (c) 2013年 House365. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FMUSTRING_WRAP_D(_d) [NSString stringWithFormat:@"%d", _d]
#define FMUSTRING_WRAP_F(_f) [NSString stringWithFormat:@"%f", _f]
#define FMUSTRING_WRAP_COORD_LAT(_coord) [NSString stringWithFormat:@"%f,%f", _coord.latitude, _coord.longitude]
#define FMUSTRING_WRAP_COORD_LNG(_coord) [NSString stringWithFormat:@"%f,%f", _coord.longitude, _coord.latitude]

@interface FMUString : NSObject

//Base
+ (BOOL)isEmptyString:(NSString *)_str;
+ (BOOL)isEmptyStringBySpace:(NSString*)_str;
+ (BOOL)isEmptyStringFilterBlank:(NSString *)_str;
+(NSString*)bytesSizeText:(double)bytes;

+ (int)textLengthWithChineseAndEnglish:(NSString *)text;
+ (NSInteger)textLength:(NSString *)text;
+ (NSUInteger)theLenthOfStringFilterBlank:(NSString *)_str;
+ (CGFloat)heightForText:(NSString*)text withTextWidth:(CGFloat)textWidth withFont:(UIFont*)aFont;
+ (CGFloat)widthForText:(NSString*)text withTextHeigh:(CGFloat)textHeigh withFont:(UIFont*)aFont;
+ (BOOL)inputView:(id)inputView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text maxLength:(NSInteger)maxlength;

+(void)sizeToFitWebView:(UIWebView*)webview;

+ (BOOL)isNumberVaild:(NSString *)aString;
+ (BOOL)hasChineseCharacter:(NSString *)aString;
+ (BOOL)isFloatVaild:(NSString *)aString;
+(BOOL)digitACharacterAuth:(NSString*)password min:(NSInteger)min max:(NSInteger)max;
+(CGFloat)unicodeLengthOfString: (NSString *) text;

//Time
+ (NSString *)timeSinceDate:(NSDate *)date format:(NSString*)formatestr;
+ (NSString *)timeIntervalSince1970:(NSTimeInterval)secs Format:(NSString*)formatestr;
+ (NSTimeInterval)secTimeInterValSice1970:(NSString *)string Format:(NSString *)formatestr;
+ (NSString*)cusTimeSinceDate:(NSDate*)date format:(NSString*)formatestr;
+ (NSString*)cusTimeSinceDateNewRole:(NSDate*)date format:(NSString*)formatestr;
+ (NSString*)cusTimeSinceDateString:(NSString*)datestr Format:(NSString*)formatestr;

//URL
+ (BOOL)isURL:(NSString*)url;
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;
+ (NSDictionary *)getParamsFromUrl:(NSString*)urlQuery;
+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;

//HTML
+ (NSString*)filterHtml:(NSString*)str;
+ (NSString *)flattenHTML:(NSString *)html;

//Encode
+ (NSString*)encodedString:(NSString*)str;
+ (NSString*)encodeBase64:(NSData*)input;

//Phone
+ (BOOL)isPhoneNumber:(NSString *)phoneNum;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)telePhoneCall:(NSString*)telno;
+ (BOOL)telePhoneCallWithChecking:(NSString*)telno;

//HASH
+ (NSString*)hashString:(NSString*)str;


@end
