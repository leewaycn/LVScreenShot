//
//  ImageMarkViewController.m
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/9.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "ImageMarkViewController.h"

#import "UIImage+LVManager.h"

@interface ImageMarkViewController ()
    {

        CGFloat height;
        CGFloat width;
        UIImageView *testImageview;
        UIImageView *testImageview1;
        UIImageView *testImageview2;

    }
@end

@implementation ImageMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    height = UIScreen.mainScreen.bounds.size.height;

    width = UIScreen.mainScreen.bounds.size.width;

    self.view.backgroundColor = [UIColor whiteColor];


    testImageview = [UIImageView new];
    UIImage *logo = [UIImage imageNamed:@"logo"];
    testImageview.frame = CGRectMake(50, 150, 100, 100);

    [self.view addSubview:testImageview];

    __weak typeof(self  ) weakself = self;
    [[LVManager share] asyn_tailorImageWithimageName:logo CompletedBlock:^(UIImage *newImage) {

        __strong typeof(weakself) StrongSelf = weakself;

        StrongSelf ->testImageview .image = newImage;


    }];




    testImageview1 = [UIImageView new];

    testImageview1.frame = CGRectMake(50, 250, 200, 200);

    [self.view addSubview:testImageview1];

    [[LVManager share] asyn_tailoringImageWithImage:logo cornerRadius:50 Block:^(UIImage *newImage) {
        __strong typeof(weakself) StrongSelf = weakself;

        StrongSelf ->testImageview1 .image = newImage;

    }];





    testImageview2 = [UIImageView new];

    testImageview2.frame = CGRectMake(50, 450, 100, 100);

    [self.view addSubview:testImageview2];

    [[LVManager share] async_tailoringImageLayerWithImage:logo borderWidth:10.0 borderColor:[UIColor redColor] completed:^(UIImage *newImage) {
        __strong typeof(weakself) StrongSelf = weakself;

        StrongSelf ->testImageview2 .image = newImage;

    }];



    
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
