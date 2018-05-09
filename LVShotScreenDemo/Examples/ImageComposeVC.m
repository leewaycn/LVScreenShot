//
//  ImageComposeVC.m
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/9.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "ImageComposeVC.h"
#import "UIImage+LVManager.h"
@interface ImageComposeVC ()
    {

        CGFloat height;
        CGFloat width;
        UIImageView *testImageview;
    }
@end

@implementation ImageComposeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    height = UIScreen.mainScreen.bounds.size.height;

    width = UIScreen.mainScreen.bounds.size.width;

    self.view.backgroundColor = [UIColor whiteColor];


   testImageview = [UIImageView new];
    testImageview.image = [UIImage imageNamed:@"1"];
    testImageview.frame = CGRectMake(10, 100, width-20, height-200);

    [self.view addSubview:testImageview];
    

    UIButton *leftbutotn = [UIButton new];
    leftbutotn.backgroundColor =[UIColor yellowColor];
    [leftbutotn setTitle:@"加logo" forState:UIControlStateNormal];
    [leftbutotn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftbutotn addTarget:self action:@selector(screenshotALL) forControlEvents:UIControlEventTouchUpInside];
    leftbutotn.frame = CGRectMake(20, height-50, 100, 40);
    [self.view addSubview:leftbutotn];

    UIButton *rightbutotn = [UIButton new];
    rightbutotn.backgroundColor =[UIColor yellowColor];
    [rightbutotn setTitle:@"多图片合成" forState:UIControlStateNormal];
    [rightbutotn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightbutotn addTarget:self action:@selector(clearscreenshotALL) forControlEvents:UIControlEventTouchUpInside];
    rightbutotn.frame = CGRectMake(width- 120, height-50, 100, 40);
    [self.view addSubview:rightbutotn];

}

    -(void)screenshotALL{

        UIImage *image = [UIImage imageNamed:@"1"];

        image = [image composeImageWithLogo:image LogoOrigin:CGPointMake(100, 50) LogoSize:CGSizeMake(240, 120)];

        testImageview.image = image;

    }
    -(void)clearscreenshotALL{

        NSArray *images = @[[UIImage imageNamed:@"0"],
                            [UIImage imageNamed:@"1"],
                            [UIImage imageNamed:@"2"],
                            [UIImage imageNamed:@"logo"]
                            ];

        NSArray *imgeRects = @[
                               [NSValue valueWithCGRect: CGRectMake(10, 10, 200, 100)],

                               [NSValue valueWithCGRect: CGRectMake(30, 150, 300, 100)],

                               [NSValue valueWithCGRect: CGRectMake(21, 280, 200, 100)],

                               [NSValue valueWithCGRect: CGRectMake(280, 280, 200, 100)]];

        UIImage *image = [[LVManager share] composeImageWithLogo:[UIImage imageNamed:@"bgGreen"] imageRect:imgeRects Images:images];

        testImageview.image = image;


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
