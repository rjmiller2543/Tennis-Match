//
//  UIViewController+UIViewController_MZFormDismissal.h
//  Tennis Match
//
//  Created by Robert Miller on 4/20/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UIViewController_MZFormDismissal)
-(void)dismissNewPlayerWithCompletionHandler:(void (^)(UIViewController *viewController))completionHandler;
@end