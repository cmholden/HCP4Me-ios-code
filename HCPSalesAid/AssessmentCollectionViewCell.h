//
//  AssessmentTableViewCell.h
//  HCPSalesAid
//
//  Created by cmholden on 09/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssessmentDataObject.h"
#import "Utilities.h"

@interface AssessmentCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) AssessmentDataObject *dataObject;
@property (strong, nonatomic) UILabel *detailText;
@property (strong, nonatomic) UILabel *titleText;

-(void) setup;

-(void) updateCell : (AssessmentDataObject *)dataObject;

@end
