//
//  AssessmentDataObject.h
//  HCPSalesAid
//
//  Created by cmholden on 09/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssessmentDataObject : NSObject <NSCoding>

#define NOT_STARTED_STATUS 0;
#define IN_PROGRESS_STATUS 1;
#define COMPLETED_STATUS 2;

@property(strong, nonatomic) NSString *category;
@property(strong, nonatomic) NSString *question;
@property(strong, nonatomic) NSString *answer1;
@property(strong, nonatomic) NSString *answer2;
@property(strong, nonatomic) NSString *answer3;
@property(strong, nonatomic) NSString *answer4;
@property(strong, nonatomic) NSString *answer5;
@property (strong, nonatomic) NSMutableArray *correctAnswer;
@property (strong, nonatomic) NSMutableArray *userAnswers;
@property (nonatomic) int result;  //1 for correct answer 0 for wrong
@property (nonatomic) int status;
@property(nonatomic) double tstamp;

- (void) updateStatus : (int) statusInt;

- (NSString *) valuesAsJSON;

- (BOOL) isAnswerCorrect;

- (NSString *) getCorrectAnswerText ;

- (NSString *) getUserAnswerText ;

@end
