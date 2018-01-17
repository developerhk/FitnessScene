//
//  RecipeFileManager.h
//  fitnessII
//
//  Created by Haley on 15/9/1.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeFileManager : NSObject
{
    NSString       *_rootPath;
}
@property (nonatomic, copy, readonly) NSString *rootPath;

//运动指导专用
+ (RecipeFileManager *)sharedInstance;

-(BOOL)removeFileWithName:(NSString *)name;
-(BOOL)isExistFileWithFileName:(NSString *)name;
-(NSString *)filePathWithName:(NSString *)name;

-(NSString *)allRecipeSize;

- (NSString *)diskFreeSpaceEx;
- (long long)diskTotalSpaceEx;

- (BOOL)canDownloadFile:(NSString *)fileSize;
- (void)showDiskWarning;
@end
