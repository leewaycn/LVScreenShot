//
//  UIImage+LVManager.h
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/8.
//  Copyright © 2018年 LV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LVManager:NSObject

+(instancetype)share;

-(UIImage*)composeImageWithLogo:(UIImage*)bgImage imageRect:(NSArray*  )imageRect Images:(NSArray<UIImage*>*)images;
/*
 ** 用绘图方式将图片进行圆角裁剪
 ** imageName--传头头像名称
 */

-(UIImage*)tailoringImage:(UIImage*)image;
/**
 ** 用异步绘图方式将图片进行圆角裁剪
 - imageName--传头头像名称
 - parameter completed:    异步完成回调(主线程回调)
 */
-(void)asyn_tailorImageWithimageName:(UIImage*)imageName CompletedBlock:(void  (^)(UIImage *newImage))completed;
//- (void)someMethodThatTakesABlock:(returnType (^nullability)(parameterTypes))blockName;

/**
 ** 用异步绘图方式将图片进行任意圆角裁剪
 - imageName --传头头像名称
 - cornerRadius --传头头像名称
 */
-(UIImage*)tailoringImage:(UIImage *)image withRadius:(CGFloat)radius;

/**
 ** 用异步绘图方式将图片进行任意圆角裁剪
 - imageName --传头头像名称
 - cornerRadius --要设置圆角的大小
 - parameter completed:    异步完成回调(主线程回调)
 */

-(void)asyn_tailoringImageWithImage:(UIImage*)imageName  cornerRadius:(CGFloat)radius Block:(void (^)(UIImage *newImage))completed;
/**
 ** 绘图方式将图片裁剪成圆角并添加边框
 - imageName --传头头像名称
 - borderWidth --边框大小
 - borderColor --边框颜色
 */
-(UIImage*)tailoringImageLayerWithimageName:(UIImage*)imageName BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor ;

/**
 ** 异步绘图方式将图片裁剪成圆角并添加边框
 - imageName --传头头像名称
 - borderWidth --边框大小
 - borderColor --边框颜色
 - parameter completed:    异步完成回调(主线程回调)
 */
-(void)async_tailoringImageLayerWithImage: (UIImage *)imageName borderWidth:(CGFloat)width  borderColor:(UIColor *)color completed:(void(^)(UIImage*newImage))completed;



/**
 ** 用手势截图（截取图片的任意部分）
 - imageView --传图片
 - bgView --截图背景
 - parameter completed:    异步完成回调(主线程回调)
 */
-(UIImage*)shotImage:(UIImageView*)imageView bgView:(UIView*)bgView;

/**
 ** 异步用手势截图（截取图片的任意部分）
 - imageView --传图片
 - bgView --截图背景
 - parameter completed:    异步完成回调(主线程回调)
 */

-(void)async_shotImageWithimageView:(UIImageView *)imageView bgView:(UIView*)bgView CompltedBlock:(void(^)(UIImage* newImage))completed;

/**
 ** 用手势擦除图片
 - imageView --传图片
 - bgView --截图背景
 - parameter completed:    异步完成回调(主线程回调)
 */
-(UIImage*)clearImage:(UIImageView*)imageView Rect:(CGRect )rect;

//MARK: 图像滤镜处理篇
/**
 ** 图片滤镜处理篇
 - image --传图片
 - filter -- 传入滤镜
 */
-(UIImage*)imageFilterHandle:(UIImage*)image Filtername:(NSString*)filterName;
/**
 ** 图片滤镜处理篇
 - image --传图片
 - filter -- 传入滤镜
 - parameter completed:    异步完成回调(主线程回调)
 */
-(void)async_imageFilterHandleWithimage:(UIImage* )image filterName:( NSString *)filterName CompletedBlock:(void(^)(UIImage* newImage))completed;








@end




@interface UIImage (LVManager)


//   public func drawTextInImage(text: String,
//                         textColor: UIColor,
//                         textFont: CGFloat,
//                         textBgColor: UIColor,
//                         textX: CGFloat,
//                         textY: CGFloat )->UIImage {
//        //开启图片上下文
//        UIGraphicsBeginImageContext(self.size)
//        //图形重绘
//        self.draw(in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
//        //水印文字属性
//        let att = [NSAttributedStringKey.foregroundColor: textColor,
//                   NSAttributedStringKey.font: UIFont.systemFont(ofSize: textFont),
//                   NSAttributedStringKey.backgroundColor: textBgColor]
//        //水印文字大小
//        let text = NSString(string: text)
//        let size =  text.size(withAttributes: att)
//        //绘制文字
//        text.draw(in: CGRect.init(x: textX, y: textY, width: size.width, height: size.height), withAttributes: att)
//        //从当前上下文获取图片
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        //关闭上下文
//        UIGraphicsEndImageContext()
//        return image!
//    }
-(UIImage*)composeImageWithLogo:(UIImage*)logo
                    LogoOrigin :(CGPoint)logoOrigin
                       LogoSize:(CGSize)logoSize;


    
@end
