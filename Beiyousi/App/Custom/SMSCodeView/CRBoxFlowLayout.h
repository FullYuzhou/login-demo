//
//  CRBoxFlowLayout.h
//  Beiyousi
//
//  Created by 倍优思 on 2020/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRBoxFlowLayout : UICollectionViewFlowLayout

/** ifNeedEqualGap
 * default: YES
 */
@property (assign, nonatomic) BOOL ifNeedEqualGap;

@property (assign, nonatomic) NSInteger itemNum;

/** minLineSpacing
* default: 10
*/
@property (assign, nonatomic) NSInteger minLineSpacing;

- (void)autoCalucateLineSpacing;

@end

NS_ASSUME_NONNULL_END
