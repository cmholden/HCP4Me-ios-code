//
//  FavoritesCollectionView.h
//  HCPSalesAid
//
//  Created by cmholden on 07/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "AssetsCollectionView.h"
#import "FavoritesCollectionHeaderView.h"
#import "Utilities.h"

@interface FavoritesCollectionView : AssetsCollectionView

@property (strong, nonatomic) UILabel *noFavorites;

- (void) showNoFavorites : (BOOL) show;

@end
