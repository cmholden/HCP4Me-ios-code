//
//  ResponseViewCell.m
//  HCPSalesAid
//
//  Created by cmholden on 10/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "ResponseViewCell.h"

@implementation ResponseViewCell

@synthesize questionText;
@synthesize radioImg;
@synthesize radioOffImg;
@synthesize radioOnImg;
@synthesize isQuestSelected;

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
    
    
    radioOffImg = [UIImage imageNamed:@"radio32.png"];
    radioOnImg = [UIImage imageNamed:@"radio32-on.png"];
    
    self.radioImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.frame.size.height/2 - 18/2, 18, 18)];
    [self.radioImg setContentMode:UIViewContentModeScaleAspectFit];
    self.radioImg.image = radioOffImg;
    [self.contentView addSubview:self.radioImg];
    
    self.questionText = [[UILabel alloc] initWithFrame:CGRectMake(self.radioImg.frame.origin.x + self.radioImg.frame.size.width + 20,
                                    self.frame.size.height/2 - 60/2, self.frame.size.width - 79.0f, 60)];
    [self.questionText setNumberOfLines:0];
    self.questionText.lineBreakMode = NSLineBreakByWordWrapping;
    self.questionText.font = [Utilities getFont:15];
    self.questionText.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.questionText];
    
    
}

-(void) updateCell : (AssessmentDataObject *)dObject  rowIndex: (int) row{
    if( dObject == nil){
        [self.questionText setText:@""];
        self.radioImg.image = radioOffImg;
        return;
    }
    else{
        switch( row ){
            case 0:
                self.questionText.text = dObject.answer1;
                break;
            case 1:
                self.questionText.text = dObject.answer2;
                break;
            case 2:
                self.questionText.text = dObject.answer3;
                break;
            case 3:
                self.questionText.text = dObject.answer4;
                break;
            case 4:
                self.questionText.text = dObject.answer5;
                break;
                
        }
        
    }
    
}

-(void) setQuestionSelected : (BOOL) sel{
    isQuestSelected = sel;
    self.radioImg.image = isQuestSelected? radioOnImg : radioOffImg;
}

@end
