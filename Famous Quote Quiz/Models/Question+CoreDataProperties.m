//
//  Question+CoreDataProperties.m
//  Famous Quote Quiz
//
//  Created by Mihail Velikov on 10/30/15.
//  Copyright © 2015 Flat Rock. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Question+CoreDataProperties.h"

@implementation Question (CoreDataProperties)

@dynamic isMultipleChoice;
@dynamic text;
@dynamic answers;
@dynamic sessions;

@end
