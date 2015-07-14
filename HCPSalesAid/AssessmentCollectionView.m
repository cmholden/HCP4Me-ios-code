//
//  AssessmentTableView.m
//  HCPSalesAid
//
//  Created by cmholden on 09/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "AssessmentCollectionView.h"

@implementation AssessmentCollectionView

@synthesize assessRetriever;
@synthesize assessViewDelegate;

NSMutableArray *assessmentArray;
NSMutableArray *orderedCategories;
NSMutableDictionary *categories;
NSMutableDictionary *categoryNumbers;

-(NSMutableArray *) setData{
    assessmentArray = [assessRetriever loadAssessmentDataFromFile];
    
    orderedCategories = [assessRetriever loadAssessmentOrdererListFromFile];
    
    categoryNumbers = [[NSMutableDictionary alloc] initWithCapacity:10];
    for( int i=0; i<[orderedCategories count]; i++){
        [categoryNumbers setObject:[orderedCategories objectAtIndex:i] forKey:[NSNumber numberWithInt:i]];
    }
    
    //create a convenience dictionary to test if object already exists
    categories = [[NSMutableDictionary alloc] initWithCapacity:10];
    for( int i=0; i<[assessmentArray count]; i++){
        AssessmentDataObject *dataObj = (AssessmentDataObject *)[assessmentArray objectAtIndex:i];
        NSString *category = dataObj.category;
        NSMutableArray *questions = [categories objectForKey:category];
        if( questions == nil){ //create a new array for the category group
            questions = [[NSMutableArray alloc]initWithCapacity:10];
        }
        [questions addObject:dataObj];
        [categories setObject:questions forKey:category];
    }
    return assessmentArray;
}


-(void)setup{
    assessRetriever = [[AssetRetriever alloc] init];
    self.delegate = self;
    self.dataSource = self;
}

//========== Collection View Delegates ============//
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // Return the number of sections.
    int numSections = 0;
    if( orderedCategories != nil)
        numSections = (int)[orderedCategories count];
        
    return numSections;
}

// Customize the appearance of  view cells.

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AssessmentCollectionViewCell *cell = (AssessmentCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    AssessmentDataObject *dobj = nil;
    
    NSString *category = [categoryNumbers objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    if(category != nil && categories != nil){
        NSMutableArray *items = [categories objectForKey:category];
        if( items != nil && [items count] > indexPath.item){
            dobj = [items objectAtIndex:indexPath.item];
        }
    }
    if( dobj != nil){
        cell.dataObject = dobj;
        [cell updateCell:dobj];
    }
    
    return cell;
    
}
// Customize the number of rows in the collection view
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger totalValues = 0;
    NSString *category = [categoryNumbers objectForKey:[NSNumber numberWithInteger:section]];
    if(category != nil && categories != nil){
        NSMutableArray *items = [categories objectForKey:category];
        totalValues = [items count];
    }
    return totalValues;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if(kind == UICollectionElementKindSectionFooter){
        return [collectionView dequeueReusableSupplementaryViewOfKind:
                UICollectionElementKindSectionFooter withReuseIdentifier:@"SectionFooter" forIndexPath:indexPath];
    }
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
    
    AssetsCollectionHeaderView *assetHeader = (AssetsCollectionHeaderView *)headerView;
    
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
        
    //    int numAssets = 0;
    if( [categoryNumbers count] > indexPath.section){
        NSString *category = [categoryNumbers objectForKey:[NSNumber numberWithInteger:indexPath.section]];
        if( category != nil){
            title.text  = category;
        }
        else{
            title.text  =  @"";
        }
        
    }
    //  assets.text = [NSString stringWithFormat:@"%d Assets", numAssets];
    
    // NSLog(@"Header title %@   desc %@  ", title.text, [headerView description]);
    return headerView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.frame.size.width - 12), 70);
}
//====== Collection View Delegate =========//

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if( assessViewDelegate != nil){
        AssessmentDataObject *dobj = nil;
        NSString *category = [categoryNumbers objectForKey:[NSNumber numberWithInteger:indexPath.section]];
        if(category != nil && categories != nil){
            NSMutableArray *items = [categories objectForKey:category];
            if( items != nil && [items count] > indexPath.item){
                dobj = [items objectAtIndex:indexPath.item];
            }
        }
        if( dobj != nil){
            [assessViewDelegate assessmentSelected:dobj assessmentObject:assessmentArray];

        }
    }
}

@end
