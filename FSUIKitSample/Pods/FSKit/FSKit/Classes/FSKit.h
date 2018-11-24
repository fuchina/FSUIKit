//
//  FSKit.h
//  Pods
//
//  Created by fudon on 2017/6/17.
//
//

#import <UIKit/UIKit.h>
#import "FSRuntime.h"

@interface FSKit : NSObject

NSTimeInterval _fs_timeIntevalSince1970(void);
NSInteger _fs_integerTimeIntevalSince1970(void);

void _fs_userDefaults_setObjectForKey(id object,NSString *key);
id _fs_userDefaults_objectForKey(NSString *key);
void _fs_clearUserDefaults(void);

+ (id)objectFromJSonstring:(NSString *)jsonString;

+ (BOOL)popToController:(NSString *)className navigationController:(UINavigationController *)navigationController animated:(BOOL)animated;

+ (void)pushToViewControllerWithClass:(NSString *)className navigationController:(UINavigationController *)navigationController param:(NSDictionary *)param configBlock:(void (^)(id vc))configBlockParam;
+ (void)presentToViewControllerWithClass:(NSString *)className controller:(UIViewController *)viewController param:(NSDictionary *)param configBlock:(void (^)(UIViewController *vc))configBlockParam presentCompletion:(void(^)(void))completion;
+ (void)copyToPasteboard:(NSString *)copyString;

+ (void)letScreenLock:(BOOL)lock;                           // YES:让屏幕锁屏    NO：让屏幕不锁屏   【未测】
+ (void)gotoAppCentPageWithAppId:(NSString *)appID;         // 去App评分页
+ (void)setStatusBarBackgroundColor:(UIColor *)color;       // 设置状态栏颜色

+ (BOOL)isValidateEmail:(NSString *)str;
+ (BOOL)keyedArchiverWithArray:(NSArray *)array toFilePath:(NSString *)fileName;
+ (BOOL)keyedArchiverWithData:(NSData *)data toFilePath:(NSString *)fileName;
+ (BOOL)keyedArchiverWithNumber:(NSNumber *)number toFilePath:(NSString *)fileName;
+ (BOOL)keyedArchiverWithString:(NSString *)string toFilePath:(NSString *)fileName;
+ (BOOL)keyedArchiverWithDictionary:(NSDictionary *)dic toFilePath:(NSString *)fileName;
+ (BOOL)createFile:(NSString *)fileName withContent:(NSString *)string;
+ (BOOL)moveFile:(NSString *)filePath toPath:(NSString *)newPath;
+ (BOOL)renameFile:(NSString *)filePath toPath:(NSString *)newPath;
+ (BOOL)copyFile:(NSString *)filePath toPath:(NSString *)newPath;
+ (BOOL)removeFile:(NSString *)filePath;
+ (BOOL)isChinese:(NSString *)string;
+ (BOOL)isValidateUserPasswd :(NSString *)str;
+ (BOOL)isChar:(NSString *)str;
+ (BOOL)isNumber:(NSString *)str;
+ (BOOL)isString:(NSString *)aString containString:(NSString *)bString;
+ (BOOL)isStringContainsStringAndNumber:(NSString *)sourceString;
+ (BOOL)isURLString:(NSString *)sourceString;//0
// 判断字符串是否含有中文
+ (BOOL)isHaveChineseInString:(NSString *)string;
// 判断字符串是否全为数字
+ (BOOL)isAllNum:(NSString *)string;

BOOL _fs_isPureInt(NSString *string);
BOOL _fs_isPureFloat(NSString *string);
BOOL _fs_isValidateString(NSString *string);
BOOL _fs_isValidateArray(NSArray *array);
BOOL _fs_isValidateDictionary(NSDictionary *dictionary);
BOOL _fs_floatEqual(CGFloat aNumber,CGFloat bNumber);

// 判断是否为中文语言环境
+ (BOOL)isChineseEnvironment;

+ (NSInteger)weekdayStringFromDate:(NSDate *)inputDate;

+ (double)forwardValue:(double)number afterPoint:(int)position;  // 只入不舍
+ (double)usedMemory;                                                               // 获得应用占用的内存，单位为M
+ (double)availableMemory;                                                          // 获得当前设备可用内存,单位为M
+ (NSInteger)folderSizeAtPath:(NSString*)folderPath extension:(NSString *)extension;// 获取文件夹目录下的文件大小
+ (NSInteger)fileSizeAtPath:(NSString*)filePath;                                    // 获取文件的大小

// 获取磁盘大小（单位：Byte）
+ (CGFloat)diskOfAllSizeBytes;
// 磁盘可用空间
+ (CGFloat)diskOfFreeSizeBytes;
//获取文件夹下所有文件的大小
+ (long long)folderSizeAtPath:(NSString *)folderPath;
// 手机可用内存
+ (double)availableMemoryNew;
// 当前app所占内存（RAM）
+ (double)currentAppMemory;
+ (CGSize)keyboardNotificationScroll:(NSNotification *)notification baseOn:(CGFloat)baseOn;

+ (CGFloat)freeStoragePercentage;   // 可用内存占总内存的比例,eg  0.1;
+ (NSInteger)getTotalDiskSize;   // 获取磁盘总量
+ (NSInteger)getAvailableDiskSize;   // 获取磁盘可用量

// 根据键盘通知获取键盘高度
+ (CGSize)keyboardSizeFromNotification:(NSNotification *)notification;

+ (NSString *)appVersionNumber;                                                     // 获得版本号
+ (NSString *)appName;  // App名字
+ (NSString *)appBundleName; // 获得应用Bundle，如com.hope.myhome的myhome
+ (NSString *)iPAddress;
+ (NSString *)randomNumberWithDigit:(int)digit;
+ (NSString *)blankInChars:(NSString *)string byCellNo:(int)num;
+ (NSString *)jsonStringWithObject:(id)dic;
+ (NSString *)JSONString:(NSString *)aString;
+ (NSString *)dataToString:(NSData *)data withEncoding:(NSStringEncoding)encode;
+ (NSString *)homeDirectoryPath:(NSString *)fileName;
+ (NSString *)keyedUnarchiverWithString:(NSString *)fileName;
+ (NSString *)documentsPath:(NSString *)fileName;
+ (NSString *)temporaryDirectoryFile:(NSString *)fileName;
NSString *_fs_md5(NSString *str);
+ (NSString *)stringDeleteNewLineAndWhiteSpace:(NSString *)string;
+ (NSString *)macaddress;
+ (NSString *)identifierForVendorFromKeyChain;
+ (NSString *)asciiCodeWithString:(NSString *)string;
+ (NSString *)stringFromASCIIString:(NSString *)string;
+ (NSString *)DataToHex:(NSData *)data;                          // 将二进制转换为16进制再用字符串表示
+ (NSString *)cleanString:(NSString *)str;
+ (NSString *)stringByDate:(NSDate *)date;                       // 解决差8小时的问题
+ (NSString *)bankStyleData:(id)data;
+ (NSString *)bankStyleDataThree:(id)data;
+ (NSString *)fourNoFiveYes:(float)number afterPoint:(int)position;  // 四舍五入
+ (NSString *)decimalNumberMutiplyWithString:(NSString *)multiplierValue  valueB:(NSString *)multiplicandValue;
+ (NSString *)deviceModel;
+ (NSString *)easySeeTimesBySeconds:(NSInteger)seconds;
+ (NSString *)tenThousandNumber:(double)value;
+ (NSString *)tenThousandNumberString:(NSString *)value;
+ (NSString *)urlEncodedString:(NSString *)urlString;
+ (NSString *)urlDecodedString:(NSString *)urlString;
+ (NSString *)base64StringForText:(NSString *)text;     // 将字符串转换为base64编码
+ (NSString *)textFromBase64String:(NSString *)text;    // 将base64转换为字符串
+ (NSString *)base64Code:(NSData *)data;                // 用来将图片转换为字符串
+ (NSString *)sessionID:(NSURLResponse *)response;

+ (NSString *)ymdhsByTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)ymdhsByTimeIntervalString:(NSString *)timeInterval;

+ (NSString *)countOverTime:(NSTimeInterval)time;   // 把秒转换为天时分
+ (NSString *)convertNumbers:(NSString *)string;    // SQLite3的表名不能是数字，所以可以用这方法转成拼音
+ (NSString *)pinyinForHans:(NSString *)chinese;        // 获取汉字的拼音
+ (NSString *)pinyinForHansClear:(NSString *)chinese;        // 获取汉字的拼音，没有空格
+ (NSString*)reverseWordsInString:(NSString*)str;       // 字符串反转
+ (NSString *)twoChar:(NSInteger)value;
+ (NSString *)scanQRCode:(UIImage *)image;  // 解析二维码
+ (NSString *)dataToHex:(NSData *)data;
+ (NSData *)convertHexStrToData:(NSString *)str;

/*  NSAttributedString *connectAttributedString = [FuData attributedStringFor:connectString colorRange:@[[NSValue valueWithRange:connectRange]] color:GZS_RedColor textRange:@[[NSValue valueWithRange:connectRange]] font:FONTFC(25)];*/
+ (NSAttributedString *)attributedStringFor:(NSString *)sourceString colorRange:(NSArray *)colorRanges color:(UIColor *)color textRange:(NSArray *)textRanges font:(UIFont *)font;
+ (NSAttributedString *)attributedStringFor:(NSString *)sourceString strings:(NSArray *)colorStrings color:(UIColor *)color fontStrings:(NSArray *)fontStrings font:(UIFont *)font;

+ (NSString *)firstCharacterWithString:(NSString *)string;
+ (NSString *)forthCarNumber:(NSString *)text;

//     strikeLabel.attributedText = attribtStr;
- (NSAttributedString *)middleLineForLabel:(NSString *)text;    // 中划线
- (NSAttributedString *)underLineForLabel:(NSString *)text;     // 下划线

+ (void)call:(NSString *)phone;
+ (void)callPhoneWithNoNotice:(NSString *)phone;
+ (void)openAppByURLString:(NSString *)str;

+ (NSArray *)arrayFromArray:(NSArray *)array withString:(NSString *)string;
+ (NSArray *)arrayByOneCharFromString:(NSString *)string;
+ (NSArray *)keyedUnarchiverWithArray:(NSString *)fileName;
+ (NSArray *)arrayReverseWithArray:(NSArray *)array;
+ (NSArray *)maxandMinNumberInArray:(NSArray *)array;                           // 找出数组中最大的数 First Max, Last Min
+ (NSArray *)maopaoArray:(NSArray *)array;
+ (NSArray *)addCookies:(NSArray *)nameArray value:(NSArray *)valueArray cookieDomain:(NSString *)cookName;
+ (NSArray *)deviceInfos;

+ (NSDictionary *)keyedUnarchiverWithDictionary:(NSString *)fileName;

+ (NSData *)keyedUnarchiverWithData:(NSString *)fileName;
+ (NSData*)rsaEncryptString:(SecKeyRef)key data:(NSString*) data;
//压缩图片到指定文件大小
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

+ (NSNumber *)keyedUnarchiverWithNumber:(NSString *)fileName;
+ (NSNumber *)fileSize:(NSString *)filePath;

UIColor *_fs_randomColor(void);

+ (UIColor *)colorWithHexString:(NSString *)color;               // 根据16进制字符串获得颜色类对象

// 主要用于汉字倾斜,系统UIFont没有直接支持汉字倾斜。可以使字体倾斜rate角度，rate在0-180之间，取15较好；fontSize是字体大小。
+ (UIFont *)angleFontWithRate:(CGFloat)rate fontSize:(NSInteger)fontSize;

// 单位转换方法
NSString* _fs_KMGUnit(NSInteger size);

+ (NSURL *)convertTxtEncoding:(NSURL *)fileUrl;

// 将文件拷贝到tmp目录
+ (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL;

+ (id)storyboardInstantiateViewControllerWithStoryboardID:(NSString *)storybbordID;

void _fs_spendTimeInDoSomething(void(^body)(void),void(^time)(double time));

// userDefault只执行一次，即key对应的值不存在时，走event，存在，就不走
void _fs_userDefaultsOnce(NSString *key,void (^event)(void));

// GCD方法
void _fs_dispatch_global_main_queue_async(dispatch_block_t _global_block,dispatch_block_t _main_block);
void _fs_dispatch_main_queue_async(dispatch_block_t _main_block);
void _fs_dispatch_main_queue_sync(dispatch_block_t _main_block);
void _fs_dispatch_global_queue_async(dispatch_block_t _global_block);
void _fs_dispatch_global_queue_sync(dispatch_block_t _global_block);

//void _fs_runloop_observer(void);
void _fs_runloop_freeTime_event(void(^event)(void));

// 高精度计算
NSString *_fs_highAccuracy_add(NSString *a,NSString *b);
NSString *_fs_highAccuracy_subtract(NSString *a,NSString *b);
NSString *_fs_highAccuracy_multiply(NSString *a,NSString *b);
NSString *_fs_highAccuracy_divide(NSString *a,NSString *b);

@end
