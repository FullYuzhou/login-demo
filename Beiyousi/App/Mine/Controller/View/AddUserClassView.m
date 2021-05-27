//
//  AddUserClassView.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/14.
//

#import "AddUserClassView.h"

@implementation AddUserClassView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    addCalssBtn.layer.cornerRadius = 20.0f;
    addCalssBtn.layer.masksToBounds = YES;
}

@end
