//
//  ResultViewController.h
//  HCPSalesAid
//
//  Created by cmholden on 10/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetRetriever.h"
#import "AssessmentDataObject.h"
#import "Utilities.h"

@interface ResultViewController : UIViewController

@property (strong, nonatomic) UILabel *categoryTitle;
@property (strong, nonatomic) UILabel *resultTitle;
@property (strong, nonatomic) UILabel *userAnswerTitle;
@property (strong, nonatomic) UITextView *userAnswer;
@property (strong, nonatomic) UILabel *correctAnswerTitle;
@property (strong, nonatomic) UITextView *correctAnswer;
@property (strong, nonatomic) UILabel *toggleText;
@property (strong, nonatomic) UIButton *toggleAnswer;
@property (strong, nonatomic) UIButton *finishButton;
@property (strong, nonatomic) UIImageView *correctImg;

@property (strong, nonatomic) AssessmentDataObject *assessDataObject;
@property (strong, nonatomic) NSMutableArray *currentSelections;
@property (nonatomic) BOOL isMultiSelect;
//a ref to the complete list of asses values
@property (strong, nonatomic) NSMutableArray *assessmentArray;
//the object to save the updated list when updating
@property (strong, nonatomic) AssetRetriever *updateSaver;

@property (nonatomic) int correctAnswerHt;

- (void) setup;

- (void) setAssessmentDataObject : (AssessmentDataObject *) assDataObject;



@end

