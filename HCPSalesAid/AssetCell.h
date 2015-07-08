//
//  AssetCell.h
//  HCPSalesAid
//
//  Created by cmholden on 28/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AssetsCollectionDelegate.h"
#import "AssetDataObject.h"
#import "AssetRetriever.h"
#import "UserAssetStatus.h"
#import "Utilities.h"

@interface AssetCell : UICollectionViewCell


@property (strong, nonatomic) id<AssetsCollectionDelegate> assetsCollectionDelegate;

@property (strong, nonatomic) UIImageView *imageView;
//@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *titleText;
@property (strong, nonatomic) UILabel *detailText;
@property (strong, nonatomic) UILabel *userViewText;
@property (strong, nonatomic) UIButton *favoritesButton;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSMutableArray *favsList;

@property (nonatomic) BOOL usesFavorites;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic) BOOL isEditing;

@property (strong, nonatomic) UIImage *favsOnImg;
@property (strong, nonatomic) UIImage *favsOffImg;
@property (strong, nonatomic) UIImage *trashImg;

@property (strong, nonatomic) AssetDataObject *assetDataObject;

-(void) updateCell : (AssetDataObject *)dataObject userAssetViews :  (UserAssetStatus *)userViews;

@end
