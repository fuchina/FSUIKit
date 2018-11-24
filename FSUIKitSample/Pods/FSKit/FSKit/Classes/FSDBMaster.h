//
//  FSDBMaster.h
//  Demo
//
//  Created by fudon on 2017/5/16.
//  Copyright © 2017年 fuhope. All rights reserved.
//

/*
 select * from ab_ling where (atype = 'fzp' and cast(arest as REAL) > 0 or (btype = 'fzp' and cast(brest as REAL) > 0));
 直接在电脑上SQLPRO FOR SQLITE修改数据
 
 SELECT name FROM (SELECT * FROM sqlite_master UNION ALL SELECT * FROM sqlite_temp_master) WHERE type=’table’ ORDER BY name;
 
 1.将数据库导出到其他应用，无法插入数据和修改数据，这是因为权限问题，可以cd到数据库文件目录下执行:
    chmod 777 sql_ling.db
    sql_ling.db是数据库文件名
 
 2.从第三方过来的数据库，除非在终端执行上述第2条的chmod命令，但在代码中还没有解决增删改权限的办法。查了一下，据说把db文件copy一份到Document目录下的数据库可以增删改。
    NSString *path=[NSString stringWithFormat:@"%@/livefile.%@",[[NSBundle mainBundle]  resourcePath],[[durl path] pathExtension]];
    BOOL isosd = [dd writeToURL:[NSURL URLWithString:path] options:NSDataWritingAtomic error:&error1];
    这样写文件如果在非越狱机上调试 会失败 提示用户权限有问题 这样应该是违背了所谓的沙箱原理
 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"livefile.mp3"];
    BOOL isosd = [dd writeToFile:writableDBPath atomically:YES];
    这样写则无问题。
 
 3.判断某个字段为NULL的条件语句是 deflag is NULL，而不是 deflag = NULL;


 NOTE:
 1.需要在 Link Binary With Libraries 中导入 libsqlite3.tbd库
 2.因为id是iOS的关键字，所以用aid来作为自增id名，Model里有这个名为aid属性，就会得到NSNumber的值；但不能给这个属性赋值。
 3.表名,不要和所存的类名相同。因为如果类增加了字段，表中就没有该字段。
 4.多线程会出错，比如在 dispatch_group_t dispatchGroup = dispatch_group_create();中多线程查询，会出现EXC_BAD_ACCESS
 5.貌似FMDB也是串行队列
 6.数据类型有
    NULL，值是NULL
    INTEGER，值是有符号整形，根据值的大小以1,2,3,4,6或8字节存放
    REAL，值是浮点型值，以8字节IEEE浮点数存放
    TEXT，值是文本字符串，使用数据库编码（UTF-8，UTF-16BE或者UTF-16LE）存放
    BLOB，只是一个数据块，完全按照输入存放（即没有准换）
    。。。。。。
 */

/*
 1.串行队列+同步方式，如果在queue里又同步往queue里添加任务，有死锁的风险；
 */

#import <Foundation/Foundation.h>

static NSString *_db_extension = @".db";
static NSString *_db_first_name = @"sql_ling";

@interface FSDBMaster : NSObject

/*
 打开默认的数据库
 */
+ (FSDBMaster *)sharedInstance;

- (BOOL)openSqlite3DatabaseAtPath:(NSString *)path;

/*
 打开的是传入的dbName数据
 */
+ (FSDBMaster *)sharedInstanceWithDBName:(NSString *)dbName;

// 根据数据库名字获取本地路径
-(NSString *)dbPath;
// 不需要带扩展名，扩展名自动补充为.db
- (NSString *)dbPathWithFileName:(NSString *)name;

/*
 新增 eg.
 @"INSERT INTO %@ (time,name,loti,lati) VALUES ('%@','%@','%@','%@');";
 */
- (NSString *)insertSQL:(NSString *)sql fields:(NSArray<NSString *> *)fields table:(NSString *)table;

/*
 删除  eg
 @"DELETE FROM %@ WHERE time = '%@';"
 注意time的值，time是字符串，所以要用''来表示，如果time是字符型数字时加不加''都没关系，但如果time是155555.8888之类时，因为那个小数点导致必须加上''才能找到time
 */
- (NSString *)deleteSQL:(NSString *)sql;

// @"UPDATE %@ SET lati = '%@',loti = '%@' WHERE aid = %@;"
- (NSString *)updateWithSQL:(NSString *)sql;

- (NSString *)execSQL:(NSString *)SQL type:(NSString *)type;

/*
 【SELECT DISTINCT name FROM %@;】// 从%@表中查询name字段的所有不重复的值
 【SELECT * FROM %@ WHERE name = 'ddd';】
 【SELECT * FROM %@ order by time DESC limit 0,10;】    ASC
 【SELECT * FROM %@ WHERE atype = ? OR btype = ? and time BETWEEN 1483228800 AND 1514764799 order by time DESC limit 0,10;】
 */
- (NSMutableArray<NSDictionary *> *)querySQL:(NSString *)sql tableName:(NSString *)tableName;

//  检查表是否存在
- (BOOL)checkTableExist:(NSString *)tableName;

// 往表中增加字段  成功返回nil，失败返回原因
- (NSString *)addField:(NSString *)field defaultValue:(NSString *)value toTable:(NSString *)table;

// 删除表  成功返回nil，失败返回原因
- (NSString *)dropTable:(NSString *)table;

//  获取表名的所有数据数量
- (int)countForTable:(NSString *)tableName;

/*
 根据sql语句获取满足条件的数据数量；count(*)内部可以是*，也可是字段名来限制范围。
 【select count(*) from dbgroup Where cast(freq as INTEGER) > 30;】查询满足条件的数据条数；
 【select count(DISTINCT type) from dbgroup;】查询type不同种类，比如type有password和diary两种，就返回2;
 */
- (int)countWithSQL:(NSString *)sql table:(NSString *)table;

// 获取数据库中所有表名
- (NSArray<NSString *> *)allTables;
- (NSArray<NSDictionary *> *)allTablesDetail;
// 获取表中的所有字段
- (NSArray<NSDictionary *> *)allFields:(NSString *)table;

/*
 所有关键字，不能用作表名或字段名
 */
- (NSArray<NSString *> *)keywords;

//线程安全  iOS是2，2：支持多线程但不支持一个数据库在多线程内，即只支持一个数据库对应一个线程的多线程
+ (int)sqlite3_threadsafe;

@end



