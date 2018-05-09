//
//  WebViewShotViewController.m
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/9.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "WebViewShotViewController.h"
#import "UIView+LVShot.h"
#import "UIScrollView+LVShot.h"
@interface WebViewShotViewController ()<UIWebViewDelegate>
    {
        CGFloat height;
        CGFloat width;
        UIWebView *webView;
        UIScrollView *storeScrollView;
        UIImageView *storeImage;
        UIActivityIndicatorView *activity;

    }
@end

@implementation WebViewShotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    height = UIScreen.mainScreen.bounds.size.height;

    width = UIScreen.mainScreen.bounds.size.width;


    self.view.backgroundColor = [UIColor whiteColor];

    webView = [[UIWebView alloc]initWithFrame:CGRectMake(10, 100, width, height-150)];
    [self.view addSubview:webView];
    webView.delegate = self;
    webView.backgroundColor = [UIColor purpleColor];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: @"https://www.jianshu.com/p/7c8cf9bef56f"]]];
    



    UIButton *leftbutotn = [UIButton new];
    leftbutotn.backgroundColor =[UIColor yellowColor];
    [leftbutotn setTitle:@"截webView" forState:UIControlStateNormal];
    [leftbutotn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftbutotn addTarget:self action:@selector(screenshotALL) forControlEvents:UIControlEventTouchUpInside];
    leftbutotn.frame = CGRectMake(20, height-50, 150, 40);
    [self.view addSubview:leftbutotn];

    UIButton *rightbutotn = [UIButton new];
    rightbutotn.backgroundColor =[UIColor yellowColor];
    [rightbutotn setTitle:@"清除" forState:UIControlStateNormal];
    [rightbutotn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightbutotn addTarget:self action:@selector(clearscreenshotALL) forControlEvents:UIControlEventTouchUpInside];
    rightbutotn.frame = CGRectMake(width- 120, height-50, 100, 40);
    [self.view addSubview:rightbutotn];




    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:
                                          UIActivityIndicatorViewStyleWhiteLarge];
    [ self.view addSubview:indicator];
    indicator.frame = CGRectMake(width/2-15, 70, 30, 30);
    indicator.backgroundColor = [UIColor blackColor];
    indicator.hidesWhenStopped = YES;
    [self.view addSubview:indicator];

    activity = indicator;
    
}


-(void)screenshotALL{

    activity .hidden = NO;
    [activity startAnimating];
    __weak typeof(self) weakSelf = self;

    [webView DDGContentScreenShot:^(UIImage *screenShotImage) {

        __strong typeof(weakSelf) strongSelf = weakSelf;

        [strongSelf showScreenShot:screenShotImage];
        strongSelf->activity .hidden = YES;
        [strongSelf->activity stopAnimating];

    }];
    
}
    -(void)clearscreenshotALL{
        if(storeScrollView!=nil){
            [storeScrollView removeFromSuperview];
            storeScrollView = nil;
        }
    }

    -(void)showScreenShot:(UIImage*)image{

        if(storeScrollView==nil){
            storeScrollView = [UIScrollView new];
        }


        CGFloat imageFakewidth = width/2;
        CGFloat imageFakeHeight = image.size.height*imageFakewidth/image.size.width;

        storeScrollView.contentSize = CGSizeMake(imageFakewidth, imageFakeHeight);
        storeScrollView.frame =CGRectMake(0, 0, width/2, height/2);
        storeScrollView.center = self.view .center;
        storeScrollView.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:storeScrollView];

        storeImage = [UIImageView new];
        storeImage.image = image;
        [storeScrollView addSubview:storeImage];
        storeImage.frame = CGRectMake(0, 0, imageFakewidth, imageFakeHeight);



    }

    -(void)webViewDidStartLoad:(UIWebView *)webView{
        activity .hidden = NO;
        [activity startAnimating];
    }
    -(void)webViewDidFinishLoad:(UIWebView *)webView{
        activity .hidden = YES;
        [activity stopAnimating];
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
