[如果你觉得能帮助到你，请给一颗小星星。谢谢！(If you think it can help you, please give it a star. Thanks!)](https://github.com/dgynfi/DYFLoadingManager)

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;

## DYFLoadingManager

一个加载动画提示，设置，设置线条宽度，颜色，etc.。

## 技术交流群(群号:155353383) 

欢迎加入技术交流群，一起探讨技术问题。<br />
![](https://github.com/dgynfi/DYFLoadingManager/raw/master/images/qq155353383.jpg)

## 效果图

<div align=left>
<img src="https://github.com/dgynfi/DYFLoadingManager/raw/master/images/LoadingPreview.gif" width="40%" />
</div>

## 使用说明

-  展示加载提示 (Shows Loading)

```ObjC
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

- 在一个视图中展示加载提示 (Shows Loading in a view)

```ObjC
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

- 隐藏加载提示 (Hide Loading)

```ObjC
- (void)hideAfterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

- (void)hide {
    if (DYFLoadingManager.shared.hasLoading) {
        [DYFLoadingManager.shared hideLoading];
    }
}
```

## Sample Codes

- [Sample Codes Gateway](https://github.com/dgynfi/DYFLoadingManager/blob/master/Basic%20Files/ViewController.m)
