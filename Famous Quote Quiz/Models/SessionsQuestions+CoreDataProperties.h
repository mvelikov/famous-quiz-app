//
//  SessionsQuestions+CoreDataProperties.h
//  Famous Quote Quiz
//
//  Created by Mihail Velikov on 10/30/15.
//  Copyright © 2015 Flat Rock. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SessionsQuestions.h"

NS_ASSUME_NONNULL_BEGIN

@interface SessionsQuestions (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isCorrect;
@property (nullable, nonatomic, retain) NSSet<Question *> *questions;
@property (nullable, nonatomic, retain) NSSet<Session *> *sessions;

@end

@interface SessionsQuestions (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSSet<Question *> *)values;
- (void)removeQuestions:(NSSet<Question *> *)values;

- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet<Session *> *)values;
- (void)removeSessions:(NSSet<Session *> *)values;

@end

NS_ASSUME_NONNULL_END
