//
//  StatisticsViewController.m
//  Famous Quote Quiz
//
//  Created by Mihail Velikov on 10/31/15.
//  Copyright © 2015 Flat Rock. All rights reserved.
//

#import "StatisticsViewController.h"

@interface StatisticsViewController ()

@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_scoreLabel setText:[NSString stringWithFormat:@"%ld", (long)_percentageOfCorrectAnswer]];
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

- (IBAction)startOverButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
