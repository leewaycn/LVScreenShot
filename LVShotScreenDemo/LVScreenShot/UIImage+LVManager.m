//
//  UIImage+LVManager.m
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/8.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "UIImage+LVManager.h"


@implementation LVManager

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


    


@end

@implementation UIImage (LVManager)

@end
