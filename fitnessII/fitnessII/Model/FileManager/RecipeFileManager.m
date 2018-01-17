//
//  RecipeFileManager.m
//  fitnessII
//
//  Created by Haley on 15/9/1.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RecipeFileManager.h"
#include <sys/stat.h>
#include <sys/mount.h>

static RecipeFileManager *instance = nil;
@implementation RecipeFileManager
@synthesize rootPath = _rootPath;

+ (RecipeFileManager *)sharedInstance {
    @synchronized(self){
        if(instance == nil){
            instance = [[RecipeFileManager alloc] init];
        }
    }
    return instance;
}

- (id)init {
    if (self = [super init]) {
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        // 目录路径
        
//        // 检查旧版本，如果存在，需要删除掉
//        NSString *oldVersonPath = [documentDirectory stringByAppendingPathComponent:@"RecipeVideo"];
//        if ([[NSFileManager defaultManager] fileExistsAtPath:oldVersonPath] == YES) {
//            [[NSFileManager defaultManager] removeItemAtPath:oldVersonPath error:NULL];
//        }
        
        // 创建新的版本
        NSString *newPath = [NSString stringWithFormat:@"%@", @"RecipeVideo"];
        _rootPath = [documentDirectory stringByAppendingPathComponent:newPath];
        
        // 在目录路径下创建文件夹
        if ([[NSFileManager defaultManager] fileExistsAtPath:_rootPath] == NO) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_rootPath withIntermediateDirectories:NO attributes:nil error:NULL];
        }
    }
    return self;
    
}

-(BOOL)removeFileWithName:(NSString *)name
{
    NSString *filepath=[_rootPath stringByAppendingPathComponent:name];
    BOOL isSuccess = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath] == YES) {
        isSuccess = [[NSFileManager defaultManager] removeItemAtPath:filepath error:NULL];
    }
    return isSuccess;
}

-(BOOL)isExistFileWithFileName:(NSString *)name
{
    NSString *filepath=[_rootPath stringByAppendingPathComponent:name];
    BOOL isNO=NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isNO];
}

-(NSString *)filePathWithName:(NSString *)name
{
    return [_rootPath stringByAppendingPathComponent:name];
}

-(NSString *)allRecipeSize
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:_rootPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:_rootPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [_rootPath stringByAppendingPathComponent:fileName];
        folderSize += [[manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
    }
    //除以整形返回整形  除以小数 返回小数
    return [NSString stringWithFormat:@"%.2f" ,folderSize/1024.00/1024.00];
}

- (NSString *)diskFreeSpaceEx
{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return [NSString stringWithFormat:@"%qi" ,freespace/1024];
}

- (long long)diskTotalSpaceEx
{
    struct statfs buf;
    long long totalspace;
    totalspace = 0;
    if(statfs("/private/var", &buf) >= 0){
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    return totalspace;
}

- (BOOL)canDownloadFile:(NSString *)fileSize
{
    int diskFreeSpace = [[self diskFreeSpaceEx] intValue];
    int taskSize = [fileSize intValue];
    if (diskFreeSpace - taskSize > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)showDiskWarning {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"内存已满"
                                                    message:@"请及时清理内存！"
                                                   delegate:nil
                                          cancelButtonTitle:@"我知道了"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
