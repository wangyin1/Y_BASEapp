//
//  YINButton.h
//  BL_BaseApp
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YINLoadingButton : UIButton

//是否loading中
@property (assign,nonatomic,readonly) BOOL  isLoading;

//start
- (void)startLoading;

//stop
- (void)stopLoading;

@end
