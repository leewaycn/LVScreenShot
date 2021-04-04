//
//  UIImage+LVManager.m
//  LVShotScreenDemo
//
//  Created by leewaycn on 2018/5/8.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "UIImage+LVManager.h"


@implementation LVManager
+(instancetype)share{

    static LVManager *shar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shar = [[LVManager alloc]init];
    });
    return shar;
}

-(UIImage*)composeImageWithLogo:(UIImage*)bgImage imageRect:(NSArray* )imageRect Images:(NSArray<UIImage*>*)images{
    //以bgImage的图大小为底图
    CGImageRef  imageRef = bgImage.CGImage;
    CGFloat w = CGImageGetWidth(imageRef);
    CGFloat h = CGImageGetHeight(imageRef);
     //以1.png的图大小为画布创建上下文
     UIGraphicsBeginImageContext(CGSizeMake(w, h));
     [bgImage drawInRect:CGRectMake(0, 0, w, h)];
    //先把1.png 画到上下文中
    for (int i = 0;i< images.count; i++) {

        NSValue* rectvalue =(NSValue*) imageRect[i];

        CGRect rect = rectvalue.CGRectValue;
        [images[i] drawInRect:CGRectMake(rect.origin.x, rect.origin.y,rect.size.width, rect.size.height)];

    }

    //再把小图放在上下文中
 
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    //从当前上下文中获得最终图片
    UIGraphicsEndImageContext();
    return resultImg;

}

-(UIImage*)tailoringImage:(UIImage*)image{
    //开启上下文

    UIGraphicsBeginImageContext(image.size);
    //设置一个圆形的裁剪区域
     UIBezierPath *path = [ UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];

    //把路径设置为裁剪区域(超出裁剪区域以外的内容会被自动裁剪掉)
    [path addClip];
    //把图片绘制到上下文当中

    [image drawAtPoint:CGPointZero];
    //从上下文当中生成一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)asyn_tailorImageWithimageName:(UIImage*)imageName CompletedBlock:(void  (^)(UIImage *newImage))completed{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        UIImage *anewImage = [self tailoringImage: imageName];

        dispatch_async(dispatch_get_main_queue(), ^{
            completed(anewImage);

        });
    });
}

-(UIImage*)tailoringImage:(UIImage *)image withRadius:(CGFloat)radius{

    //开启上下文
    UIGraphicsBeginImageContext(image.size);
    //设置一个圆形的裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, image.size.width, image.size.height) cornerRadius:radius];
    //把路径设置为裁剪区域(超出裁剪区域以外的内容会被自动裁剪掉)
    [path addClip];
    //把图片绘制到上下文当中
    [image drawAtPoint:CGPointZero];
    //从上下文当中生成一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return newImage;


}

-(void)asyn_tailoringImageWithImage:(UIImage*)imageName  cornerRadius:(CGFloat)radius Block:(void (^)(UIImage *newImage))completed{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *anewImage = [self tailoringImage:imageName withRadius:radius];
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(anewImage);

        });
    });

}


-(UIImage*)tailoringImageLayerWithimageName:(UIImage*)imageName BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor {
    //1.先开启一个图片上下文 ,尺寸大小在原始图片基础上宽高都加上两倍边框宽度.
    CGSize imageSize = CGSizeMake(imageName.size.width+borderWidth*2, imageName.size.height+borderWidth*2);
    UIGraphicsBeginImageContext(imageSize);
    //2.填充一个圆形路径.这个圆形路径大小,和上下文尺寸大小一样.
    //把大圆画到上下文当中.
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    //颜色设置
    [borderColor set];
    //填充
    [path fill];
    //3.添加一个小圆,小圆,x,y从边框宽度位置开始添加,宽高和原始图片一样大小.把小圆设为裁剪区域.
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderWidth, borderWidth, imageName.size.width, imageName.size.height)];
    //把小圆设为裁剪区域.
    [clipPath addClip];
    //4.把图片给绘制上去.
    [imageName drawAtPoint:CGPointMake(borderWidth, borderWidth)];

    //5.从上下文当中生成一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //6.关闭上下文
    UIGraphicsEndImageContext();
    return  newImage;

}


-(void)async_tailoringImageLayerWithImage: (UIImage *)imageName borderWidth:(CGFloat)width  borderColor:(UIColor *)color completed:(void(^)(UIImage*newImage))completed{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        UIImage *anewImage = [self tailoringImageLayerWithimageName:imageName BorderWidth:width BorderColor:color];
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(anewImage);

        });
    });
}
-(UIImage*)shotImage:(UIImageView*)imageView bgView:(UIView*)bgView{

    if (imageView == nil ){
        return nil;
    }
    //开启一个位图上下文
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0);
    //用贝塞尔绘制
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bgView.frame];
    //开始截取
    [path addClip];
    //把ImageView的内容渲染上下文当中.
    CGContextRef imgeCtx = UIGraphicsGetCurrentContext();
    [imageView.layer renderInContext:imgeCtx];
    //从上下文中得到图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return newImage;

}


-(void)async_shotImageWithimageView:(UIImageView *)imageView bgView:(UIView*)bgView CompltedBlock:(void(^)(UIImage* newImage))completed{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *anewImage = [self shotImage:imageView bgView:bgView];
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(anewImage);
        });
    });
}

-(UIImage*)clearImage:(UIImageView*)imageView Rect:(CGRect )rect{

    if (imageView == nil) {
        return nil;
    }
    //开启一个位图上下文
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0);
    //把ImageView内容渲染到上下文当中
    CGContextRef imageCTX = UIGraphicsGetCurrentContext();
    [imageView.layer renderInContext:imageCTX];
    //擦除上下文当中某一块区域
    CGContextClearRect(imageCTX, rect);
    //得到新图片
    UIImage *newImage  = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();

    return newImage;
}


-(UIImage*)imageFilterHandle:(UIImage*)image Filtername:(NSString*)filterName{
    //输入图片
    CIImage * inputeImge = [[CIImage alloc] initWithImage:image];
    //设置filter健值
    CIFilter *filter = [CIFilter filterWithName:filterName];
    [filter setValue:inputeImge forKey:kCIInputImageKey];
    //得到滤镜中输出图像
    CIImage *outputImage   = filter.outputImage;
    //设置上下文
    CIContext *context = [[CIContext alloc]initWithOptions:nil ];
    //通过上下文绘制获取
    CGImageRef  cgImage = [context createCGImage:outputImage fromRect:outputImage.extent];
    //得到最新的图片
    UIImage *newImage = [[UIImage alloc]initWithCGImage:cgImage];
    return newImage;

}

-(void)async_imageFilterHandleWithimage:(UIImage* )image filterName:( NSString *)filterName CompletedBlock:(void(^)(UIImage* newImage))completed{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *anewImage = [self  imageFilterHandle:image Filtername:filterName];
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(anewImage);

        });
    });

}



@end

@implementation UIImage (LVManager)

-(UIImage*)composeImageWithLogo:(UIImage*)logo
                    LogoOrigin :(CGPoint)logoOrigin
                       LogoSize:(CGSize)logoSize{

    //以bgImage的图大小为底图
    CGImageRef imageRef = self.CGImage;
    CGFloat w = CGImageGetWidth(imageRef);
    CGFloat h = CGImageGetHeight(imageRef);
    //以1.png的图大小为画布创建上下文
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [self  drawInRect:CGRectMake(0, 0, w, h)];
    //先把1.png 画到上下文中
    [logo drawInRect:CGRectMake(logoOrigin.x, logoOrigin.y, logoSize.width, logoSize.height)];
    //再把小图放在上下文中
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    //从当前上下文中获得最终图片
    UIGraphicsEndImageContext();
    return resultImage;

}

@end
