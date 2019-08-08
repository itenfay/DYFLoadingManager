//
//  ViewController.m
//
//  Created by dyf on 2016/07/26.
//  Copyright © 2016 dyf. All rights reserved.
//

#import "ViewController.h"
#import "DYFLoadingManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)show:(id)sender {
    [DYFLoadingManager.shared setDimBackground:NO];
    [DYFLoadingManager.shared setCentralImage:nil];

    [DYFLoadingManager.shared setText:@"全力加载中..."];
    
    [DYFLoadingManager.shared setRingColor:UIColor.whiteColor];
    [DYFLoadingManager.shared setCornerRadius:10.f];
    
    [DYFLoadingManager.shared showLoading];
    
    [self hideAfterDelay:5.f];
}

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

- (void)hideAfterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

- (void)hide {
    if (DYFLoadingManager.shared.hasLoading) {
        [DYFLoadingManager.shared hideLoading];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
