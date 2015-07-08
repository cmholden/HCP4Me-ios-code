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

NSMutableArray *assetList;
AssetRetriever *assetRet;
//AssetsCollectionView *weeklyCollectionView;
AssetsCollectionView *assetsCollectionView;
UIWebView *weeklyFocusView;
UIWebView *discussionView;
//the user view history
NSMutableDictionary *userViews;
UISegmentedControl *segControl;


- (void)viewDidLoad {
    [super viewDidLoad];
    assetRet = [[AssetRetriever alloc] init];
    //[assetRet updateOnlineUserViews];
    //return;
    //[assetRet loadJSONAssetList];
   // [assetRet loadJSONListStructure];
    //NSMutableDictionary *list = [assetRet loadAssetsFromFile : @LIST_STRUCTURE_PLIST];
    
    //assetList = [assetRet loadAssetsListFromFile];
    //return;
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
        selIndex = segControl.selectedSegmentIndex;
     //   selIndex = 0;
    }
    [self manageTabSelection : selIndex];
  //  }
    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"search_30x30.png"]
                                                                    style:UIBarButtonItemStylePlain target:self
                                                                   action:@selector(displaySearchView)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.title = @"HCP4Me";
   // navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [Utilities getSAPGold];
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
/*
-(void) setNavigationBarImage : (UIImage *) image {
    UIImageView *iv = [[UIImageView alloc] initWithImage: image];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    CGRect rect = CGRectMake(0, 0, 75, 38);
    iv.frame = rect;
    self.navigationItem.titleView = iv;
}
*/
- (void) setupTabViews {
    float std_margin = 5.0f;
    
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"What's New", @"Sales Resources", @"Assessment", nil];
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
    
    //setup the discussion web view
    
    discussionView = [[UIWebView alloc] initWithFrame:CGRectMake(std_margin ,
                                                          tabSelEnd + std_margin,
                                                          self.view.frame.size.width-std_margin*2,
                                                          frameHt )];
    discussionView.delegate = self;
    discussionView.hidden = YES;
    
    [self.view addSubview:discussionView];

}

- (void)displaySearchView {
    UIStoryboard*  sb = self.storyboard;
    SearchViewController *searchViewController =
    [sb instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:searchViewController animated:YES];
    
}

- (void)tabSelectionChanged:(id)sender {
    [self manageTabSelection : ((UISegmentedControl *)sender).selectedSegmentIndex];
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
    discussionView.hidden = YES;
    
   // int selIndex = (int)self.tabSelector.selectedSegmentIndex;
    
    if( selIndex == 0){ //weekly focus
        // @WEEKLY_FOCUS];
        NSString *fileName = [@WEEKLY_FOCUS stringByAppendingPathComponent:@"index.html"];
        [self runChangeEffect:@"right" :weeklyFocusView];
        NSString *path = [assetRet getAssetFilePath: fileName];
        NSURL *url = [NSURL fileURLWithPath:path];
        [weeklyFocusView loadRequest:[NSURLRequest requestWithURL:url]];
    
    }
    else if( selIndex == 1){ //sales tools
   //     if( assetList == nil)
            assetList = [assetRet loadAssetsListFromFile : @SALES_TOOLS];//@SALES_TOOLS
        [self runChangeEffect:@"right" :assetsCollectionView];
        [assetsCollectionView setData:assetList userViewData:userViews];
        [assetsCollectionView reloadData];
    }
    else if( selIndex == 2){ //forum
        [self runChangeEffect:@"left" :discussionView];
        [self loadForumFromURL: @DISCUSSION_URL];
    }

    
}

- (void) loadForumFromURL : (NSString *) forumURL{
    if( discussionView == nil)
        return;
    NSURL *pageURL = [NSURL URLWithString:forumURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:pageURL];
    
    [discussionView loadRequest:requestObj];
}
//**** WEB View delegate  ***/

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

@end
