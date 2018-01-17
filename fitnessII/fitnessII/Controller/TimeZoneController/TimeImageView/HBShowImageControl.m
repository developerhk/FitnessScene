//
//  HBShowImageControl.m
//  MyTest
//
//  Created by weqia on 13-8-8.
//  Copyright (c) 2013年 weqia. All rights reserved.
//

#import "HBShowImageControl.h"
#import "FMUString.h"
#import "SDWebImageManager.h"
#import "ImageData.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"

@implementation HBShowImageControl
@synthesize delegate,bFirstSmall,smallTag,bigTag,controller;
#pragma -mark 覆盖父类的方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageWidth = frame.size.width;
    }
    return self;
}

#pragma -mark 私有方法
-(void)layoutImages
{
    int count=[_imgurls count];
    if(count==1) {
        if (bFirstSmall) {
            [self drawLessThree];
        } else {
            [self drawSingleImage:[_imgurls objectAtIndex:0]];
        }
    }
    else if(count<=3)
        [self drawLessThree];
    else if(count==4)
        [self drawFour];
    else
        [self drawMoreFour];
//    [self drawFile];
    
}
-(void)drawFile
{
    if([_files count]>0){
        float y;
        int imgCount=[_imgurls count];
        if(imgCount==0){
            y=0;
        }else if(imgCount==1){
            y=MAX_HEIGHT;
        }else{
            y=([_imgurls count]/4+1)*(IMAGE_SPACE+IMAGE_SIZE);
        }
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, y+5, 44, 29)];
        imageView.image=[UIImage imageNamed:@"f_attach"];
        [self addSubview:imageView];
        UIImageView * countView=[[UIImageView alloc]initWithFrame:CGRectMake(22, 10, 18, 18)];
        countView.image=[UIImage imageNamed:@"f_attach_count@2x"];
        UILabel * countLabel=[[UILabel alloc]initWithFrame:CGRectMake(22, 10, 18, 18)];
        countLabel.backgroundColor=[UIColor clearColor];
        countLabel.textAlignment=NSTextAlignmentCenter;
        countLabel.textColor=[UIColor whiteColor];
        countLabel.font=[UIFont systemFontOfSize:12];
        countLabel.text=[NSString stringWithFormat:@"%d",[_files count]];
        [imageView addSubview:countView];
        [imageView addSubview:countLabel];
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookFileAction:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled=YES;
    }
    
}

-(void)uploadFinish
{
    if(delegate&&[delegate respondsToSelector:@selector(showImageControlFinishLoad:)])
        [delegate showImageControlFinishLoad:self];
}

-(void)drawSingleImage:(NSString*)url
{
    [_bigUrls addObject:url];
    UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAX_WIDTH, MAX_HEIGHT)];
    imageView.image=[UIImage imageNamed:@"img_loading_for_talk"];
    [self addSubview:imageView];
    [ _imageViews addObject:imageView];
    UIActivityIndicatorView * indicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(90, 50, 20, 20)];
    [imageView addSubview:indicator];
    [indicator startAnimating];
    void(^block)(UIImage * image)=^(UIImage * image){
        if(image==nil)return ;
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        CGSize size=image.size;
//        float scale=size.height/size.width;
        float width= imageWidth,height=size.height*imageWidth/size.width;
        if(height > self.bounds.size.height)
        {
            height = self.bounds.size.height;
        }
//        if(scale<=(MAX_HEIGHT/MAX_WIDTH)&&width>=MAX_WIDTH)
//        {
//            width=MAX_WIDTH;
//            height=width*scale;
//        }
//        scale= width/size.width;
//        if(scale!=1){
//            image=[UIImage imageWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
//        }
//        size=image.size;
        imageView.frame=CGRectMake(0, 0, width, height);
        imageView.image=image;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookImageAction:)];
        imageView.userInteractionEnabled=YES;
        [imageView addGestureRecognizer:tap];
    };
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        //
        block(image);
        [self uploadFinish];
    }];
}

-(void)drawLessThree
{
    int count=[_imgurls count];
    for(int i=0;i<count;i++)
    {
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake((IMAGE_SIZE+IMAGE_SPACE)*i, 0, IMAGE_SIZE, IMAGE_SIZE)];
        ImageData * file=[[ImageData alloc] init];
        file.url =[_imgurls objectAtIndex:i];
        [self addSubview:imageView];
        [self drawImage:imageView file:file];
        if(count-1==i){
            [self uploadFinish];
        }
    }
}
-(void)drawFour
{
    int count=[_imgurls count];
    for(int i=0;i<count;i++)
    {
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake((IMAGE_SPACE+IMAGE_SIZE)*(i%2),(IMAGE_SPACE+IMAGE_SIZE)*(i/2), IMAGE_SIZE, IMAGE_SIZE)];
        ImageData * file=[[ImageData alloc] init];
        file.url =[_imgurls objectAtIndex:i];
        [self addSubview:imageView];
        [self drawImage:imageView file:file];
        if(i==count-1)
            [self uploadFinish];
    }
}

-(void)drawMoreFour
{
    int count=[_imgurls count];
    
    for(int i=0;i<count;i++)
    {
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake((IMAGE_SPACE+IMAGE_SIZE)*(i%3),(IMAGE_SPACE+IMAGE_SIZE)*(i/3), IMAGE_SIZE, IMAGE_SIZE)];
        ImageData * file=[[ImageData alloc] init];
        file.url =[_imgurls objectAtIndex:i];
        [self addSubview:imageView];
        [self drawImage:imageView file:file];
        if(i==count-1)
            [self uploadFinish];
    }

}

-(void)drawImage:(UIImageView*)imageView file:(ImageData*)file
{
    [_bigUrls addObject:file.url];
    [ _imageViews addObject:imageView];
    UIActivityIndicatorView * indicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((IMAGE_SIZE-20)/2, (IMAGE_SIZE-20)/2, 20, 20)];
    [imageView addSubview:indicator];
    [indicator startAnimating];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds=YES;
    __block UIImageView * wimageView=imageView;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:file.url] placeholderImage:[UIImage imageNamed:@"loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookImageAction:)];
        wimageView.userInteractionEnabled=YES;
        [wimageView addGestureRecognizer:tap];
    }];
}

#pragma -mark 事件响应方法
-(void)lookFileAction:(UIGestureRecognizer*)sender
{
    if(delegate&&[delegate respondsToSelector:@selector(lookFileAction:files:)]){
        [delegate lookFileAction:self files:_files];
    }
}

-(void)lookImageAction:(UIGestureRecognizer*)sender
{
    //事件统计 运动时光 点击图片
    [MobClick event:SportsTime_ZoomPicture];
    
    if(delegate&&[delegate respondsToSelector:@selector(lookImageAction:)])
        [delegate lookImageAction:self];
    _imageList=[[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
    int index=[_imageViews indexOfObject:sender.view];
//    if(IOS_VERSION<7.0){
//        [UIApplication sharedApplication].statusBarHidden=YES;
//    }
    UIImageView * view=(UIImageView*)sender.view;
    NSString * url=[_bigUrls objectAtIndex:index];
    _util=[[NSImageUtil alloc]init];
    int count=[_imageViews count];
    for(int i=0;i<count;i++){
        UIImage * image=((UIImageView*)[_imageViews objectAtIndex:i]).image;
        if(image){
            [_images addObject:image];
        }else{
            
        }
    }
    [_util showBigImageWithUrl:url fromView:view complete:^(UIView * backView) {
        [backView setHidden:YES];
        [_imageList addImagesURL:_bigUrls withSmallImage:_images];
        [_imageList setIndex:index];
        [self.window addSubview:_imageList];
    
    }];
}
-(void)dismissImageAction:(UIImageView*)sender
{
    int index=[_imageList.imageViews indexOfObject:sender.superview];
    UIImageView * view=[_imageViews objectAtIndex:index];
    [_imageList removeFromSuperview];
     NSString * url=[_bigUrls objectAtIndex:index];
    [_util goBackToView:view withImageUrl:url];
//    if(IOS_VERSION<7.0){
//        [UIApplication sharedApplication].statusBarHidden=NO;
//    }
}

#pragma -mark 接口方法

-(void)setImagesFileArr:(NSArray*)fileArr
{
    if(fileArr==nil || [fileArr count] == 0)
        return;

    [self setImagesWithFiles:fileArr];
}
-(void)setImagesFileStr:(NSString*)fileStr
{
    if(fileStr==nil)
        return;
    if ([fileStr isKindOfClass:[NSArray class]]) {
        if(((NSArray*)fileStr).count==0)
            return;
        id object=[((NSArray*)fileStr) objectAtIndex:0];
        if([object isKindOfClass:[ImageData class]]){
            [self setImagesWithFiles:(NSArray*)fileStr];
            return;
        }
        fileStr = [fileStr JSONString];
    }
    [self setImagesWithFiles:(NSArray*)fileStr];
}

-(void)setImagesWithFiles:(NSArray*)files1
{
    NSMutableArray * images=[[NSMutableArray alloc]init];
    NSMutableArray * files=[[NSMutableArray alloc]init];

    _imgurls=files1;
    _files=files;
    _bigUrls=[[NSMutableArray alloc]init];
    _images=[[NSMutableArray alloc]init];
    _imageViews=[[NSMutableArray alloc]init];
    for(UIView * view in self.subviews)
        [view removeFromSuperview];
    [self layoutImages];
}
+(float)heightForFileStr:(NSString*)fileStr
{
    if(fileStr==nil)
        return 0;
    if ([fileStr isKindOfClass:[NSArray class]]) {
        if(((NSArray*)fileStr).count==0)
            return 0;
        id object=[((NSArray*)fileStr) objectAtIndex:0];
        if([object isKindOfClass:[ImageData class]]){
            return [self heightForFiles:(NSArray*)fileStr];
        }
        fileStr = [fileStr JSONString];
    }
    return [self heightForFiles:(NSArray*)fileStr];
}

+(float)heightForFiles:(NSArray*)files1
{
    int imageCount=0;
    int count=[files1 count];
    for(int i=0;i<count;i++){
        ImageData * data =[files1 objectAtIndex:i];
        NSArray * array=[data.mime componentsSeparatedByString:@"/"];
        NSString * mime=[array objectAtIndex:0];
        if([mime isEqualToString:@"image"])
            imageCount++;
    }
    float offset;
    if(imageCount==count){
        offset=0;
    }else{
        offset=40;
    }
    if(imageCount==0)
        return offset;
    else if(imageCount==1){
        return  MAX_HEIGHT+offset;
    }else{
        return (imageCount/4+1)*(IMAGE_SIZE+IMAGE_SPACE)+offset;
    }
}

@end
