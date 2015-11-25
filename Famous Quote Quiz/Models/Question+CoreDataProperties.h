//
//  Question+CoreDataProperties.h
//  Famous Quote Quiz
//
//  Created by Mihail Velikov on 10/30/15.
//  Copyright © 2015 Flat Rock. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Question.h"

NS_ASSUME_NONNULL_BEGIN

@interface Question (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isMultipleChoice;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSSet<Answer *> *answers;
@property (nullable, nonatomic, retain) NSSet<SessionsQuestions *> *sessions;

@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(Answer *)value;
- (void)removeAnswersObject:(Answer *)value;
- (void)addAnswers:(NSSet<Answer *> *)values;
- (void)removeAnswers:(NSSet<Answer *> *)values;

- (void)addSessionsObject:(SessionsQuestions *)value;
- (void)removeSessionsObject:(SessionsQuestions *)value;
- (void)addSessions:(NSSet<SessionsQuestions *> *)values;
- (void)removeSessions:(NSSet<SessionsQuestions *> *)values;

@end

NS_ASSUME_NONNULL_END
