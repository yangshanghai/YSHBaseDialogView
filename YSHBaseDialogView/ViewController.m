//
//  ViewController.m
//  YSHBaseDialogView
//
//  Created by yangshanghai on 2017/2/27.
//  Copyright © 2017年 yangshanghai. All rights reserved.
//

#import "ViewController.h"
#import "CustomDialogView.h"

@interface ViewController ()

@property (nonatomic, strong) CustomDialogView *popView;
@property (nonatomic, strong) UIButton *showButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.showButton];
}

- (void)viewDidLayoutSubviews
{
    self.showButton.frame = CGRectMake(0, 0, 200, 30);
    self.showButton.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClicked:(UIButton *)sender
{
    [self.popView showWithCompletion:^(id dialogView, NSInteger selectIndex) {
        NSLog(@"textOutput:%@, click buttonIndex:%ld", [[dialogView textField] text], selectIndex);
    }];
}

- (UIButton *)showButton
{
    if (!_showButton) {
        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_showButton setTitle:@"show pop view" forState:UIControlStateNormal];
        [_showButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showButton;
}

- (YSHBaseDialogView *)popView
{
    if (!_popView) {
        _popView = [[CustomDialogView alloc] initWithCancelButton:@"取消" buttonTitles:@"确定", nil];
    }
    return _popView;
}

@end

