//
//  ResultViewController.m
//  HCPSalesAid
//
//  Created by cmholden on 10/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "ResultViewController.h"

@implementation ResultViewController

@synthesize categoryTitle;
@synthesize resultTitle;
@synthesize userAnswerTitle;
@synthesize userAnswer;
@synthesize correctAnswerTitle;
@synthesize correctAnswer;
@synthesize toggleText;
@synthesize toggleAnswer;
@synthesize finishButton;
@synthesize correctImg;


@synthesize isMultiSelect;
@synthesize assessDataObject;
@synthesize currentSelections;
@synthesize assessmentArray;
@synthesize updateSaver;
@synthesize correctAnswerHt;

#define CORRECT_ANSWER "Correct Answer"
#define INCORRECT_ANSWER "Incorrect Answer"

- (void) viewDidLoad{
    [super viewDidLoad];
    [self setup];
}
- (void) setup{
    

    float leftIndent = 12.0f;
    self.currentSelections = [[NSMutableArray alloc] initWithCapacity:5];
    self.categoryTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + leftIndent ,
                                                                   8.0f,
                                                                   290,
                                                                   20)];
    self.categoryTitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.categoryTitle.font = [Utilities getBoldFont:18];
    self.categoryTitle.textColor = [Utilities getDarkGray];
    [self.view addSubview:self.categoryTitle];
    
    self.resultTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + leftIndent,
                                                         self.categoryTitle.frame.origin.y + self.categoryTitle.frame.size.height + 5.0f,
                                                         self.view.frame.size.width * 0.4f ,
                                                         50)];
    self.resultTitle.font = [Utilities getBoldFont:20 ];
    self.resultTitle.numberOfLines = 2;
    self.resultTitle.textColor = [UIColor blackColor];
    self.resultTitle.text = @"Result Summary";
    [self.view addSubview:self.resultTitle];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(
                             self.view.frame.origin.x + leftIndent,
                             self.resultTitle.frame.origin.y + self.resultTitle.frame.size.height + 4.0f,
                             self.view.frame.size.width  - leftIndent * 2,
                             2)];
    line1.backgroundColor = [Utilities getLightGray];
    [self.view addSubview:line1];
    
    self.userAnswerTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + leftIndent,
                                                                 line1.frame.origin.y + line1.frame.size.height + 4.0f,
                                                                 self.view.frame.size.width * 0.6f ,
                                                                 20)];
    self.userAnswerTitle.font = [Utilities getItalicFont:16 ];
    self.userAnswerTitle.numberOfLines = 1;
    self.userAnswerTitle.textColor = [UIColor redColor];
    //self.userAnswerTitle.text = @"";
    [self.view addSubview:self.userAnswerTitle];
    
    
    self.userAnswer = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + leftIndent,
                                                                     self.userAnswerTitle.frame.origin.y + self.userAnswerTitle.frame.size.height + 4.0f,
                                                                     self.view.frame.size.width * 0.8f,
                                                                     65)];
    self.userAnswer.font = [Utilities getFont:16 ];
    self.userAnswer.textColor = [UIColor blackColor];
    //self.userAnswerTitle.text = @"";
    [self.view addSubview:self.userAnswer];
    
    self.correctImg = [[UIImageView alloc] initWithFrame:CGRectMake(
                                           self.view.frame.size.width * 0.88f,
                                           self.userAnswer.frame.origin.y + self.userAnswer.frame.size.height/2 - 10,
                                           20,20)];
    self.correctImg.image = [UIImage imageNamed:@"check_in_20px.png"];
    [self.correctImg setContentMode:UIViewContentModeScaleAspectFit];
    self.correctImg.hidden = YES;
    [self.view addSubview:self.correctImg];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(
                                         self.view.frame.origin.x + leftIndent,
                                         self.userAnswer.frame.origin.y + self.userAnswer.frame.size.height + 4.0f,
                                         self.view.frame.size.width  - leftIndent * 2,
                                                             2)];
    line2.backgroundColor = [Utilities getLightGray];
    [self.view addSubview:line2];
    
    
    self.toggleText = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + leftIndent,
                                                                line2.frame.origin.y + line2.frame.size.height + 2.0f,
                                                                self.view.frame.size.width * 0.4f,
                                                                15)];
    self.toggleText.font = [Utilities getFont:11 ];
    self.toggleText.numberOfLines = 1;
    self.toggleText.textColor = [Utilities getLightGray];
    self.toggleText.text = @"Toggle to show answer";
    [self.view addSubview:self.toggleText];
    
    
    self.toggleAnswer = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width  - leftIndent * 2 - 48.0f ,
                                                                  self.toggleText.frame.origin.y +
                                                                 self.toggleText.frame.size.height - 8.0f,
                                                                 44, 44)];
    [self.toggleAnswer setTitle:@"+" forState:UIControlStateNormal];
    [self.toggleAnswer setTitleColor:[Utilities getDarkGray] forState:UIControlStateNormal];
 //   self.toggleAnswer.tintColor = [UIColor blackColor];
    self.toggleAnswer.titleLabel.font = [Utilities getFont:18];
    self.toggleAnswer.backgroundColor = [UIColor clearColor];
    [self.toggleAnswer addTarget:self action:@selector(toggleClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toggleAnswer];
    
    
    self.correctAnswerTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + leftIndent,
                                                                     self.toggleText.frame.origin.y + self.toggleText.frame.size.height + 2.0f,
                                                                     self.view.frame.size.width * 0.6f,
                                                                     20)];
    self.correctAnswerTitle.font = [Utilities getItalicFont:18 ];
    self.correctAnswerTitle.numberOfLines = 1;
    self.correctAnswerTitle.textColor = [UIColor colorWithRed:((float)18)/255 green:((float)109)/255 blue:((float)63)/255 alpha:1.0f];
    self.correctAnswerTitle.text = @CORRECT_ANSWER;
    [self.view addSubview:self.correctAnswerTitle];
    
    self.correctAnswer = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + leftIndent,
                                            self.correctAnswerTitle.frame.origin.y + self.correctAnswerTitle.frame.size.height + 4.0f,
                                            self.view.frame.size.width * 0.8f,
                                            0)];
    self.correctAnswer.font = [Utilities getItalicFont:16 ];
    self.correctAnswer.textColor = [Utilities getDarkGray];
    //self.userAnswerTitle.text = @"";
    [self.view addSubview:self.correctAnswer];
    self.correctAnswerHt = 80;
    self.correctAnswer.hidden = YES;
    
    float frameHt = self.tabBarController.tabBar.frame.origin.y -  self.navigationController.navigationBar.frame.origin.y -
    self.navigationController.navigationBar.frame.size.height;
    self.finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                            frameHt - 46,
                                                            self.view.frame.size.width, 45)];
    [self.finishButton setTitle:@"FINISH" forState:UIControlStateNormal];
    self.finishButton.tintColor = [UIColor whiteColor];
    self.finishButton.titleLabel.font = [Utilities getBoldFont:18];
    self.finishButton.backgroundColor = [Utilities getSAPGold];
    [self.finishButton addTarget:self action:@selector(finishClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.finishButton];

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if( self.assessDataObject != nil){
        self.categoryTitle.text = self.assessDataObject.category;
        
        if ( self.assessDataObject.userAnswers != nil)
            self.currentSelections = self.assessDataObject.userAnswers;
        else
            return;
        BOOL isAnswerCorrect = [self.assessDataObject isAnswerCorrect];

        if( isAnswerCorrect){ //right answer
            self.userAnswerTitle.text = @CORRECT_ANSWER;
            self.userAnswerTitle.textColor =
                    [UIColor colorWithRed:((float)18)/255 green:((float)109)/255 blue:((float)63)/255 alpha:1.0f];
            self.correctImg.hidden = NO;
            [self showHideCorrectItems:YES];
            self.correctAnswer.text = @"";
            [self.assessDataObject updateStatus : 2];
        }
        else{ //wrong
            self.userAnswerTitle.text = @INCORRECT_ANSWER;
            self.userAnswerTitle.textColor = [UIColor redColor];
            self.correctImg.hidden = YES;
            [self showHideCorrectItems:NO];
            [self.assessDataObject updateStatus : 1];
            self.correctAnswer.text = [self.assessDataObject getCorrectAnswerText];
        }
        self.userAnswer.text = [self.assessDataObject getUserAnswerText];
        
    }
    
    
}
- (void) setAssessmentDataObject : (AssessmentDataObject *) assDataObject{
    
}
- (void) showHideCorrectItems : (BOOL) hide {
  //  self.correctAnswer.hidden = hide;
    self.correctAnswerTitle.hidden = hide;
    self.toggleAnswer.hidden = hide;
    self.toggleText.hidden = hide;
    
}
- (void) finishClicked : (id) sender{
    [self goHome];
}

- (void)goHome {
    
    self.assessDataObject.userAnswers = self.currentSelections;
    
    
    NSDate *dt = [[NSDate alloc] init];
    self.assessDataObject.tstamp =  dt.timeIntervalSince1970 * 1000;
    //now save it
    if( assessmentArray != nil && updateSaver != nil){
        updateSaver.downloadDelegate = nil;
        [updateSaver writeArrayToFile:assessmentArray :@ASSESS_DATA_PLIST];
        //also save to server if we have a connection
        [updateSaver updateOnlineUserViews];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void) toggleClicked : (id) sender{

    float currentHt = (self.correctAnswerHt ) * -1;
    if( self.correctAnswer.frame.size.height == 0)
        currentHt = self.correctAnswerHt;
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.correctAnswer.hidden = NO;
                         CGRect frame = self.correctAnswer.frame;
                         frame.size.height += currentHt;
                         self.correctAnswer.frame = frame;
                         if( currentHt < 0){
                             [self.toggleAnswer setTitle:@"+" forState:UIControlStateNormal];
                         }
                         else{
                             [self.toggleAnswer setTitle:@"-" forState:UIControlStateNormal];
                             
                         }
                     }
                     completion:^(BOOL finished){
                         //  [self test];
                     }];

}

@end

