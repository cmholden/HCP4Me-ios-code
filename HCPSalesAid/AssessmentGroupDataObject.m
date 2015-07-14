//
//  AssessmentGroupDataObject.m
//  HCPSalesAid
//
//  Created by cmholden on 09/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//
//NOT CURRENTLY USED
#import "AssessmentGroupDataObject.h"

@implementation AssessmentGroupDataObject

@synthesize category;
@synthesize categoryGroup;
@synthesize assessObjList;
@synthesize dataObjForQuestion;
@synthesize completed;

- (id)init{
    self = [super init];
    if (self) {
        assessObjList = [[NSMutableArray alloc] initWithCapacity:10];
        dataObjForQuestion = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:category forKey:@"category"];
    [encoder encodeObject:categoryGroup forKey:@"categoryGroup"];
    [encoder encodeObject:assessObjList forKey:@"assessObjList"];
    [encoder encodeObject:dataObjForQuestion forKey:@"dataObjForQuestion"];
    [encoder encodeBool:completed forKey:@"completed"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    self.category = [decoder decodeObjectForKey:@"category"];
    self.categoryGroup = [decoder decodeObjectForKey:@"categoryGroup"];
    self.assessObjList = [decoder decodeObjectForKey:@"assessObjList"];
    self.dataObjForQuestion = [decoder decodeObjectForKey:@"dataObjForQuestion"];
    self.completed = [decoder decodeBoolForKey:@"completed"];
    return self;
}
- (void) addAssessmentDataObject : (AssessmentDataObject *) dataObj{
    NSString *question = dataObj.question;
    if( question != nil){
        //see if we have the question already
        AssessmentDataObject *existingDObj = [dataObjForQuestion objectForKey:question];
        if( existingDObj == nil){
            [dataObjForQuestion setObject:dataObj forKey:question];
            [assessObjList addObject:dataObj];
        }
        else{ //update
            for( int i=0; i<[assessObjList count]; i++){
                if( [existingDObj isEqual:[assessObjList objectAtIndex:i]]){
                    [assessObjList setObject:dataObj atIndexedSubscript:i];
                    break;
                }
            }
                
        }
    }
}

- (AssessmentDataObject *) dataObjectForQuestion : (NSString *)questionTxt{
    return [dataObjForQuestion objectForKey:questionTxt];
}

@end
