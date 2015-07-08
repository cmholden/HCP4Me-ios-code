//
//  AssetCollectionView.m
//  HCPSalesAid
//
//  Created by cmholden on 07/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AssetRetriever.h"
#import "AssetCell.h"
#import "ReaderViewController.h"
#import "AssetsCollectionDelegate.h"
#import "AssetsCollectionHeaderView.h"
#import "AssetsCollectionFooterView.h"
#import "ListToggleButton.h"


@interface AssetsCollectionView : UICollectionView<ReaderViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource,
            AssetsCollectionDelegate>

@property(nonatomic) BOOL selectedSection;
@property(strong,nonatomic) NSMutableArray *baseData;
@property(strong,nonatomic) UILabel *favoritesLabel;
@property(strong,nonatomic) NSMutableDictionary *userViewsValues;
@property(strong,nonatomic) UITabBarController *tabBarController;
@property(strong,nonatomic) NSMutableArray *assetsBySection;
@property(nonatomic) BOOL usesFavorites;
@property(nonatomic) BOOL isEditing;

@property(strong,nonatomic) AssetRetriever *assetRetriever;
//a list of favorites
@property(strong,nonatomic) NSMutableArray *favoritesList;
-(void)setup;

-(void) setData : (NSMutableArray *)assetArray userViewData : (NSMutableDictionary *)userViews;

-(void) resetAndReload;

-(void) animateFavoriteLabelShow : (BOOL)added;

@end

