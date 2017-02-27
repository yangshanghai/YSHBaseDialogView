# ZBHBaseDialogView
类似UIAlertView的自定义弹窗视图，可以自定义添加任意view，代码供参考

#使用方式
将ZBHBaseDialogView.h和.m文件加入工程，并继承ZBHBaseDialogView根据需要进行添加、改写，主要包括下边三个函数<br/>

```c
//额外添加UIView, 将新增的UIView添加到参数contentView上
- (void)setupAdditionalContent:(UIView *)contentView;

//继承添加在弹窗之前需要执行的动作
- (void)showWithCompletion:(void (^)(id dialogView, NSInteger selectIndex))completeBlock; 

//继承添加在弹窗关闭后需要执行的动作
- (void)closeView;  
```

#实际效果图
![实际效果图](https://github.com/binhan198/ZBHBaseDialogView/raw/master/ZBHBaseDialogViewDemo/images/showImage.gif)
