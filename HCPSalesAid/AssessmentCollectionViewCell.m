//
//  AssessmentTableViewCell.m
//  HCPSalesAid
//
//  Created by cmholden on 09/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "AssessmentCollectionViewCell.h"

@implementation AssessmentCollectionViewCell

@synthesize dataObject;
@synthesize titleText;
@synthesize detailText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // NSLog(@"INIT");
    }
    [self setup];
    return self;
}

-(void) setup{
    
    self.backgroundColor = [UIColor whiteColor];
    float titleIndent = 5;
    
    float htGap = 2;
    UIFont *fBoldBody = [UIFont fontWithName:@"Arial-BoldMT" size:14];
    
    
    self.titleText = [[UILabel alloc] initWithFrame:CGRectMake(titleIndent, htGap, self.frame.size.width - 79.0f, 38)];
    [self.titleText setNumberOfLines:0];
    self.titleText.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleText.font = fBoldBody;
    self.titleText.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleText];
    
    self.detailText = [[UILabel alloc] initWithFrame:CGRectMake(
                                    self.titleText.frame.origin.x,
                                    self.titleText.frame.origin.y + self.titleText.frame.size.height ,
                                    self.frame.size.width - 79.0f, 28)];
    [self.detailText setNumberOfLines:0];
    self.detailText.font = [UIFont fontWithName:@"ArialMT" size:13];
    self.detailText.lineBreakMode = NSLineBreakByWordWrapping;
    self.detailText.textColor = [Utilities getDarkGray];
    [self.detailText setText:@""];
    [self.contentView addSubview:self.detailText];
    
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 40.0f,
                                                                          (self.frame.size.height - 22)/2, 20, 22)];
    arrowImg.image= [UIImage imageNamed:@"UIButtonBarArrowRightGrey.png"];
    [arrowImg setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:arrowImg];
 
}

-(void) updateCell : (AssessmentDataObject *)dObject {
    self.dataObject = dObject;
    if( dataObject == nil){
        [self.titleText setText:@""];
        return;
    }
        
    NSString *tmpStr = dataObject.question;
    if( tmpStr == nil)
        [titleText setText:@""];
    else
        [titleText setText:tmpStr];
    
    [self.detailText setAttributedText: [self getUserViewsString:dObject]];
    
    
}

-(NSMutableAttributedString *) getUserViewsString :  (AssessmentDataObject *)dObject{
    UIColor *color = [Utilities getDarkGray];
    NSTextAttachment *attachment;
    UIFont *fBody = [UIFont fontWithName:@"ArialMT" size:13];
    NSMutableAttributedString *userViewsTxt = [[NSMutableAttributedString alloc] init];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:color,
                                 NSFontAttributeName:fBody};
    
    
    NSString *tmpStr = @"";
    UIImage *status;
    int assessStatus = dObject.status;
    if( assessStatus == 0){
        status = [UIImage imageNamed:@"notstarted16.png"];
        tmpStr = @" Not Started  |  ";
    }
    else if( assessStatus == 2){
        status = [UIImage imageNamed:@"completed16.png"];
        tmpStr = @" Completed  |  ";
    }
    else {
        status = [UIImage imageNamed:@"inprogress16.png"];
        tmpStr = @" In Progress  |  ";
    }
    attachment = [[NSTextAttachment alloc] init];
    attachment.bounds = CGRectMake(0, -3, 16, 16);
    attachment.image = status;
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attachment];
    
    [userViewsTxt appendAttributedString:attrStringWithImage ];
    
    NSMutableAttributedString *tmpViews = [[NSMutableAttributedString alloc] initWithString:tmpStr];
    [userViewsTxt appendAttributedString:tmpViews];
    
    NSTimeInterval viewTime = dObject.tstamp/1000;
    if( viewTime == 0){
        tmpStr = @"Not yet viewed";
    }
    else{
        NSDate *dt = [[NSDate alloc] initWithTimeIntervalSince1970:viewTime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M/d/yy"];
        tmpStr = [formatter stringFromDate:dt];
        tmpStr = [@"Viewed: " stringByAppendingString:tmpStr];
    }
    tmpViews = [[NSMutableAttributedString alloc] initWithString:tmpStr];
    [userViewsTxt appendAttributedString:tmpViews];
    
    [userViewsTxt addAttributes:attributes range:NSMakeRange(0, [userViewsTxt length])];
    return userViewsTxt;
}
@end
