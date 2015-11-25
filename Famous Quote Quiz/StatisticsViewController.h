//
//  StatisticsViewController.h
//  Famous Quote Quiz
//
//  Created by Mihail Velikov on 10/31/15.
//  Copyright © 2015 Flat Rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsViewController : UIViewController

@property (nonatomic) NSInteger percentageOfCorrectAnswer;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (IBAction)startOverButtonTapped:(id)sender;
@end
