//
//  CustomDialogView.m
//  YSHBaseDialogView
//
//  Created by yangshanghai on 2017/2/27.
//  Copyright © 2017年 yangshanghai. All rights reserved.
//

#import "CustomDialogView.h"

@interface CustomDialogView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) CABasicAnimation *rotationAnimation;

@end

@implementation CustomDialogView

- (void)setupAdditionalContent:(UIView *)contentView
{
    [contentView addSubview:self.titleLabel];
    [contentView addSubview:self.imgView];
    [contentView addSubview:self.textField];
    
    self.titleLabel.frame = CGRectMake(0, 20, contentView.bounds.size.width, 30);
    self.imgView.frame = CGRectMake((contentView.bounds.size.width - 24) / 2, 60, 24, 24);
    self.textField.frame = CGRectMake(20, 100, contentView.bounds.size.width - 40, 30);
    
    [self setBtnTextFont:[UIFont boldSystemFontOfSize:17]];
    [self setBtnTextColor:[UIColor blueColor]];
    [self setBtnTextColor:[UIColor redColor] atIndex:0];
}

#pragma mark - event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

#pragma mark - overwrite

- (void)showWithCompletion:(void (^)(id, NSInteger))completeBlock
{
    [super showWithCompletion:completeBlock];
    //视图打开前的额外工作
    self.textField.text = @"";
    [self.imgView.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
}

- (void)closeView
{
    [super closeView];
    //视图关闭时的额外工作
    [self.imgView.layer removeAllAnimations];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self upMoveContent];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self downMoveContent];
}

#pragma mark - getter & setter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"请输入文本";
    }
    return _titleLabel;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_function"]];
    }
    return _imgView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.layer.borderWidth = 0.5;
        _textField.delegate = self;
    }
    return _textField;
}

- (CABasicAnimation *)rotationAnimation
{
    if (!_rotationAnimation) {
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
        _rotationAnimation.duration = 2;
        _rotationAnimation.cumulative = YES;
        _rotationAnimation.repeatCount = MAXFLOAT;
    }
    return _rotationAnimation;
}

@end
