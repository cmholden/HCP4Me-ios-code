//
//  FavoritesCollectionView.m
//  HCPSalesAid
//
//  Created by cmholden on 07/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "FavoritesCollectionView.h"

@implementation FavoritesCollectionView
@synthesize noFavorites;

-(void)setup{
    [super setup];
    noFavorites = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, self.frame.size.width - 40, 80)];
    noFavorites.textAlignment = NSTextAlignmentCenter;
    noFavorites.text = @"There are currently no favorites selected. Please select your favorites in the 'Sales Resources' section of the home page";
    noFavorites.numberOfLines = 0;
    noFavorites.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    noFavorites.textColor = [UIColor blackColor];
    noFavorites.backgroundColor = [UIColor whiteColor];
    [self addSubview:noFavorites];
    
}
- (void) showNoFavorites : (BOOL) show{
    noFavorites.hidden = !show;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int numItems = 0;
    
    if( [self.assetsBySection count] > section){
        ListStructureObject *structureObj = (ListStructureObject *)[self.assetsBySection objectAtIndex:section];
        if( structureObj != nil){
            NSArray *items = structureObj.assetDataObjs;
            if( items != nil)
                numItems = (int32_t)[items count];
        }
        
    }
    return numItems;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if(kind == UICollectionElementKindSectionFooter){
        return [collectionView dequeueReusableSupplementaryViewOfKind:
                UICollectionElementKindSectionFooter withReuseIdentifier:@"SectionFooter" forIndexPath:indexPath];
    }
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
    
    FavoritesCollectionHeaderView *assetHeader = (FavoritesCollectionHeaderView *)headerView;
    
    UILabel *title = (UILabel *)[assetHeader viewWithTag:1001];
    if (!title) {
        //set background only once
        [assetHeader setBackgroundColor:[Utilities getSAPGold]];
        CGRect rect = CGRectInset(assetHeader.bounds, 5, 5);
        //   rect.size.width = rect.size.width/2;
        title = [[UILabel alloc] initWithFrame:rect];
        title.textAlignment = NSTextAlignmentLeft;
        title.tag = 1001;
        title.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        title.textColor = [UIColor whiteColor];
        [assetHeader addSubview:title];
    }
    
    //see if we need to set alt color
    if( (indexPath.section % 2) == 0)
        [assetHeader setBackgroundColor:[Utilities getSAPGold]];
    else
        [assetHeader setBackgroundColor:[Utilities getSAPGoldAlt]];
    
    if( [self.assetsBySection count] > indexPath.section){
        ListStructureObject *structureObj = (ListStructureObject *)[self.assetsBySection objectAtIndex:indexPath.section];
        if( structureObj != nil){
            NSArray *items = structureObj.assetDataObjs;
            if( items != nil && [items count] > 0){
                AssetDataObject *dobj = [items objectAtIndex:0];
                title.text  = dobj.category;
                //          numAssets = [items count];
            }
        }
        
    }
    return headerView;
}

//=================== The AssetsCollectionDelegate ===========//
- (void) manageFavorite : (NSString *)fileName addAsFavorite : (BOOL)addFavorite{
    if( !self.isEditing)
        return;
    //should always be delete
    [self.favoritesList removeObject:fileName];
    [self animateFavoriteLabelShow : NO];
    
    
//    self.assetsBySection = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.baseData]];
    [self removeFromFavoritesList : fileName];
    [self.assetRetriever writeArrayToFile : self.favoritesList : @FAVORITES_PLIST];
    
    
    [self reloadData];
 
}

-(void) removeFromFavoritesList : (NSString *)fileName{
    BOOL found = NO;
    BOOL removeCategory = NO;
    ListStructureObject *structureObj = nil;
    for( int i=0; i<[self.assetsBySection count]; i++){
        structureObj = (ListStructureObject *)[self.assetsBySection objectAtIndex:i];
        NSArray *items = structureObj.assetDataObjs;
        NSMutableArray *newItems = [[NSMutableArray alloc] init];
        for( int j=0; j<[items count]; j++){
            AssetDataObject *dobj = (AssetDataObject *)[items objectAtIndex:j];
            if( ![dobj.fileName isEqualToString:fileName]){
                [newItems addObject:dobj];
            }
            else{
                found = YES;
            }
        }
        if( [newItems count] == 0)
            removeCategory = YES;
        structureObj.assetDataObjs = newItems;
        if(found)
            break;
    }
    if(removeCategory){
        [self.assetsBySection removeObject:structureObj];
    }
    
    if( [self.assetsBySection count] == 0)
        [self showNoFavorites:YES];
    else
        [self showNoFavorites:NO];
}
@end
