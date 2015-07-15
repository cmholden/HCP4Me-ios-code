//
//  FavoritesViewController.m
//  HCPSalesAid
//
//  Created by cmholden on 02/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

//the favorite list data
NSMutableArray *favAssetList;
AssetRetriever *favLoader;
//the searchable text
NSMutableDictionary *favDictionary;
//file name vs the asset data object
NSMutableArray *currentFavs;
//the user view history
NSMutableDictionary *userFavViews;

FavoritesCollectionView *favCollectionView;

//edit delete buttons
UIBarButtonItem *rightButton;
UIBarButtonItem *rightButton1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    favLoader = [[AssetRetriever alloc] init];
    
    
    rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self
                                                                   action:@selector(editFavorites:)];
    
    
    rightButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                                                action:@selector(editFavorites:)];
    
    self.navigationController.navigationBar.tintColor = [Utilities getSAPGold];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    [self setupCollectionView];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self buildFavoritesList];
}

-(void) buildFavoritesList{
    
    userFavViews = [favLoader loadAssetsFromFile:@USER_VIEWS_PLIST];
    NSMutableArray *assetList = [favLoader loadAssetsListFromFile : @SALES_TOOLS];
    currentFavs = [favLoader loadFavoritesFromFile];
    favAssetList = [[NSMutableArray alloc] initWithCapacity:10];

    
    for( int i=0; i<[assetList count]; i++){
        ListStructureObject *structureObj = (ListStructureObject *)[assetList objectAtIndex:i];
        if( structureObj != nil){
            NSString *category = @"";
            NSArray *items = structureObj.assetDataObjs;
            NSMutableArray *copyItems = [[NSMutableArray alloc] initWithCapacity:5];
            for(int j=0; j<[items count]; j++){
                AssetDataObject *dobj = [items objectAtIndex:j];
                if( [currentFavs containsObject:dobj.fileName]){
                    category = dobj.category;
                    [copyItems addObject:dobj];
                    //NSLog(@"FOUN %@", dobj.fileName);
                }
            }
            if( [copyItems count] > 0){
                ListStructureObject *copyStructure = [[ListStructureObject alloc]init];
                copyStructure.category = category;
                copyStructure.assetDataObjs = copyItems;
                [favAssetList addObject:copyStructure];
            }
        }
        
    }
    [favCollectionView setData:favAssetList userViewData:userFavViews];
    if( [favAssetList count] == 0)
        [favCollectionView showNoFavorites:YES];
    else
        [favCollectionView showNoFavorites:NO];
    
    [favCollectionView reloadData];
    
}

-(void) editFavorites : (id)sender{
    if( self.navigationItem.rightBarButtonItem == rightButton1){ //restore to normal
        self.navigationItem.rightBarButtonItem = rightButton;
        favCollectionView.isEditing = NO;
    }
    else{ //deleting
        self.navigationItem.rightBarButtonItem = rightButton1;
        favCollectionView.isEditing = YES;
    }
    //recreate the data
    [self buildFavoritesList];
  //  [favCollectionView resetAndReload];
}
- (void) setupCollectionView {
    float std_margin = 1.0f;
    
    float frameHt = self.tabBarController.tabBar.frame.origin.y - 2 - self.navigationController.navigationBar.frame.origin.y -
    self.navigationController.navigationBar.frame.size.height;
    //set up the weekly views
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:2.0f];
    [flowLayout setSectionInset:UIEdgeInsetsMake(1, 0, 0, 0)];
    [flowLayout setMinimumLineSpacing:1.0f];
    [flowLayout setHeaderReferenceSize:CGSizeMake((self.view.frame.size.width - 2), 27)];
    [flowLayout setFooterReferenceSize:CGSizeMake((self.view.frame.size.width - 2), 1)];
    
    favCollectionView = [[FavoritesCollectionView alloc]
                            initWithFrame:CGRectMake(std_margin ,
                                                     std_margin,
                                                     self.view.frame.size.width-std_margin*2,
                                                     frameHt )
                            collectionViewLayout:flowLayout];
    [favCollectionView setup];
    [favCollectionView registerClass:[AssetCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [favCollectionView registerClass:[FavoritesCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader"];
    [favCollectionView registerClass:[AssetsCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SectionFooter"];
    favCollectionView.usesFavorites = NO;
    favCollectionView.tabBarController = self.tabBarController;
    
    favCollectionView.backgroundColor = [Utilities getLightGray];
    
    [self.view addSubview:favCollectionView];
}

@end