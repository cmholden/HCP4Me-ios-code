//
//  MenuViewController.h
//  HCPSalesAid
//
//  Created by cmholden on 04/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

#define SUPPORT_EMAIL "support@sap.com"
#define SUGGEST_EMAIL "suggest@sap.com"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>


@property (strong, nonatomic) NSString *subject;


@property (strong, nonatomic) NSString *messageBody;

@property (strong, nonatomic) NSString *emailAddress;

@end
