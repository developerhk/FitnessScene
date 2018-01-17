//
//  StarZoneManager.h
//  fitnessII
//
//  Created by Haley on 15/11/5.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StarZoneManager : NSObject
{
    NSString       *_rootPath;
}
@property (nonatomic, copy, readonly) NSString *rootPath;

//时间轴专用
+ (StarZoneManager *)sharedInstance;

-(BOOL)isExistFileWithFileName:(NSString *)name;
-(NSString *)videoPathWithName:(NSString *)name;

-(NSString *)allTimeVideoSize;
-(void)removeFileWithName:(NSString *)name;
-(void)removeALLFile;

- (NSString *)diskFreeSpaceEx;
- (long long)diskTotalSpaceEx;

- (BOOL)canDownloadFile:(NSString *)fileSize;
- (void)showDiskWarning;
@end
