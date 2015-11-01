//
//  MCUtil.m
//  iMagazine2
//
//  Created by dreamRen on 12-11-16.
//  Copyright (c) 2012年 iHope. All rights reserved.
//

#import "MCUtil.h"
#include <CommonCrypto/CommonDigest.h>
#import <netdb.h>
#import <QuartzCore/QuartzCore.h>
#import "MCPath.h"

@implementation MCUtil

//保存一个字典
+(void)saveDictToDefaults:(NSMutableDictionary*)aDict withKey:(NSString*)aKey{
    NSUserDefaults *myInfo=[NSUserDefaults standardUserDefaults];
    [myInfo setObject:aDict forKey:aKey];
    [myInfo synchronize];
}

//保存一个string
+(void)saveStringToDefaults:(NSString*)aString withKey:(NSString*)aKey{
    NSUserDefaults *myInfo=[NSUserDefaults standardUserDefaults];
    [myInfo setObject:aString forKey:aKey];
    [myInfo synchronize];
}

+(id)getObjectFromDefaultsWithKey:(NSString*)aKey{
    NSUserDefaults *myInfo=[NSUserDefaults standardUserDefaults];
    return [myInfo objectForKey:aKey];
}

//根据view.frame大小截取图像
+ (UIImage *)imageFromView:(UIView *)aview atFram:(CGRect)frame
{
    UIGraphicsBeginImageContext(aview.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(frame);
    [aview.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  theImage;
}

//获取某个view的截图
+ (UIImage *)imageGetFromView:(UIView *)theView
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT), YES, 0);

//    UIGraphicsBeginImageContext(theView.bounds.size);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//////////

//根据设定的语言,本地化
+(NSString*)languageSelectedStringForKey:(NSString*)key{
    NSUserDefaults *myInfo=[NSUserDefaults standardUserDefaults];
    NSString *path= [[NSBundle mainBundle] pathForResource:[myInfo objectForKey:@"lang"] ofType:@"lproj"];
    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
    NSString* str=[languageBundle localizedStringForKey:key value:@"" table:nil];
    return str;
}

//获取当前设定的语言
+(NSString*)getMyLangCode{
    NSUserDefaults *myInfo=[NSUserDefaults standardUserDefaults];
    return [myInfo objectForKey:@"lang"];
}


//from大小等比例缩小
+(CGSize)resizeFrom:(CGSize)fromSize To:(CGSize)toSize{
    
    float iWidth=toSize.width;
    float iHeight=toSize.height;

    float iImageWidth=fromSize.width;
    float iImageHeight=fromSize.height;
    
    if (iImageWidth>0 && iImageHeight>0) {
        if (iImageWidth/iImageHeight >= iWidth/iHeight) {
            iImageHeight=iWidth*iImageHeight/iImageWidth;
            iImageWidth=iWidth;
        }else{
            iImageWidth=iHeight*iImageWidth/iImageHeight;
            iImageHeight=iHeight;
        }
    }
    
    return CGSizeMake(iImageWidth, iImageHeight);
}

+(UIImage*)scaleFitImage:(UIImage*)aImage toSize:(CGSize)toSize{
    float iWidth=toSize.width;
    float iHeight=toSize.height;
    
    float iImageWidth=aImage.size.width;
    float iImageHeight=aImage.size.height;
    
    if (iImageWidth>0 && iImageHeight>0) {
        if (iImageWidth/iImageHeight >= iWidth/iHeight) {
            iImageHeight=iWidth*iImageHeight/iImageWidth;
            iImageWidth=iWidth;
        }else{
            iImageWidth=iHeight*iImageWidth/iImageHeight;
            iImageHeight=iHeight;
        }
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(iImageWidth, iImageHeight));
    [aImage drawInRect:CGRectMake(0, 0, iImageWidth, iImageHeight)];
    UIImage *tEndImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tEndImage;
}

//日期+随机数
+(NSString*)getTimeAndRandom{
    int iRandom=arc4random();
	if (iRandom<0) {
		iRandom=-iRandom;
	}
	
	NSDateFormatter *tFormat=[[[NSDateFormatter alloc] init] autorelease];
	[tFormat setDateFormat:@"yyyyMMddHHmmssSSS"];
	NSString *tResult=[NSString stringWithFormat:@"%@%d",[tFormat stringFromDate:[NSDate date]],iRandom];
    return tResult;
}

+(NSString*)getImageNameWithTimeAndRandom{
    int iRandom=arc4random();
    iRandom=abs(iRandom%100000);
	if (iRandom<10000) {
		iRandom+=10000;
	}
	
	NSDateFormatter *tFormat=[[[NSDateFormatter alloc] init] autorelease];
	[tFormat setDateFormat:@"yyyyMMddHHmmss"];
	NSString *tResult=[NSString stringWithFormat:@"%@%d.png",[tFormat stringFromDate:[NSDate date]],iRandom];
    return tResult;
    // http://mkt.cndkseeds.com
}

//获取当前时间 yyyy-MM-dd HH:mm
+(NSString *)getCurrentDate
{
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

//时间转换成月日
+ (NSString *)turnToMouthDayFromTime:(NSString *)timeString
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN "] autorelease]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *aDate = [formatter dateFromString:timeString];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *mouthDay = [formatter stringFromDate:aDate];
    return mouthDay;
}

//检查设备
+(BOOL)checkDevice:(NSString *)name{
	NSString *deviceType = [UIDevice currentDevice].model;
	NSRange range = [deviceType rangeOfString:name];
	return range.location != NSNotFound;
}

//获取当前界面语言,跟地区无关
+(NSString*)getCurLanguageCode{
    //    简体中文:zh-Hans
    //    繁体中文:zh-Hant
    //    英文:en
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    //    NSLog(@"%@",[defs dictionaryRepresentation]);
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    //    NSLog(@"langList==%@",languages);
    return [languages objectAtIndex:0];
}

+(BOOL)isEmptyOrWhitespace:(NSString*)aStr {
    // A nil or NULL string is not the same as an empty string
    return 0 == aStr.length || ![aStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

//////////////////////////////
//////////////////////////////

+(NSUInteger)getRandomInt:(NSUInteger)aMinInt withMax:(NSUInteger)aMaxInt{
    NSInteger iRandom=arc4random();
    iRandom=iRandom % aMaxInt;
    if (iRandom<aMinInt) {
        iRandom=aMinInt+iRandom % (aMaxInt-aMinInt);
    }
    return iRandom;
}

+(NSString *)getToday
{
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(NSString *)formatToDay:(NSDate*)aDate
{
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:aDate];
}

+ (BOOL)IsIpad {
    NSString *devicename = [UIDevice currentDevice].model;
    if (devicename) {
        NSRange range = [devicename rangeOfString:@"iPad" options:NSCaseInsensitiveSearch];
        if (range.length>0) {
            return YES;
        }
    }
    return NO;
}

//比较输入时间与当前时间的时间差（秒数），并转换成天、时、分、秒返回

+ (NSString *)getDayToNowFromDate:(NSString *)timeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"] autorelease]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *aDate = [formatter dateFromString:timeString];
    [formatter release];
    NSInteger time = (-[aDate timeIntervalSinceNow]);
//    NSLog(@"%d",time);
    NSInteger day = time/(3600*24);
    NSInteger hour = time/3600%24;
    NSInteger min = (time-(day*3600*24)-hour*3600)/60;
//    NSInteger sec = (time-day*3600*24-hour*3600-min*60);
//    NSString *astring = [NSString stringWithFormat:@"%d天%d时%d分%d秒",day,hour,min,sec];
//    NSLog(@"atring = %@",astring);
    if (day<1) {
        if (hour<1) {
            if (min<1) {
                return @"刚刚";
            }
            
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
            
            return [NSString stringWithFormat:@"%lu分前",min];
            
#else
            
            return [NSString stringWithFormat:@"%i分前",min];
            
#endif
        }
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
        
        return [NSString stringWithFormat:@"%lu小时前",hour];
        
#else
        
        return [NSString stringWithFormat:@"%u小时前",hour];
        
#endif
    }else
        return [timeString substringWithRange:NSMakeRange(5, 11)];
//        return [NSString stringWithFormat:@"%u小时前",day];

    
//    return astring;
}

//比较输入时间与当前时间的时间差（秒数），并转换成天、时、分、秒返回

+ (NSString *)getNewDayToNowFromDate:(NSString *)timeString
{
    if ([timeString isKindOfClass:[NSNull class]] || timeString == nil) {
        return @"1分钟前";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"] autorelease]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *aDate = [formatter dateFromString:timeString];
    [formatter release];
    NSInteger time = (-[aDate timeIntervalSinceNow]);
    //    NSLog(@"%d",time);
    NSInteger day = time/(3600*24);
    if (day<1) {
        return [timeString substringWithRange:NSMakeRange(11, 5)];
    }else{
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
        
        return [NSString stringWithFormat:@"%lu天前",day];
        
#else
        
        return [NSString stringWithFormat:@"%u天前",day];
        
#endif

    }
}

//比较输入时间与当前时间的时间差（秒数），并转换成天、时、分、秒返回
+ (NSString *)getDayToNowFromDateTime:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN "] autorelease]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeString = [formatter stringFromDate:date];
    [formatter release];

    NSInteger time = (-[date timeIntervalSinceNow]);
    //    NSLog(@"%d",time);
    NSInteger day = time/(3600*24);
    NSInteger hour = time/3600%24;
    NSInteger min = (time-(day*3600*24)-hour*3600)/60;

    if (day<1) {
        if (hour<1) {
            if (min<1) {
                return @"刚刚";
            }
            return [NSString stringWithFormat:@"%zi分前",min];
        }
        return [NSString stringWithFormat:@"%zi小时前",hour];
    }else
        return [timeString substringWithRange:NSMakeRange(5, 11)];
}

//比较输入时间与当前时间的时间差（秒数），并转换成天、时、分、秒返回
+ (NSString *)getNewDayToNowFromDateTime:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN "] autorelease]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeString = [formatter stringFromDate:date];
    [formatter release];
    
    NSInteger time = (-[date timeIntervalSinceNow]);
    NSInteger day = time/(3600*24);
    
    if (day<1) {
        return [timeString substringWithRange:NSMakeRange(11, 5)];
    }else{
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
        
        return [NSString stringWithFormat:@"%lu天前",day];
        
#else
        
        return [NSString stringWithFormat:@"%u天前",day];
#endif
    }
}


//显示一个AlertView提示网络下载失败
+ (void)netWorkingFailed:(NSString *)aString andDelegate:(id)obj;
{
    if (!aString) {
        aString = @"网络连接失败，请检查网络连接";
    }else{
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:aString delegate:obj cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

//对字符串进行MD5加密
+ (NSString *)MD5String:(NSString *)astring
{
    const char *original_str = [astring UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return hash;
}

//把字母名字以首字母顺序排列
+ (NSMutableArray *)sortByNameFirstLatter:(NSArray *)nameArray
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSMutableArray *aArray = [NSMutableArray array];
    NSMutableArray *bArray = [NSMutableArray array];
    NSMutableArray *cArray = [NSMutableArray array];
    NSMutableArray *dArray = [NSMutableArray array];
    NSMutableArray *eArray = [NSMutableArray array];
    NSMutableArray *fArray = [NSMutableArray array];
    NSMutableArray *gArray = [NSMutableArray array];
    NSMutableArray *hArray = [NSMutableArray array];
    NSMutableArray *iArray = [NSMutableArray array];
    NSMutableArray *jArray = [NSMutableArray array];
    NSMutableArray *kArray = [NSMutableArray array];
    NSMutableArray *lArray = [NSMutableArray array];
    NSMutableArray *mArray = [NSMutableArray array];
    NSMutableArray *nArray = [NSMutableArray array];
    NSMutableArray *oArray = [NSMutableArray array];
    NSMutableArray *pArray = [NSMutableArray array];
    NSMutableArray *qArray = [NSMutableArray array];
    NSMutableArray *rArray = [NSMutableArray array];
    NSMutableArray *sArray = [NSMutableArray array];
    NSMutableArray *tArray = [NSMutableArray array];
    NSMutableArray *uArray = [NSMutableArray array];
    NSMutableArray *vArray = [NSMutableArray array];
    NSMutableArray *wArray = [NSMutableArray array];
    NSMutableArray *xArray = [NSMutableArray array];
    NSMutableArray *yArray = [NSMutableArray array];
    NSMutableArray *zArray = [NSMutableArray array];
    NSMutableArray *otherArray = [NSMutableArray array];
    
    for (NSDictionary *dict in nameArray) {
        NSString *pinyin = [dict objectForKey:@"pinyin"];
        if (pinyin) {
            if ([pinyin hasPrefix:@"a"]||[pinyin hasPrefix:@"A"]) {
                [aArray addObject:dict];
            }else if ([pinyin hasPrefix:@"b"]||[pinyin hasPrefix:@"B"]){
                [bArray addObject:dict];
            }else if ([pinyin hasPrefix:@"c"]||[pinyin hasPrefix:@"C"]){
                [cArray addObject:dict];
            }else if ([pinyin hasPrefix:@"d"]||[pinyin hasPrefix:@"D"]){
                [dArray addObject:dict];
            }else if ([pinyin hasPrefix:@"e"]||[pinyin hasPrefix:@"E"]){
                [eArray addObject:dict];
            }else if ([pinyin hasPrefix:@"f"]||[pinyin hasPrefix:@"F"]){
                [fArray addObject:dict];
            }else if ([pinyin hasPrefix:@"g"]||[pinyin hasPrefix:@"G"]){
                [gArray addObject:dict];
            }else if ([pinyin hasPrefix:@"h"]||[pinyin hasPrefix:@"H"]){
                [hArray addObject:dict];
            }else if ([pinyin hasPrefix:@"i"]||[pinyin hasPrefix:@"I"]){
                [iArray addObject:dict];
            }else if ([pinyin hasPrefix:@"j"]||[pinyin hasPrefix:@"J"]){
                [jArray addObject:dict];
            }else if ([pinyin hasPrefix:@"k"]||[pinyin hasPrefix:@"K"]){
                [kArray addObject:dict];
            }else if ([pinyin hasPrefix:@"l"]||[pinyin hasPrefix:@"L"]){
                [lArray addObject:dict];
            }else if ([pinyin hasPrefix:@"m"]||[pinyin hasPrefix:@"M"]){
                [mArray addObject:dict];
            }else if ([pinyin hasPrefix:@"n"]||[pinyin hasPrefix:@"N"]){
                [nArray addObject:dict];
            }else if ([pinyin hasPrefix:@"o"]||[pinyin hasPrefix:@"O"]){
                [oArray addObject:dict];
            }else if ([pinyin hasPrefix:@"p"]||[pinyin hasPrefix:@"P"]){
                [pArray addObject:dict];
            }else if ([pinyin hasPrefix:@"q"]||[pinyin hasPrefix:@"Q"]){
                [qArray addObject:dict];
            }else if ([pinyin hasPrefix:@"r"]||[pinyin hasPrefix:@"R"]){
                [rArray addObject:dict];
            }else if ([pinyin hasPrefix:@"s"]||[pinyin hasPrefix:@"S"]){
                [sArray addObject:dict];
            }else if ([pinyin hasPrefix:@"t"]||[pinyin hasPrefix:@"T"]){
                [tArray addObject:dict];
            }else if ([pinyin hasPrefix:@"u"]||[pinyin hasPrefix:@"U"]){
                [uArray addObject:dict];
            }else if ([pinyin hasPrefix:@"v"]||[pinyin hasPrefix:@"V"]){
                [vArray addObject:dict];
            }else if ([pinyin hasPrefix:@"w"]||[pinyin hasPrefix:@"W"]){
                [wArray addObject:dict];
            }else if ([pinyin hasPrefix:@"x"]||[pinyin hasPrefix:@"X"]){
                [xArray addObject:dict];
            }else if ([pinyin hasPrefix:@"y"]||[pinyin hasPrefix:@"Y"]){
                [yArray addObject:dict];
            }else if ([pinyin hasPrefix:@"z"]||[pinyin hasPrefix:@"Z"]){
                [zArray addObject:dict];
            }else{
                [otherArray addObject:dict];
            }
        }
    }
    [mutableArray addObject:@{@"A":aArray}];
    [mutableArray addObject:@{@"B":bArray}];
    [mutableArray addObject:@{@"C":cArray}];
    [mutableArray addObject:@{@"D":dArray}];
    [mutableArray addObject:@{@"E":eArray}];
    [mutableArray addObject:@{@"F":fArray}];
    [mutableArray addObject:@{@"G":gArray}];
    [mutableArray addObject:@{@"H":hArray}];
    [mutableArray addObject:@{@"I":iArray}];
    [mutableArray addObject:@{@"J":jArray}];
    [mutableArray addObject:@{@"K":kArray}];
    [mutableArray addObject:@{@"L":lArray}];
    [mutableArray addObject:@{@"M":mArray}];
    [mutableArray addObject:@{@"N":nArray}];
    [mutableArray addObject:@{@"O":oArray}];
    [mutableArray addObject:@{@"P":pArray}];
    [mutableArray addObject:@{@"Q":qArray}];
    [mutableArray addObject:@{@"R":rArray}];
    [mutableArray addObject:@{@"S":sArray}];
    [mutableArray addObject:@{@"T":tArray}];
    [mutableArray addObject:@{@"U":uArray}];
    [mutableArray addObject:@{@"V":vArray}];
    [mutableArray addObject:@{@"W":wArray}];
    [mutableArray addObject:@{@"X":xArray}];
    [mutableArray addObject:@{@"Y":yArray}];
    [mutableArray addObject:@{@"Z":zArray}];
    [mutableArray addObject:@{@"#":otherArray}];

    return mutableArray;
}

//掉手机号中的+86、86 '-' ' '等字符
+ (NSString *)removecharactersFromString:(NSString *)string withCharacter:(NSString *)characters
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:characters];
    NSString *result = [[string stringByTrimmingCharactersInSet:set] stringByTrimmingCharactersInSet:characterSet];
    NSLog(@"result = %@",result);
    return result;
}

//只读取字符串中的数字
+ (NSString *)getOnlyNumsInString:(NSString *)string
{
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"012345689"];
    NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
    while (![scanner isAtEnd]) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:characterSet intoString:&buffer]) {
                [result appendString:buffer];
        }
    }
    return (NSString *)result;
}

//登录提示框
+ (void) needLoginAlertWithDelegate:(id)obj
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notification", nil) message:NSLocalizedString(@"needLogin", nil) delegate:obj cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"login", nil), nil];
    alert.tag = 11;
    [alert show];
}

@end
