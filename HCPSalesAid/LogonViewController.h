//
//  LogonViewController.h
//  HCPSalesAid
//
//  Created by cmholden on 08/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadDelegate.h"
#import "Utilities.h"

@interface LogonViewController : UIViewController<UITextFieldDelegate>

#define kBgLoginQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@property (strong, nonatomic)  UILabel *hcpTitle;

@property (strong, nonatomic)  UITextField *userId;

@property (strong, nonatomic)  UITextField *password;


@property (strong, nonatomic)  UIButton *logonButton;

@property (strong, nonatomic)  UIButton *forgotButton;

@property (strong, nonatomic)  UIButton *helpButton;

@property (strong, nonatomic)  UIView *dividerLine;

@property (strong, nonatomic)  UILabel *popupLabel;

- (void)helpClicked:(id)sender;

- (void)logonClicked:(id)sender;

- (void)forgotClicked:(id)sender;

@end
