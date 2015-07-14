//
//  LogonViewController.m
//  HCPSalesAid
//
//  Created by cmholden on 08/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "LogonViewController.h"

@implementation LogonViewController

@synthesize hcpTitle;
@synthesize userId;
@synthesize password;
@synthesize dividerLine;
@synthesize logonButton;
@synthesize forgotButton;
@synthesize helpButton;
@synthesize popupLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForm];
    
}

- (void) setupForm {
    //UIFont *fBoldBody = [UIFont fontWithName:@"Arial-BoldMT" size:14];
    
    //   UIFont *fBodySub = [UIFont fontWithName:@"ArialMT" size:14];
   // UIFont *fBody = [UIFont fontWithName:@"ArialMT" size:13];
    float top = 0.0f;
    CGRect rect = CGRectMake((self.view.frame.size.width - 250)/2, 75, 250, 40);
    hcpTitle = [[UILabel alloc] initWithFrame:rect];
    hcpTitle.textAlignment = NSTextAlignmentCenter;
    hcpTitle.textColor = [UIColor whiteColor];
    hcpTitle.text = @"HCP4Me";
    hcpTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:36];
    [self.view addSubview:hcpTitle];
    top += hcpTitle.frame.origin.y + hcpTitle.frame.size.height + 30;
    
    UILabel *empIdText = [[UILabel alloc] initWithFrame:CGRectMake(hcpTitle.frame.origin.x, top, 250, 18)];
    empIdText.textColor = [UIColor whiteColor];
    empIdText.text = @"EMPLOYEE ID";
    empIdText.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    [self.view addSubview:empIdText];
    top += empIdText.frame.size.height + 5;
    
    UIButton *closeKeboard = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, top-50, 70, 48)];
    [closeKeboard setTitle:@"Close Keyboard" forState:UIControlStateNormal];
    closeKeboard.tintColor = [UIColor whiteColor];
    closeKeboard.titleLabel.numberOfLines = 2;
    closeKeboard.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:12];
    //logonButton.backgroundColor = [Utilities getSAPGold];
    [closeKeboard addTarget:self action:@selector(closeKeyClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeKeboard];
    
    userId = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250)/2, top, 250, 18)];
  //  userId.placeholder = @"Enter your employee number";
    userId.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your employee number" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    userId.textColor = [UIColor whiteColor];
  //  userId.backgroundColor = [UIColor lightGrayColor];
    userId.font = [UIFont fontWithName:@"ArialMT" size:16];
    [self.view addSubview:userId];
    top += userId.frame.size.height + 26;
    
    
    
    UILabel *pwdText = [[UILabel alloc] initWithFrame:CGRectMake(hcpTitle.frame.origin.x, top, 250, 18)];
    pwdText.textColor = [UIColor whiteColor];
    pwdText.text = @"PASSWORD";
    pwdText.font = [UIFont fontWithName:@"ArialMT" size:16];
    [self.view addSubview:pwdText];
    top += pwdText.frame.size.height + 5;
    
    password = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250)/2, top, 250, 18)];
    password.secureTextEntry = YES;
    password.textColor = [UIColor whiteColor];
    password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"********" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    password.font = [UIFont fontWithName:@"ArialMT" size:16];
    [self.view addSubview:password];
    top += password.frame.size.height + 26;
    password.delegate = self;
    
    dividerLine = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, top, 300, 1)];
    dividerLine.backgroundColor = [Utilities getSAPGold];
    [self.view addSubview:dividerLine];
    top += dividerLine.frame.size.height + 26;
    
    
    logonButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, top, 300, 35)];
    [logonButton setTitle:@"SIGN IN" forState:UIControlStateNormal];
    logonButton.tintColor = [UIColor whiteColor];
    logonButton.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:16];
    logonButton.backgroundColor = [Utilities getSAPGold];
    [logonButton addTarget:self action:@selector(logonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logonButton];
    
    
    forgotButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, self.view.frame.size.height - 55, 175, 35)];
    [forgotButton setTitle:@"FORGOT PASSWORD?" forState:UIControlStateNormal];
    forgotButton.tintColor = [UIColor whiteColor];
    forgotButton.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:16];
    [forgotButton addTarget:self action:@selector(forgotClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotButton];
    
    helpButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, self.view.frame.size.height - 55, 75, 35)];
    [helpButton setTitle:@"HELP" forState:UIControlStateNormal];
    helpButton.tintColor = [UIColor whiteColor];
    helpButton.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:16];
    [helpButton addTarget:self action:@selector(helpClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:helpButton];
    
    popupLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, 35, 300, 35)];
    popupLabel.textColor = [UIColor whiteColor];
    popupLabel.textAlignment = NSTextAlignmentCenter;
    popupLabel.text = @"";
    popupLabel.backgroundColor = [Utilities getSAPGold];
    popupLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    popupLabel.alpha = 0.0f;
    [self.view addSubview:popupLabel];
    
}

- (void) viewWillAppear:(BOOL)animated{

}

- (void)helpClicked:(id)sender {
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self logonClicked:nil];
    return YES;
}
- (void)logonClicked:(id)sender {
    [self animatePopupLabelShow : @"Logging onto System"];
    [self attemptLogon];
}

- (void) closeKeyClicked:(id)sender {
    [self.view endEditing:YES];
}

- (void) attemptLogon {
    NSString *empId = userId.text;
    if( empId == nil || [empId isEqualToString:@""])
        return;// do nothing
    NSString *pwd = password.text;
    if( pwd == nil)
        pwd = @"";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginURL = [[defaults objectForKey:@"baseurl"] stringByAppendingString:@"/Login?userId="];
    
    loginURL = [loginURL stringByAppendingString:empId];
    loginURL = [loginURL stringByAppendingString:@"&password="];
    loginURL = [loginURL stringByAppendingString:pwd ];
    NSURL *url = [NSURL URLWithString:loginURL];
    
    dispatch_async(kBgLoginQueue, ^{
        
        [self performSelectorOnMainThread:@selector(handleLoginCall:)
                               withObject:[NSData dataWithContentsOfURL: url] waitUntilDone:YES];
    });
    
    
}
- (void)handleLoginCall:(NSData *)responseData {
    
    if( responseData == nil){
        //   [self stopBusyIndicator];
        NSLog(@"Data nil from handleLoginCall");
        return;
    }
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    
    NSString *login = [json objectForKey:@"login"];
    if( login == nil || ![login isEqualToString:@"ok"]){
        popupLabel.alpha = 0.0f;
        [self showLoginFailed];
    }
    else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *sUserId = [json objectForKey:@"userId"];
        NSString *name1 = [json objectForKey:@"name1"];
        if( name1 == nil)
            name1 = @"";
        NSString *name2 = [json objectForKey:@"name2"];
        if( name2 == nil)
            name2 = @"";
        
        [defaults setObject:sUserId forKey:@"userId"];
        [defaults setObject:name1 forKey:@"name1"];
        [defaults setObject:name2 forKey:@"name2"];
        //make sure we check for new downloads
        
        [defaults setDouble:0.0f forKey:@"updateTime"];
        [defaults synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void) showLoginFailed {
    
    UIAlertView *popup = [[UIAlertView alloc]
                          initWithTitle:@"Logon Failed!"
                          message:@"Please try again"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil];
    [popup show];
}

-(void) animatePopupLabelShow : (NSString *)titleText {
        popupLabel.text = titleText;
    
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [popupLabel setAlpha: 0.6f];
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self performSelector:@selector(animatePopupLabelHide) withObject:nil afterDelay:2.0f];
                         
                     }];
}
-(void) animatePopupLabelHide {
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [popupLabel setAlpha: 0.0f];
                     }
                     completion:nil];
}


- (void)forgotClicked:(id)sender {
}

@end
