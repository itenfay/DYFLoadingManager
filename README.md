[如果此项目能帮助到你，就请你给一颗星。谢谢！(If this project can help you, please give it a star. Thanks!)](https://github.com/dgynfi/DYFLoadingManager)

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;

## DYFLoadingManager

`DYFLoadingManager`是一个 iOS 加载动画提示的管理类，它显示带有指示器和/或标签的半透明遮罩直到任务完成。( `DYFLoadingManager` is an iOS management class that loads animation prompts, it displays a translucent mask with an indicator and labels while work is being done. )

## Group (ID:614799921)

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFLoadingManager/raw/master/images/g614799921.jpg" width="30%" />
</div>

## Preview

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFLoadingManager/raw/master/images/LoadingPreview.gif" width="30%" />
</div>

## Usage

-  展示加载提示 (Shows Loading)

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

- 在一个视图中展示加载提示 (Shows Loading in a view)

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

- 隐藏加载提示 (Hide Loading)

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

## Code Sample

- [Code Sample Portal](https://github.com/dgynfi/DYFLoadingManager/blob/master/Basic%20Files/ViewController.m)
