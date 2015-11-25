//
//  Question.h
//  Famous Quote Quiz
//
//  Created by Mihail Velikov on 10/30/15.
//  Copyright © 2015 Flat Rock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Answer, SessionsQuestions;

NS_ASSUME_NONNULL_BEGIN

@interface Question : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Question+CoreDataProperties.h"
