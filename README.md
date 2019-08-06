# DYFLoadingView

DYFLoadingView为加载动画提示，可放置Logo，设置线条宽度，颜色，etc.。

https://github.com/dyf/DYFLoadingView

`Author: dyf` <br>
`Date: 2017/1/10`

## Usage

## 1.实例化
```Objective-C
_loadingView = [DYFLoadingView loadingViewWithFrame:CGRectMake(30, 30, 160, 160) withImage:[UIImage imageNamed:@"Panda_64px"]];
_loadingView.lineWidth = 3.0;
_loadingView.lineColor = [UIColor whiteColor];
```

## 2.是否在加载
```Objective-C
[[DYFPopController sharedInstance] hasLoading];
```

## 3.显示
```Objective-C
[[DYFPopController sharedInstance] popLoadingView];
```

## 4.移除
```Objective-C
[[DYFPopController sharedInstance] removeLoadingView];
```

## 5.注意
`DYFPopController为DYFLoadingView展示的辅助类`
