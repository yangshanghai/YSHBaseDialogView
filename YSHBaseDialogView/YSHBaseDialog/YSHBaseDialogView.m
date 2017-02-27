//
//  YSHBaseDialogView.m
//  YSHBaseDialogView
//
//  Created by yangshanghai on 2017/2/27.
//  Copyright © 2017年 yangshanghai. All rights reserved.
//

#import "YSHBaseDialogView.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define kButtonTag      1001

@interface YSHBaseDialogView ()

@property (strong, nonatomic) UIView            *backView;
@property (strong, nonatomic) UIView            *contentView;

@property (strong, nonatomic) NSMutableArray    *buttonList;

@property (copy, nonatomic) void (^dialogViewCompleteHandle)(id dialogView, NSInteger selectIndex);

@property (nonatomic, assign) CGFloat contentCenterYOffsetNormal;
@property (nonatomic, assign) CGFloat contentCenterYOffsetAvoid;

@end

@implementation YSHBaseDialogView

#pragma mark - lifeCircle

- (instancetype)init
{
    return [self initWithCancelButton:@"cancel" buttonTitles:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithCancelButton:@"cancel" buttonTitles:nil];
}

- (instancetype)initWithCancelButton:(NSString *)cancelTitle buttonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *arrayM = [NSMutableArray new];
    
    va_list args;
    va_start(args, otherButtonTitles);
    [arrayM addObject:cancelTitle];
    for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args, NSString*)) {
        if (str) {
            [arrayM addObject:str];
        }
    }
    va_end(args);
    
    return [self initWithContentSize:CGSizeMake(260, 200) buttonHeight:52 contentCenterYOffsetNormal:-23 contentCenterYOffsetAvoid:-79 buttonTitleArray:arrayM];
}

- (instancetype)initWithContentSize:(CGSize)contentSize
                       buttonHeight:(CGFloat)buttonHeight
         contentCenterYOffsetNormal:(CGFloat)contentCenterYOffsetNormal
          contentCenterYOffsetAvoid:(CGFloat)contentCenterYOffsetAvoid
                       CancelButton:(NSString *)cancelTitle
                       buttonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *arrayM = [NSMutableArray new];
    
    va_list args;
    va_start(args, otherButtonTitles);
    [arrayM addObject:cancelTitle];
    for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args, NSString*)) {
        if (str) {
            [arrayM addObject:str];
        }
    }
    va_end(args);
    
    return [self initWithContentSize:contentSize buttonHeight:buttonHeight contentCenterYOffsetNormal:contentCenterYOffsetNormal contentCenterYOffsetAvoid:contentCenterYOffsetAvoid buttonTitleArray:arrayM];
}
//core
- (instancetype)initWithContentSize:(CGSize)contentSize
                       buttonHeight:(CGFloat)buttonHeight
         contentCenterYOffsetNormal:(CGFloat)contentCenterYOffsetNormal
          contentCenterYOffsetAvoid:(CGFloat)contentCenterYOffsetAvoid
                   buttonTitleArray:(NSArray *)titleArray
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        [self configFrame:contentSize andContentCenterYOffsetNormal:contentCenterYOffsetNormal];
        [self configViewWithContentSize:contentSize buttonHeight:buttonHeight andTitleArray:titleArray];
        [self configKeyBoardAvoid:contentCenterYOffsetNormal contentCenterYOffsetAvoid:contentCenterYOffsetAvoid];
        [self setupAdditionalContent:self.contentView];
    }
    
    return self;
}

#pragma mark - config

- (void)configFrame:(CGSize)contentSize andContentCenterYOffsetNormal:(CGFloat)contentCenterYOffsetNormal
{
    self.backView.frame = self.bounds;
    self.contentView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    CGPoint contentCenterPoint = self.center;
    contentCenterPoint.y += contentCenterYOffsetNormal;
    self.contentView.center = contentCenterPoint;
}

- (void)configViewWithContentSize:(CGSize)contentSize
                     buttonHeight:(CGFloat)buttonHeight
                    andTitleArray:(NSArray *)titleArray
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backView];
    [self addSubview:self.contentView];
    
    //初始化按钮
    float btnWidth = contentSize.width / titleArray.count;
    for (NSInteger i = 0; i < titleArray.count; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(buttonCancelled:) forControlEvents:UIControlEventTouchDragExit];
        [btn setTag:kButtonTag + i];
        btn.frame = CGRectMake(i * btnWidth, contentSize.height - buttonHeight, btnWidth, buttonHeight);
        [self.contentView addSubview:btn];
        [self.buttonList addObject:btn];
        if (i) {
            [self.contentView addSubview:[self createVerticalOnePixelLine:CGRectMake(btnWidth * i, contentSize.height - buttonHeight, 0, buttonHeight) color:[UIColor colorWithWhite:0.9 alpha:1]]];
        }
    }
    [self.contentView addSubview:[self createOnePixelLine:CGRectMake(0, contentSize.height - buttonHeight, contentSize.width, 0) color:[UIColor colorWithWhite:0.9 alpha:1]]];
}

- (void)configKeyBoardAvoid:(CGFloat)contentCenterYOffsetNormal
  contentCenterYOffsetAvoid:(CGFloat)contentCenterYOffsetAvoid
{
    self.contentCenterYOffsetNormal = contentCenterYOffsetNormal;
    self.contentCenterYOffsetAvoid = contentCenterYOffsetAvoid;
}

#pragma mark - click event

- (void)buttonPushed:(UIButton *)sender
{
    sender.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
}

- (void)buttonCancelled:(UIButton *)sender
{
    sender.backgroundColor = [UIColor clearColor];
}

- (void)buttonAction:(UIButton *)sender
{
    sender.backgroundColor = [UIColor clearColor];
    if (self.dialogViewCompleteHandle) {
        self.dialogViewCompleteHandle(self, sender.tag - kButtonTag);
    }
    [self closeView];
}

#pragma mark - public

//显示视图
- (void)showWithCompletion:(void (^)(id dialogView, NSInteger selectIndex))completeBlock
{
    if (self.superview) {
        return;
    }
    
    [[self topView] addSubview:self];
    self.backView.alpha = 0;
    self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3f animations:^{
        self.backView.alpha = 1;
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    self.dialogViewCompleteHandle = completeBlock;
}

//隐藏视图
- (void)closeView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setupAdditionalContent:(UIView *)contentView
{
    //需要继承被改写
}

//移动内容视图，键盘躲避
- (void)upMoveContent
{
    CGPoint contentCenterPoint = self.center;
    contentCenterPoint.y += self.contentCenterYOffsetAvoid;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.center = contentCenterPoint;
    }];
}
- (void)downMoveContent
{
    CGPoint contentCenterPoint = self.center;
    contentCenterPoint.y += self.contentCenterYOffsetNormal;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.center = contentCenterPoint;
    }];
}

//设置全部按钮文字颜色，字体
- (void)setBtnTextColor:(UIColor *)color
{
    for (UIButton *btn in self.buttonList) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
}
- (void)setBtnTextFont:(UIFont *)font
{
    for (UIButton *btn in self.buttonList) {
        btn.titleLabel.font = font;
    }
}

//设置按钮颜色字体
- (void)setBtnTextColor:(UIColor *)color atIndex:(NSInteger)index
{
    if (index >= self.buttonList.count || index < 0) {
        return;
    }
    [self.buttonList[index] setTitleColor:color forState:UIControlStateNormal];
}
- (void)setBtnTextFont:(UIFont *)font atIndex:(NSInteger)index
{
    if (index >= self.buttonList.count || index < 0) {
        return;
    }
    [[self.buttonList[index] titleLabel] setFont:font];
}

#pragma mark - private

//获取最上层视图
- (UIView *)topView
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    return window;
}

- (UIView *)createOnePixelLine:(CGRect)rect color:(UIColor *)color
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y - 0.5, rect.size.width, 0.5)];
    lineView.backgroundColor = color;
    
    return lineView;
}

- (UIView *)createVerticalOnePixelLine:(CGRect)rect color:(UIColor *)color
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x - 0.5, rect.origin.y, 0.5, rect.size.height)];
    lineView.backgroundColor = color;
    
    return lineView;
}

#pragma mark - getter & setter

- (UIView *)backView
{
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _backView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        _contentView.layer.shadowOffset = CGSizeMake(0.1, 1.5);
        _contentView.layer.shadowRadius = 1.5;
        _contentView.layer.shadowOpacity = 0.4;
    }
    return _contentView;
}

- (NSMutableArray *)buttonList
{
    if (!_buttonList) {
        _buttonList = [NSMutableArray new];
    }
    return _buttonList;
}

@end
