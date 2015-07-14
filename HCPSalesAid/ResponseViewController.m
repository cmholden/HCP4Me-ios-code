//
//  ResponseViewController.m
//  HCPSalesAid
//
//  Created by cmholden on 10/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "ResponseViewController.h"

@implementation ResponseViewController

@synthesize categoryTitle;
@synthesize question;
@synthesize nextButton;
@synthesize responseViewCollection;
@synthesize assessDataObject;
@synthesize isMultiSelect;
@synthesize currentSelections;
@synthesize updateSaver;
@synthesize assessmentArray;

- (void) viewDidLoad{
    [super viewDidLoad];
    [self setup];
}
- (void) setup{
    
    float std_margin = 2.0f;
    float leftIndent = 12.0f;
    self.currentSelections = [[NSMutableArray alloc] initWithCapacity:5];
    self.categoryTitle = [[UILabel alloc] initWithFrame:
                          CGRectMake(self.view.frame.origin.x + leftIndent + 5,
                                                              6.0f,
                                                              290,
                                                              18)];
    self.categoryTitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.categoryTitle.font = [Utilities getBoldFont:18];
    self.categoryTitle.textColor = [Utilities getDarkGray];
    [self.view addSubview:self.categoryTitle];
    
    self.question = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + leftIndent,
                                                                 self.categoryTitle.frame.origin.y + self.categoryTitle.frame.size.height,
                                                                 self.view.frame.size.width * 0.9f ,
                                                                    70)];
    self.question.font = [Utilities getFont:18 ];
    self.question.textColor = [UIColor blackColor];
    self.question.text = @"";
    [self.view addSubview:self.question];
    
    
    float frameHt = self.tabBarController.tabBar.frame.origin.y -  self.navigationController.navigationBar.frame.origin.y -
    self.navigationController.navigationBar.frame.size.height;
    //setup the sales tools list
    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout2 setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout2 setMinimumInteritemSpacing:0.0f];
    [flowLayout2 setSectionInset:UIEdgeInsetsMake(1, 0, 0, 0)];
    [flowLayout2 setMinimumLineSpacing:1.0f];
   // [flowLayout2 setHeaderReferenceSize:CGSizeMake((self.view.frame.size.width - 2), 2)];
   // [flowLayout2 setFooterReferenceSize:CGSizeMake((self.view.frame.size.width - 2), 1)];
    
    responseViewCollection = [[UICollectionView alloc]
                                initWithFrame:CGRectMake(std_margin ,
                                                         self.question.frame.origin.y + self.question.frame.size.height + 2.0f,
                                                         self.view.frame.size.width - 4,// - std_margin * 2,
                                                         frameHt - 48  - self.question.frame.origin.y -
                                                         self.question.frame.size.height )
                                collectionViewLayout:flowLayout2];
    responseViewCollection.dataSource = self;
    responseViewCollection.delegate = self;
   // assessmentCollectionView.assessViewDelegate = assessViewDelegate;
    [responseViewCollection registerClass:[ResponseViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];

    responseViewCollection.backgroundColor = [Utilities getLightGray];
    [self.view addSubview:responseViewCollection];
    
    
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                            responseViewCollection.frame.origin.y +
                                                            responseViewCollection.frame.size.height + 1,
                                                            self.view.frame.size.width, 45)];
    [nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    nextButton.tintColor = [UIColor whiteColor];
    nextButton.titleLabel.font = [Utilities getBoldFont:18];
    nextButton.backgroundColor = [Utilities getSAPGold];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];

    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if( self.assessDataObject != nil){
        self.categoryTitle.text = self.assessDataObject.category;
        self.question.text = self.assessDataObject.question;
        if ( self.assessDataObject.userAnswers != nil)
            self.currentSelections = self.assessDataObject.userAnswers;
    }
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
}
- (void) setAssessmentDataObject : (AssessmentDataObject *) assDataObject{
    self.assessDataObject = assDataObject;
    if(self.assessDataObject != nil){
        self.isMultiSelect = [self.assessDataObject.correctAnswer count] > 1;
    }
}

- (void) nextClicked : (id) sender{
    [self displayResponseView];
}

- (void)displayResponseView {// : (AssessmentDataObject *) assessDataObject  assessmentObject : (NSMutableArray *)assessmentArray{
    UIStoryboard*  sb = self.storyboard;
    ResultViewController *resultViewController =
                [sb instantiateViewControllerWithIdentifier:@"ResultViewController"];
    
    resultViewController.assessDataObject = assessDataObject;
    resultViewController.updateSaver = updateSaver;
    resultViewController.assessmentArray = assessmentArray;
    //responseViewController.assessmentSaver = assetRet;
    [self.navigationController pushViewController:resultViewController animated:YES];
    
}
//==== Data Source Delegate ===========//
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int numItems = 0;
    if( self.assessDataObject != nil){
        if(self.assessDataObject.answer1 != nil && ![self.assessDataObject.answer1 isEqualToString:@""])
            numItems++;
        if(self.assessDataObject.answer2 != nil && ![self.assessDataObject.answer2 isEqualToString:@""])
            numItems++;
        if(self.assessDataObject.answer3 != nil && ![self.assessDataObject.answer3 isEqualToString:@""])
            numItems++;
        if(self.assessDataObject.answer4 != nil && ![self.assessDataObject.answer4 isEqualToString:@""])
            numItems++;
        if(self.assessDataObject.answer5 != nil && ![self.assessDataObject.answer5 isEqualToString:@""])
            numItems++;
    
    }
    return numItems;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ResponseViewCell *cell = (ResponseViewCell *)[collectionView
                                                  dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    if( self.assessDataObject != nil){
        [cell updateCell:self.assessDataObject rowIndex:(int)indexPath.row];
        [cell setQuestionSelected:[self.currentSelections containsObject:[NSNumber numberWithInt:(int)indexPath.row]]];
    }
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width - 4), 66);
}

//====== Collection View Delegate =========//

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if( !isMultiSelect){
        [self.currentSelections removeAllObjects];
        [self.currentSelections addObject:[NSNumber numberWithInt:(int)indexPath.row]];
    }
    else{
        //if object is contained remove it else add it
        NSNumber *locateValue = nil;
        for( int i=0; i<[self.currentSelections count]; i++){
            NSNumber *item = (NSNumber *)[self.currentSelections objectAtIndex:i];
            if( [item intValue] == indexPath.row){
                locateValue = item;
                break;
            }
        }
        if( locateValue != nil)
            [self.currentSelections removeObject:locateValue];
        else
            [self.currentSelections addObject:[NSNumber numberWithInt:(int)indexPath.row]];
    }
    self.assessDataObject.userAnswers = self.currentSelections;
    [self.assessDataObject updateStatus : 1];
    
    NSDate *dt = [[NSDate alloc] init];
    self.assessDataObject.tstamp =  dt.timeIntervalSince1970 * 1000;
    //now save it
    if( assessmentArray != nil && updateSaver != nil){
        [updateSaver writeArrayToFile:assessmentArray :@ASSESS_DATA_PLIST];
        //also save to server if we have a connection - DONT NEED THIS HERE
       // [updateSaver updateOnlineUserViews];
    }
    [collectionView reloadData];
    
}
@end
