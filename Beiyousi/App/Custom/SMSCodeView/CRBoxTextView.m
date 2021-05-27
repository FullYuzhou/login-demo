//
//  CRBoxTextView.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/8.
//

#import "CRBoxTextView.h"

@implementation CRBoxTextView

/**
 * /禁止可被粘贴复制
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

@end
