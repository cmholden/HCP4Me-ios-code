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

UITableView *optionsTable;
NSMutableArray *rowValues;

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    scrollView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 1,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height- self.tabBarController.tabBar.frame.size.height);

    */
    //   [self createData:defaults];
    optionsTable = [[UITableView alloc]init];
    optionsTable.delegate = self;
    optionsTable.dataSource = self;
    [optionsTable setTableHeaderView:nil];
    optionsTable.frame = CGRectMake(8, 45, self.view.frame.size.width-16, 307);
 //   [scrollView addSubview:optionsTable];
    [self createData];
    
    [optionsTable.layer setBorderColor:[UIColor colorWithRed:0.929f green:0.937f blue:0.937f alpha:1.0f].CGColor];
    [optionsTable.layer setBorderWidth:2.0f];
    
    [self.view addSubview:optionsTable];//scrollView];
}

-(void) createData {
    
    rowValues = [[NSMutableArray alloc] initWithCapacity:5];
    
    
    [rowValues addObject:@"Modules up to Date"];
    
    [rowValues addObject:@"Training Modules"];
    
    [rowValues addObject:@"Knowledge Check"];
    [rowValues addObject:@"Technical Support"];
    [rowValues addObject:@"Recommendations"];
}

-(void) viewDidAppear:(BOOL)animated{
    [optionsTable reloadData];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//========== Table View Delegates ============//
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger totalValues = 0;
    if( rowValues != nil )
        totalValues = [rowValues count];
    return totalValues;
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
        
        /*
        UIView* accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        UIImageView* accessoryViewImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goto_btn_25x25.png"]];
        accessoryViewImage.center = CGPointMake(25, 12);
        [accessoryView addSubview:accessoryViewImage];
        [cell setAccessoryView:accessoryView];*/
        
    }
    //  cell.textLabel.text = @"";
    
    if( rowValues != nil && [rowValues count] > indexPath.row){
        cell.textLabel.text = [rowValues objectAtIndex:indexPath.row];
        
    }
    
    
    
    
    return cell;
}


 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     NSString *value = cell.textLabel.text;
     
    if( [value isEqualToString:@"Training Modules"]){
        [self goHome];
    }
    else if( [value isEqualToString:@"product_locations"]){
     //   [self showLocation];
    }
    else if( [value isEqualToString:@"searchStore"]){
      //  [self openSearchList];
    }
    
    else if( [value isEqualToString:@"Technical Support"]){
        emailAddress = @SUPPORT_EMAIL;
        subject = @"Help Needed";
        [self sendEmail];
    }
    else if ([value isEqualToString:@"Recommendations"]){
        emailAddress = @SUGGEST_EMAIL;
        subject = @"Application Suggestion";
        [self sendEmail];
    }
    else if ([value isEqualToString:@"terms_url"]){
       // [self openTermsWebPage];
    }
    else if ([value isEqualToString:@"instore_url"]){
       // [self openAboutWebPage];
        
    }
    //  NSLog(@"SEL %@", [sourceDictionary objectForKey:key]);
    
}


- (void) goHome{
    NSInteger tab = 1;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:tab forKey:@"selectedTab"];
    [defaults synchronize];
    
    if( self.tabBarController.selectedIndex != 0 ){
        self.tabBarController.selectedIndex = 0;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
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
@end
