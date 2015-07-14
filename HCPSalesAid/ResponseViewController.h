//
//  ResponseViewController.h
//  HCPSalesAid
//
//  Created by cmholden on 10/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetRetriever.h"
#import "AssessmentDataObject.h"
#import "ResponseViewCell.h"
#import "ResultViewController.h"

#import "Utilities.h"

@interface ResponseViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UILabel *categoryTitle;
@property (strong, nonatomic) UITextView *question;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UICollectionView *responseViewCollection;
@property (strong, nonatomic) AssessmentDataObject *assessDataObject;
@property (nonatomic) BOOL isMultiSelect;
@property (strong, nonatomic) NSMutableArray *currentSelections;
//a ref to the complete list of asses values
@property (strong, nonatomic) NSMutableArray *assessmentArray;
//the object to save the updated list when updating
@property (strong, nonatomic) AssetRetriever *updateSaver;

- (void) setup;

- (void) setAssessmentDataObject : (AssessmentDataObject *) assDataObject;


@end
