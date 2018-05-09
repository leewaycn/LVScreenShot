//
//  ClearImageViewVC.m
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/9.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "ClearImageViewVC.h"
#import "UIImage+LVManager.h"

@interface ClearImageViewVC ()
    {
        CGFloat height;
        CGFloat width;
        UIImageView *testImageview;
    }

    @property (nonatomic,strong)UIImageView *bottomImageView;
    @property (nonatomic,strong)UIImageView *clearImageView;


@end

@implementation ClearImageViewVC

-(UIImageView*)bottomImageView{
    if (!_bottomImageView){

        _bottomImageView = [UIImageView new];
        _bottomImageView.image = [UIImage imageNamed:@"image"];
        _bottomImageView.frame = CGRectMake(0, 100, width, width);
        [self.view addSubview:_bottomImageView];

    }
    return _bottomImageView;
}


-(UIImageView*)clearImageView{
    if (!_clearImageView){

        _clearImageView = [UIImageView new];
        _clearImageView.image = [UIImage imageNamed:@"logo"];
        _clearImageView.frame = CGRectMake(0, 100, width, width);
        [self.view addSubview:_clearImageView];

    }
    return _clearImageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];


    height = UIScreen.mainScreen.bounds.size.height;

    width = UIScreen.mainScreen.bounds.size.width;

    self.view.backgroundColor = [UIColor whiteColor];

    self.bottomImageView .userInteractionEnabled = NO;

    self.clearImageView .userInteractionEnabled = YES;

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(clearpanTouch:)];

    [self.clearImageView addGestureRecognizer:pan];




}
    -(void)clearpanTouch:(UIPanGestureRecognizer*)pan{

        UIImageView *imageV = (UIImageView*) pan.view;
        CGPoint clearPan = [pan locationInView:imageV];

        CGRect rect = CGRectMake(clearPan.x-15, clearPan.y-15, 30, 30);
        UIImage *newImage = [[LVManager share] clearImage:imageV Rect:rect];

        imageV.image = newImage;
        
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
