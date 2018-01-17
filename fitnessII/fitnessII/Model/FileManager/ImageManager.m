//
//  ImageManager.m
//  fitnessII
//
//  Created by Haley on 15/9/23.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "ImageManager.h"

static ImageManager *instance = nil;

@implementation ImageManager
@synthesize rootPath = _rootPath;

+ (ImageManager *)sharedInstance {
    @synchronized(self){
        if(instance == nil){
            instance = [[ImageManager alloc] init];
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
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *newPath = [NSString stringWithFormat:@"%@", @"HeadImage"];
    newPath = [documentsDirectory stringByAppendingPathComponent:newPath];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:newPath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[newPath stringByAppendingPathComponent:filename] error:NULL];
    }
}

-(BOOL)isExistFileWithFileName:(NSString *)name
{
    NSString *filepath=[_rootPath stringByAppendingPathComponent:name];
    BOOL isNO=NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isNO];
}

-(NSString *)imagePathWithName:(NSString *)name
{
    return [_rootPath stringByAppendingPathComponent:name];
}

-(void)saveImageWithName:(NSString *)url image:(UIImage *)image
{
    NSString *imagePath = [_rootPath stringByAppendingPathComponent:url];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:imagePath atomically:YES];
}

@end
