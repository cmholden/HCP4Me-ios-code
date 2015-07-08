//
//  SearchViewController.h
//  HCPSalesAid
//
//  Created by cmholden on 02/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetDataObject.h"
#import "AssetRetriever.h"
#import "SeachCollectionView.h"
#import "AssetsCollectionFooterView.h"

@interface SearchViewController : UIViewController <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
