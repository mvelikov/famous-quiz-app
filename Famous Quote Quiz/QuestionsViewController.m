//
//  ViewController.m
//  Famous Quote Quiz
//
//  Created by Mihail Velikov on 10/29/15.
//  Copyright © 2015 Flat Rock. All rights reserved.
//

#import "QuestionsViewController.h"
#import "constants.h"
#import "AppDelegate.h"

@interface QuestionsViewController ()
@property (nonatomic) BOOL isMultipleChoiceQuestionsOptionEnabled;

@end

@implementation QuestionsViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize fetchedStatisticsResultsController = _fetchedStatisticsResultsController;
@synthesize managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // registers to the tab switch event
    UITabBarController *tabBar = (UITabBarController *)[[(AppDelegate*)[[UIApplication sharedApplication] delegate] window] rootViewController];
    [tabBar setDelegate:self];
    
    // checks if multiple or yes/no question is selected
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isMultipleChoiceQuestionsOptionEnable = [userDefaults boolForKey:MULTIPLE_CHOICE_OPTIONS];
    
    _isMultipleChoiceQuestion = isMultipleChoiceQuestionsOptionEnable;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    NSError *error;
    
    // loads 10 questions
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
        exit(-1);
    }
    
    [self initSession];
    _currentQuestionIndex = 0;
    _currentQuestion = [[[self fetchedResultsController] fetchedObjects] objectAtIndex:_currentQuestionIndex];

    [self updateQuestionViewForQuestion:_currentQuestion];
}

/*!
 * @brief updates question view for the current question
 * @param Question the current question instance
 */
- (void) updateQuestionViewForQuestion: (Question *) question {
    [_questionTextView setText:[question text]];

    if ([question.isMultipleChoice boolValue]) {
        [_yesNoQuestionsWrapperView setHidden:YES];
        [_multipleChoiceWrapperView setHidden:NO];
        
        NSArray *answers = [question.answers allObjects];
        
        if ([answers count] == 3) {
            [_multipleChoiceButtonOne setTitle:[[answers objectAtIndex:0] text] forState:UIControlStateNormal];
            [_multipleChoiceButtonTwo setTitle:[[answers objectAtIndex:1] text] forState:UIControlStateNormal];
            [_multipleChoiceButtonThree setTitle:[[answers objectAtIndex:2] text] forState:UIControlStateNormal];
        }
        
    } else {
        [_yesNoQuestionsWrapperView setHidden:NO];
        [_multipleChoiceWrapperView setHidden:YES];
        
        [_yesNoQuestionLabel setText:[[question.answers anyObject] text]];
    }
}

/// @brief inits new session
- (void) initSession {
    _currentSession = [NSEntityDescription insertNewObjectForEntityForName:@"Session"
                                                    inManagedObjectContext:[self managedObjectContext]];
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

/*!
 * @brief saves the current answer the user gave for the current session
 * @param BOOL whether the answer was correct or not
 * @return void
 */
- (void)saveSessionsQuestions:(BOOL)isCorrect {
    SessionsQuestions *sessionsQuestions = [NSEntityDescription insertNewObjectForEntityForName:@"SessionsQuestions"
                                                                         inManagedObjectContext:[self managedObjectContext]];
    [sessionsQuestions setValue:[NSNumber numberWithBool:isCorrect]
                         forKey:@"isCorrect"];
    [sessionsQuestions addSessionsObject:_currentSession];
    [sessionsQuestions addQuestionsObject:_currentQuestion];
    
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void) loadNextQuestion {
    _currentQuestionIndex++;
    
    if (_currentQuestionIndex < FETCH_QUESTIONS_LIMIT) {
        _currentQuestion = [[[self fetchedResultsController] fetchedObjects] objectAtIndex:_currentQuestionIndex];
        
        [self updateQuestionViewForQuestion:_currentQuestion];
    } else {
        [self showFinalStatistics];
    }
}

/*!
 * @brief resets the quiz
 */
- (void) resetQuiz {
    // new session
    [self initSession];

    _currentQuestionIndex = 0;

    // clears current session statistics
    self.fetchedStatisticsResultsController = nil;
    
    NSError *error;
    
    // laods new quiz questions
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
        exit(-1);
    }
    
    // fetches the initial question
    _currentQuestion = [[[self fetchedResultsController] fetchedObjects] objectAtIndex:_currentQuestionIndex];
    
    // updates the question view
    [self updateQuestionViewForQuestion:_currentQuestion];
}

/// @brief calculates the final statistics record and loads StatisticViewController
- (void) showFinalStatistics {

    NSError *error;
    // loads the number of correct answers given in the session
    if (![[self fetchedStatisticsResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
        exit(-1);
    }
    
    NSInteger numberOfCorrectAnswers = [[[self fetchedStatisticsResultsController] fetchedObjects] count];
    float percentage = (float)numberOfCorrectAnswers / FETCH_QUESTIONS_LIMIT * 100;
    _percentageOfCorrectAnswer = (int) percentage;

    
    [self performSegueWithIdentifier:@"showFinalScoreResults" sender:self];
}

/*!
 * @brief checks if the user has given a correct answer for a yes/no question
 * @param BOOL the answer the user gave
 * @return void
 */
- (void) checkYesNoQuestionAndLoadNextQuestion: (BOOL)givenAnswer {
    // gets the question answer from Core Data
    Answer *answer = [_currentQuestion.answers anyObject];
    BOOL isCorrectAnswerGiven = NO;
    NSString *message;
    if ([answer.isCorrect boolValue] == givenAnswer) {
        isCorrectAnswerGiven = YES;
        if (givenAnswer == YES) {
            message = @"YES";
        } else {
            message = @"NO";
        }
    } else {
        if (givenAnswer == YES) {
            message = @"NO";
        } else {
            message = @"YES";
        }
    }
    
    [self saveSessionsQuestions:isCorrectAnswerGiven];
    [self showCurrentResultForAnswer:isCorrectAnswerGiven withMessage:message];
}

/*!
 * @brief checks if the user gave a correct answer to a multiple options question
 * @param BOOL the answer given by the user
 */
- (void) checkMultipleOptionsQuestionAndLoadNextOne: (NSString *)givenAnswer {
    __block BOOL isCorrectAnswerGiven = NO;
    __block NSString *message;
    
    [_currentQuestion.answers enumerateObjectsUsingBlock:^(Answer * _Nonnull obj, BOOL * _Nonnull stop) {
        // checks if the answer given is the correct with each of the answers for the question
        if ([obj.text isEqualToString:givenAnswer] && [obj.isCorrect boolValue]) {
            isCorrectAnswerGiven = YES;
            message = obj.text;
        } else if ([obj.isCorrect boolValue]) {
            message = obj.text;
        }
    }];
    
    [self saveSessionsQuestions:isCorrectAnswerGiven];
    [self showCurrentResultForAnswer:isCorrectAnswerGiven withMessage:message];
}

/*!
 * @brief concats the user message and presents it via UIAlertController
 * @param BOOL is the given answer correct
 * @param NSString
 */
- (void) showCurrentResultForAnswer:(BOOL) isCorrect withMessage: (NSString *) message {

    NSString *alertMessage = [NSString stringWithFormat:@"Sorry, you are wrong! The right answer is: %@", message];
    
    if (isCorrect) {
        alertMessage = [NSString stringWithFormat:@"Correct! The right answer is: %@", message];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                                [self loadNextQuestion];
                                            }]];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

/*!
 * @brief fetching questions results in batches via CoreData
 */
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Question"
                                              inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:FETCH_QUESTIONS_LIMIT];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"text"
                                                                     ascending:@"YES"];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    /// select only questions that match the chosen settings
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isMultipleChoice == %@", [NSNumber numberWithBool:_isMultipleChoiceQuestion]];
    
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                  managedObjectContext:managedObjectContext
                                                                                                    sectionNameKeyPath:nil
                                                                                                             cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    
    return _fetchedResultsController;
}

/// @brief fetching statistic results from SessionsQuestions table
- (NSFetchedResultsController *)fetchedStatisticsResultsController {
    if (_fetchedStatisticsResultsController != nil) {
        return _fetchedStatisticsResultsController;
    }
    
    NSFetchRequest *fetchStatisticsRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SessionsQuestions"
                                              inManagedObjectContext:[self managedObjectContext]];
    
    [fetchStatisticsRequest setEntity:entity];
    [fetchStatisticsRequest setFetchLimit:FETCH_QUESTIONS_LIMIT];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"isCorrect"
                                                                     ascending:@"NO"];
    [fetchStatisticsRequest setSortDescriptors:@[sortDescriptor]];
    
    /// selects only correctly answered questions for the current session
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY sessions == %@ AND isCorrect == 1", _currentSession];

    [fetchStatisticsRequest setPredicate:predicate];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchStatisticsRequest
                                                                                                  managedObjectContext:[self managedObjectContext]
                                                                                                    sectionNameKeyPath:nil
                                                                                                             cacheName:nil];
    
    self.fetchedStatisticsResultsController = theFetchedResultsController;
    
    return _fetchedStatisticsResultsController;
}

- (void) viewDidUnload {
    self.fetchedResultsController = nil;
    self.fetchedStatisticsResultsController = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarControllerDelegate

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[SettingsViewController class]]) {
        SettingsViewController *settingsViewController = (SettingsViewController *) viewController;
        [settingsViewController setDelegate:self];
    }
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showFinalScoreResults"]) {
        StatisticsViewController *destinationViewController = (StatisticsViewController *) [segue destinationViewController];
        [destinationViewController setPercentageOfCorrectAnswer:_percentageOfCorrectAnswer];
        
        [self resetQuiz];
    }
}

#pragma mark - SettingsViewControllerDelegate
/*!
 * @brief delegate method that resets the current quiz session
 * @param BOOL what option the user has chosen in settings
 */
- (void)settingsDidChangeWithOptions:(BOOL) options {
    _isMultipleChoiceQuestion = options;
    self.fetchedResultsController = nil;
    [self resetQuiz];
}

#pragma mark - Actions
- (IBAction)multipleChoiceButtonOneTapped:(id)sender {
    [self checkMultipleOptionsQuestionAndLoadNextOne:[sender currentTitle]];
}

- (IBAction)multipleChoiceButtonTwoTapped:(id)sender {
    [self checkMultipleOptionsQuestionAndLoadNextOne:[sender currentTitle]];
}

- (IBAction)multipleChoiceButtonThreeTapped:(id)sender {
    [self checkMultipleOptionsQuestionAndLoadNextOne:[sender currentTitle]];
}

- (IBAction)yesButtonTapped:(id)sender {
    [self checkYesNoQuestionAndLoadNextQuestion:YES];
}

- (IBAction)noButtonTapped:(id)sender {
    [self checkYesNoQuestionAndLoadNextQuestion:NO];
}
@end
