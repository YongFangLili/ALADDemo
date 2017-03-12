//
//  ReaderMedplusLoadingView.m
//  Pods
//
//  Created by zhangbin on 16/6/21.
//
//

#import "ReaderMedplusLoadingView.h"

#define AnimationKey @"ReaderMedplusLoadingViewAnimationKey"

@interface ReaderMedplusLoadingView ()

/**
 *  中心的图片
 */
@property(nonatomic,strong) UIImageView *imageViewC;
/**
 *  外面的圈
 */
@property(nonatomic,strong) UIImageView *imageViewB;
@end

@implementation ReaderMedplusLoadingView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.imageViewC];
        [self addSubview:self.imageViewB];
        
        CGSize  imgCSize = self.imageViewC.image.size;
        CGFloat imgC_X = (frame.size.width - imgCSize.width) * 0.5;
        CGFloat imgC_Y = (frame.size.height - imgCSize.height) * 0.5;
        self.imageViewC.frame = CGRectMake(imgC_X, imgC_Y, imgCSize.width, imgCSize.height);
        
        
        CGSize imgBSize = self.imageViewB.image.size;
        CGFloat imgB_X = (frame.size.width - imgBSize.width) * 0.5;
        CGFloat imgB_Y = (frame.size.height - imgBSize.height) * 0.5;
        
        self.imageViewB.frame = CGRectMake(imgB_X, imgB_Y, imgBSize.width, imgBSize.height);
    }
    return self;
}

-(void)start
{
    self.hidden = NO;
    if ([self.imageViewB.layer animationForKey:AnimationKey]) {
        return;
    }
    else
    {
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:  M_PI * 2.0 ];
        rotationAnimation.duration = 1.0;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = CGFLOAT_MAX;
        
        [self.imageViewB.layer addAnimation:rotationAnimation forKey:AnimationKey];
    }
}

-(void)stop
{
    if ([self.imageViewB.layer animationForKey:AnimationKey]) {
        [self.imageViewB.layer removeAnimationForKey:AnimationKey];
        self.hidden = YES;
    }
}

#pragma mark -lazy
-(UIImageView *)imageViewC
{
    if (!_imageViewC) {
        
        NSBundle *bun = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Reader.bundle"]];
        UIImage *img = [UIImage imageWithContentsOfFile:[[bun resourcePath] stringByAppendingPathComponent:@"medplusLogo.png"]];
        _imageViewC = [[UIImageView alloc]initWithImage:img];
    }
    return _imageViewC;
}

-(UIImageView *)imageViewB
{
    if (!_imageViewB) {
        NSBundle *bun = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Reader.bundle"]];
        UIImage *img = [UIImage imageWithContentsOfFile:[[bun resourcePath] stringByAppendingPathComponent:@"medplusCicrle.png"]];
        _imageViewB = [[UIImageView alloc]initWithImage:img];
    }
    return _imageViewB;
}
@end
