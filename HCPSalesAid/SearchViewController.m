//
//  SearchViewController.m
//  HCPSalesAid
//
//  Created by cmholden on 02/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "SearchViewController.h"

@implementation SearchViewController

AssetRetriever *assetLoader;
//the searchable text
NSMutableDictionary *searchDictionary;
//file name vs the asset data object
NSMutableDictionary *currentAssets;
//the user view history
NSMutableDictionary *userHistoryViews;

SeachCollectionView *searchCollectionView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    assetLoader = [[AssetRetriever alloc] init];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    searchDictionary = [assetLoader loadAssetsFromFile : @LOCAL_DESC_PLIST];
    currentAssets = [assetLoader loadAssetsFromFile : @ASSET_PLIST];
    [self setupCollectionView];
    
    [self.searchBar setBarTintColor:[Utilities getSAPGold]];// .backgroundColor = [UIColor redColor];
    
}


- (void) setupCollectionView {
    float std_margin = 1.0f;
    float tabSelEnd = self.searchBar.frame.origin.y + self.searchBar.frame.size.height;
    
    float frameHt = self.tabBarController.tabBar.frame.origin.y - 1 - tabSelEnd;
    
    //set up the weekly views
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:2.0f];
    [flowLayout setSectionInset:UIEdgeInsetsMake(1, 0, 0, 0)];
    [flowLayout setMinimumLineSpacing:1.0f];
    [flowLayout setHeaderReferenceSize:CGSizeMake((self.view.frame.size.width - 2), 1)];
    [flowLayout setFooterReferenceSize:CGSizeMake((self.view.frame.size.width - 2), 1)];
    
    searchCollectionView = [[SeachCollectionView alloc]
                            initWithFrame:CGRectMake(std_margin,
                                                     2 +
                                                     self.searchBar.frame.size.height,
                                                     self.view.frame.size.width-std_margin*2,
                                                     frameHt)
                            collectionViewLayout:flowLayout];
    [searchCollectionView setup];
    [searchCollectionView registerClass:[AssetCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [searchCollectionView registerClass:[AssetsCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionFooter"];
    [searchCollectionView registerClass:[AssetsCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SectionFooter"];
    
    searchCollectionView.tabBarController = self.tabBarController;
    
    searchCollectionView.backgroundColor = [Utilities getLightGray];

    [self.view addSubview:searchCollectionView];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    userHistoryViews = [assetLoader loadAssetsFromFile:@USER_VIEWS_PLIST];
}
//****** SEARCH BAR Delegate ****//

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    if( searchBar.text.length > 1)
        [self findAssets:searchBar.text];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if( [searchText length] > 2){
        [self findAssets : searchText];
    }
    else{
        NSMutableArray *emptyData = [[NSMutableArray alloc] init];
        [searchCollectionView setData:emptyData userViewData:[[NSMutableDictionary alloc]init] ];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void) findAssets : (NSString *)searchText{
    if( searchDictionary == nil)
        return;
    NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:10];
    searchText = [searchText lowercaseString];
    for( NSString *file in [searchDictionary allKeys]){
        NSString *value = [searchDictionary objectForKey:file];
        if( [value rangeOfString:searchText].location != NSNotFound){
            AssetDataObject *dobj = [currentAssets objectForKey:file];
            if( dobj != nil)
                [results addObject:dobj];
        }
       
    }
    [searchCollectionView setData:results userViewData:userHistoryViews];
    [searchCollectionView reloadData];
    /*
    [searchCollectionView performBatchUpdates:^{
        [searchCollectionView reloadData];
        }
                   completion:nil]; */
   // [searchCollectionView reloadData];
}
@end
