## [Chinese Document](https://github.com/dgynfi/DYFLoadingManager)


If this project can help you, please give it [a star](https://github.com/dgynfi/DYFLoadingManager/blob/master/README-en.md). Thanks!


## DYFLoadingManager

`DYFLoadingManager` is an iOS management class that loads animation prompts, it displays a translucent mask with an indicator and labels while work is being done.

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;


## Group (ID:614799921)

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFLoadingManager/raw/master/images/g614799921.jpg" width="30%" />
</div>

## Preview

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFLoadingManager/raw/master/images/LoadingPreview.gif" width="30%" />
</div>

## Usage

-  Show Loading

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

- Show Loading in a view

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

- Hide Loading

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


## Demo

To learn more, please check out [Demo](https://github.com/dgynfi/DYFLoadingManager/blob/master/Basic%20Files/ViewController.m).


## Feedback is welcome

If you notice any issue, got stuck or just want to chat feel free to create an issue. I will be happy to help you.
