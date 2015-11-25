//
//  Answer+CoreDataProperties.h
//  Famous Quote Quiz
//
//  Created by Mihail Velikov on 10/30/15.
//  Copyright © 2015 Flat Rock. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Answer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Answer (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isCorrect;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) Question *question;

@end

NS_ASSUME_NONNULL_END
