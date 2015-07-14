//
//  ResponseViewCell.h
//  HCPSalesAid
//
//  Created by cmholden on 10/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssessmentDataObject.h"
#import "Utilities.h"


@interface ResponseViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *questionText;
@property (strong, nonatomic) UIImageView *radioImg;

@property (strong, nonatomic) UIImage *radioOnImg;
@property (strong, nonatomic) UIImage *radioOffImg;
@property (nonatomic) BOOL isQuestSelected;

-(void) setup;

-(void) updateCell : (AssessmentDataObject *)dataObject rowIndex : (int) row ;

-(void) setQuestionSelected : (BOOL) sel;

@end
