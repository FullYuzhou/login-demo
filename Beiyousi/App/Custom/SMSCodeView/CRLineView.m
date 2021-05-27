//
//  CRLineView.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/8.
//

#import "CRLineView.h"

@interface CRLineView()
{
    
}
@end

@implementation CRLineView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _underlineColorNormal = CRColorMaster;
        _underlineColorSelected = CRColorMaster;
        _underlineColorFilled = CRColorMaster;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    static CGFloat sepLineViewHeight = 4;
    
    _lineView = [UIView new];
    [self addSubview:_lineView];
    _lineView.backgroundColor = _underlineColorNormal;
    _lineView.layer.cornerRadius = sepLineViewHeight / 2.0;
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(sepLineViewHeight);
        make.left.right.bottom.offset(0);
    }];
    
    _lineView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    _lineView.layer.shadowOpacity = 1;
    _lineView.layer.shadowOffset = CGSizeMake(0, 2);
    _lineView.layer.shadowRadius = 4;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    if (self.selectChangeBlock) {
        __weak __typeof(self)weakSelf = self;
        self.selectChangeBlock(weakSelf, selected);
    }
}

@end
