//
//  ViewShotViewController.m
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/9.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "ViewShotViewController.h"

#import "UIView+LVShot.h"




@interface ViewShotViewController ()
{

    CGFloat height;
    CGFloat width;

    UIImageView *storeImage;
}
@end

@implementation ViewShotViewController



- (void)viewDidLoad {
    [super viewDidLoad];


    height = UIScreen.mainScreen.bounds.size.height;

    width = UIScreen.mainScreen.bounds.size.width;

    
    self.view.backgroundColor = [UIColor whiteColor];


    UIView *blueView =[UIView new];
    blueView.backgroundColor  = [UIColor blueColor];
    blueView.frame = CGRectMake(0, 0, 100, 100);
    blueView.center = self.view.center;
     [self.view addSubview:blueView];


    UIImageView *logoVIew = [UIImageView new];
    logoVIew.image = [UIImage imageNamed:@"logo"];
    logoVIew.frame = CGRectMake(50, 100, 100, 100);

    [ self.view addSubview:logoVIew];

    UIButton *leftbutotn = [UIButton new];
    leftbutotn.backgroundColor =[UIColor yellowColor];
    [leftbutotn setTitle:@"截整个屏" forState:UIControlStateNormal];
    [leftbutotn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftbutotn addTarget:self action:@selector(screenshotALL) forControlEvents:UIControlEventTouchUpInside];
    leftbutotn.frame = CGRectMake(20, height-50, 100, 40);
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



    storeImage = [UIImageView new];

    [self.view addSubview:storeImage];






}


-(void)screenshotALL{

    __weak typeof(self) weakself = self;
    [self.view DDGScreenShotWithCompletionHandle:^(UIImage *screenShotImage) {

        __strong typeof(weakself) strongSelf = weakself;
        strongSelf-> storeImage .image = screenShotImage;
        strongSelf ->storeImage.frame = CGRectMake(0, 0, screenShotImage.size.width/2, screenShotImage.size.height/2);
        strongSelf ->storeImage.center = strongSelf.view.center;
        strongSelf.view.backgroundColor = [UIColor yellowColor];


    }];


}

-(void)clearscreenshotALL{

    self->storeImage.image = nil;
    self.view.backgroundColor = [UIColor whiteColor];
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
