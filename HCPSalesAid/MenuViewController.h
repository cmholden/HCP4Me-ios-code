//
//  MenuViewController.h
//  HCPSalesAid
//
//  Created by cmholden on 04/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetRetriever.h"
#import "DownloadDelegate.h"
#import "DownloadView.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "ProfileViewController.h"
#import "Utilities.h"

#define SUPPORT_EMAIL "support@sap.com"
#define SUGGEST_EMAIL "suggest@sap.com"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate, DownloadDelegate>


@property (strong, nonatomic) DownloadView *downloadView;

@property (strong, nonatomic) NSString *subject;

@property (strong, nonatomic) NSString *messageBody;

@property (strong, nonatomic) NSString *emailAddress;

@property (strong, nonatomic) NSString *name1;

@property (strong, nonatomic) NSString *name2;

@property (strong, nonatomic) UILabel *nameLab;

@property (strong, nonatomic) NSString *userId;

@end
