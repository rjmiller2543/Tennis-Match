//
//  UIViewController+UIViewController_MZFormDismissal.m
//  Tennis Match
//
//  Created by Robert Miller on 4/20/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "UIViewController+UIViewController_MZFormDismissal.h"
#import <MZFormSheetController.h>

@implementation UIViewController (UIViewController_MZFormDismissal)

-(void)dismissMZFormWithCompletionHandler:(void (^)(UIViewController *viewController))completionHandler {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        //up up
        completionHandler([formSheetController presentedFSViewController]);
    }];
}

@end
