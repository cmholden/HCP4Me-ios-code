//
//  AssessmentGroupDataObject.h
//  HCPSalesAid
//
//  Created by cmholden on 09/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//
//NOT CURRENTLY USED
#import <Foundation/Foundation.h>
#import "AssessmentDataObject.h"

@interface AssessmentGroupDataObject : NSObject <NSCoding>

@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *categoryGroup;
@property (strong, nonatomic) NSMutableArray *assessObjList;
@property (strong, nonatomic) NSMutableDictionary *dataObjForQuestion;
@property (nonatomic) BOOL completed;

- (void) addAssessmentDataObject : (AssessmentDataObject *) dataObj;

- (AssessmentDataObject *) dataObjectForQuestion : (NSString *)questionTxt;

@end
