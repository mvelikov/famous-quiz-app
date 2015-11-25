//
//  Settings.h
//  Famous Quote Quiz
//
//  Created by Mihail Velikov on 10/29/15.
//  Copyright © 2015 Flat Rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate;

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *multipelChoiceQuestionsOption;
@property (weak, nonatomic) id<SettingsViewControllerDelegate> delegate;

- (IBAction)multipelChoiceQuestionsOptionChanged:(id)sender;
@end


@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsDidChangeWithOptions:(BOOL) options;

@end