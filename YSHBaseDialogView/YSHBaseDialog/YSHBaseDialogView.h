//
//  YSHBaseDialogView.h
//  YSHBaseDialogView
//
//  Created by yangshanghai on 2017/2/27.
//  Copyright © 2017年 yangshanghai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSHBaseDialogView : UIView

//初始化
- (instancetype)initWithCancelButton:(NSString *)cancelTitle
                        buttonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithContentSize:(CGSize)contentSize
                       buttonHeight:(CGFloat)buttonHeight
         contentCenterYOffsetNormal:(CGFloat)contentCenterYOffsetNormal
          contentCenterYOffsetAvoid:(CGFloat)contentCenterYOffsetAvoid
                       CancelButton:(NSString *)cancelTitle
                       buttonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;

//添加额外控件，继承，改写
- (void)setupAdditionalContent:(UIView *)contentView;
- (void)showWithCompletion:(void (^)(id dialogView, NSInteger selectIndex))completeBlock;
- (void)closeView;

//移动内容视图，键盘躲避
- (void)upMoveContent;
- (void)downMoveContent;

//设置全部按钮文字颜色，字体
- (void)setBtnTextColor:(UIColor *)color;
- (void)setBtnTextFont:(UIFont *)font;

//设置按钮颜色字体
- (void)setBtnTextColor:(UIColor *)color atIndex:(NSInteger)index;
- (void)setBtnTextFont:(UIFont *)font atIndex:(NSInteger)index;

@end
