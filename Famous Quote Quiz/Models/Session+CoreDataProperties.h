//
//  Session+CoreDataProperties.h
//  Famous Quote Quiz
//
//  Created by Mihail Velikov on 10/30/15.
//  Copyright © 2015 Flat Rock. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Session.h"

NS_ASSUME_NONNULL_BEGIN

@interface Session (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<SessionsQuestions *> *questions;

@end

@interface Session (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(SessionsQuestions *)value;
- (void)removeQuestionsObject:(SessionsQuestions *)value;
- (void)addQuestions:(NSSet<SessionsQuestions *> *)values;
- (void)removeQuestions:(NSSet<SessionsQuestions *> *)values;

@end

NS_ASSUME_NONNULL_END
