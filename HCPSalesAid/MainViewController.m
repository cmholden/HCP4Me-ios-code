//
//  FirstViewController.m
//  HCPSalesAid
//
//  Created by cmholden on 26/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()


@end

@implementation MainViewController

@synthesize downloadLabel;
@synthesize badge;

NSMutableArray *assetList;
AssetRetriever *assetRet;

AssetsCollectionView *assetsCollectionView;
UIWebView *weeklyFocusView;
//UIWebView *discussionView;

//AssessmentCollectionView *assessmentCollectionView;
AssessmentMainView *assessMainView;
//the user view history
NSMutableDictionary *userViews;
UISegmentedControl *segControl;


- (void)viewDidLoad {
    [super viewDidLoad];
    assetRet = [[AssetRetriever alloc] init];
    assetRet.downloadDelegate = self;
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    userViews = [assetRet loadAssetsFromFile:@USER_VIEWS_PLIST];
    //see which selection we have
    
    int selIndex = (int32_t)[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedTab"];
    if( selIndex != -1){
        NSInteger tab = -1;
        [[NSUserDefaults standardUserDefaults] setInteger:tab forKey:@"selectedTab"];
      
    }
    else{
        selIndex = (int32_t)segControl.selectedSegmentIndex;
    
    }
    
    
    segControl.selectedSegmentIndex = selIndex;
    [segControl sendActionsForControlEvents:UIControlEventValueChanged];

    //[self manageTabSelection : selIndex];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[self clearUserId]; //just for testing
    //[self clearUpdateTime:defaults]; //just for testing
    NSString *sUserId = [defaults objectForKey:@"userId"];
    if( sUserId == nil || [sUserId isEqualToString:@""]){
        [self displayLogonView];
    }
    else{
        [self checkIfUpdateNeeded:defaults];
    }
}
- (void) clearUserId{ //use this to test logging in
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"userId"];
    
    [defaults synchronize];
}
- (void) clearUpdateTime : (NSUserDefaults *)defaults{ //use this to test updates
    
    [defaults setDouble:0 forKey:@"updateTime"];
    
    [defaults synchronize];
}

- (void) checkIfUpdateNeeded : (NSUserDefaults *)defaults{
    NSDate *dt = [[NSDate alloc] init];
    double updateDate = [defaults doubleForKey:@"updateTime"];
    if( dt.timeIntervalSince1970 - updateDate > (24 * 60 * 60)){ //check for day
        [assetRet loadJSONAssetList];
    }
}

- (void) setupNavigationBar {
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.hidden = NO;
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
                    setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                            [Utilities getSAPGold], NSBackgroundColorAttributeName,
                            [UIColor whiteColor],NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor blackColor]];
    //set the mini logo
    /*
    UIImage *image = [UIImage imageNamed:@"logo_sap.png"];
    if( image != nil){
        [self setNavigationBarImage: image];
    }
     */
  //  [navigationBar set
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"22-NavBar-Search.png"]
                                                                    style:UIBarButtonItemStylePlain target:self
                                                                   action:@selector(displaySearchView)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.title = @"HCP4Me";
    
    
   // navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];// [Utilities getSAPGold];
  //  self.navigationController.tabBarController.tabBar.selectedImageTintColor =[Utilities getSAPGold];
   // self.navigationController.tabBarController.tabBar.backgroundColor = [UIColor blackColor];
    
    /*
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont fontWithName:@"Helvetica" size:15],NSFontAttributeName,
                                                          [Utilities getSAPGold],NSForegroundColorAttributeName,
                                                          [Utilities getSAPGold],NSBackgroundColorAttributeName,nil] forState:UIControlStateNormal];
    */
    [self setupTabViews];
    
}

- (void) setupTabViews {
    float std_margin = 2.0f;
    
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"What's New", @"Resources", @"Assessment", nil];
    segControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segControl.frame = CGRectMake(1, 1, self.view.frame.size.width-2, 39);
    [segControl addTarget:self action:@selector(tabSelectionChanged:) forControlEvents: UIControlEventValueChanged];
    segControl.selectedSegmentIndex = 0;
    
    [segControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:14.0],
                                           NSForegroundColorAttributeName:[UIColor blackColor],}
                              forState:UIControlStateNormal];
    [segControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:14.0],
                                         NSForegroundColorAttributeName:[UIColor whiteColor]}
                              forState:UIControlStateSelected];
    
    segControl.tintColor = [Utilities getSAPGold];
    [self.view addSubview:segControl];
    
    //setup the discussion web view
    
    float tabSelEnd = segControl.frame.origin.y + segControl.frame.size.height;
    
    float frameHt = self.tabBarController.tabBar.frame.origin.y - tabSelEnd - 5 - self.navigationController.navigationBar.frame.origin.y -
    self.navigationController.navigationBar.frame.size.height;
    
    weeklyFocusView = [[UIWebView alloc] initWithFrame:CGRectMake(std_margin ,
                                                                 tabSelEnd + std_margin,
                                                                 self.view.frame.size.width-std_margin*2,
                                                                 frameHt )];
    
    weeklyFocusView.delegate = self;
    weeklyFocusView.hidden = YES;
    
    [self.view addSubview:weeklyFocusView];
    
    //setup the sales tools list
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout1 setMinimumInteritemSpacing:2.0f];
    [flowLayout1 setSectionInset:UIEdgeInsetsMake(1, 0, 0, 0)];
    [flowLayout1 setMinimumLineSpacing:1.0f];
    [flowLayout1 setHeaderReferenceSize:CGSizeMake((self.view.frame.size.width - 2), 45)];
    [flowLayout1 setFooterReferenceSize:CGSizeMake((self.view.frame.size.width - 2), 1)];
    
    assetsCollectionView = [[AssetsCollectionView alloc]
                    initWithFrame:CGRectMake(std_margin ,
                                            tabSelEnd + std_margin,
                                            self.view.frame.size.width-std_margin*2,
                                             frameHt )
                                            collectionViewLayout:flowLayout1];
    [assetsCollectionView setup];
    [assetsCollectionView registerClass:[AssetCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [assetsCollectionView registerClass:[AssetsCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader"];
    [assetsCollectionView registerClass:[AssetsCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SectionFooter"];
    assetsCollectionView.tabBarController = self.tabBarController;
    assetsCollectionView.usesFavorites = YES;
    assetsCollectionView.backgroundColor = [Utilities getLightGray];
    assetsCollectionView.hidden = YES;
    [self.view addSubview:assetsCollectionView];
    
  
    assessMainView = [[AssessmentMainView alloc]
                      initWithFrame:CGRectMake(std_margin ,
                                               tabSelEnd + std_margin,
                                               self.view.frame.size.width-std_margin*2,
                                               frameHt )];
    assessMainView.assessViewDelegate = self;
    [assessMainView setup];
    [self.view addSubview:assessMainView];
    
    //plus add the download label
    downloadLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, 35, 300, 35)];
    downloadLabel.textColor = [UIColor whiteColor];
    downloadLabel.textAlignment = NSTextAlignmentCenter;
    downloadLabel.text = @"";
    downloadLabel.backgroundColor = [UIColor blackColor];
    downloadLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    downloadLabel.alpha = 0.0f;
    [self.view addSubview:downloadLabel];
    
    self.downloadView = [[DownloadView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    [self.downloadView setup];
    self.downloadView.alpha = 0.0f;
    [self.view addSubview:self.downloadView];
    
    
    BadgeStyle *badge4Style = [BadgeStyle freeStyleWithTextColor:[UIColor whiteColor]
                                                  withInsetColor:[UIColor blackColor]
                                                  withFrameColor:[UIColor blackColor]
                                                       withFrame:NO
                                                      withShadow:NO
                                                     withShining:NO
                                                    withFontType:BadgeStyleFontTypeHelveticaNeueMedium];
    badge = [CustomBadge customBadgeWithString:@"99" withScale:0.8f withStyle:badge4Style];
    UIView *segment = [segControl.subviews objectAtIndex:2];
    
    badge.frame = CGRectMake(segControl.frame.size.width/3- 20,0,  20, 20);
    badge.hidden = YES;
    [segment addSubview:badge];
}

- (void)displaySearchView {
    UIStoryboard*  sb = self.storyboard;
    SearchViewController *searchViewController =
        [sb instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:searchViewController animated:YES];
    
}


- (void)displayLogonView {
    UIStoryboard*  sb = self.storyboard;
    LogonViewController *logonViewController =
        [sb instantiateViewControllerWithIdentifier:@"LogonViewController"];
        
    
    [self.tabBarController presentViewController:logonViewController animated:YES completion:nil];
    
}
- (void)tabSelectionChanged:(id)sender {
    [self manageTabSelection : (int32_t)((UISegmentedControl *)sender).selectedSegmentIndex];
}
-(void) runChangeEffect : (NSString *) type : (UIView *)viewToShow {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    viewToShow.hidden = NO;
    if( [type isEqualToString:@"left"])
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:viewToShow cache:YES];
    else if( [type isEqualToString:@"right"])
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:viewToShow cache:YES];
    else if ([type isEqualToString:@"curlup"])
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:viewToShow cache:YES];
    
    
    [UIView commitAnimations];
    
}
- (void) manageTabSelection : (int) selIndex {
    
    weeklyFocusView.hidden = YES;
    assetsCollectionView.hidden = YES;
    assessMainView.hidden = YES;
    
   // run this to make sure badge updated
    [assessMainView setData : badge];
    
    if( selIndex == 0){ //weekly focus
        NSURL *url = [self getWeeklyFocusURL];
        [weeklyFocusView loadRequest:[NSURLRequest requestWithURL:url]];
    
    }
    else if( selIndex == 1){ //sales tools
   //     if( assetList == nil)
            assetList = [assetRet loadAssetsListFromFile : @SALES_TOOLS];
        [self runChangeEffect:@"right" :assetsCollectionView];
        [assetsCollectionView setData:assetList userViewData:userViews];
        [assetsCollectionView reloadData];
    }
    else if( selIndex == 2){ //forum
        [self runChangeEffect:@"left" :assessMainView];
        [assessMainView reloadData];
      //  [self loadForumFromURL: @DISCUSSION_URL];
    }

    
}

- (NSURL *) getWeeklyFocusURL {
    NSString *fileName = [@WEEKLY_FOCUS stringByAppendingPathComponent:@"index.html"];
    [self runChangeEffect:@"right" :weeklyFocusView];
    NSString *path = [assetRet getAssetFilePath: fileName];
    return [NSURL fileURLWithPath:path];
    
}
/*
- (void) loadForumFromURL : (NSString *) forumURL{
    if( discussionView == nil)
        return;
    NSURL *pageURL = [NSURL URLWithString:forumURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:pageURL];
    
    [discussionView loadRequest:requestObj];
}
 */
//**** WEB View delegate  ***

UIActivityIndicatorView* activityIndicator;

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType{
    if( activityIndicator == nil){
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake(self.view.frame.size.width/2 - 25,
                                             self.view.frame.size.height/2 - 25, 50, 50 );
    }
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    return YES;
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if( activityIndicator != nil){
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if( activityIndicator != nil){
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    }
}

//================== DownloadDelegate Methods ================= //


 - (void) setNumberOfDownloads : (int) numDownloads downloadSize : (int) filesSize{

     if( numDownloads == 0){ //do nothing
        // [self alertUserNoDownloads];
     }
     else{
         //prepare the download view
         [self.downloadView setDownloadSizeLabelText:[[Utilities getSizeAsDiskSize:filesSize] stringByAppendingString:@" available"]];
         NSString *msg = [NSString stringWithFormat:@"%d", numDownloads];
         msg = [msg stringByAppendingString:@" updates are available.\nA total size of: "];
         msg = [msg stringByAppendingString:[Utilities getSizeAsDiskSize:filesSize]];
         msg = [msg stringByAppendingString:@"\nDo you want to download them?"];
         [self alertUserDownload : msg];
     }
 
 }
- (void) downloadStatus : (float) fractionCompleted{
    [self.downloadView updateBarWidth : fractionCompleted];
}
 -(void) fileDownloaded : (NSString *)fileName{
     [self.downloadView setFileNameText:[@"Downloading : " stringByAppendingString:fileName]];
 }

- (void) downloadCompleted : (BOOL) completed{
    if( completed){
        [assetRet updateOnlineUserViews];
        //  [assetRet updateOnlineAssessmentStatus];
    }
}
- (void) synchronizationComplete {
    
    userViews = [assetRet loadAssetsFromFile:@USER_VIEWS_PLIST];
    // run this to make sure badge updated
    [assessMainView setData : badge];
    assetList = [assetRet loadAssetsListFromFile : @SALES_TOOLS];
    [assetsCollectionView setData:assetList userViewData:userViews];
    
    [self animateDownloadViewHide];
    [self animateDownloadLabelShow: @"New Assets Successfully Downloaded"];
    //refresh the app
    
    NSURL *url = [self getWeeklyFocusURL];
    [weeklyFocusView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [assessMainView reloadData];
    [assetsCollectionView reloadData];
    
}

 - (void) alertUserDownload: (NSString *)msg {
 
     UIAlertView *popup = [[UIAlertView alloc]
     initWithTitle:@"Download Assets"
     message:msg
     delegate:nil
     cancelButtonTitle:@"Cancel"
     otherButtonTitles:@"Download", nil];
     popup.delegate = self;
     [popup show];
 }
 
 - (void) alertUserNoDownloads {
 
     UIAlertView *popup = [[UIAlertView alloc]
     initWithTitle:@"Download Assets"
     message:@"Your assets are up to date!"
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles: nil];
     [popup show];
 }
 
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
     if( buttonIndex == 1){
         [self animateDownloadViewShow];
         [assetRet addResignNotification];
         [assetRet downloadAsset];
     }
     alertView.delegate = nil;
     [alertView dismissWithClickedButtonIndex:0 animated:YES];
 
 }

-(void) animateDownloadLabelShow : (NSString *)titleText {
    downloadLabel.text = titleText;
    
    [UIView animateWithDuration:0.6f
                     animations:^{
                         [downloadLabel setAlpha: 0.6f];
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self performSelector:@selector(animateDownloadLabelHide) withObject:nil afterDelay:2.0f];
                         
                     }];
}
-(void) animateDownloadLabelHide {
    [UIView animateWithDuration:0.6f
                     animations:^{
                         [self.downloadLabel setAlpha: 0.0f];
                     }
                     completion:nil];
}

-(void) animateDownloadViewShow  {
    [UIView animateWithDuration:0.6f
                     animations:^{
                         [self.downloadView setAlpha: 0.75f];
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
}
-(void) animateDownloadViewHide {
    [UIView animateWithDuration:0.6f
                     animations:^{
                         [self.downloadView setAlpha: 0.0f];
                     }
                     completion:nil];
}


//============== AssessmentViewDelegate Methods ============//
- (void) assessmentSelected : (AssessmentDataObject *) assessDataObject  assessmentObject : (NSMutableArray *)assessmentArray{

    [self displayResponseView : assessDataObject assessmentObject:assessmentArray];
}

- (void)displayResponseView : (AssessmentDataObject *) assessDataObject  assessmentObject : (NSMutableArray *)assessmentArray{
    
    UIStoryboard*  sb = self.storyboard;
    ResponseViewController *responseViewController =
            [sb instantiateViewControllerWithIdentifier:@"ResponseViewController"];

    [responseViewController setAssessmentDataObject:assessDataObject];
    responseViewController.updateSaver = assetRet;
    responseViewController.assessmentArray = assessmentArray;
    //responseViewController.assessmentSaver = assetRet;
    [self.navigationController pushViewController:responseViewController animated:YES];
    
}
@end
