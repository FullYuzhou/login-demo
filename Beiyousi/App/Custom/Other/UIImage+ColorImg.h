//
//  UIImage+ColorImg.h
//  community
//
//  Created by 蔡文练 on 2019/9/23.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ColorImg)


+(UIImage *)createImageWithColor:(UIColor*)color;


+ (UIImage *)getImage:(NSString *)filePath;


@end

NS_ASSUME_NONNULL_END
