//
//  SeachCollectionView.m
//  HCPSalesAid
//
//  Created by cmholden on 02/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "SeachCollectionView.h"

@implementation SeachCollectionView


-(void) setData : (NSMutableArray *)assetArray  userViewData : (NSMutableDictionary *)userViews{
    //take a deep copy
    self.baseData = assetArray;
    self.userViewsValues = userViews;
}

//==== Data Source Delegate ===========//
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int numItems = 0;
    if( self.baseData != nil){
        numItems = (int32_t)[self.baseData count];
        
    }
    return numItems;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return [collectionView dequeueReusableSupplementaryViewOfKind:
                kind withReuseIdentifier:@"SectionFooter" forIndexPath:indexPath];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AssetCell *cell = (AssetCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    AssetDataObject *dobj = nil;

    if( [self.baseData count] > indexPath.section){
        dobj = [self.baseData objectAtIndex:indexPath.item];
    }
    if( dobj != nil){
        UserAssetStatus *userViews = [self.userViewsValues objectForKey:dobj.fileName];
        [cell updateCell:dobj userAssetViews:userViews];
    }
   
    return cell;
    
}

@end
