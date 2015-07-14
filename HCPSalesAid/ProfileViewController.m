//
//  ProfileViewController.m
//  HCPSalesAid
//
//  Created by cmholden on 08/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController

@synthesize userName;
@synthesize userIdTxt;
@synthesize userNameTxt;
@synthesize statsTitle;

@synthesize assessCompleted;
@synthesize assessNotCompleted;
@synthesize assessCompletedTxt;
@synthesize assessNotCompletedTxt;
@synthesize viewAssessments;
@synthesize assessCompletedImg;

@synthesize assetUpdater;
@synthesize statsView;


@synthesize assetCompleted;
@synthesize assetInProgress;
@synthesize assetNotStarted;

@synthesize assetCompletedTxt;
@synthesize assetInProgressTxt;
@synthesize assetNotStartedTxt;

@synthesize assetCompletedImg;
@synthesize assetInProgressImg;
@synthesize assetNotStartedImg;

@synthesize viewAssets;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"PROFILE";
    float indent = 9.0f;
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 6,60,60)];//(self.view.frame.size.width-60)/2, 6,60,60)];
    logoView.image= [UIImage imageNamed:@"60-iPhone.png"];
    [logoView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:logoView];
    
    
    userName = [[UILabel alloc] initWithFrame:CGRectMake(
                                    100,//(self.view.frame.size.width-280)/2,
                                    6,//logoView.frame.origin.y + logoView.frame.size.height + 5.0f,
                                                         280,60)];
    userName.textColor = [UIColor blackColor];
    userName.textAlignment = NSTextAlignmentLeft;//Center;
    userName.numberOfLines = 2;
    [self.view addSubview:userName];
    
    float frameHt = self.tabBarController.tabBar.frame.origin.y - self.navigationController.navigationBar.frame.origin.y -
    self.navigationController.navigationBar.frame.size.height;
    
    statsView = [[UIView alloc] initWithFrame:
                 CGRectMake(0, userName.frame.origin.y + userName.frame.size.height + 5.0f, self.view.frame.size.width, frameHt - 72)];
    statsView.layer.borderColor = [Utilities getLightGray].CGColor;
    statsView.layer.borderWidth = 4.0f;
    [self.view addSubview:statsView];
    
    statsTitle = [[UILabel alloc] initWithFrame:CGRectMake(
                                  12,6,90,18)];
    statsTitle.textColor = [UIColor blackColor];
    statsTitle.text = @"ASSETS";
    statsTitle.textAlignment = NSTextAlignmentLeft;
    statsTitle.font = [Utilities getBoldFont:16];
    [statsView addSubview:statsTitle];
    
    float thirdWd = (statsView.frame.size.width - indent * 2)/3;
    float rowY = statsTitle.frame.origin.y + statsTitle.frame.size.height + 8.0f;
    
    assetCompleted = [[UILabel alloc] initWithFrame:CGRectMake( indent,rowY,thirdWd,16)];
    assetCompleted.textColor = [UIColor blackColor];
    assetCompleted.textAlignment = NSTextAlignmentCenter;
    assetCompleted.font = [Utilities getBoldFont:15];
    [statsView addSubview:assetCompleted];
    
    assetInProgress = [[UILabel alloc] initWithFrame:CGRectMake( thirdWd + indent,rowY,thirdWd,16)];
    assetInProgress.textColor = [UIColor blackColor];
    assetInProgress.textAlignment = NSTextAlignmentCenter;
    assetInProgress.font = [Utilities getBoldFont:15];
    [statsView addSubview:assetInProgress];
    
    assetNotStarted = [[UILabel alloc] initWithFrame:CGRectMake( thirdWd * 2 + indent,rowY,thirdWd,16)];
    assetNotStarted.textColor = [UIColor blackColor];
    assetNotStarted.textAlignment = NSTextAlignmentCenter;
    assetNotStarted.font = [Utilities getBoldFont:15];
    [statsView addSubview:assetNotStarted];
    
    rowY += 20;
    assetCompletedTxt = [[UILabel alloc] initWithFrame:CGRectMake( indent,rowY,thirdWd,16)];
    assetCompletedTxt.textColor = [Utilities getDarkGray];
    assetCompletedTxt.textAlignment = NSTextAlignmentCenter;
    assetCompletedTxt.text = @"COMPLETED";
    assetCompletedTxt.font = [Utilities getFont:14];
    [statsView addSubview:assetCompletedTxt];
    
    assetInProgressTxt = [[UILabel alloc] initWithFrame:CGRectMake( thirdWd + indent,rowY,thirdWd,16)];
    assetInProgressTxt.textColor = [Utilities getDarkGray];
    assetInProgressTxt.text = @"IN PROGRESS";
    assetInProgressTxt.textAlignment = NSTextAlignmentCenter;
    assetInProgressTxt.font = [Utilities getFont:14];
    [statsView addSubview:assetInProgressTxt];
    
    assetNotStartedTxt = [[UILabel alloc] initWithFrame:CGRectMake( thirdWd * 2 + indent,rowY,thirdWd,16)];
    assetNotStartedTxt.textColor = [Utilities getDarkGray];
    assetNotStartedTxt.text = @"NOT STARTED";
    assetNotStartedTxt.textAlignment = NSTextAlignmentCenter;
    assetNotStartedTxt.font = [Utilities getFont:14];
    [statsView addSubview:assetNotStartedTxt];
    
    rowY += 20;
    float imgAdj = thirdWd/2 - 8;
    assetCompletedImg = [[UIImageView alloc] initWithFrame:CGRectMake( indent + imgAdj,rowY,16,16)];
    assetCompletedImg.image= [UIImage imageNamed:@"completed16.png"];
    [assetCompletedImg setContentMode:UIViewContentModeScaleAspectFit];
    [statsView addSubview:assetCompletedImg];
    
    assetInProgressImg = [[UIImageView alloc] initWithFrame:CGRectMake( thirdWd + indent + imgAdj,rowY,16,16)];
    assetInProgressImg.image= [UIImage imageNamed:@"inprogress16.png"];
    [assetInProgressImg setContentMode:UIViewContentModeScaleAspectFit];
    [statsView addSubview:assetInProgressImg];
    
    assetNotStartedImg = [[UIImageView alloc] initWithFrame:CGRectMake( thirdWd * 2 + indent + imgAdj,rowY,16,16)];
    assetNotStartedImg.image= [UIImage imageNamed:@"notstarted16.png"];
    [assetNotStartedImg setContentMode:UIViewContentModeScaleAspectFit];
    [statsView addSubview:assetNotStartedImg];
    rowY += 20;
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake( indent, statsView.frame.size.height/2 - 1,
                                                            statsView.frame.size.width - (indent * 2),1)];
    
    line.backgroundColor = [Utilities getLightGray];
    [statsView addSubview:line];
    rowY = line.frame.origin.y - 48;
    
    viewAssets = [[UIButton alloc] initWithFrame:CGRectMake(indent, rowY, statsView.frame.size.width - (indent * 2), 45)];
    [viewAssets setTitle:@"VIEW ASSETS" forState:UIControlStateNormal];
    viewAssets.tintColor = [UIColor whiteColor];
    viewAssets.titleLabel.font = [Utilities getBoldFont:18];
    viewAssets.backgroundColor = [Utilities getSAPGold];
    [viewAssets addTarget:self action:@selector(viewAssetsClicked:) forControlEvents:UIControlEventTouchUpInside];
    [statsView addSubview:viewAssets];
    
    rowY = statsView.frame.size.height - line.frame.origin.y + 2;
    //rowY += 10;
    assessNotCompleted = [[UILabel alloc] initWithFrame:CGRectMake( indent,rowY,60,50)];
    assessNotCompleted.textColor = [UIColor redColor];
    assessNotCompleted.textAlignment = NSTextAlignmentCenter;
    assessNotCompleted.font = [Utilities getBoldFont:30];
    [statsView addSubview:assessNotCompleted];
    
    assessNotCompletedTxt = [[UILabel alloc] initWithFrame:CGRectMake(
                            assessNotCompleted.frame.origin.x + assessNotCompleted.frame.size.width+10,rowY,210,50)];
    assessNotCompletedTxt.textColor = [UIColor blackColor];
    assessNotCompletedTxt.textAlignment = NSTextAlignmentLeft;
    assessNotCompletedTxt.numberOfLines = 2;
    assessNotCompletedTxt.text = @"Assessment questions have not been completed";
    assessNotCompletedTxt.font = [Utilities getFont:16];
    [statsView addSubview:assessNotCompletedTxt];
    
    self.assessCompletedImg = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                    indent + 48,
                                                    assessNotCompleted.frame.origin.y + assessNotCompleted.frame.size.height + 12,
                                                    20,20)];
    self.assessCompletedImg.image = [UIImage imageNamed:@"check_in_20px.png"];
    [self.assessCompletedImg setContentMode:UIViewContentModeScaleAspectFit];
    [statsView addSubview:self.assessCompletedImg];
    
    assessCompletedTxt = [[UILabel alloc] initWithFrame:CGRectMake(
                                    assessCompletedImg.frame.origin.x + assessCompletedImg.frame.size.width+30,
                                    assessCompletedImg.frame.origin.y, 150,16)];
    assessCompletedTxt.textColor = [UIColor blackColor];
    assessCompletedTxt.textAlignment = NSTextAlignmentLeft;
    assessCompletedTxt.font = [Utilities getFont:14];
    [statsView addSubview:assessCompletedTxt];
    
    rowY = statsView.frame.size.height - 47;
    
    viewAssessments = [[UIButton alloc] initWithFrame:CGRectMake(indent, rowY, statsView.frame.size.width - (indent * 2), 45)];
    [viewAssessments setTitle:@"VIEW ASSESSMENTS" forState:UIControlStateNormal];
    viewAssessments.tintColor = [UIColor whiteColor];
    viewAssessments.titleLabel.font = [Utilities getBoldFont:18];
    viewAssessments.backgroundColor = [Utilities getSAPGold];
    [viewAssessments addTarget:self action:@selector(viewAssessmentsClicked:) forControlEvents:UIControlEventTouchUpInside];
    [statsView addSubview:viewAssessments];
    
}

- (void) setName : (NSString *)name : (NSString *) userId{
    self.userNameTxt = name;
    self.userIdTxt = userId;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    userName.attributedText = [self getTitleString : self.userNameTxt : self.userIdTxt];
    
    NSMutableArray *assessmentArray = [assetUpdater loadAssessmentDataFromFile];
    [self extractAssesStatus : assessmentArray ];
    
    
    NSMutableDictionary *userViews = [assetUpdater loadAssetsFromFile:@USER_VIEWS_PLIST];
    NSMutableDictionary *assetList = [assetUpdater loadAssetsFromFile:@LOCAL_DESC_PLIST];
    [self extractAssetStatus : assetList : userViews ];
}


-(NSMutableAttributedString *) getTitleString :(NSString *)name : (NSString *) userId{
    NSMutableAttributedString *titleTxt = [[NSMutableAttributedString alloc] init];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [titleTxt addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleTxt length])];
    
    NSDictionary *attributesIntro = @{NSForegroundColorAttributeName:[Utilities getDarkGray],
                                 NSFontAttributeName:[Utilities getFont:13]};
    
    NSDictionary *attributesMain = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                      NSFontAttributeName:[Utilities getBoldFont:18]};

    NSMutableAttributedString *userIntro = [[NSMutableAttributedString alloc] initWithString:@"NAME : "];
    [userIntro addAttributes:attributesIntro range:NSMakeRange(0, [userIntro length])];
    [titleTxt appendAttributedString:userIntro];

    
    NSMutableAttributedString *userMain = [[NSMutableAttributedString alloc] initWithString:name];
    [userMain addAttributes:attributesMain range:NSMakeRange(0, [userMain length])];
    [titleTxt appendAttributedString:userMain];
    
    NSMutableAttributedString *userIdIntro = [[NSMutableAttributedString alloc] initWithString:@"\nUSER ID : "];
    [userIdIntro addAttributes:attributesIntro range:NSMakeRange(0, [userIdIntro length])];
    [titleTxt appendAttributedString:userIdIntro];
    
    
    NSMutableAttributedString *userIdMain = [[NSMutableAttributedString alloc] initWithString:userId];
    [userIdMain addAttributes:attributesMain range:NSMakeRange(0, [userIdMain length])];
    [titleTxt appendAttributedString:userIdMain];
    
    return titleTxt;
    
}
- (void) extractAssesStatus : (NSMutableArray *) assessValues  {
    int totalValues = (int)[assessValues count];
    int completedItems = 0;
    for( int i=0; i<totalValues; i++){
        AssessmentDataObject *dataObj = (AssessmentDataObject *)[assessValues objectAtIndex:i];
        if( dataObj.status == 2)
            completedItems++;
    }
    self.assessNotCompleted.text = [NSString stringWithFormat:@"%d", totalValues-completedItems];
    NSString *tmp = [NSString stringWithFormat:@"%d", completedItems];
    self.assessCompletedTxt.text = [tmp stringByAppendingString: @" Questions Completed"];

    
}
- (void) extractAssetStatus : (NSMutableDictionary *) assetList : (NSMutableDictionary *) assessViews{
    int totalValues = (int)[assetList count];
    int completed = 0;
    int inProgress = 0;
    for( NSString *key in assetList){
        UserAssetStatus *status = [assessViews objectForKey:key];
        if( status != nil){
            if( status.percentComplete >0 && status.percentComplete < 100)
                inProgress++;
            else if( status.percentComplete == 100)
                completed++;
        }
        
    }
    self.assetNotStarted.text = [NSString stringWithFormat:@"%d", totalValues - completed - inProgress];
    self.assetCompleted.text = [NSString stringWithFormat:@"%d", completed];
    self.assetInProgress.text = [NSString stringWithFormat:@"%d", inProgress];
    
}

- (void) viewAssetsClicked : (id) sender {
    [self goHomeTab:1];
}
- (void) viewAssessmentsClicked : (id) sender {
    [self goHomeTab:2];
}
- (void) goHomeTab : (int)tab{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:tab forKey:@"selectedTab"];
    [defaults synchronize];

    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
