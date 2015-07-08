//
//  FirstViewController.h
//  HCPSalesAid
//
//  Created by cmholden on 26/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetCell.h"
#import "AssetRetriever.h"
#import "AssetsCollectionView.h"
#import "AssetsCollectionHeaderView.h"
#import "AssetsCollectionFooterView.h"
#import "SearchViewController.h"
#import "Utilities.h"

@interface MainViewController : UIViewController<UIWebViewDelegate>

#define SALES_TOOLS "Sales Tool"
//#define WEEKLY_FOCUS "Training Tool"
#define DISCUSSION_URL "http://www.google.com"

@property (strong, nonatomic) IBOutlet UISegmentedControl *tabSelector;


@end

