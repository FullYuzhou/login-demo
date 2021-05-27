//
//  QiCountdownButton.m
//  QiCountdownButton
//
//  Created by huangxianshuai on 2019/6/25.
//  Copyright © 2019 HuangXianshuai. All rights reserved.
//

#import "QiCountdownButton.h"

@interface QiCountdownButton ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentInteger;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;

@end

@implementation QiCountdownButton


#pragma mark - Public functions

- (void)startCountdown {
    
    _currentInteger = _maxInteger;
    [self setTitle:[NSString stringWithFormat:@"重新获取 (%@)", @(MAX(_currentInteger, _minInteger)).stringValue] forState:UIControlStateDisabled];
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target: self selector: @selector(handleTimer:)  userInfo:nil  repeats: YES];
    }
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)handleTimer:(NSTimer *)Time{
    [self setTitle:[NSString stringWithFormat:@"重新获取 (%@)", @(MAX(--self.currentInteger, self.minInteger)).stringValue] forState:UIControlStateDisabled];
    if (self.currentInteger <= self.minInteger) {
        [self stopCountdown];
    }
    
}

- (void)stopCountdown {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [self endBackgroundTask];
    [self setBackgroundColor:mainColor];
    [self setEnabled:YES];
    
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - Private functions

- (void)startBackgroundTask {
    
    __weak typeof(self) weakSelf = self;
    _backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [weakSelf endBackgroundTask];
    }];
}

- (void)endBackgroundTask {
    
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
    _backgroundTaskId = UIBackgroundTaskInvalid;
}


#pragma mark - Notifications

- (void)applicationDidEnterBackground:(id)sender {
    NSLog(@"%s", __func__);
    
    [self startBackgroundTask];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    
    [self stopCountdown];
}

@end
