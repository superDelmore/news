//
//  MCUtil.h
//  iMagazine2
//
//  Created by dreamRen on 12-11-16.
//  Copyright (c) 2012年 iHope. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLangIsCn [StaticContext().lanName isEqualToString:@"cn"]

@interface MCUtil : NSObject
+ (BOOL)IsIpad;

#define ISIPAD [MCUtil IsIpad]

//保存一个字典
+(void)saveDictToDefaults:(NSMutableDictionary*)aDict withKey:(NSString*)aKey;

//保存一个string
+(void)saveStringToDefaults:(NSString*)aString withKey:(NSString*)aKey;

+(id)getObjectFromDefaultsWithKey:(NSString*)aKey;

///////////////

/**
 *获取屏幕frame大小的截图
 *@return 返回截取的图片
 */
+ (UIImage *)imageFromView:(UIView *)aview atFram:(CGRect)frame;

/**
 *获取某个view的截图
 */
+ (UIImage *)imageGetFromView:(UIView *)theView;

//根据设定的语言,本地化
+(NSString*)languageSelectedStringForKey:(NSString*)key;

//获取当前设定的语言
+(NSString*)getMyLangCode;

//from大小等比例缩小
+(CGSize)resizeFrom:(CGSize)fromSize To:(CGSize)toSize;
+(UIImage*)scaleFitImage:(UIImage*)aImage toSize:(CGSize)toSize;

//日期+随机数
+(NSString*)getTimeAndRandom;
//返回特定格式的图片名称
+(NSString*)getImageNameWithTimeAndRandom;

//获取当前时间 yyyy-MM-dd HH:mm
+(NSString *)getCurrentDate;

//检查设备
+(BOOL)checkDevice:(NSString *)name;

//获取当前界面语言,跟地区无关
+(NSString*)getCurLanguageCode;

//是否空格
+(BOOL)isEmptyOrWhitespace:(NSString*)aStr;

//////////////////////////////

+(NSUInteger)getRandomInt:(NSUInteger)aMinInt withMax:(NSUInteger)aMaxInt;
+(NSString *)getToday;
+(NSString *)formatToDay:(NSDate*)aDate;

/**
 *将时间字符串转换成月日并返回
 */
+ (NSString *)turnToMouthDayFromTime:(NSString *)timeString;

/**
 *比较输入时间与当前时间的时间差（秒数），并转换成天、时、分、秒返回
 *@param timeString 要比较的时间字符串
 *@return 返回与当前时间的时间差并转换成天数
 */
+ (NSString *)getDayToNowFromDate:(NSString *)timeString;

/**
 *比较输入时间与当前时间的时间差（秒数），并转换成天、时、分、秒返回
 *@param timeString 要比较的时间字符串
 *@return 返回与当前时间的时间差并转换成天数
 */
+ (NSString *)getNewDayToNowFromDate:(NSString *)timeString;


/**
 *比较输入时间与当前时间的时间差（秒数），并转换成天、时、分、秒返回
 *@param date 要比较的时间
 *@return 返回与当前时间的时间差并转换成天数
 */
+ (NSString *)getDayToNowFromDateTime:(NSDate *)date;

/**
 *比较输入时间与当前时间的时间差（秒数），并转换成天、时、分、秒返回
 *@param date 要比较的时间
 *@return 返回与当前时间的时间差并转换成天数
 */
+ (NSString *)getNewDayToNowFromDateTime:(NSDate *)date;


/**
 *显示一个AlertView提示网络下载失败
 */
+ (void)netWorkingFailed:(NSString *)aString andDelegate:(id)obj;

/**
 *字符串MD5加密
 *@param astring 要加密的字符串
 *@return 返回加密完成的字符串
 */
+ (NSString *)MD5String:(NSString *)astring;

/**
 *把字母名字以首字母顺序排列
 *@param nameArray 名称数组
 *@return 返回排序完成的数组
 */
+ (NSMutableArray *)sortByNameFirstLatter:(NSArray *)nameArray;

/**
 *掉手机号中的+86、86 '-' ' '等字符
 *@param 传入要修改的字符串以及要移除的字符字符串
 *@return 返回修改完成的字符串
 */
+ (NSString *)removecharactersFromString:(NSString *)string withCharacter:(NSString *)characters;

/**
 *只获取字符串中的数字
 *@param 传入要修改的字符串
 *@return 返回修改完成的字符串
 */
+ (NSString *)getOnlyNumsInString:(NSString *)string;

/**
 *登录提示框
 */
+ (void) needLoginAlertWithDelegate:(id)obj;

@end
