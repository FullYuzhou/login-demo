//
//  CRBoxInputView.m
//  Beiyousi
//
//  Created by εδΌζ on 2020/12/8.
//

#import "CRBoxInputView.h"
#import "CRBoxTextView.h"

typedef NS_ENUM(NSInteger, CRBoxTextChangeType) {
    CRBoxTextChangeType_NoChange,
    CRBoxTextChangeType_Insert,
    CRBoxTextChangeType_Delete,
};

@interface CRBoxInputView () <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>
{
    NSInteger _oldLength;
    BOOL _ifNeedBeginEdit;
}

@property (nonatomic, assign) NSInteger codeLength;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;
@property (nonatomic, strong) CRBoxTextView *textView;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSMutableArray <NSString *> *valueArr;
@property (nonatomic, strong) NSMutableArray <CRBoxInputCellProperty *> *cellPropertyArr;

@end

@implementation CRBoxInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultValue];
        [self addNotificationObserver];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initDefaultValue];
        [self addNotificationObserver];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDefaultValue];
        [self addNotificationObserver];
    }
    
    return self;
}

- (instancetype _Nullable )initWithCodeLength:(NSInteger)codeLength
{
    self = [super init];
    if (self) {
        [self initDefaultValue];
        [self addNotificationObserver];
        self.codeLength = codeLength;
    }
    
    return self;
}

- (void)dealloc
{
    [self removeNotificationObserver];
}

#pragma mark - Notification Observer
- (void)addNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeNotificationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    // θ§¦εhomeζδΈοΌεζ ε¨η»η§»ι€
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    // ιζ°θΏζ₯εεεΊοΌεζ ε¨η»ιζ°εΌε§
    [self reloadAllCell];
}

#pragma mark - You can inherit
- (void)initDefaultValue
{
    _oldLength = 0;
    self.ifNeedSecurity = NO;
    self.securityDelay = 0.3;
    self.codeLength = 4;
    self.ifNeedCursor = YES;
        
    self.keyBoardType = UIKeyboardTypeNumberPad;
    self.inputType = CRInputType_Number;
    self.customInputRegex = @"";
    self.backgroundColor = [UIColor clearColor];
    _valueArr = [NSMutableArray new];
    _ifNeedBeginEdit = NO;
}

#pragma mark - LoadAndPrepareView
- (void)loadAndPrepareView
{
    [self loadAndPrepareViewWithBeginEdit:YES];
}

- (void)loadAndPrepareViewWithBeginEdit:(BOOL)beginEdit
{
    if (_codeLength<=0) {
        NSAssert(NO, @"θ―·θΎε₯ε€§δΊ0ηιͺθ―η δ½ζ°");
        return;
    }
    
    [self generateCellPropertyArr];
    
    // mainCollectionView
    if (!self.mainCollectionView || ![self.subviews containsObject:self.mainCollectionView]) {
        [self addSubview:self.mainCollectionView];
        [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    
    // textView
    if (!self.textView || ![self.subviews containsObject:self.textView]) {
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(0);
            make.left.top.mas_equalTo(0);
        }];
    }
    
    // tap
    if (self.tapGR.view != self) {
        [self addGestureRecognizer:self.tapGR];
    }
    
    if (![self.textView.text isEqualToString:self.customCellProperty.originValue]) {
        self.textView.text = self.customCellProperty.originValue;
        [self textDidChange:self.textView];
    }
    
    if (beginEdit) {
        [self beginEdit];
    }
}

- (void)generateCellPropertyArr
{
    [self.cellPropertyArr removeAllObjects];
    for (int i = 0; i < self.codeLength; i++) {
        [self.cellPropertyArr addObject:[self.customCellProperty copy]];
    }
}

#pragma mark - code Length θ°ζ΄
- (void)resetCodeLength:(NSInteger)codeLength beginEdit:(BOOL)beginEdit
{
    if (codeLength<=0) {
        NSAssert(NO, @"θ―·θΎε₯ε€§δΊ0ηιͺθ―η δ½ζ°");
        return;
    }
    
    self.codeLength = codeLength;
    [self generateCellPropertyArr];
    [self clearAllWithBeginEdit:beginEdit];
}

#pragma mark - Reload Input View
- (void)reloadInputString:(NSString *_Nullable)value
{
    if (![self.textView.text isEqualToString:value]) {
        self.textView.text = value;
        [self baseTextDidChange:self.textView manualInvoke:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _ifNeedBeginEdit = YES;
    
    if (self.ifClearAllInBeginEditing && self.textValue.length == self.codeLength) {
        [self clearAll];
    }
    
    if (self.textEditStatusChangeblock) {
        self.textEditStatusChangeblock(CRTextEditStatus_BeginEdit);
    }
    
    [self reloadAllCell];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _ifNeedBeginEdit = NO;
    
    if (self.textEditStatusChangeblock) {
        self.textEditStatusChangeblock(CRTextEditStatus_EndEdit);
    }
    
    [self reloadAllCell];
}

#pragma mark - TextViewEdit
- (void)beginEdit{
    if (![self.textView isFirstResponder]) {
        [self.textView becomeFirstResponder];
    }
}

- (void)endEdit{
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

- (void)clearAll
{
    [self clearAllWithBeginEdit:YES];
}

- (void)clearAllWithBeginEdit:(BOOL)beginEdit
{
    _oldLength = 0;
    [_valueArr removeAllObjects];
    self.textView.text = @"";
    [self allSecurityClose];
    [self reloadAllCell];
    [self triggerBlock];
    
    if (beginEdit) {
        [self beginEdit];
    }
}

#pragma mark - UITextFieldDidChange
- (void)textDidChange:(UITextField *)textField {
    [self baseTextDidChange:textField manualInvoke:NO];
}

/**
 * θΏζ»€θΎε₯εε?Ή
*/
- (NSString *)filterInputContent:(NSString *)inputStr {
    
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:inputStr];
    if (self.inputType == CRInputType_Number) {
        
        /// ηΊ―ζ°ε­
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]" options:0 error:nil];
        [regex replaceMatchesInString:mutableStr options:0 range:NSMakeRange(0, [mutableStr length]) withTemplate:@""];
    } else if (self.inputType == CRInputType_Normal) {
        
        /// δΈε€η
        nil;
    } else if (self.inputType == CRInputType_Regex) {
        
        /// θͺε?δΉζ­£ε
        if (self.customInputRegex.length > 0) {
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.customInputRegex options:0 error:nil];
            [regex replaceMatchesInString:mutableStr options:0 range:NSMakeRange(0, [mutableStr length]) withTemplate:@""];
        }
    }
    
    return [mutableStr copy];
}

/**
 * textDidChangeεΊζδ½
 * manualInvokeοΌζ―ε¦δΈΊζε¨θ°η¨
 */
- (void)baseTextDidChange:(UITextField *)textField manualInvoke:(BOOL)manualInvoke  {
    
    __weak typeof(self) weakSelf = self;
    NSString *verStr = textField.text;
    
    //ζη©Ίζ Όε»ζη©Ίζ Ό
    verStr = [verStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    verStr = [self filterInputContent:verStr];
    
    if (verStr.length >= _codeLength) {
        verStr = [verStr substringToIndex:_codeLength];
        [self endEdit];
    }
    textField.text = verStr;
    
    // ε€ζ­ε ι€/ε’ε 
    CRBoxTextChangeType boxTextChangeType = CRBoxTextChangeType_NoChange;
    if (verStr.length > _oldLength) {
        boxTextChangeType = CRBoxTextChangeType_Insert;
    }else if (verStr.length < _oldLength){
        boxTextChangeType = CRBoxTextChangeType_Delete;
    }
    
    // _valueArr
    if (boxTextChangeType == CRBoxTextChangeType_Delete) {
        [self setSecurityShow:NO index:_valueArr.count-1];
        [_valueArr removeLastObject];
        
    }else if (boxTextChangeType == CRBoxTextChangeType_Insert){
        if (verStr.length > 0) {
            if (_valueArr.count > 0) {
                [self replaceValueArrToAsteriskWithIndex:_valueArr.count - 1 needEqualToCount:NO];
            }
//            NSString *subStr = [verStr substringWithRange:NSMakeRange(verStr.length - 1, 1)];
//            [strongSelf.valueArr addObject:subStr];
            [_valueArr removeAllObjects];
            
            [verStr enumerateSubstringsInRange:NSMakeRange(0, verStr.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.valueArr addObject:substring];
            }];
            
            if (self.ifNeedSecurity) {
                if (manualInvoke) {
                    // ε€ηζζη§ζ
                    [self delaySecurityProcessAll];
                }else {
                    // εͺε€ηζεδΈδΈͺη§ζ
                    [self delaySecurityProcessLastOne];
                }
            }
        }
    }
    [self reloadAllCell];
    
    _oldLength = verStr.length;
    
    if (boxTextChangeType != CRBoxTextChangeType_NoChange) {
        [self triggerBlock];
    }
}

#pragma mark - Control security show
- (void)setSecurityShow:(BOOL)isShow index:(NSInteger)index
{
    if (index < 0) {
        NSAssert(NO, @"indexεΏι‘»ε€§δΊη­δΊ0");
        return;
    }
    
    CRBoxInputCellProperty *cellProperty = self.cellPropertyArr[index];
    cellProperty.ifShowSecurity = isShow;
}

- (void)allSecurityClose
{
    [self.cellPropertyArr enumerateObjectsUsingBlock:^(CRBoxInputCellProperty * _Nonnull cellProperty, NSUInteger idx, BOOL * _Nonnull stop) {
        if (cellProperty.ifShowSecurity == YES) {
            cellProperty.ifShowSecurity = NO;
        }
    }];
}

- (void)allSecurityOpen
{
    [self.cellPropertyArr enumerateObjectsUsingBlock:^(CRBoxInputCellProperty * _Nonnull cellProperty, NSUInteger idx, BOOL * _Nonnull stop) {
        if (cellProperty.ifShowSecurity == NO) {
            cellProperty.ifShowSecurity = YES;
        }
    }];
}


#pragma mark - Trigger block
- (void)triggerBlock
{
    if (self.textDidChangeblock) {
        BOOL isFinished = _valueArr.count == _codeLength ? YES : NO;
        self.textDidChangeblock(_textView.text, isFinished);
    }
}

#pragma mark - Asterisk ζΏζ’ε―ζ
/**
 * ζΏζ’ε―ζ
 * needEqualToCountοΌζ―ε¦εͺζΏζ’ζεδΈδΈͺ
 */
- (void)replaceValueArrToAsteriskWithIndex:(NSInteger)index needEqualToCount:(BOOL)needEqualToCount
{
    if (!self.ifNeedSecurity) {
        return;
    }
    
    if (needEqualToCount && index != _valueArr.count - 1) {
        return;
    }
    
    [self setSecurityShow:YES index:index];
}

#pragma mark ε»ΆζΆζΏζ’ζεδΈδΈͺε―ζ
- (void)delaySecurityProcessLastOne
{
    __weak __typeof(self)weakSelf = self;
    [self delayAfter:self.securityDelay dealBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.valueArr.count > 0) {
            [strongSelf replaceValueArrToAsteriskWithIndex:strongSelf.valueArr.count-1 needEqualToCount:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf reloadAllCell];
            });
        }
    }];
}

#pragma mark ε»ΆζΆζΏζ’ζζδΈδΈͺε―ζ
- (void)delaySecurityProcessAll
{
    __weak __typeof(self)weakSelf = self;
    [self.valueArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf replaceValueArrToAsteriskWithIndex:idx needEqualToCount:NO];
    }];
    
    [self reloadAllCell];
}

#pragma mark - DelayBlock
- (void)delayAfter:(CGFloat)delayTime dealBlock:(void (^)(void))dealBlock
{
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime *NSEC_PER_SEC));
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        if (dealBlock) {
            dealBlock();
        }
    });
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _codeLength;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id tempCell = [self customCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if ([tempCell isKindOfClass:[CRBoxInputCell class]]) {
        
        CRBoxInputCell *cell = (CRBoxInputCell *)tempCell;
        cell.ifNeedCursor = self.ifNeedCursor;
        
        // CellProperty
        CRBoxInputCellProperty *cellProperty = self.cellPropertyArr[indexPath.row];
        cellProperty.index = indexPath.row;
        
        NSString *currentPlaceholderStr = nil;
        if (_placeholderText.length > indexPath.row) {
            currentPlaceholderStr = [_placeholderText substringWithRange:NSMakeRange(indexPath.row, 1)];
            cellProperty.cellPlaceholderText = currentPlaceholderStr;
        }
        
        // setOriginValue
        NSUInteger focusIndex = _valueArr.count;
        if (_valueArr.count > 0 && indexPath.row <= focusIndex - 1) {
            [cellProperty setMyOriginValue:_valueArr[indexPath.row]];
        }else{
            [cellProperty setMyOriginValue:@""];
        }
        
        cell.boxInputCellProperty = cellProperty;
        
        if (_ifNeedBeginEdit) {
            cell.selected = indexPath.row == focusIndex ? YES : NO;
        }else{
            cell.selected = NO;
        }
    }
    
    return tempCell;
}

- (void)reloadAllCell
{
    [self.mainCollectionView reloadData];

    NSUInteger focusIndex = _valueArr.count;
    /// ζεδΈδΈͺ
    if (focusIndex == self.codeLength) {
        [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:focusIndex - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    } else {
        [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:focusIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark - Qiuck set
- (void)quickSetSecuritySymbol:(NSString *)securitySymbol
{
    if (securitySymbol.length != 1) {
        securitySymbol = @"β±";
    }
    
    self.customCellProperty.securitySymbol = securitySymbol;
}

#pragma mark - You can rewrite
- (UICollectionViewCell *)customCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CRBoxInputCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CRBoxInputCellID forIndexPath:indexPath];
    return cell;
}

#pragma mark - Setter & Getter
- (UITapGestureRecognizer *)tapGR
{
    if (!_tapGR) {
        _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginEdit)];
    }
    
    return _tapGR;
}

- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.boxFlowLayout];
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.layer.masksToBounds = YES;
        _mainCollectionView.clipsToBounds = YES;
        [_mainCollectionView registerClass:[CRBoxInputCell class] forCellWithReuseIdentifier:CRBoxInputCellID];
    }
    
    return _mainCollectionView;
}

- (CRBoxFlowLayout *)boxFlowLayout
{
    if (!_boxFlowLayout) {
        _boxFlowLayout = [CRBoxFlowLayout new];
        _boxFlowLayout.itemSize = CGSizeMake(32, 47);
    }
    
    return _boxFlowLayout;
}

- (void)setCodeLength:(NSInteger)codeLength
{
    _codeLength = codeLength;
    self.boxFlowLayout.itemNum = codeLength;
}

- (void)setKeyBoardType:(UIKeyboardType)keyBoardType{
    _keyBoardType = keyBoardType;
    self.textView.keyboardType = keyBoardType;
}

- (CRBoxTextView *)textView{
    if (!_textView) {
        _textView = [CRBoxTextView new];
        _textView.delegate = self;
        [_textView addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textView;
}

- (void)setTextContentType:(UITextContentType)textContentType
{
    _textContentType = textContentType;
    
    _textView.textContentType = textContentType;
}

- (CRBoxInputCellProperty *)customCellProperty
{
    if (!_customCellProperty) {
        _customCellProperty = [CRBoxInputCellProperty new];
    }
    
    return _customCellProperty;
}

- (NSMutableArray <CRBoxInputCellProperty *> *)cellPropertyArr
{
    if (!_cellPropertyArr) {
        _cellPropertyArr = [NSMutableArray new];
    }
    
    return _cellPropertyArr;
}

- (NSString *)textValue
{
    return _textView.text;
}

@synthesize inputAccessoryView = _inputAccessoryView;
- (void)setInputAccessoryView:(UIView *)inputAccessoryView
{
    _inputAccessoryView = inputAccessoryView;
    self.textView.inputAccessoryView = _inputAccessoryView;
}

- (UIView *)inputAccessoryView
{
    return _inputAccessoryView;
}

- (void)setIfNeedSecurity:(BOOL)ifNeedSecurity
{
    _ifNeedSecurity = ifNeedSecurity;
    
    if (ifNeedSecurity == YES) {
        [self allSecurityOpen];
    }else{
        [self allSecurityClose];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadAllCell];
    });
}

@end
