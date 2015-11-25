//
//  ViewController.h
//  Famous Quote Quiz
//
//  Created by Mihail Velikov on 10/29/15.
//  Copyright © 2015 Flat Rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Question.h"
#import "Answer.h"
#import "Session.h"
#import "SessionsQuestions.h"
#import "SettingsViewController.h"
#import "StatisticsViewController.h"

@interface QuestionsViewController : UIViewController <SettingsViewControllerDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *fetchedStatisticsResultsController;


/// @brief holds data if multiple or yes/no questions will be loaded
@property (nonatomic) BOOL isMultipleChoiceQuestion;
/// @brief holds the current index of the question presented to the user
@property (nonatomic) NSInteger currentQuestionIndex;
/// @brief holds current question instance
@property (nonatomic, strong) Question *currentQuestion;
/// @brief holds current session instance
@property (nonatomic, strong) Session *currentSession;
/// @brief holds the percentage of the correct answers in the current session
@property (nonatomic) NSInteger percentageOfCorrectAnswer;

@property (weak, nonatomic) IBOutlet UITextView *questionTextView;

@property (weak, nonatomic) IBOutlet UIView *multipleChoiceWrapperView;
@property (weak, nonatomic) IBOutlet UIView *yesNoQuestionsWrapperView;

@property (weak, nonatomic) IBOutlet UIButton *multipleChoiceButtonOne;
@property (weak, nonatomic) IBOutlet UIButton *multipleChoiceButtonTwo;
@property (weak, nonatomic) IBOutlet UIButton *multipleChoiceButtonThree;

@property (weak, nonatomic) IBOutlet UILabel *yesNoQuestionLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesNoYesButton;
@property (weak, nonatomic) IBOutlet UIButton *yesNoNoButton;

- (IBAction)multipleChoiceButtonOneTapped:(id)sender;
- (IBAction)multipleChoiceButtonTwoTapped:(id)sender;
- (IBAction)multipleChoiceButtonThreeTapped:(id)sender;


- (IBAction)yesButtonTapped:(id)sender;
- (IBAction)noButtonTapped:(id)sender;

@end

