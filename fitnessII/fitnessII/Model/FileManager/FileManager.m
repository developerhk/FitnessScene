//
//  FileManager.m
//  fitnessII
//
//  Created by Haley on 15/8/29.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "FileManager.h"
#include <sys/stat.h>
#include <sys/mount.h>

static FileManager *instance = nil;

@implementation FileManager
@synthesize rootPath = _rootPath;

+ (FileManager *)sharedInstance {
    @synchronized(self){
        if(instance == nil){
            instance = [[FileManager alloc] init];
        }
    }
    return instance;
}

- (id)init {
    if (self = [super init]) {
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        
        // 创建新的版本
        NSString *newPath = [NSString stringWithFormat:@"%@", @"TimeVideo"];
        _rootPath = [documentDirectory stringByAppendingPathComponent:newPath];
        
        // 在目录路径下创建文件夹
        if ([[NSFileManager defaultManager] fileExistsAtPath:_rootPath] == NO) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_rootPath withIntermediateDirectories:NO attributes:nil error:NULL];
        }

    }
    return self;
}

-(void)removeFileWithName:(NSString *)name
{
    NSString *filepath=[_rootPath stringByAppendingPathComponent:name];
    BOOL isSuccess = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath] == YES) {
        isSuccess = [[NSFileManager defaultManager] removeItemAtPath:filepath error:NULL];
    }
}

-(void)removeALLFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *newPath = [NSString stringWithFormat:@"%@", @"TimeVideo"];
    newPath = [documentsDirectory stringByAppendingPathComponent:newPath];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:newPath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[newPath stringByAppendingPathComponent:filename] error:NULL];
    }
}

-(NSString *)allTimeVideoSize
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
    return [NSString stringWithFormat:@"%.2f" ,folderSize/1024.00/1024.00];
}

-(BOOL)isExistFileWithFileName:(NSString *)name
{
    NSString *filepath=[_rootPath stringByAppendingPathComponent:name];
    BOOL isNO=NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isNO];
}

-(NSString *)videoPathWithName:(NSString *)name
{
    return [_rootPath stringByAppendingPathComponent:name];
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
