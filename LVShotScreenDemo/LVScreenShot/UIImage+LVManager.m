//
//  UIImage+LVManager.m
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/8.
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
//        let w: CGFloat = CGFloat((imageRef?.width)!)

    CGFloat h = CGImageGetHeight(imageRef);
//        let h: CGFloat = CGFloat((imageRef?.height)!)
    //以1.png的图大小为画布创建上下文
//        UIGraphicsBeginImageContext(CGSize(width: w, height: h))
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
//        bgImage.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
    [bgImage drawInRect:CGRectMake(0, 0, w, h)];
    //先把1.png 画到上下文中
//        for i in 0..<images.count {
//            images[i].draw(in: CGRect(x: imageRect[i].origin.x,
//                                      y: imageRect[i].origin.y,
//                                      width: imageRect[i].size.width,
//                                      height:imageRect[i].size.height))
//        }

    for (int i = 0;i< images.count; i++) {

        NSValue* rectvalue =(NSValue*) imageRect[i];

        CGRect rect = rectvalue.CGRectValue;
        [images[i] drawInRect:CGRectMake(rect.origin.x, rect.origin.y,rect.size.width, rect.size.height)];

    }

    //再把小图放在上下文中
//        let resultImg: UIImage? = UIGraphicsGetImageFromCurrentImageContext()

    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    //从当前上下文中获得最终图片
    UIGraphicsEndImageContext();
//        return resultImg!
    return resultImg;

}

-(UIImage*)tailoringImage:(UIImage*)image{
    //开启上下文
//        UIGraphicsBeginImageContext((image.size))
    UIGraphicsBeginImageContext(image.size);
    //设置一个圆形的裁剪区域
//        let path = UIBezierPath(ovalIn: CGRect(x: 0,
//                                               y: 0,
//                                               width: (image.size.width),
//                                               height: (image.size.height)))

    UIBezierPath *path = [ UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];



    //把路径设置为裁剪区域(超出裁剪区域以外的内容会被自动裁剪掉)
//        path.addClip()
    [path addClip];
    //把图片绘制到上下文当中
//        image.draw(at: CGPoint.zero)
    [image drawAtPoint:CGPointZero];
    //从上下文当中生成一张图片
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
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
//        UIGraphicsBeginImageContext((image.size))
    UIGraphicsBeginImageContext(image.size);
    //设置一个圆形的裁剪区域
//        let path = UIBezierPath(roundedRect: CGRect(x: 0,
//                                                    y: 0,
//                                                    width: (image.size.width),
//                                                    height: (image.size.height)), cornerRadius: radius)

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, image.size.width, image.size.height) cornerRadius:radius];


    //把路径设置为裁剪区域(超出裁剪区域以外的内容会被自动裁剪掉)
//        path.addClip()
    [path addClip];
    //把图片绘制到上下文当中
//        image.draw(at: CGPoint.zero)
    [image drawAtPoint:CGPointZero];
    //从上下文当中生成一张图片
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
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
//        let imageSize = CGSize(width: image.size.width + width * 2 , height: image.size.height + width * 2)

    CGSize imageSize = CGSizeMake(imageName.size.width+borderWidth*2, imageName.size.height+borderWidth*2);

//        UIGraphicsBeginImageContext(imageSize)
    UIGraphicsBeginImageContext(imageSize);
    //2.填充一个圆形路径.这个圆形路径大小,和上下文尺寸大小一样.
    //把大圆画到上下文当中.
//        let path = UIBezierPath(ovalIn: CGRect(x: 0,
//                                               y: 0,
//                                               width: imageSize.width,
//                                               height: imageSize.height))

    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    //颜色设置
//        color.set()
    [borderColor set];
    //填充
//        path.fill()
    [path fill];
    //3.添加一个小圆,小圆,x,y从边框宽度位置开始添加,宽高和原始图片一样大小.把小圆设为裁剪区域.
//        let clipPath = UIBezierPath(ovalIn: CGRect(x: width, y: width, width: image.size.width, height: image.size.height))

    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderWidth, borderWidth, imageName.size.width, imageName.size.height)];
    //把小圆设为裁剪区域.
//        clipPath.addClip()
    [clipPath addClip];
    //4.把图片给绘制上去.
//        image.draw(at: CGPoint(x: width, y: width))
    [imageName drawAtPoint:CGPointMake(borderWidth, borderWidth)];

    //5.从上下文当中生成一张图片
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
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
//        UIGraphicsBeginImageContextWithOptions((imageView?.bounds.size)!, false, 0.0)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0);
    //用贝塞尔绘制
//        let path = UIBezierPath(rect: (bgView?.frame)!)
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bgView.frame];
    //开始截取
//        path.addClip()
    [path addClip];
    //把ImageView的内容渲染上下文当中.
//        let imgectx = UIGraphicsGetCurrentContext()
    CGContextRef imgeCtx = UIGraphicsGetCurrentContext();
//        imageView?.layer.render(in: imgectx!)
    [imageView.layer renderInContext:imgeCtx];
    //从上下文中得到图片
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
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
//        UIGraphicsBeginImageContextWithOptions((imageView?.bounds.size)!, false, 0.0)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0);
    //把ImageView内容渲染到上下文当中
//        let imageCtx = UIGraphicsGetCurrentContext()
    CGContextRef imageCTX = UIGraphicsGetCurrentContext();
//        imageView?.layer.render(in: imageCtx!)
    [imageView.layer renderInContext:imageCTX];
    //擦除上下文当中某一块区域
//        imageCtx!.clear(rect)
    CGContextClearRect(imageCTX, rect);
    //得到新图片
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIImage *newImage  = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();

    return newImage;
}


-(UIImage*)imageFilterHandle:(UIImage*)image Filtername:(NSString*)filterName{
    //输入图片
//        let inputImage = CIImage(image: image)

    CIImage * inputeImge = [[CIImage alloc] initWithImage:image];


    //设置filter健值
//        let filter = CIFilter(name: filterName)
    CIFilter *filter = [CIFilter filterWithName:filterName];

//        filter?.setValue(inputImage, forKey: kCIInputImageKey)
    [filter setValue:inputeImge forKey:kCIInputImageKey];
    //得到滤镜中输出图像
//        let outputImage =  filter?.outputImage!
    CIImage *outputImage   = filter.outputImage;
    //设置上下文
//        let context: CIContext = CIContext(options: nil)

    CIContext *context = [[CIContext alloc]initWithOptions:nil ];

    //通过上下文绘制获取
//        let cgImage = context.createCGImage(outputImage!, from: (outputImage?.extent)!)
    CGImageRef  cgImage = [context createCGImage:outputImage fromRect:outputImage.extent];
    //得到最新的图片
//        let newImage = UIImage(cgImage: cgImage!)
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
//        let imageRef = self.cgImage
    CGImageRef imageRef = self.CGImage;

//        let w: CGFloat = CGFloat((imageRef?.width)!)
    CGFloat w = CGImageGetWidth(imageRef);
//        let h: CGFloat = CGFloat((imageRef?.height)!)
    CGFloat h = CGImageGetHeight(imageRef);
    //以1.png的图大小为画布创建上下文
//        UIGraphicsBeginImageContext(CGSize(width: w, height: h))
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
//        self.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
    [self  drawInRect:CGRectMake(0, 0, w, h)];
    //先把1.png 画到上下文中
//        logo.draw(in: CGRect(x: logoOrigin.x,
//                             y: logoOrigin.y,
//                             width: logoSize.width,
//                             height:logoSize.height))

    [logo drawInRect:CGRectMake(logoOrigin.x, logoOrigin.y, logoSize.width, logoSize.height)];
    //再把小图放在上下文中
//        let resultImg: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    //从当前上下文中获得最终图片
    UIGraphicsEndImageContext();
//        return resultImg!
    return resultImage;

}

@end
