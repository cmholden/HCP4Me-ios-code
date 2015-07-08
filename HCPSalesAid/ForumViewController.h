//
//  SecondViewController.h
//  HCPSalesAid
//
//  Created by cmholden on 26/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AssetRetriever.h"
#import "DownloadDelegate.h"

@interface ForumViewController : UIViewController <UIAlertViewDelegate, DownloadDelegate>

@property (strong, nonatomic) IBOutlet UIButton *updateButton;


@end

