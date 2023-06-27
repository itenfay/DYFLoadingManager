## DYFLoadingManager

`DYFLoadingManager`是一个 iOS 加载动画提示的管理类，它显示带有指示器和/或标签的半透明遮罩直到任务完成。

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;

## QQ群 (ID:614799921)

<div align=left>
&emsp; <img src="https://github.com/chenxing640/DYFLoadingManager/raw/master/images/g614799921.jpg" width="30%" />
</div>

## 预览

<div align=left>
&emsp; <img src="https://github.com/chenxing640/DYFLoadingManager/raw/master/images/LoadingPreview.gif" width="30%" />
</div>

## 使用

-  展示加载提示

```
- (IBAction)show:(id)sender {
    [DYFLoadingManager.shared setDimBackground:NO];
    [DYFLoadingManager.shared setCentralImage:nil];

    [DYFLoadingManager.shared setText:@"全力加载中..."];

    [DYFLoadingManager.shared setRingColor:UIColor.whiteColor];
    [DYFLoadingManager.shared setCornerRadius:10.f];

    [DYFLoadingManager.shared showLoading];

    [self hideAfterDelay:5.f];
}
```

- 在一个视图中展示加载提示

```
- (IBAction)showInView:(id)sender {
    [DYFLoadingManager.shared setDimBackground:YES];
    
    UIImage *image = [UIImage imageNamed:@"tencentv_logo"];
    [DYFLoadingManager.shared setCentralImage:image];

    [DYFLoadingManager.shared setText:@"正在请求，请稍等..."];
    [DYFLoadingManager.shared setRingColor:UIColor.orangeColor];
    [DYFLoadingManager.shared setCornerRadius:15.f];

    UIView *view = self.navigationController.view;
    [DYFLoadingManager.shared showLoadingInView:view];

    [self hideAfterDelay:5.f];
}
```

- 隐藏加载提示

```
- (void)hideAfterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

- (void)hide {
    if (DYFLoadingManager.shared.hasLoading) {
        [DYFLoadingManager.shared hideLoading];
    }
}
```

## 演示

如需了解更多，请查看[Demo](https://github.com/chenxing640/DYFLoadingManager/blob/master/Basic%20Files/ViewController.m)。

## 欢迎反馈

如果你注意到任何问题被卡住，请创建一个问题。我很乐意帮助你。
