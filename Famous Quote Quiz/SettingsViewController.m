//
//  Settings.m
//  Famous Quote Quiz
//
//  Created by Mihail Velikov on 10/29/15.
//  Copyright © 2015 Flat Rock. All rights reserved.
//

#import "SettingsViewController.h"
#import "constants.h"

@implementation SettingsViewController

- (void) viewDidLoad {
    
    // restores the selected switch value from NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isMultipleChoiceQuestionsOptionEnable = [userDefaults boolForKey:MULTIPLE_CHOICE_OPTIONS];
    
    [_multipelChoiceQuestionsOption setOn:isMultipleChoiceQuestionsOptionEnable];
}

/*!
 * @brief handles the multiple-yes/no questions switch control
 * @param id the control that sends the event
 */
- (IBAction)multipelChoiceQuestionsOptionChanged:(id)sender {

    if (sender == _multipelChoiceQuestionsOption) {
        BOOL multipleOptions = NO;
        if (_multipelChoiceQuestionsOption.isOn) {
            multipleOptions = YES;
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:multipleOptions forKey:MULTIPLE_CHOICE_OPTIONS];
        [userDefaults synchronize];
        
        if ([self.delegate respondsToSelector:@selector(settingsDidChangeWithOptions:)]) {
            [self.delegate settingsDidChangeWithOptions:multipleOptions];
        }
    }
}
@end
