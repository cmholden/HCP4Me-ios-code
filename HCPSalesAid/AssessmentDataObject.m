//
//  AssessmentDataObject.m
//  HCPSalesAid
//
//  Created by cmholden on 09/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "AssessmentDataObject.h"

@implementation AssessmentDataObject

#define ANSWER_SEPARATOR "\n-------------------\n"

@synthesize category; 
@synthesize question;
@synthesize answer1;
@synthesize answer2;
@synthesize answer3;
@synthesize answer4;
@synthesize answer5;
@synthesize correctAnswer;
@synthesize userAnswers;
@synthesize result;
@synthesize tstamp;
@synthesize status;

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:category forKey:@"category"];
    [encoder encodeObject:question forKey:@"question"];
    [encoder encodeObject:answer1 forKey:@"answer1"];
    [encoder encodeObject:answer2 forKey:@"answer2"];
    [encoder encodeObject:answer3 forKey:@"answer3"];
    [encoder encodeObject:answer4 forKey:@"answer4"];
    [encoder encodeObject:answer5 forKey:@"answer5"];
    [encoder encodeObject:correctAnswer forKey:@"correctAnswer"];
    [encoder encodeObject:userAnswers forKey:@"userAnswers"];
    [encoder encodeInt:result forKey:@"result"];
    [encoder encodeInt:status forKey:@"status"];
    [encoder encodeDouble:tstamp forKey:@"tstamp"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    self.category = [decoder decodeObjectForKey:@"category"];
    self.question = [decoder decodeObjectForKey:@"question"];
    self.answer1 = [decoder decodeObjectForKey:@"answer1"];
    self.answer2 = [decoder decodeObjectForKey:@"answer2"];
    self.answer3 = [decoder decodeObjectForKey:@"answer3"];
    self.answer4 = [decoder decodeObjectForKey:@"answer4"];
    self.answer5 = [decoder decodeObjectForKey:@"answer5"];
    self.correctAnswer = [decoder decodeObjectForKey:@"correctAnswer"];
    self.userAnswers = [decoder decodeObjectForKey:@"userAnswers"];
    self.result = [decoder decodeIntForKey:@"result"];
    self.status = [decoder decodeIntForKey:@"status"];
    self.tstamp = [decoder decodeFloatForKey:@"tstamp"];
    return self;
}
//only allows status update if greater than current status
- (void) updateStatus : (int) statusInt{
    if( statusInt > status)
        status = statusInt;
}
- (BOOL) isAnswerCorrect{
    BOOL answerCorrect = NO;
    if(userAnswers == nil || [userAnswers count] == 0 || correctAnswer == nil)
        return answerCorrect;
    if( [userAnswers count] != [correctAnswer count])
        return answerCorrect;
    
    answerCorrect = YES;
    for( int i=0;i<[correctAnswer count]; i++){
        if( ![userAnswers containsObject:[correctAnswer objectAtIndex:i]] ){
            answerCorrect = NO;
            break;
        }
    }
    
    return answerCorrect;
        
    
}
- (NSString *) getCorrectAnswerText {
    NSString *answer = @"";
    if( correctAnswer == nil)
        return answer;
    int count = (int)[correctAnswer count];
    int len = 0;
    for( int i=0;i<count; i++){
        int txtNum = [((NSNumber *)[correctAnswer objectAtIndex:i]) intValue];
        answer = [answer stringByAppendingString:[self getAnswerText:txtNum]];
        if( len < count-1)
            answer = [answer stringByAppendingString:@ANSWER_SEPARATOR];
        len++;
    }
    return answer;
}

- (NSString *) getUserAnswerText {
    NSString *answer = @"";
    if( userAnswers == nil)
        return answer;
    int count = (int)[userAnswers count];
    int len = 0;
    for( int i=0;i<count; i++){
        int txtNum = [((NSNumber *)[userAnswers objectAtIndex:i]) intValue];
        answer = [answer stringByAppendingString:[self getAnswerText:txtNum]];
        if( len < count-1)
            answer = [answer stringByAppendingString:@ANSWER_SEPARATOR];
        len++;
    }
    return answer;
}

- (NSString *) getAnswerText : (int) answerNum {
    NSString *answer = @"";
    switch (answerNum){
        case 0:
            answer = answer1;
            break;
        case 1:
            answer = answer2;
            break;
        case 2:
            answer = answer3;
            break;
        case 3:
            answer = answer4;
            break;
        case 4:
            answer = answer5;
            break;
            
    }
    
    return answer;
}

- (NSString *) valuesAsJSON {
    NSString *json = @"{\"category\":\"";
    json = [json stringByAppendingString:self.category];
    json = [json stringByAppendingString:@"\"\"timeStamp\":\""];
    
    NSString *ts = [NSString stringWithFormat:@"%0.f", tstamp ];
    
    json = [json stringByAppendingString:ts];
    json = [json stringByAppendingString:@"\"\"question\":\""];
    
    json = [json stringByAppendingString:self.question];
    
    json = [json stringByAppendingString:@"\"\"status\":\""];
    
    NSString *stat = @"Not Started";
    if(self.status == 1 )
        stat = @"In Progress";
    else if (self.status == 2)
        stat = @"Completed";
    
    json = [json stringByAppendingString:stat];
    
    json = [json stringByAppendingString:@"\"\"result\":\""];
    
    NSString *res = [self isAnswerCorrect]? @"1" : @"0";
    
    json = [json stringByAppendingString:res];
    json = [json stringByAppendingString:@"\"}"];
    
    
    return json;
}
@end
