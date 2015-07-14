//
//  AssetsCollectionView.m
//  
//
//  Created by cmholden on 28/06/2015.
//
//

#import "AssetsCollectionView.h"

@implementation AssetsCollectionView

@synthesize selectedSection;
@synthesize baseData;
@synthesize tabBarController;
@synthesize userViewsValues;
@synthesize favoritesLabel;
@synthesize usesFavorites;
@synthesize isEditing;
@synthesize assetRetriever;
@synthesize favoritesList;

//each array item represent a section. The array item contains another array of
//dataobjects for the row of the section the index represents
//NSMutableArray *assetsBySection;
@synthesize assetsBySection;


float cellHT = 98.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        selectedSection = -1;
        usesFavorites = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        selectedSection = -1;
    }
    return self;
}

-(void)setup{
    assetRetriever = [[AssetRetriever alloc] init];
    self.delegate = self;
    self.dataSource = self;
    
    favoritesLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, self.frame.size.height-60, self.frame.size.width-100, 25)];
    favoritesLabel.backgroundColor = [UIColor blackColor];
    favoritesLabel.textColor = [UIColor whiteColor];
    favoritesLabel.textAlignment = NSTextAlignmentCenter;
    [self.favoritesLabel setAlpha: 0.0f];
    [self addSubview:favoritesLabel];
    
}
-(void) setData : (NSMutableArray *)assetArray userViewData : (NSMutableDictionary *)userViews{
    //take a deep copy
    baseData = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:assetArray]];

    assetsBySection = assetArray;
    //store the user view inof
    userViewsValues = userViews;
    
    //refresh the favorites list
    favoritesList = [assetRetriever loadFavoritesFromFile];
}
- (NSMutableArray *) getDeepDataCopy{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:baseData]];
}
//==== Data Source Delegate ===========//
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    int numSections = 0;
    if(assetsBySection != nil)
        numSections = (int32_t)[assetsBySection count];
    //NSLog(@"NUM SEC %d",numSections);
    return numSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int numItems = 0;
    if( section != selectedSection)
        return 0;
    if( [assetsBySection count] > section){
        ListStructureObject *structureObj = (ListStructureObject *)[assetsBySection objectAtIndex:section];
        if( structureObj != nil){
            NSArray *items = structureObj.assetDataObjs;
            if( items != nil)
                numItems = (int32_t)[items count];
        }
        
    }
    return numItems;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AssetCell *cell = (AssetCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    AssetDataObject *dobj = nil;
    
    if( [assetsBySection count] > indexPath.section){
        ListStructureObject *structureObj = (ListStructureObject *)[assetsBySection objectAtIndex:indexPath.section];
        if( structureObj != nil){
            NSArray *items = structureObj.assetDataObjs;
            if( items != nil && [items count] > indexPath.item){
                dobj = [items objectAtIndex:indexPath.item];
            }
        }
       
    }
    if( dobj != nil){
        if( isEditing){
            cell.isEditing = YES;
            cell.usesFavorites = NO;
        }
        else{
            cell.isEditing = NO;
            cell.usesFavorites = usesFavorites;
        }
        cell.favsList = favoritesList;
        cell.assetsCollectionDelegate = self;
        UserAssetStatus *userViews = [userViewsValues objectForKey:dobj.fileName];
        [cell updateCell:dobj userAssetViews:userViews];
    }
    //NSLog(@" item %d section %d file %@ type %@ ",indexPath.item, indexPath.section, dobj.fileName, dobj.assetType);
    return cell;
    
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
    
    /*
    UILabel *assets = (UILabel *)[headerView viewWithTag:1002];
    if (!assets) {
        CGRect rect = CGRectInset(headerView.bounds, 5, 5);
        rect.origin.x =rect.size.width/2;
        rect.size.width = rect.size.width/2;
        assets = [[UILabel alloc] initWithFrame:rect];
        assets.textAlignment = NSTextAlignmentRight;
        assets.tag = 1002;
        assets.font = [UIFont fontWithName:@"Arial" size:12];
        assets.textColor = [UIColor darkGrayColor];
        [headerView addSubview:assets];
    } */
    ListToggleButton *toggleButton = (ListToggleButton *)[assetHeader viewWithTag:1003];
    if (!toggleButton) {
        CGRect rect = CGRectInset(headerView.bounds, 5, 5);
        toggleButton = [[ListToggleButton alloc] initWithFrame:rect];
        toggleButton.tag = 1003;
        toggleButton.backgroundColor = [UIColor clearColor];
        toggleButton.headerView = assetHeader;
        [toggleButton addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
        
        assetHeader.buttonImage.frame = CGRectMake(toggleButton.frame.size.width-35, toggleButton.frame.size.height/2 - 25/2, 25, 25);
        [toggleButton addSubview:assetHeader.buttonImage];
        
        [assetHeader addSubview:toggleButton];
    }
    //see if we need to set alt color
    if( (indexPath.section % 2) == 0)
        [assetHeader setBackgroundColor:[Utilities getSAPGold]];
    else
        [assetHeader setBackgroundColor:[Utilities getSAPGoldAlt]];
    
    [assetHeader setArrowImage:(indexPath.section == selectedSection)];
    toggleButton.sectionNum = (int32_t)indexPath.section;

    
 //    int numAssets = 0;
     if( [assetsBySection count] > indexPath.section){
        ListStructureObject *structureObj = (ListStructureObject *)[assetsBySection objectAtIndex:indexPath.section];
        if( structureObj != nil){
            title.text  = structureObj.category;
        }
        
    }  
  //  assets.text = [NSString stringWithFormat:@"%d Assets", numAssets];
    
   // NSLog(@"Header title %@   desc %@  ", title.text, [headerView description]);
    return headerView;
}
AssetsCollectionHeaderView *currentHeader;

- (void)headerAction:(UICollectionReusableView *)sender {
    
    ListToggleButton *button = (ListToggleButton *)sender;
    if( button == nil){
        return ;
    }
    AssetsCollectionHeaderView *headerView = button.headerView;
    if( headerView != nil){
        //toggle selected status
        headerView.isSelected = !headerView.isSelected;
        BOOL selectedStatus = headerView.isSelected;
        if( selectedStatus){
            selectedSection = button.sectionNum;
        }
        else{
            selectedSection = -1;
        }
        [headerView setArrowImage:(button.sectionNum == selectedSection)];
    }
    if( currentHeader != nil && ![currentHeader isEqual:headerView]){
        [currentHeader setArrowImage:NO];
    }
    currentHeader = headerView;
    
    //get a deep copy of the original data
    NSMutableArray *newData = [self getDeepDataCopy];
    int numRows = 0;
  //  if( selectedSection == -1) { // all data needs to be removed
        for( int i=0; i<[newData count]; i++){
            ListStructureObject *structureObj = (ListStructureObject *)[newData objectAtIndex:i];
            structureObj.assetDataObjs = [[NSMutableArray alloc] init];
            [newData setObject:structureObj atIndexedSubscript:i];
        }
        assetsBySection = newData;
        int visSection = -1;
        for( int j=0; j<[self numberOfSections]; j++){
            int numItems = (int32_t)[self numberOfItemsInSection:j];
            if( numItems > 0){
                numRows += numItems;
                visSection = j;
                break;
            }
        }
        NSMutableArray *newRows = [[NSMutableArray alloc] initWithCapacity:numRows];
        for( int i=0; i<numRows; i++){
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:i inSection:visSection];
            [newRows addObject:indexPath];
        }
    
    if( numRows > 0 ){

        [self performBatchUpdates:^{
            [self deleteItemsAtIndexPaths:newRows];
            
                }
               completion:^(BOOL finished) {
                   [self completeHeaderTap];
                   
               }];
    }
    else{
        [self completeHeaderTap];
    }
}
- (void) completeHeaderTap {
    if( selectedSection == -1)
        return;
    
    NSMutableArray *newData = [self getDeepDataCopy];
    int numRows = 0;
    for( int i=0; i<[newData count]; i++){
        
        ListStructureObject *structureObj = (ListStructureObject *)[newData objectAtIndex:i];
        if( i != selectedSection){
            structureObj.assetDataObjs = [[NSMutableArray alloc] init];
            [newData setObject:structureObj atIndexedSubscript:i];
        }
        else{
            numRows = (int32_t)[structureObj.assetDataObjs count];
        }
        
    }
    NSMutableArray *newRows = [[NSMutableArray alloc] initWithCapacity:numRows];
    for( int i=0; i<numRows; i++){
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:i inSection:selectedSection];
        [newRows addObject:indexPath];
    }
    assetsBySection = newData;
    
    [self performBatchUpdates:^{
        [self insertItemsAtIndexPaths:newRows];
        }
           completion:nil
     ];

    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.frame.size.width - 12), cellHT);
}

//====== Collection View Delegate =========//

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AssetsCollectionView *assetsView =   (AssetsCollectionView *)collectionView;
    if( assetsView != nil){
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        AssetCell *assetCell = nil;
        if( cell != nil && [cell isKindOfClass:AssetCell.class] ){
            assetCell = (AssetCell *)cell;
        }
        if( assetCell == nil){
            return; //cannot continue here
        }
        else{ //load the asset
            AssetDataObject *assetData = assetCell.assetDataObject;
            
            NSString *type = assetData.assetType;
            if( [[type lowercaseString] isEqualToString:@"video"]){//open video play
                [self playMovie:assetData.fileName];
            }
            else if( [[type lowercaseString] isEqualToString:@"pdf"]){//open pdf player
                [self viewPDFReader:assetData.fileName];
            }
            else if( [[type lowercaseString] isEqualToString:@"audio"]){ //open audio player
                [self playMovie:assetData.fileName];
            }
            else if( [[type lowercaseString] isEqualToString:@"other"]){ //try other player
            }
            
        }
    }
}
//=================== The AssetsCollectionDelegate ===========//
- (void) manageFavorite : (NSString *)fileName addAsFavorite : (BOOL)addFavorite{
    BOOL added = YES;
    if( addFavorite){
        if(![favoritesList containsObject:fileName]){
            [favoritesList addObject:fileName];
        }
    }
    else{
        [favoritesList removeObject:fileName];
        added = NO;
    }
    [assetRetriever writeArrayToFile : favoritesList : @FAVORITES_PLIST];
    [self animateFavoriteLabelShow : added];
    
    [self resetAndReload];
}

-(void) resetAndReload{
    //recreate the data
    assetsBySection = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:baseData]];
    
    [self reloadData];
    
}

-(void) animateFavoriteLabelShow : (BOOL)added {
    if( added)
        self.favoritesLabel.text = @"Added to Favorites";
    else
        self.favoritesLabel.text = @"Removed from Favorites";
    
    CGRect rect = self.favoritesLabel.frame;
    rect.origin.y =  self.contentOffset.y + 5.0f;
    self.favoritesLabel.frame = rect;
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [self.favoritesLabel setAlpha: 0.6f];
                     }
                     completion:^(BOOL finished){
                         [self performSelector:@selector(animateFavoriteLabelHide) withObject:nil afterDelay:2.0f];
                       
                     }];
}
-(void) animateFavoriteLabelHide {
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [self.favoritesLabel setAlpha: 0.0f];
                     }
                     completion:nil];
}

//=================== Movie Player methods ===============/
- (void) playMovie:(NSString *)fileName
{
    
    NSString *path = [assetRetriever getAssetFilePath: fileName];
    NSURL *url = [NSURL fileURLWithPath:path];
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc]
                                           initWithContentURL:url];
  //  CustomMoviePlayerViewController  *player = [[CustomMoviePlayerViewController alloc]
  //                                              initWithContentURL:url];
    // Remove the movie player view controller from the "playback did finish" notification observers
    
    [[NSNotificationCenter defaultCenter] removeObserver:player
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player.moviePlayer];
    
    // Set the modal transition style of your choice
    //   player.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;     // Present the movie player view controller
    [self.tabBarController presentMoviePlayerViewControllerAnimated:player];
    
    // Start playback
    [player.moviePlayer prepareToPlay];
    [player.moviePlayer play];
    
    
}
- (void)moviePlayBackDidFinish:(NSNotification*)aNotification
{
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    // Obtain the reason why the movie playback finished
    
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        //    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:nil];
        MPMoviePlayerController *moviePlayer = [aNotification object];
       //update the user view details
        NSString *fileName = [moviePlayer.contentURL lastPathComponent];
        double d1 = moviePlayer.currentPlaybackTime;
        double d2 = moviePlayer.duration;
        double d3 = d1/d2 * 100;
        [assetRetriever updateUserViews:fileName percentViewed:d3];
        //also save to server if we have a connection
        [assetRetriever updateOnlineUserViews];
        // Remove this class from the observers
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        
        // Dismiss the view controller
        [self.tabBarController dismissMoviePlayerViewControllerAnimated];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:nil];
        //  [moviePlayer.view removeFromSuperview];
    }
    
}

//================ PDF Player Methods ==============//
- (void) viewPDFReader : (NSString *)fileName {
    if( fileName == nil)
        return;// can't handle this
    NSString *path = [assetRetriever getAssetFilePath: fileName];
    ReaderDocument *pdfDoc = [ReaderDocument withDocumentFilePath:path password:nil];
    if( pdfDoc == nil){
        NSLog(@"PDF Doc %@ not found", fileName);
        return;
    }
    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:pdfDoc];
    readerViewController.delegate = self;
    [self.tabBarController presentViewController:readerViewController animated:YES completion:nil];
}

-(void) clearProductList : (AssetsCollectionView *)collection{
    [collection setData:[[NSMutableArray alloc]init] userViewData:[[NSMutableDictionary alloc] init]];
 
    [collection reloadData];
}

//=============== ReaderViewControllerDelegate ==================//
- (void)dismissReaderViewController:(ReaderViewController *)viewController{
    NSLog(@"PDF Reader view dissmissed");
    ReaderDocument *pdfDoc = [viewController getDocument];
    if( pdfDoc != nil){
        double pageNum = (double)pdfDoc.pageNumber.intValue;
        double pageCount = (double)pdfDoc.pageCount.intValue;
        
        double percent = (double)(pageNum / pageCount) * 100;
        NSString *fileName = pdfDoc.fileName;
        [assetRetriever updateUserViews:fileName percentViewed:percent];
        //also save to server if we have a connection
        [assetRetriever updateOnlineUserViews];
    }
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


@end
