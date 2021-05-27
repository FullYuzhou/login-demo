//
//  CRBoxFlowLayout.m
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/8.
//

#import "CRBoxFlowLayout.h"

@implementation CRBoxFlowLayout

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self initPara];
    }
    
    return self;
}

- (void)initPara
{
    self.ifNeedEqualGap = YES;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minLineSpacing = 0;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.sectionInset = UIEdgeInsetsZero;
    self.itemNum = 1;
}

- (void)prepareLayout
{
    if (_ifNeedEqualGap) {
        [self autoCalucateLineSpacing];
    }
    
    [super prepareLayout];
}

- (void)autoCalucateLineSpacing
{
    if (self.itemNum > 1) {
        CGFloat width = CGRectGetWidth(self.collectionView.frame);
        self.minimumLineSpacing = floor(1.0 * (width - self.itemNum * self.itemSize.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right) / (self.itemNum - 1));
        
        if (self.minimumLineSpacing < self.minLineSpacing) {
            self.minimumLineSpacing = self.minLineSpacing;
        }
    }else{
        self.minimumLineSpacing = 0;
    }
}

@end
