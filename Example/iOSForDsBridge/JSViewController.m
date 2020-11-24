//
//  JSViewController.m
//  iOSForDsBridge
//
//  Created by chenjs on 11/23/2020.
//  Copyright (c) 2020 chenjs. All rights reserved.
//

#import "JSViewController.h"
#import <dsbridge.h>
#import "JSInvokeTest.h"

@interface JSViewController ()
@property (nonatomic, strong) DWKWebView *webView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation JSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addAndLoadWebView];
    [self registerJsMethods];
    [self addNativeButtons];
}

- (void)registerJsMethods {
    [self.webView addJavascriptObject:[[JSInvokeTest alloc] init] namespace:nil];
}

- (void)addAndLoadWebView {
    self.webView = [[DWKWebView alloc] initWithFrame:self.view.frame];
    
    [self registerJsMethods];
    
    // load test.html
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                          ofType:@"html"];
    NSString * htmlContent = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.webView loadHTMLString:htmlContent baseURL:baseURL];
    [self.view addSubview:self.webView];
    
    //显示结果
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, size.height - 40, size.width, 40)];
    self.label.backgroundColor = [UIColor lightGrayColor];
    self.label.textColor = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.text = @"这里显示原生调用js的结果";
    [self.view addSubview:self.label];
}

- (void)addNativeButtons {
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 150, 30)];
    [addBtn setTitle:@"调用js的addMethod" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(invokeAddMethod) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *subBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addBtn.frame) + 10, 200, 150, 30)];
    [subBtn setTitle:@"调用js的subMethod" forState:UIControlStateNormal];
    subBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    subBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [subBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    subBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:subBtn];
    [subBtn addTarget:self action:@selector(invokeSubMethod) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *invokeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 240, 170, 30)];
    [invokeBtn setTitle:@"调用js注册的异步多个方法" forState:UIControlStateNormal];
    invokeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    invokeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [invokeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    invokeBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:invokeBtn];
    [invokeBtn addTarget:self action:@selector(invokeMulMethod) forControlEvents:UIControlEventTouchUpInside];
}

//调用js注册的异步多个方法
- (void)invokeMulMethod {
    __weak typeof(self) weakSelf = self;
//    [self.webView callHandler:@"async.myadd2" arguments:@[@"hello ", @"zhangsan"] completionHandler:^(id  _Nullable value) {
//        weakSelf.label.text = [NSString stringWithFormat:@"%@", value];
//    }];
    
    //
    [self.webView callHandler:@"async.mysub2" arguments:@[@(101), @(1)] completionHandler:^(id  _Nullable value) {
        weakSelf.label.text = [NSString stringWithFormat:@"%@", value];
    }];
}

//调用js的addMethod
- (void)invokeAddMethod {
    __weak typeof(self) weakSelf = self;
    [self.webView callHandler:@"addMethod" arguments:@[@(1), @(1000)] completionHandler:^(id  _Nullable value) {
        weakSelf.label.text = [NSString stringWithFormat:@"%@", value];
    }];
}

//调用js的invokeSubMethod
- (void)invokeSubMethod {
    __weak typeof(self) weakSelf = self;
    [self.webView callHandler:@"subMethod" arguments:@[@(1000), @(1)] completionHandler:^(id  _Nullable value) {
        weakSelf.label.text = [NSString stringWithFormat:@"%@", value];
    }];
}

@end
