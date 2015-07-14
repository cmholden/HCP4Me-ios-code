//
//  AssessmentViewDelegate.h
//  HCPSalesAid
//
//  Created by cmholden on 09/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssessmentDataObject.h"

@protocol AssessmentViewDelegate <NSObject>

- (void) assessmentSelected : (AssessmentDataObject *) assessDataObject assessmentObject : (NSMutableArray *)assessmentArray;

@end
