//
//  ReaderNoNetView.m
//  Pods
//
//  Created by zhangbin on 16/6/20.
//
//

#import "ReaderNoNetView.h"


@interface ReaderNoNetView ()

@property (nonatomic, assign) ReaderAppType appType;

@property(nonatomic,strong) UIImageView *allin_imageView;
@property(nonatomic,strong) UILabel *allin_topLabel;

@property(nonatomic,strong) UIButton *allin_btn;

@property(nonatomic,strong) UIImageView *medplus_imageView;

@property(nonatomic,strong) UILabel *medplus_lbl;

@end

@implementation ReaderNoNetView

-(instancetype)initWithFrame:(CGRect)frame withReaderAppType:(ReaderAppType)appType{
    
    if (self = [super initWithFrame:frame]) {
        self.appType = appType;
        switch (appType) {
            case eReaderAllimdType:
                [self loadAllinView:frame];
                
                break;
            case eReaderMedPlusType:
                [self loadMedplusView:frame];
                
                break;
            case eReaderYdingType: // 医鼎
                [self loadMedplusView:frame];
                
                break;
                
            default:
                break;
        }
        
    }

}

-(void)loadAllinView:(CGRect)frame
{
    [self addSubview:self.allin_imageView];
    [self addSubview:self.allin_topLabel];
    [self addSubview:self.allin_btn];
    
    CGSize imageSize = self.allin_imageView.image.size;
    
    CGFloat imageViewX = (frame.size.width - imageSize.width)   * 0.5;
    CGFloat imageViewY = (frame.size.height * 0.5)  - imageSize.height - 20;
    self.allin_imageView.frame = CGRectMake(imageViewX, imageViewY, imageSize.width, imageSize.height);
    
    
    [self.allin_topLabel sizeToFit];
    CGSize lblSize = self.allin_topLabel.bounds.size;
    
    CGFloat lblX = (frame.size.width - lblSize.width) * 0.5;
    CGFloat lblY = CGRectGetMaxY(self.allin_imageView.frame) + 20 ;
    self.allin_topLabel.frame = CGRectMake(lblX, lblY, lblSize.width, lblSize.height);
    
    [self.allin_btn sizeToFit];
    CGSize btnSize = self.allin_btn.bounds.size;
    
    CGFloat btnX = (frame.size.width - btnSize.width) * 0.5;
    CGFloat btnY = CGRectGetMaxY(self.allin_topLabel.frame) + 20;
    
    self.allin_btn.frame = CGRectMake(btnX, btnY, btnSize.width, btnSize.height);
    
}


-(void)loadMedplusView:(CGRect)frame
{
    [self addSubview:self.medplus_imageView];
    [self addSubview:self.medplus_lbl];
    
    CGSize imgSize = self.medplus_imageView.image.size;
    
    CGFloat imageViewX = (frame.size.width - imgSize.width) * 0.5;
    CGFloat imageViewY = (frame.size.height * 0.5) - (imgSize.height * 0.5) - 15 ;
    self.medplus_imageView.frame = CGRectMake(imageViewX, imageViewY, imgSize.width, imgSize.height);
    
    [self.medplus_lbl sizeToFit];
    CGSize lblSize = self.medplus_lbl.bounds.size;
    
    CGFloat lblX = (frame.size.width - lblSize.width) * 0.5;
    CGFloat lblY = (frame.size.height * 0.5) + (lblSize.height * 0.5) + 15;
    
    self.medplus_lbl.frame = CGRectMake(lblX, lblY, lblSize.width, lblSize.height);
    
}


#pragma layz
-(UIImageView *)allin_imageView
{
    if (!_allin_imageView) {
        
        NSBundle *bun = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Reader.bundle"]];
        UIImage *img = [UIImage imageWithContentsOfFile:[[bun resourcePath] stringByAppendingPathComponent:@"allinNoNet.png"]];
        
        _allin_imageView = [[UIImageView alloc]initWithImage:img];
    }
    return _allin_imageView;
}

-(UILabel *)allin_topLabel
{
    if (!_allin_topLabel) {
        _allin_topLabel = [UILabel new];
        _allin_topLabel.textAlignment = NSTextAlignmentCenter;
        _allin_topLabel.textColor = [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1.0];
        _allin_topLabel.text = @"网络出错，请点击重新加载";
//        _allin_topLabel.font = [UIFont systemFontOfSize:15];

    }
    return _allin_topLabel;
}
-(UIButton *)allin_btn
{
    if (!_allin_btn) {
        _allin_btn = [[UIButton alloc]init];
        
        [_allin_btn setTitle:@"  重新加载  " forState:UIControlStateNormal];
        [_allin_btn setTitleColor:[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1.0] forState:UIControlStateNormal];
        
        _allin_btn.layer.borderWidth = 0.5;
        _allin_btn.layer.borderColor = [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1.0].CGColor;
        _allin_btn.layer.cornerRadius = 5;
        
    }
    return _allin_btn;
}

/**
 *  Medplus
 */

-(UIImageView *)medplus_imageView
{
    if (!_medplus_imageView) {
        NSBundle *bun = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Reader.bundle"]];
        UIImage *img = [UIImage imageWithContentsOfFile:[[bun resourcePath] stringByAppendingPathComponent:@"medplusNoNet.png"]];
        _medplus_imageView = [[UIImageView alloc]initWithImage:img];
    }
    return _medplus_imageView;
}

-(UILabel *)medplus_lbl
{
    if (!_medplus_lbl) {
        _medplus_lbl = [[UILabel alloc]init];
        
        _medplus_lbl.text = @"网络不太给力，点击重新加载";
        _medplus_lbl.textColor = [UIColor colorWithRed:115 / 255.0 green: 123 / 255.0 blue:143 / 255.0 alpha:1.0];
        _medplus_lbl.textAlignment = NSTextAlignmentCenter;
        _medplus_lbl.font = [UIFont systemFontOfSize:15.0];
        
    }
    return _medplus_lbl;
}
@end
