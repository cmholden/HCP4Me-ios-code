//
//  MenuViewController.m
//  HCPSalesAid
//
//  Created by cmholden on 04/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize subject;
@synthesize emailAddress;
@synthesize messageBody;
@synthesize name2;
@synthesize name1;
@synthesize userId;
@synthesize nameLab;
@synthesize downloadView;

UITableView *optionsTable;
NSArray *sectionValues;
NSMutableDictionary *sourceData;

AssetRetriever *assetUpdater;
UILabel *downloadStatus;

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.name1 = [defaults objectForKey:@"name1"];
    self.name2 = [defaults objectForKey:@"name2"];
    self.name1 = [self.name1 stringByAppendingString:@" "];
    self.userId = [defaults objectForKey:@"userId"];
    
    nameLab = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-280)/2, 15,280,30)];// (self.view.frame.size.width-120)/2, 120)];
    nameLab.textColor = [UIColor blackColor];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = [self.name1 stringByAppendingString:self.name2];
    nameLab.font = [UIFont fontWithName:@"Arial-BoldMT" size:22];
    [self.view addSubview:nameLab];
    
    optionsTable = [[UITableView alloc]init];
    optionsTable.delegate = self;
    optionsTable.dataSource = self;
    [optionsTable setTableHeaderView:nil];
    optionsTable.frame = CGRectMake(8, 60, self.view.frame.size.width-16, 347);

    [self createData];
    
 //   [optionsTable.layer setBorderColor:[UIColor colorWithRed:0.929f green:0.937f blue:0.937f alpha:1.0f].CGColor];
  //  [optionsTable.layer setBorderWidth:1.0f];
    
    [self.view addSubview:optionsTable];
    
    
    downloadStatus = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, 65, 300, 35)];
    downloadStatus.textColor = [UIColor whiteColor];
    downloadStatus.textAlignment = NSTextAlignmentCenter;
    downloadStatus.text = @"";
    downloadStatus.backgroundColor = [UIColor blackColor];
    downloadStatus.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    downloadStatus.alpha = 0.0f;
    [self.view addSubview:downloadStatus];
    
    
    self.downloadView = [[DownloadView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    [self.downloadView setup];
    self.downloadView.alpha = 0.0f;
    [self.view addSubview:self.downloadView];
}

-(void) createData {
    sourceData = [[NSMutableDictionary alloc] initWithCapacity:5];
    NSArray *section1 = [NSArray arrayWithObjects:@"Resources", @"Assessment", nil];
    [sourceData setObject:section1 forKey:@"0"];
    
    NSArray *section2 = [NSArray arrayWithObjects:@"Profile Settings", @"Check for Update/Sync Device", nil];
    [sourceData setObject:section2 forKey:@"1"];
    
    NSArray *section3 = [NSArray arrayWithObjects:@"E-mail", nil];
    [sourceData setObject:section3 forKey:@"2"];
    
    
    sectionValues = [NSArray arrayWithObjects:@"RESOURCES", @"SETTINGS", @"REPORT A PROBLEM", nil];
    
}

-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    int selIndex = (int32_t)[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedTab"];
    if( selIndex != -1){
        self.tabBarController.selectedIndex = 0;
        
    }
    else{
        [optionsTable reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//========== Table View Delegates ============//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return [sectionValues count];
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger totalValues = 0;
    NSArray *rowData = [sourceData objectForKey:[NSString stringWithFormat:@"%d",(int)section]];
    if( rowData != nil )
        totalValues = [rowData count];
    return totalValues;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"i";
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 16)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 16)];
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    NSString *string =[sectionValues objectAtIndex:section];
    label.textColor = [UIColor whiteColor];
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[Utilities getSAPGold]];
    return view;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //  NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if( cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:16];

        
    }
    NSArray *rowData = [sourceData objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.section]];
    if( rowData != nil &&  [rowData count] > indexPath.row){
        cell.textLabel.text = [rowData objectAtIndex:indexPath.row];
    }
    else{
        cell.textLabel.text = @"";
    }
    
    
    
    
    return cell;
}


 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     NSString *value = cell.textLabel.text;
     
    if( [value isEqualToString:@"Resources"]){
        [self goHomeTab : 1];
    }
    else if( [value isEqualToString:@"Assessment"]){
        [self goHomeTab : 2];
    }
    else if( [value isEqualToString:@"Profile Settings"]){
        [self displayProfileView];
    }
    
    else if( [value isEqualToString:@"E-mail"]){
        emailAddress = @SUPPORT_EMAIL;
        subject = @"Help Needed";
        [self sendEmail];
    }
     
    else if ([value isEqualToString:@"Check for Update/Sync Device"]){
        if( assetUpdater == nil){
            [self createAssetUpdater];
        }
        [self animateDownloadLabelShow : @"Checking Status"];
        [assetUpdater updateOnlineUserViews];
     //   [assetUpdater updateOnlineAssessmentStatus];
        [assetUpdater loadJSONAssetList];
    }
    
}

- (void) createAssetUpdater {
    assetUpdater = [[AssetRetriever alloc]init];
    assetUpdater.downloadDelegate = self;
    
}

- (void) goHomeTab : (int)tab{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:tab forKey:@"selectedTab"];
    [defaults synchronize];
    
    if( self.tabBarController.selectedIndex != 0 ){
        self.tabBarController.selectedIndex = 0;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)displayProfileView {
    //get the assessment data
    
    UIStoryboard*  sb = self.storyboard;
    ProfileViewController *profileViewController =
        [sb instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    if( assetUpdater == nil){
        [self createAssetUpdater];
    }
    profileViewController.assetUpdater = assetUpdater;
    [self.navigationController pushViewController:profileViewController animated:YES];
    
    [profileViewController setName : [self.name1 stringByAppendingString:self.name2] : self.userId];
}

//========== EMail Message =======//
- (void) sendEmail  {
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    if( mailComposer == nil)
        return;
    mailComposer.mailComposeDelegate = self;
    mailComposer.modalPresentationStyle = UIModalPresentationFullScreen;
    
    if (subject != nil)
        [mailComposer setSubject: subject];
    
    
    if (emailAddress != nil && [emailAddress rangeOfString:@"@"].location != NSNotFound)
        [mailComposer setToRecipients:[emailAddress componentsSeparatedByString:@","]];
    
    [mailComposer setMessageBody:messageBody isHTML:NO];
    [mailComposer setSubject:subject];
    mailComposer.delegate = self;
    [self presentViewController:mailComposer animated:YES completion:nil];
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Email Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Email Message sent");
    else
        NSLog(@"Email Message failed");
    
}
//================== DownloadDelegate Methods ================= //

- (void) setNumberOfDownloads : (int) numDownloads downloadSize : (int) filesSize{
    
    if( numDownloads == 0){ //do nothing
         [self alertUserNoDownloads];
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
        [self animateDownloadViewHide];
        [self animateDownloadLabelShow: @"New Assets Successfully Downloaded"];
    }
}

- (void) synchronizationComplete {}

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
    if( assetUpdater == nil)
        assetUpdater = [[AssetRetriever alloc]init];
    if( buttonIndex == 1){
        [self animateDownloadViewShow];
        [assetUpdater addResignNotification];
        [assetUpdater downloadAsset];
    }
    alertView.delegate = nil;
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    
}

-(void) animateDownloadLabelShow : (NSString *)titleText {
    downloadStatus.text = titleText;
    
    [UIView animateWithDuration:0.6f
                     animations:^{
                         [downloadStatus setAlpha: 0.6f];
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self performSelector:@selector(animateDownloadLabelHide) withObject:nil afterDelay:2.0f];
                         
                     }];
}

-(void) animateDownloadLabelHide {
    [UIView animateWithDuration:0.6f
                     animations:^{
                         [downloadStatus setAlpha: 0.0f];
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

@end
