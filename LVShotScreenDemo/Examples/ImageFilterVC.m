//
//  ImageFilterVC.m
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/9.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "ImageFilterVC.h"

#import "UIImage+LVManager.h"
@interface ImageFilterVC ()

    {
        CGFloat height;
        CGFloat width;
        UIImageView *imageview;

        UIImage *originalImage ;
    }
@end

@implementation ImageFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];


    height = UIScreen.mainScreen.bounds.size.height;

    width = UIScreen.mainScreen.bounds.size.width;

    self.view.backgroundColor = [UIColor whiteColor];


    originalImage = [UIImage imageNamed:@"image"];

    CGFloat btnWidth = (self.view.frame.size.width -40)/4.0;
    imageview = [UIImageView new];
    imageview.frame = CGRectMake(20, 70, width-40, width);
    imageview.layer.shadowOpacity = 0.8;
    imageview.layer.shadowColor = UIColor.blackColor.CGColor;
    imageview.layer.shadowOffset = CGSizeMake(1, 1);
    imageview.image = originalImage;

    [self.view addSubview:imageview];

    NSArray *titleArr = @[@"怀旧",@"黑白",@"色调",@"岁月",@"单色",@"褪色",@"冲印",@"烙黄",@"原图"];

    for (int i = 0; i<titleArr.count; i++) {

        UIButton *btn = [UIButton new];
        btn.tag = 100+i;
        btn.frame = CGRectMake(20+btnWidth*(i%4), width+100+40*(i/4), btnWidth, 40);

        [btn setTitle:titleArr[i] forState:UIControlStateNormal];

        if(i==8){
            btn.backgroundColor = [UIColor yellowColor];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addImageFilter:) forControlEvents:UIControlEventTouchUpInside];

         [self.view addSubview:btn];
    }




}
-(void)resetBtn{

    for (UIView *sbView in self.view.subviews) {
        if(sbView.tag-100<=10){
            sbView.backgroundColor = [UIColor whiteColor];
        }
    }
}
    -(void)addImageFilter:(UIButton*)chnageBtn{

        [self resetBtn];
        switch (chnageBtn.tag-100) {
            case 0:
            {
                UIImage *newImage = [[LVManager share] imageFilterHandle:originalImage Filtername:@"CIPhotoEffectInstant"];

                imageview.image = newImage;

                chnageBtn.backgroundColor = [UIColor yellowColor];
            }
            break;
            case 1:
            {  UIImage *newImage = [[LVManager share] imageFilterHandle:originalImage Filtername:@"CIPhotoEffectNoir"];

                imageview.image = newImage;

                chnageBtn.backgroundColor = [UIColor yellowColor];

            }
            break;
            case 2:
            {
                UIImage *newImage = [[LVManager share] imageFilterHandle:originalImage Filtername:@"CIPhotoEffectTonal"];

                imageview.image = newImage;

                chnageBtn.backgroundColor = [UIColor yellowColor];
            }
            break;
            case 3:
            {
                UIImage *newImage = [[LVManager share] imageFilterHandle:originalImage Filtername:@"CIPhotoEffectTransfer"];

                imageview.image = newImage;

                chnageBtn.backgroundColor = [UIColor yellowColor];
            }
            break;
            case 4:
            {
                UIImage *newImage = [[LVManager share] imageFilterHandle:originalImage Filtername:@"CIPhotoEffectMono"];

                imageview.image = newImage;

                chnageBtn.backgroundColor = [UIColor yellowColor];
            }
            break;
            case 5:
            {
                UIImage *newImage = [[LVManager share] imageFilterHandle:originalImage Filtername:@"CIPhotoEffectFade"];

                imageview.image = newImage;

                chnageBtn.backgroundColor = [UIColor yellowColor];
            }
            break;
            case 6:
            {
                UIImage *newImage = [[LVManager share] imageFilterHandle:originalImage Filtername:@"CIPhotoEffectProcess"];

                imageview.image = newImage;

                chnageBtn.backgroundColor = [UIColor yellowColor];
            }
            break;
            case 7:
            {  UIImage *newImage = [[LVManager share] imageFilterHandle:originalImage Filtername:@"CIPhotoEffectChrome"];

                imageview.image = newImage;

                chnageBtn.backgroundColor = [UIColor yellowColor];

            }
            break;

            case 8:
            {
                UIImage *newImage = originalImage;

                imageview.image = newImage;

                chnageBtn.backgroundColor = [UIColor yellowColor];
            }
            break;
            case 9:
            {
                UIImage *newImage = [[LVManager share] imageFilterHandle:originalImage Filtername:@"CIPhotoEffectInstant"];

                imageview.image = newImage;

                chnageBtn.backgroundColor = [UIColor yellowColor];
            }
            break;
            default:
            break;
        }


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
