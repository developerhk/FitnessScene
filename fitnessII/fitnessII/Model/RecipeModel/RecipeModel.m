//
//  RecipeModel.m
//  fitnessII
//
//  Created by Haley on 15/9/6.
//  Copyright (c) 2015年 samples.hankang. All rights reserved.
//

#import "RecipeModel.h"

@implementation RecipeModel
- (id)initWithListInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        [self assingmentWithInfo:info];
    }
    return self;
}

+ (RecipeModel *)RIWithInfo:(NSDictionary *)info
{
    return [[RecipeModel alloc] initWithListInfo:info];
}

- (void)assingmentWithInfo:(NSDictionary *)info{
    IgnoreNullAssign(self.zipVersion, [info objectForKey:@"Version"]);
    IgnoreNullAssign(self.unzipSize, [info objectForKey:@"UnzipSize"]);
    IgnoreNullAssign(self.zipUrl, [info objectForKey:@"URL"]);
    self.dataArray = [self getArrayWithDataArray:[info objectForKey:@"ExerciseUnit"]];
    self.rdModel = [RecipeDetailModel RDWithInfo:[info objectForKey:@"ExerciseGuide"]];
}

-(NSArray *)getArrayWithDataArray:(NSArray *)dataArray
{
    NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:0];
    [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [ar addObject:[RecipeItem RWithInfo:obj]];
    }];
    return ar;
}
@end
