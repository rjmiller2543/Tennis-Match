//
//  PlayerPageViewController.m
//  Tennis Match
//
//  Created by Robert Miller on 5/4/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "PlayerPageViewController.h"
#import "PlayerDetailViewController.h"
#import "OppositionDetailViewController.h"
#import <FlatUIKit.h>

@interface PlayerPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property(nonatomic,retain) NSMutableArray *viewControllersArray;

@end

@implementation PlayerPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cloudsColor];
    _viewControllersArray = [[NSMutableArray alloc] init];
    
    PlayerDetailViewController *playerDetail = [[PlayerDetailViewController alloc] init];
    playerDetail.detailPlayer = _detailPlayer;
    playerDetail.indexNumber = 0;
    playerDetail.navBar = self.navigationController.navigationBar;
    playerDetail.navItem = self.navigationItem;
    [_viewControllersArray addObject:playerDetail];
    
    NSArray *playerOpponents = [_detailPlayer opponents];
    NSInteger index = 1;
    for (Opponent *playerOpponent in playerOpponents) {
        OppositionDetailViewController *oppositionViewController = [[OppositionDetailViewController alloc] init];
        oppositionViewController.detailOpponent = playerOpponent;
        oppositionViewController.indexNumber = index;
        oppositionViewController.navBar = self.navigationController.navigationBar;
        oppositionViewController.navItem = self.navigationItem;
        index++;
        [_viewControllersArray addObject:oppositionViewController];
    }
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    [_pageViewController setViewControllers:[NSArray arrayWithObject:playerDetail] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        //up up
    }];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    //_pageViewController.view.backgroundColor = [UIColor cloudsColor];
    _pageViewController.view.tintColor = [UIColor asbestosColor];
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger index;
    if ([viewController class] == [PlayerDetailViewController class]) {
        index = [(PlayerDetailViewController*)viewController indexNumber];
    }
    else if ([viewController class] == [OppositionDetailViewController class]) {
        index = [(OppositionDetailViewController*)viewController indexNumber];
    }
    
    if (index == 0) {
        return nil;
    }
    
    if (index == 1) {
        index--;
        PlayerDetailViewController *vc = [_viewControllersArray objectAtIndex:index];
        return vc;
    }
    else {
        index--;
        OppositionDetailViewController *vc = [_viewControllersArray objectAtIndex:index];
        return vc;
    }
    
    return nil;
    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSInteger index;
    if ([viewController class] == [PlayerDetailViewController class]) {
        index = [(PlayerDetailViewController*)viewController indexNumber];
    }
    else if ([viewController class] == [OppositionDetailViewController class]) {
        index = [(OppositionDetailViewController*)viewController indexNumber];
    }
    
    if (index >= ([_viewControllersArray count]-1)) {
        return nil;
    }
    index++;
    OppositionDetailViewController *vc = [_viewControllersArray objectAtIndex:index];
    return vc;
    
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [[_detailPlayer opponents] count] + 1;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - page controller methods

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
