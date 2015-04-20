//
//  InfoPageViewController.m
//  Tennis Match
//
//  Created by Robert Miller on 4/20/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "InfoPageViewController.h"
#import <FlatUIKit.h>

@interface InfoPageViewController ()

@end

@implementation InfoPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)configureView {
    NSLog(@"configure info page with frame: %f x %f", self.view.frame.size.width, self.view.frame.size.height);
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    textView.backgroundColor = [UIColor cloudsColor];
    textView.editable = NO;
    textView.font = [UIFont flatFontOfSize:14.0f];
    textView.text =
    @"This app was developed by me, Robert Miller\nYou can contact me at RobertMiller2543 at me.com\nFeel free to email me with any bugs, suggestions, questions, or comments, I would love to hear from all of you..\nI would like to thank everyone that helped, including Bernard for the suggestion of the app and for beta testing..\n\nI have to give a ton of props to CocoaPods.org and the following developers:\n\nRoman Efimov at github.com/romaonthego for the use of REMenu\nKevin at github.com/kevinzhow for the use of PNChart\nMichael Zabrowski at github.com/m1entus for the use of MZFormSheetController\nGrouper, Inc. at github.com/jflinter for the use of FlatUIKit\nCharcoal Design at github.com/nicklockwood for the use of FXBlurView\nVictor\nBaro at github.com/victorBaro for the use of VBFPopFlatButton\nMohd Iftekhar Qurashi at github.com/hackiftekhar for the use of IQDropDownTextField\nTom Konig at github.com/TomKnig for the use of TOMSMorphingLabel\nJared Verdi at github.com/jverdi for the use of JVFloatLabeledTextField\n\nEnjoy!!";
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
