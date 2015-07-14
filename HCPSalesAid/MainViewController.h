//
//  FirstViewController.h
//  HCPSalesAid
//
//  Created by cmholden on 26/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssessmentViewDelegate.h"
#import "AssetCell.h"
#import "AssetRetriever.h"
#import "AssetsCollectionView.h"
#import "AssetsCollectionHeaderView.h"
#import "AssetsCollectionFooterView.h"
#import "AssessmentMainView.h"
#import "CustomBadge.h"
#import "DownloadDelegate.h"
#import "DownloadView.h"
#import "LogonViewController.h"
#import "ResponseViewController.h"
#import "SearchViewController.h"
#import "Utilities.h"

@interface MainViewController : UIViewController<UIWebViewDelegate, DownloadDelegate, AssessmentViewDelegate>

#define SALES_TOOLS "Sales Tool"
//#define WEEKLY_FOCUS "Training Tool"
#define DISCUSSION_URL "http://www.google.com"

@property (strong, nonatomic) UILabel *downloadLabel;
@property (strong, nonatomic) DownloadView *downloadView;
@property (strong, nonatomic) CustomBadge *badge;

@end

