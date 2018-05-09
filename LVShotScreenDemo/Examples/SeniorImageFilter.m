//
//  SeniorImageFilter.m
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/9.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "SeniorImageFilter.h"

@interface SeniorImageFilter ()
    {
        CGFloat height;
        CGFloat width;
        UIImageView *imageview;
        UIImage *originalImage ;

        CIContext *context;
        UISlider *slider;
        CIFilter *filter;

    }
@end

@implementation SeniorImageFilter

- (void)viewDidLoad {
    [super viewDidLoad];


    height = UIScreen.mainScreen.bounds.size.height;

    width = UIScreen.mainScreen.bounds.size.width;

    self.view.backgroundColor = [UIColor whiteColor];

    originalImage = [UIImage imageNamed:@"image"];

    CGFloat btnWidth = (self.view.frame.size.width -40)/4.0;

    context = [CIContext contextWithOptions:nil];

    imageview = [UIImageView new];
    imageview.frame = CGRectMake(20, 70, width-40, width);
    imageview.layer.shadowOpacity = 0.8;
    imageview.layer.shadowColor = UIColor.blackColor.CGColor;
    imageview.layer.shadowOffset = CGSizeMake(1, 1);
    imageview.image = originalImage;

    [self.view addSubview:imageview];

    slider = [UISlider new];
    slider.frame = CGRectMake(20, width+80, width-40, 20);
    slider.maximumValue = M_PI;
    slider.minimumValue = -M_PI;
    slider.value = 0;
    [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];

     [self.view addSubview:slider];
    CIImage *inputiImage = [CIImage imageWithCGImage:originalImage.CGImage];

    filter = [CIFilter filterWithName:@"CIHueAdjust"];
    [filter setValue:inputiImage forKey:kCIInputImageKey];

    [slider sendActionsForControlEvents:UIControlEventValueChanged];

    NSArray *titleArr  = @[@"原图",@"高斯模糊",@"老电影"];
    for (int i = 0; i<titleArr.count; i++) {

        UIButton *btn = [UIButton new];
        btn.tag = 1000+i;
        btn.frame = CGRectMake(20+btnWidth*(i%4), width+100+40*(i/4), btnWidth, 40);

        [btn setTitle:titleArr[i] forState:UIControlStateNormal];

        if(i==0){
            btn.backgroundColor = [UIColor yellowColor];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addImageFilter:) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:btn];
    }

}

-(void)showFiltersInConsole{


    NSArray *filterNams = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];

    NSLog(@"%@",filterNams);


    
}
    -(void)addImageFilter:(UIButton*)changeBtn{

        [self resetBtn];


        switch (changeBtn.tag-1000) {
            case 0:

            {
                imageview.image = originalImage;
                changeBtn.backgroundColor = [UIColor yellowColor];
            }
            break;
            case 1:

            {
                [self gaussianBlurFilmEffect];
                changeBtn.backgroundColor = [UIColor yellowColor];
            }
            break;
            case 2:

            {
                [self oldFilmEffect];

                changeBtn.backgroundColor = [UIColor yellowColor];
            }
            break;

            default:
            break;
        }
    }
    -(void)gaussianBlurFilmEffect{

        filter = [CIFilter filterWithName:@"CIGaussianBlur"];

        [filter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputRadius"];

        CIImage *inputImage = [CIImage imageWithCGImage:originalImage.CGImage];
        [filter setValue:inputImage forKey:kCIInputImageKey];

        CIImage *outputimage = filter.outputImage;

      struct  CGImage * cgimage = [context createCGImage:outputimage fromRect:outputimage.extent];

        imageview.image = [UIImage imageWithCGImage:cgimage];

    }
    -(void)oldFilmEffect{

        CIImage *inputImage = [CIImage imageWithCGImage:originalImage.CGImage];
        // 1.创建CISepiaTone滤镜（棕绿色）
        CIFilter* sepiaToneFilter = [CIFilter filterWithName:@"CISepiaTone"];
        [sepiaToneFilter setValue:inputImage forKey:kCIInputImageKey];
        //参数是强度
        [sepiaToneFilter setValue:@1 forKey:kCIInputIntensityKey];
        // 2.创建白班图滤镜
        CIFilter* whiteSpecksFilter = [CIFilter filterWithName:@"CIColorMatrix"];
        CIFilter *randomFiter  = [CIFilter filterWithName:@"CIRandomGenerator"] ;
        CIImage *randomImage = randomFiter.outputImage;
        [whiteSpecksFilter setValue:[randomImage imageByCroppingToRect:inputImage.extent] forKey:kCIInputImageKey];

        [whiteSpecksFilter setValue:[CIVector vectorWithX:0 Y:1 Z:0 W:0] forKey:@"inputRVector"];
        [whiteSpecksFilter setValue:[CIVector vectorWithX:0 Y:1 Z:0 W:0] forKey:@"inputGVector"];
        [whiteSpecksFilter setValue:[CIVector vectorWithX:0 Y:1 Z:0 W:0] forKey:@"inputBVector"];
        [whiteSpecksFilter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputBiasVector"];

        //        let outputImage = whiteSpecksFilter.outputImage!
        //        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        //        imageView.image = UIImage(cgImage: cgImage!)
        // 3.把CISepiaTone滤镜和白班图滤镜以源覆盖(source over)的方式先组合起来

        CIFilter  *sourceOverCompositingFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];

        [sourceOverCompositingFilter setValue:whiteSpecksFilter.outputImage forKey:kCIInputBackgroundImageKey];
        [sourceOverCompositingFilter setValue:sepiaToneFilter.outputImage forKey:kCIInputImageKey];
        // 4.用CIAffineTransform滤镜先对随机噪点图进行处理 应用坐标系


        CIFilter *affineTransformFilter = [CIFilter filterWithName:@"CIAffineTransform"];
        [affineTransformFilter setValue:[randomFiter.outputImage imageByCroppingToRect:inputImage.extent] forKey:kCIInputImageKey];

        [affineTransformFilter setValue:[NSValue valueWithCGAffineTransform: CGAffineTransformMakeScale(1.5, 2.5)] forKey:kCIInputTransformKey];

        //        let outputImage = affineTransformFilter.outputImage!
        //        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        //        imageView.image = UIImage(cgImage: cgImage!)
        // 5.创建蓝绿色磨砂图滤镜

        CIFilter* darkScratchesFilter = [CIFilter filterWithName:@"CIColorMatrix"];
        [darkScratchesFilter setValue:affineTransformFilter.outputImage forKey:kCIInputImageKey];

        [darkScratchesFilter setValue:[CIVector vectorWithX:4 Y:0 Z:0 W:0] forKey:@"inputRVector"];
        [darkScratchesFilter setValue:[CIVector vectorWithX:0 Y:1 Z:0 W:0] forKey:@"inputGVector"];
        [darkScratchesFilter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputBVector"];
        [darkScratchesFilter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputAVector"];
        [darkScratchesFilter setValue:[CIVector vectorWithX:0 Y:1 Z:1 W:1] forKey:@"inputBiasVector"];

        // 6.用CIMinimumComponent滤镜把蓝绿色磨砂图滤镜处理成黑色磨砂图滤镜

        CIFilter *minimumComponentFilter = [CIFilter filterWithName:@"CIMinimumComponent"];
        [minimumComponentFilter setValue:darkScratchesFilter.outputImage forKey:kCIInputImageKey];
        // 7.最终组合在一起

        CIFilter *multiplyCompositingFilter =[CIFilter filterWithName:@"CIMultiplyCompositing"];

        [multiplyCompositingFilter setValue:minimumComponentFilter.outputImage forKey:kCIInputBackgroundImageKey];
        [multiplyCompositingFilter setValue:sourceOverCompositingFilter.outputImage forKey:kCIInputImageKey];
        // 8.最后输出

        CIImage *outputImage= multiplyCompositingFilter.outputImage;
        struct  CGImage * cgimage = [context createCGImage:outputImage fromRect:outputImage.extent];

        imageview.image = [UIImage imageWithCGImage:cgimage];





    }
    -(void)valueChanged:(UISlider*)sl{
        NSLog(@"%f",sl.value);

        
        CIImage *inputiImage = [CIImage imageWithCGImage:originalImage.CGImage];

        filter = [CIFilter filterWithName:@"CIHueAdjust"];
        [filter setValue:inputiImage forKey:kCIInputImageKey];


        [filter setValue:[NSNumber numberWithFloat: sl.value] forKey:@"inputAngle"];

        CIImage *outputImage = filter.outputImage;

        struct CGImage *cgImage= [context createCGImage:outputImage fromRect:outputImage.extent];

        imageview.image = [UIImage imageWithCGImage:cgImage];



        

    }


-(void)resetBtn{

    for (UIView *sbView in self.view.subviews) {
        if(sbView.tag-1000<=10){
            sbView.backgroundColor = [UIColor whiteColor];
        }
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
