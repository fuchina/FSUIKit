//
//  FSDBMaster.m
//  Demo
//
//  Created by fudon on 2017/5/16.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import "FSDBMaster.h"
#import <sqlite3.h>
#import "FSRuntime.h"

@interface FSDBMaster ()

@property (nonatomic,assign) sqlite3   *sqlite3;

@end

static const char *_SQLManagerQueue = "fsdbmaster.sync";
@implementation FSDBMaster{
    dispatch_queue_t    _queue;
}

static FSDBMaster *_instance = nil;

+(FSDBMaster *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FSDBMaster alloc] init];
    });
    return _instance;
}

+ (FSDBMaster *)sharedInstanceWithDBName:(NSString *)dbName{
    FSDBMaster *master = [self sharedInstance];
    [master generateHandlerWithDBName:dbName];
    return master;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create(_SQLManagerQueue, DISPATCH_QUEUE_SERIAL);
        [self generateHandlerWithDBName:_db_first_name];
    }
    return self;
}

- (BOOL)openSqlite3DatabaseAtPath:(NSString *)path{
    if (!([path isKindOfClass:NSString.class] && path.length)) {
        return NO;
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL fileExist = [manager fileExistsAtPath:path];
    if (!fileExist) {
        return NO;
    }
    if (_sqlite3) {
        sqlite3_close(_sqlite3);
        _sqlite3 = NULL;
    }
    BOOL openDatabaseSuccess = NO;
    int openResult = sqlite3_open([path UTF8String], &_sqlite3);
    if (openResult != SQLITE_OK) {
        sqlite3_close(_sqlite3);
        _sqlite3 = NULL;
    }else{
        openDatabaseSuccess = YES;
        int result = sqlite3_exec(_sqlite3, "PRAGMA synchronous=FULL;", NULL, NULL, NULL);
        if (result != SQLITE_OK) {
            
        }
    }
    return openDatabaseSuccess;
}

- (void)generateHandlerWithDBName:(NSString *)dbName{
    if (!([dbName isKindOfClass:NSString.class] && dbName.length)) {
        return;
    }
    
    NSString *currentDBPath = [self dbPath];
    NSString *currentDBName = [currentDBPath lastPathComponent];
    NSString *nowDBName = [[NSString alloc] initWithFormat:@"%@%@",dbName,_db_extension];
    if ([currentDBName isEqualToString:nowDBName] && _sqlite3 != NULL) {
        return;
    }
    
    NSString *dbPath = [self dbPathWithFileName:dbName];
    int openResult = sqlite3_open([dbPath UTF8String], &_sqlite3);
    if (openResult != SQLITE_OK) {
        sqlite3_close(_sqlite3);
        _sqlite3 = NULL;
    }else{
        int result = sqlite3_exec(_sqlite3, "PRAGMA synchronous=FULL;", NULL, NULL, NULL);
        if (result != SQLITE_OK) {
        }
    }
}

- (NSString *)dbPath{// 数据库只能放在Documents目录下
    return [self dbPathWithFileName:_db_first_name];
}

// param: 不需要带扩展名
- (NSString *)dbPathWithFileName:(NSString *)name{
    if (!([name isKindOfClass:NSString.class] && name.length)) {
        return nil;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *path = [docDir stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@%@",name,_db_extension]];
    return path;
}

- (NSString *)createTableIfNotExists:(NSString *)tableName fields:(NSArray<NSString *> *)properties{
    if (!([properties isKindOfClass:NSArray.class] && properties.count)) {
        return @"fields 为空";
    }
    for (NSString *s in properties) {
        if (!([s isKindOfClass:NSString.class] && s.length)) {
            return @"field不是字符串";
        }
    }
    if (!([tableName isKindOfClass:NSString.class] && tableName.length)) {
        return @"表名为空";
    }
    BOOL exist = [self checkTableExist:tableName];
    if (exist) {
        return nil;
    }
    static NSString *_static_aid = @"aid";
    NSString *primaryKey = [[NSString alloc] initWithFormat:@"%@ INTEGER PRIMARY KEY autoincrement,",_static_aid];// 因为PRIMARY KEY，id自动是8个字节
    NSMutableString *append = [[NSMutableString alloc] initWithString:primaryKey];
    NSArray *keywords = [self keywords];
    for (int x = 0; x < properties.count; x ++) {
        NSString *name = properties[x];
        BOOL isKeyword = [keywords containsObject:name];
        if (isKeyword) {
            continue;
            //            name = [[NSString alloc] initWithFormat:@"[%@]",name];
        }
        if ([_static_aid isEqualToString:name]) {
            continue;
        }
        if (x == (properties.count - 1)){
            [append appendString:[[NSString alloc] initWithFormat:@"%@ TEXT NULL",name]];
        }else{
            [append appendString:[[NSString alloc] initWithFormat:@"%@ TEXT NULL,",name]];
        }
    }
    
    // PRIMARY KEY 是唯一的，每条数据不能相同
    //    NSString *sql = @"CREATE TABLE IF NOT EXISTS UserTable ( time TEXT NOT NULL PRIMARY KEY,atype TEXT NOT NULL,btype TEXT NOT NULL,je TEXT,bz TEXT,sr TEXT, cb TEXT, ys TEXT, xj TEXT, ch TEXT, tz TEXT, tx TEXT, fz TEXT);";
    NSString *sql = [[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@);",tableName,append];
    NSString *e = [self execSQL:sql type:@"创建表"];
    if (e) {
        return @"创建表失败";
    }
    return nil;
}

/*
 @"INSERT INTO %@ (time,name,loti,lati) VALUES ('%@','%@','%@','%@');";
 */
- (NSString *)insertSQL:(NSString *)sql fields:(NSArray<NSString *> *)fields table:(NSString *)table{
    if (!([table isKindOfClass:NSString.class] && table.length)) {
        return @"表名为空";
    }
    NSString *error = [self createTableIfNotExists:table fields:fields];
    if (error) {
        return error;
    }
    return [self execSQL:sql type:@"新增数据"];
}

- (NSString *)insert_fields_values:(NSDictionary<NSString *,id> *)list table:(NSString *)table{
    if (!([table isKindOfClass:NSString.class] && table.length)) {
        return @"insertSQL : table name is null or non_length";
    }
    
    if (!([list isKindOfClass:NSDictionary.class] && list.count)) {
        return nil;
    }
    
    NSArray *keys = list.allKeys;
    BOOL isTableExist = [self checkTableExist:table];
    if (!isTableExist) {
        [self insertSQL:nil fields:keys table:table];
    }
    
    NSInteger count = keys.count;
    NSMutableString *whys = [[NSMutableString alloc] init];
    NSString *fies = [keys componentsJoinedByString:@","];
    static NSString *_key_why = @"?";
    static NSString *_key_why_space = @",?";
    for (int x = 0; x < count; x ++) {
        if (x) {
            [whys appendString:_key_why_space];
        }else{
            [whys appendString:_key_why];
        }
    }
    NSString *insert_sql = [[NSString alloc] initWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",table,fies,whys];

    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_sqlite3, insert_sql.UTF8String, -1, &stmt, nil) == SQLITE_OK) {
        for (NSString *k in keys) {
            @autoreleasepool{
                NSString *nk = [[NSString alloc] initWithFormat:@":%@",k];
                const char *kc = nk.UTF8String;
                int idx = sqlite3_bind_parameter_index(stmt, kc);
                if (idx > 0) {
                    NSString *v = [list objectForKey:k];
                    sqlite3_bind_text(stmt, idx, v.UTF8String, -1, SQLITE_STATIC);
                }
            }
        }
    }
    
    int result = sqlite3_step(stmt);
    if (result != SQLITE_DONE) {
        sqlite3_finalize(stmt);
        return @"insertSQL : sqlite3_step(stmt) failed";
    }
    return nil;
}

- (NSString *)deleteSQL:(NSString *)sql{
    return [self execSQL:sql type:@"删除数据"];
}

/*
 更新  eg.
 @"UPDATE %@ SET lati = '%@',loti = '%@' WHERE aid = %@;"
 */
- (NSString *)updateWithSQL:(NSString *)sql{
    return [self execSQL:sql type:@"更新数据"];
}

- (NSString *)execSQL:(NSString *)SQL type:(NSString *)type{
    if (!([SQL isKindOfClass:NSString.class] && SQL.length)) {
        return @"语句为空";
    }
    __block NSString *errMSG = nil;
    dispatch_sync(_queue, ^{
        char *error = NULL;
        int result = sqlite3_exec(self->_sqlite3, [SQL UTF8String], NULL, NULL, &error);
        if (result != SQLITE_OK) {
            errMSG = [[NSString alloc] initWithFormat:@"%@失败，原因:%s",type,error];
        }
    });
    return errMSG;
}

/*
 【SELECT DISTINCT name FROM %@;】// 从%@表中查询name字段的所有不重复的值
 【SELECT * FROM %@ WHERE name = 'ddd';】
 【SELECT * FROM %@ order by time DESC limit 0,10;】    ASC
 【SELECT * FROM %@ WHERE atype = ? OR btype = ? and time BETWEEN 1483228800 AND 1514764799 order by time DESC limit 0,10;】
 */
- (NSMutableArray<NSDictionary *> *)querySQL:(NSString *)sql tableName:(NSString *)tableName{
    return [self execQuerySQL:sql tableName:tableName];
}

- (NSMutableArray *)execQuerySQL:(NSString *)sql tableName:(NSString *)tableName{
    if (!([sql isKindOfClass:NSString.class] && sql.length)) {
        return nil;
    }
    if (!([tableName isKindOfClass:NSString.class] && tableName.length)) {
        return nil;
    }
    BOOL exist = [self checkTableExist:tableName];
    if (!exist) {
        return nil;
    }
    __block NSMutableArray *mArr = nil;
    dispatch_sync(_queue, ^{
        sqlite3_stmt *stmt = nil;
        int prepare = sqlite3_prepare_v2(self->_sqlite3, [sql UTF8String], -1, &stmt, NULL);
        if (prepare != SQLITE_OK) {
            sqlite3_finalize(stmt);stmt = NULL;
            return;
        }
        mArr = [[NSMutableArray alloc] init];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            id entity = [self dictionaryFromStmt:stmt];
            if (entity) {
                [mArr addObject:entity];
            }
        }
        sqlite3_finalize(stmt);stmt = NULL;
    });
    if (mArr.count) {
        return mArr;
    }
    return nil;
}

- (int)countForTable:(NSString *)tableName{
    if (!([tableName isKindOfClass:NSString.class] && tableName.length)) {
        return 0;
    }
    BOOL exist = [self checkTableExist:tableName];
    if (!exist) {
        return 0;
    }
    __block int count = 0;
    dispatch_sync(_queue, ^{
        NSString *sql = [[NSString alloc] initWithFormat:@"SELECT COUNT(*) FROM %@;",tableName];
        sqlite3_stmt *stmt = nil;
        int prepare = sqlite3_prepare_v2(self->_sqlite3, [sql UTF8String], -1, &stmt, NULL);
        if (prepare != SQLITE_OK) {
            return;
        }
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            count += sqlite3_column_int(stmt, 0);
        }
        sqlite3_finalize(stmt);stmt = NULL;
    });
    return count;
}

- (int)countWithSQL:(NSString *)sql table:(NSString *)tableName{
    if (!([tableName isKindOfClass:NSString.class] && tableName.length)) {
        return 0;
    }
    BOOL exist = [self checkTableExist:tableName];
    if (!exist) {
        return 0;
    }
    if (!([sql isKindOfClass:NSString.class] && sql.length)) {
        return 0;
    }
    __block int count = 0;
    dispatch_sync(_queue, ^{
        sqlite3_stmt *stmt = nil;
        int prepare = sqlite3_prepare_v2(self->_sqlite3, [sql UTF8String], -1, &stmt, NULL);
        if (prepare != SQLITE_OK) {
            return;
        }
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            count += sqlite3_column_int(stmt, 0);
        }
        sqlite3_finalize(stmt);stmt = NULL;
    });
    return count;
}

- (BOOL)checkTableExist:(NSString *)tableName{
    if (!([tableName isKindOfClass:NSString.class] && tableName.length)) {
        return NO;
    }
    __block NSInteger success = 0;
    dispatch_sync(_queue, ^{
        sqlite3_stmt *statement;
        NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM sqlite_master where type='table' and name='%@';",tableName];
        const char *sql_stmt = [sql UTF8String];
        if (sqlite3_prepare_v2(self->_sqlite3, sql_stmt, -1, &statement, nil) == SQLITE_OK) {
            @try {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    int count = sqlite3_column_int(statement, 0);
                    success += count;
                    if (success > 0) {
                        break;
                    }
                }
            } @catch (NSException *exception) {
                
            } @finally {
                sqlite3_finalize(statement);statement = NULL;
            }
        }
    });
    return success > 0;
}

- (NSString *)addField:(NSString *)field defaultValue:(NSString *)value toTable:(NSString *)table{
    Class _class_NSString = NSString.class;
    BOOL checkField = [field isKindOfClass:_class_NSString] && field.length;
    if (!checkField) {
        return @"字段不是字符串";
    }
    NSArray *keys = [self keywords];
    if ([keys containsObject:field]) {
        return @"字段名不能使用关键字";
    }
    BOOL checkTable = [table isKindOfClass:_class_NSString] && table.length;
    if (!checkTable) {
        return @"表名错误";
    }
    BOOL exist = [self checkTableExist:table];
    if (!exist) {
        return @"表不存在";
    }
    NSArray *fs = [self allFields:table];
    BOOL isFieldExist = NO;
    NSString *_key_field_name = @"field_name";
    for (NSDictionary *dic in fs) {
        NSString *f = [dic objectForKey:_key_field_name];
        if ([f isEqualToString:field]) {
            isFieldExist = YES;
            break;
        }
    }
    if (isFieldExist) {   // 表中已有改字段，算是增加成功了
        return nil;
    }
    
    NSString *sql = [[NSString alloc] initWithFormat:@"ALTER TABLE '%@' ADD '%@' TEXT NULL DEFAULT '%@';",table,field,value?:@""];
    NSString *error = [self execSQL:sql type:nil];
    return error;
}

- (NSString *)dropTable:(NSString *)table{
    if (!([table isKindOfClass:NSString.class] && table.length)) {
        return @"表名为空";
    }
    NSString *sql = [[NSString alloc] initWithFormat:@"DROP TABLE %@",table];
    NSString *type = [[NSString alloc] initWithFormat:@"删除表'%@'",table];
    NSString *error = [self execSQL:sql type:type];
    return error;
}

- (BOOL)checkTableExistWithTableNamed:(NSString *)tableName{
    if (!([tableName isKindOfClass:NSString.class] && tableName.length)) {
        return NO;
    }
    __block BOOL success = NO;
    dispatch_sync(_queue, ^{
        char *err;
        NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM sqlite_master where type='table' and name='%@';",tableName];
        const char *sql_stmt = [sql UTF8String];
        int result = sqlite3_exec(self->_sqlite3, sql_stmt, checkTableCallBack, (void *)[tableName UTF8String], &err);
        if(result != SQLITE_OK){
            return;
        }
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *exist = [ud objectForKey:tableName];
        success = exist.length?YES:NO;
    });
    return success;
}

/*
 int (*callback)(void*,int,char**,char**)
 * 函数参数:
 void *param 传递给callback回调函数的参数,对应于sqlite3_exec函数的第四个参数
 int f_num 查找到的记录中包含的字段数目
 char **f_value 包含查找到每个记录的字段值
 char **f_name 包含查找到每个记录的字段名称
 */

int checkTableCallBack(void *param, int f_num, char **f_value, char **f_name){
    NSString *p = [[NSString alloc] initWithUTF8String:param];// 传过来的参数
    NSInteger number = 0;
    if (f_num) {
        char *count = f_value[0];
        number = atoi(count);
    }
    
    if (number) {
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:p];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:p];
    }
    return 0;
}

// 要返回一条数据中的所有字段及其值
- (NSDictionary *)dictionaryFromStmt:(sqlite3_stmt *)stmt{
    NSMutableDictionary *last = [[NSMutableDictionary alloc] init];
    int count = sqlite3_column_count(stmt);
    for (int x = 0; x < count; x ++) {
        const char *cname = sqlite3_column_name(stmt, x);
        if (cname == NULL) {
            continue;
        }
        NSString *name = [[NSString alloc] initWithUTF8String:cname];
        
        int cType = sqlite3_column_type(stmt, x);
        static NSString *noLenghthString = @"";
        id str = noLenghthString;
        if (cType == SQLITE_TEXT) {
            const char *cValue = (char *)sqlite3_column_text(stmt, x);
            if (cValue != NULL) {
                str = [[NSString alloc] initWithUTF8String:cValue];// 如果charValue为NULL会Crash
            }
        }else if (cType == SQLITE_BLOB || cType == SQLITE_NULL){
        }else if (cType == SQLITE_INTEGER){
            int cValue = sqlite3_column_int(stmt,x);
            str = @(cValue);
        }else if (cType == SQLITE_FLOAT){
            float cValue = sqlite3_column_double(stmt, x);
            str = @(cValue);
        }
        [last setObject:str forKey:name];
    }
    return last;
}

//获取表中所有字段名和类型
static NSString     *_field_name = @"field_name";
static NSString     *_field_type = @"field_type";
- (NSArray<NSDictionary *> *)allFields:(NSString *)tableName{
    __block NSMutableArray *array = nil;
    dispatch_sync(_queue, ^{
        array = [[NSMutableArray alloc] init];
        NSString *getColumn = [NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
        sqlite3_stmt *statement;
        sqlite3_prepare_v2(self->_sqlite3, [getColumn UTF8String], -1, &statement, nil);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *nameData = (char *)sqlite3_column_text(statement, 1);
            NSString *columnName = [[NSString alloc] initWithUTF8String:nameData];
            char *typeData = (char *)sqlite3_column_text(statement, 2);
            NSString *columntype = [NSString stringWithCString:typeData encoding:NSUTF8StringEncoding];
            NSDictionary *dic = @{_field_name:columnName,_field_type:[columntype lowercaseString]};
            [array addObject:dic];
        }
        sqlite3_finalize(statement);statement = NULL;
    });
    return [array copy];
}

- (NSArray<NSString *> *)allTables{
    NSArray *array = [self allTablesDetail];
    NSMutableArray *names = nil;
    if ([array isKindOfClass:NSArray.class] && array.count) {
        names = [[NSMutableArray alloc] initWithCapacity:array.count];
        static NSString *_name = @"name";
        static NSString *_nlString = @"";
        for (NSDictionary *m in array) {
            NSString *n = [m objectForKey:_name];
            [names addObject:n?:_nlString];
        }
    }
    return [names copy];
}

- (NSArray<NSDictionary *> *)allTablesDetail{
    __block NSMutableArray *array = nil;
    dispatch_sync(_queue, ^{
        array = [[NSMutableArray alloc] init];
        sqlite3_stmt *statement;
        static const char *getTableInfo = "select * from sqlite_master where type = 'table' order by name";
        if (sqlite3_prepare_v2(self->_sqlite3, getTableInfo, -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                id entity = [self dictionaryFromStmt:statement];
                if (entity) {
                    [array addObject:entity];
                }
            }
        }
        sqlite3_finalize(statement);statement = NULL;
    });
    return array.count?array:nil;
}

- (NSArray<NSString *> *)keywords{
    static NSArray *list = nil;
    if (!list) {
        list = @[@"select",@"insert",@"update",@"delete",@"from",@"creat",@"where",@"desc",@"order",@"by",@"group",@"table",@"alter",@"view",@"index",@"when"];
    }
    return list;
}

+ (int)sqlite3_threadsafe{
    return sqlite3_threadsafe();
}

@end
