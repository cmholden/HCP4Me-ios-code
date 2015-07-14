//
//  AssessmentMainView.m
//  HCPSalesAid
//
//  Created by cmholden on 10/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "AssessmentMainView.h"

@implementation AssessmentMainView

@synthesize titleLab;
@synthesize outstandingNum;
@synthesize outstanding;
@synthesize completedNum;
@synthesize completed;
@synthesize assessmentCollectionView;
@synthesize assessViewDelegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // NSLog(@"INIT");
    }
    return self;
}

- (void) setup{
    
    float std_margin = 2.0f;
    float leftIndent = 8.0f;
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x + leftIndent,
                                                               2.0f,
                                                               140,
                                                               16)];
    self.titleLab.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLab.font = [Utilities getBoldFont:13];
    self.titleLab.textColor = [Utilities getDarkGray];
    self.titleLab.text = @"YOUR PROGRESS";
    [self addSubview:self.titleLab];
    
    self.outstandingNum = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.3f - 50/2,
                                                              self.titleLab.frame.origin.y + self.titleLab.frame.size.height ,
                                                              50,
                                                              17)];
    self.outstandingNum.font = [Utilities getBoldFont:14 ];
    self.outstandingNum.textAlignment = NSTextAlignmentCenter;
    self.outstandingNum.textColor = [UIColor blackColor];
    self.outstandingNum.text = @"0";
    [self addSubview:self.outstandingNum];
    
    self.completedNum = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.7f - 50/2,
                                                                    self.titleLab.frame.origin.y + self.titleLab.frame.size.height,
                                                                    50,
                                                                    17)];
    self.completedNum.font = [Utilities getBoldFont:14 ];
    self.completedNum.textAlignment = NSTextAlignmentCenter;
    self.completedNum.textColor = [UIColor blackColor];
    self.completedNum.text = @"0";
    [self addSubview:self.completedNum];
    
    self.outstanding = [[UILabel alloc] initWithFrame:CGRectMake(
                                            self.outstandingNum.frame.origin.x + self.outstandingNum.frame.size.width/2 - 120/2,
                                             self.outstandingNum.frame.origin.y + self.outstandingNum.frame.size.height,
                                                120,
                                                18)];
    self.outstanding.font = [Utilities getFont:13 ];
    self.outstanding.textAlignment = NSTextAlignmentCenter;
    self.outstanding.textColor = [Utilities getDarkGray];
    self.outstanding.text = @"OUTSTANDING";
    [self addSubview:self.outstanding];
    
    self.completed = [[UILabel alloc] initWithFrame:CGRectMake(
                                     self.completedNum.frame.origin.x + self.completedNum.frame.size.width/2 - 120/2,
                                     self.completedNum.frame.origin.y + self.completedNum.frame.size.height,
                                     120,
                                     18)];
    self.completed.font = [Utilities getFont:13 ];
    self.completed.textAlignment = NSTextAlignmentCenter;
    self.completed.textColor = [Utilities getDarkGray];
    self.completed.text = @"COMPLETED";
    [self addSubview:self.completed];
    
    //setup the sales tools list
    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout2 setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout2 setMinimumInteritemSpacing:2.0f];
    [flowLayout2 setSectionInset:UIEdgeInsetsMake(1, 0, 0, 0)];
    [flowLayout2 setMinimumLineSpacing:1.0f];
    [flowLayout2 setHeaderReferenceSize:CGSizeMake((self.frame.size.width - 2), 25)];
    [flowLayout2 setFooterReferenceSize:CGSizeMake((self.frame.size.width - 2), 1)];

    assessmentCollectionView = [[AssessmentCollectionView alloc]
                                initWithFrame:CGRectMake(std_margin ,
                                                self.outstanding.frame.origin.y + self.outstanding.frame.size.height + 2.0f,
                                                 self.frame.size.width-std_margin*2,
                                                self.frame.size.height - (self.completed.frame.origin.y +self.completed.frame.size.height) )
                                collectionViewLayout:flowLayout2];
    [assessmentCollectionView setup];
    assessmentCollectionView.assessViewDelegate = assessViewDelegate;
    [assessmentCollectionView registerClass:[AssessmentCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [assessmentCollectionView registerClass:[AssetsCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader"];
    [assessmentCollectionView registerClass:[AssetsCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SectionFooter"];
    assessmentCollectionView.backgroundColor = [Utilities getLightGray];
    [self addSubview:assessmentCollectionView];
}

- (void) setData : (CustomBadge *)badge{ //simply pass it on
    NSMutableArray *assessValues = [assessmentCollectionView setData];
    [self extractAssesStatus:assessValues : badge];
}
- (void) extractAssesStatus : (NSMutableArray *) assessValues : (CustomBadge *)badge {
    int totalValues = (int)[assessValues count];
    int completedItems = 0;
    for( int i=0; i<totalValues; i++){
        AssessmentDataObject *dataObj = (AssessmentDataObject *)[assessValues objectAtIndex:i];
        if( dataObj.status == 2)
            completedItems++;
    }
    NSString *assessToDo = [NSString stringWithFormat:@"%d",totalValues-completedItems];
    badge.badgeText = assessToDo;
    badge.hidden = (totalValues-completedItems) == 0;
    [badge setNeedsDisplay];
    self.outstandingNum.text = assessToDo;
    self.completedNum.text = [NSString stringWithFormat:@"%d", completedItems];
    
}

- (void) reloadData{//simply pass it on
    [assessmentCollectionView reloadData];
}
@end
