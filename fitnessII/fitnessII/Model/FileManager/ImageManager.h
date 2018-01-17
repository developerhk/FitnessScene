//
//  ImageManager.h
//  fitnessII
//
//  Created by Haley on 15/9/23.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageManager : NSObject
{
    NSString       *_rootPath;
}
@property (nonatomic, copy, readonly) NSString *rootPath;

//时间轴专用
+ (ImageManager *)sharedInstance;

-(BOOL)isExistFileWithFileName:(NSString *)name;
-(NSString *)imagePathWithName:(NSString *)name;

-(void)removeFileWithName:(NSString *)name;

-(void)saveImageWithName:(NSString *)url image:(UIImage *)image;

@end
