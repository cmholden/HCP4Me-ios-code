//
//  AssetRetriever.m
//  HCPSalesAid
//
//  Created by cmholden on 26/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "AssetRetriever.h"

@implementation AssetRetriever{
    //the stack holding the assets that are to be updated
    NSMutableArray *assetStack;
    //the dictionary that holds the values stored here: file name vs timestamp
    NSMutableDictionary *localAssetValues;
    //the dictionary that holds the Descriptions stored here for search facility: file name vs text
    NSMutableDictionary *localAssetDescs;
    //the dictionary with the details of the assets on the server file name vs AssetDataObject
    NSMutableDictionary *resultValues;
    //the dictionary with the Type ie Sales Tools or Training Tools vs an array of ListStructureObject
    NSMutableDictionary *listStructures;
    
}
@synthesize downloadDelegate;

//===== JSON Asset List LOAD ========//
- (void) loadJSONAssetList{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *assetsURL = [[defaults objectForKey:@"baseurl"] stringByAppendingString:@"/DataManagementServlet?type=selectAssets"];
    NSURL *url = [NSURL URLWithString:assetsURL];
    
    dispatch_async(kBgQueue, ^{
        
        [self performSelectorOnMainThread:@selector(handleAssetListJSONCall:)
                               withObject:[NSData dataWithContentsOfURL: url] waitUntilDone:YES];
    });
    
    
}
- (void)handleAssetListJSONCall:(NSData *)responseData {
    
    if( responseData == nil){
        //   [self stopBusyIndicator];
        NSLog(@"Data nil from loadJSONAssetList");
        return;
    }
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    
    NSArray *results = [json objectForKey:@"results"];
    [self updateAssetDetails:results];
    
    
}

- (void) updateAssetDetails : (NSArray *)results{
    if( resultValues == nil)
        resultValues = [[NSMutableDictionary alloc] initWithCapacity:20];
    NSUInteger total = [results count];
    for( int i=0; i<total;i++){
        NSDictionary *result = [results objectAtIndex:i];
        
        NSString *fileName = [Utilities uRLDecode : [result objectForKey:@"locationURL"]];
        if( fileName == nil)
            fileName = @"";
        
        NSString *category = [result objectForKey:@"category"];
        if( category == nil)
            category = @"";
        
        NSString *assetId = [Utilities uRLDecode : [result objectForKey:@"assetId"]];
        if( assetId == nil)
            assetId = @"";
        
        NSString *assetType = [Utilities uRLDecode : [result objectForKey:@"assetType"]];
        if( assetType == nil)
            assetType = @"";
        
        NSString *description = [Utilities uRLDecode : [result objectForKey:@"description"]];
        if( description == nil)
            description = @"";
        
        
        NSString *format = [Utilities uRLDecode : [result objectForKey:@"format"]];
        if( format == nil)
            format = @"";
        /*
        NSString *version = [Utilities uRLDecode : [result objectForKey:@"version"]];
        if( version == nil)
            version = @"";
        */
        NSString *timestamp = [Utilities uRLDecode : [result objectForKey:@"timestamp"]];
        if( timestamp == nil)
            timestamp = @"";
        double ts = [timestamp doubleValue];
        
        NSString *length = [Utilities uRLDecode : [result objectForKey:@"length"]];
        if( length == nil)
            length = @"";
        int len = [length intValue];
        
        NSString *title = [Utilities uRLDecode : [result objectForKey:@"title"]];
        if( title == nil)
            title = @"";
        
        NSString *trainingType = [Utilities uRLDecode : [result objectForKey:@"training_type"]];
        if( trainingType == nil)
            trainingType = @"";
        
        NSString *topic = [Utilities uRLDecode : [result objectForKey:@"topics"]];
        if( topic == nil)
            topic = @"";
        
        NSString *sizeDesc = [Utilities uRLDecode : [result objectForKey:@"size_desc"]];
        if( sizeDesc == nil)
            sizeDesc = @"";
        
        NSString *internal = [Utilities uRLDecode : [result objectForKey:@"internal"]];
        if( internal == nil)
            internal = @"";
        if( ![internal isEqualToString:@"y"]){
            internal = @"n";
        }
        
        AssetDataObject *dobj = [[AssetDataObject alloc] init];
        dobj.assetId = assetId;
        dobj.assetType = assetType;
        dobj.category = category;
        dobj.desc = description;
        dobj.fileLength = len;
        dobj.fileName = fileName;
        dobj.format = format;
        dobj.tstamp = ts;
        dobj.title = title;
        dobj.trainingType = trainingType;
        dobj.topic = topic;
        dobj.sizeDesc = sizeDesc;
        dobj.internal = internal;
        
        [resultValues setObject:dobj forKey:fileName];
        
    }
    [self writeAssetsToFile:resultValues : @ASSET_PLIST];
    [self loadJSONListStructure];
    
}

//===== JSON  List Structure LOAD ========//
- (void) loadJSONListStructure{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *assetsURL = [[defaults objectForKey:@"baseurl"] stringByAppendingString:@"/DownloadListStructure"];
    NSURL *url = [NSURL URLWithString:assetsURL];
    
    dispatch_async(kBgQueue, ^{
        
        [self performSelectorOnMainThread:@selector(handleListStructureJSONCall:)
                               withObject:[NSData dataWithContentsOfURL: url] waitUntilDone:YES];
    });
    
    
}
- (void)handleListStructureJSONCall:(NSData *)responseData {
    
    if( responseData == nil){
        //   [self stopBusyIndicator];
        NSLog(@"Data nil from loadJSONAssetList");
        return;
    }
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    
    NSArray *results = [json objectForKey:@"results"];
    [self updateListStructureDetails:results];
    
    
}

- (void) updateListStructureDetails : (NSArray *)results{
    if( listStructures == nil)
        listStructures = [[NSMutableDictionary alloc] initWithCapacity:20];
    else
        [listStructures removeAllObjects];
    for( int i=0; i<[results count]; i++){
        NSDictionary *result = [results objectAtIndex:i];
        NSString *trainingType = [result objectForKey:@"trainingType"];
        NSString *category = [result objectForKey:@"category"];
        if( category == nil || trainingType == nil)
            continue; //no data to use
        NSArray *fileList = [result objectForKey:@"fileList"];
        if( fileList == nil)
            fileList = [[NSArray alloc] init];
        NSMutableArray *dobjs = [[NSMutableArray alloc] initWithCapacity:10];
        for( int i=0; i<[fileList count]; i++){
            AssetDataObject *dobj = [resultValues objectForKey:[fileList objectAtIndex:i]];
            if( dobj != nil)
                [dobjs addObject:dobj];
            
        }
        //create the list structure object to store
        ListStructureObject *listObj = [[ListStructureObject alloc] init];
        listObj.category = category;
        listObj.assetDataObjs = dobjs;
        //test if the training type has been created
        NSMutableArray *currentList = [listStructures objectForKey:trainingType];
        if( currentList == nil){ //just add to dictionary
            currentList = [[NSMutableArray alloc] initWithCapacity:10];
            
        }
        [currentList addObject:listObj];
        //and add back to the dictionary
        [listStructures setObject:currentList forKey:trainingType];
    }
    //now write the dictionary
    [self writeAssetsToFile:listStructures : @LIST_STRUCTURE_PLIST];
    
    [self downloadNewAssets];
}

//===== Download Asset Methods  ========//

- (void) downloadNewAssets {
    //get currect device status
    if( localAssetValues == nil)
        localAssetValues = [self loadAssetsFromFile:@LOCAL_ASSET_PLIST];
    //get server status
    if( resultValues == nil)
        resultValues = [self loadAssetsFromFile:@ASSET_PLIST];
    
    assetStack = [[NSMutableArray alloc] init];
    //see what we need to update
    for( NSString *fileName in resultValues){
        if( [localAssetValues objectForKey:fileName] == nil){ //not there so add to stack
            [assetStack addObject:fileName];
        }
        else{
            NSNumber *num = [localAssetValues objectForKey:fileName];
            double localTs = [num doubleValue];
            AssetDataObject *dobj = [resultValues objectForKey:fileName];
            double serverTs = dobj.tstamp;
            if( serverTs > localTs)
                [assetStack addObject:fileName];
        }
    }
    if( downloadDelegate != nil)
        [downloadDelegate setNumberOfDownloads:(int32_t)[assetStack count] ];
        
    /*
    if( [assetStack count] > 0){
        [self downloadAsset];
    }
     */
}

- (void) downloadAsset {
    NSString *fileName = [self retrieveFromStack];
    if( [fileName isEqualToString:@""])
        return; //nothing to download
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *assetsURL = [[defaults objectForKey:@"baseurl"] stringByAppendingString:@"/DownloadDocuments?userId="];
    
    assetsURL = [assetsURL stringByAppendingString:[self getUserId]];
    assetsURL = [assetsURL stringByAppendingString:@"&fileName="];
    assetsURL = [assetsURL stringByAppendingString:[Utilities urlEncodeWithString:fileName] ];
    NSURL *url = [NSURL URLWithString:assetsURL];
    
    dispatch_async(kBgQueue, ^{
        
        [self performSelectorOnMainThread:@selector(handleDownloadCall:)
                               withObject:[NSData dataWithContentsOfURL: url] waitUntilDone:YES];
    });
    
    
}
- (void)handleDownloadCall:(NSData *)responseData {
    
    if( responseData == nil){
        //   [self stopBusyIndicator];
        NSLog(@"Data nil from handleDownloadCall");
        return;
    }
    NSString *fileName = [self popFromStack];
    if( [fileName isEqualToString:@""])
        return;
    
    BOOL isWeeklyFocus = [[fileName lowercaseString] rangeOfString:@WEEKLY_FOCUS].location != NSNotFound &&
       [[fileName lowercaseString] rangeOfString:@"zip"].location != NSNotFound;
    
    NSString *path = [self getAssetFilePath : fileName];
    [responseData writeToFile:path atomically:YES];
    
    //update the downloaded values
    if( localAssetValues == nil)
        localAssetValues = [self loadAssetsFromFile:@LOCAL_ASSET_PLIST];
    if( resultValues == nil)
        resultValues = [self loadAssetsFromFile:@ASSET_PLIST];
    if( localAssetDescs == nil)
        localAssetDescs = [self loadAssetsFromFile:@LOCAL_DESC_PLIST];
    //update the details of downloads and store in dictionary
    double ts = -1;
    AssetDataObject *dobj = [resultValues objectForKey:fileName];
    if( dobj != nil){
        ts = dobj.tstamp;
        NSNumber *tsObject = [[NSNumber alloc] initWithDouble:ts];
        [localAssetValues setObject:tsObject forKey:fileName];
        if( !isWeeklyFocus){
            NSString *desc = [dobj.title lowercaseString];
            desc = [desc stringByAppendingString:@" "];
            desc = [desc stringByAppendingString:[dobj.trainingType lowercaseString]];
            desc = [desc stringByAppendingString:@" "];
            desc = [desc stringByAppendingString:[dobj.desc lowercaseString]];
            desc = [desc stringByAppendingString:@" "];
            desc = [desc stringByAppendingString:[dobj.assetType lowercaseString]];

            [localAssetDescs setObject:desc forKey:fileName];
        }
    }
    //handle the zip
    if( isWeeklyFocus){
        [self manageWeeklyFocus : path];
    }
    /*
    if( [[dobj.assetType lowercaseString] isEqualToString:@"video"]){
        [self storeMovieImage : fileName];
    }
    */
    //check if there are more to download
    if( [assetStack count] > 0){
        [self downloadAsset];
    }
    else{ //save the local data
        [self writeAssetsToFile:localAssetValues : @LOCAL_ASSET_PLIST];
        [self writeAssetsToFile:localAssetDescs : @LOCAL_DESC_PLIST];
       
    }
}

- (void) manageWeeklyFocus  : (NSString *)path{
    NSString *dirPath = [self getAssetFilePath : @WEEKLY_FOCUS];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL fileExists = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    NSError* error;
    //CREATE DIR IF DOESN'T EXIST
    if( !fileExists){
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    else{
        for (NSString *file in [fileManager contentsOfDirectoryAtPath:dirPath error:&error]) {
            BOOL success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@%@", dirPath, file] error:&error];
            if (!success || error) {
                // it failed.
            }
        }
    }
    //now unzip files
    [SSZipArchive unzipFileAtPath:path toDestination:dirPath];
    
}
//=========== Update User Views with local data ===================//
- (void) updateUserViews : (NSString *) fileName percentViewed : (double)percent {
    
    NSMutableDictionary *userViews = [self loadAssetsFromFile:@USER_VIEWS_PLIST];
    //see if there is a record of the file
    UserAssetStatus *status = [userViews objectForKey:fileName];
    NSDate *dt = [[NSDate alloc] init];
    double d = dt.timeIntervalSince1970 * 1000;
    if( status == nil){
        status = [[UserAssetStatus alloc]init];
        status.fileName = fileName;
        status.numViews = 1;
        status.percentComplete = percent;
    }
    else{
        int views = status.numViews;
        status.numViews = views + 1;
        double pct = status.percentComplete;
        if( percent > pct)
            status.percentComplete = percent;
    }
    status.tstamp = d;//dt.timeIntervalSince1970;
    [userViews setObject:status forKey:fileName];
    [self writeAssetsToFile:userViews : @USER_VIEWS_PLIST];
}

- (void) updateOnlineUserViews {
    NSMutableDictionary *userViews = [self loadAssetsFromFile:@USER_VIEWS_PLIST];
    NSString *userId = [self getUserId];
    
    NSString *jsonText = @"{\"results\":[";
    int len = (int32_t)[userViews count];
    int count = 0;
    for( NSString *key in userViews){
        UserAssetStatus *status = [userViews objectForKey:key];
        jsonText = [jsonText stringByAppendingString:[status valuesAsJSON]];
        if( count < len - 1)
            jsonText = [jsonText stringByAppendingString:@","];
        count++;
        
    }
    jsonText = [jsonText stringByAppendingString:@"]}"];
    jsonText = [Utilities urlEncodeWithString:jsonText];
    NSData *jsonData = [jsonText dataUsingEncoding:NSUTF8StringEncoding];

    NSString *updateURL = [[[NSUserDefaults standardUserDefaults] objectForKey:@"baseurl"]
                           stringByAppendingString:@"/UpdateUserViews?userId="];
    [updateURL stringByAppendingString:userId];
    NSURL *url = [NSURL URLWithString:updateURL];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [self handleUpdateUserViewJSONCall : data];
    }];
}

- (void)handleUpdateUserViewJSONCall:(NSData *)responseData {
    
    if( responseData == nil){
        //   [self stopBusyIndicator];
        NSLog(@"Data nil from loadJSONAssetList");
        return;
    }
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    
    NSArray *results = [json objectForKey:@"error"];
    if( results != nil){
        NSLog(@"Error updatinn the user view values");
    }
    
    
}
//=========== Store Movie Player Images ===========//
/*
- (void) storeMovieImage:(NSString *)fileName
{
    
    NSString *path = [self getAssetFilePath: fileName];
    NSURL *url = [NSURL fileURLWithPath:path];
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc]
                                           initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerSentImage:)
                                                 name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                               object:player.moviePlayer];
    
    [player.moviePlayer requestThumbnailImagesAtTimes:@[ @1.0f] timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    [player.moviePlayer prepareToPlay];
    [player.moviePlayer play];
    
}

- (void)moviePlayerSentImage:(NSNotification *)imageNotification{
    
    MPMoviePlayerController *player = [imageNotification object];
    
    NSString *fileName = [player.contentURL lastPathComponent];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                                  object:player];
    
    NSDictionary *userInfo = [imageNotification userInfo];
    UIImage *image = [userInfo valueForKey:MPMoviePlayerThumbnailImageKey];
    NSString *dirPath = [self getImageDirectory];
    NSLog(@"D %@", [image description]);
    [UIImagePNGRepresentation(image) writeToFile:[dirPath stringByAppendingPathComponent:
                    [NSString stringWithFormat:@"%@.%@", fileName, @"png"]] options:NSAtomicWrite error:nil];
}

- (NSString *) getImageDirectory{
    
    NSString *dirPath = [self getAssetFilePath : @IMAGE_PATH];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL fileExists = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    NSError* error;
    //CREATE DIR IF DOESN'T EXIST
    if( !fileExists){
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    return dirPath;
}
 */
//=========== Read Write to File Methods ==========//
- (void) writeAssetsToFile : (NSMutableDictionary *)dictToSave : (NSString *) fileName{
    NSString *path = [self getAssetFilePath : fileName];
    //write it back
    NSData *assetData = [NSKeyedArchiver archivedDataWithRootObject:dictToSave];
    //[resultValues writeToFile:path atomically:YES];
    [assetData writeToFile:path atomically:YES];
}

- (void) writeArrayToFile : (NSMutableArray *)arrayToSave : (NSString *) fileName{
    NSString *path = [self getAssetFilePath : fileName];
    //write it back
    NSData *assetData = [NSKeyedArchiver archivedDataWithRootObject:arrayToSave];
    //[resultValues writeToFile:path atomically:YES];
    [assetData writeToFile:path atomically:YES];
}

- (NSMutableDictionary *) loadAssetsFromFile : (NSString *) fileName{
    NSString *path = [self getAssetFilePath : fileName];
    NSMutableDictionary *assetValues = nil;
    NSData *assetData = [NSData dataWithContentsOfFile:path];
    if( assetData != nil)
        assetValues = [NSKeyedUnarchiver unarchiveObjectWithData:assetData];
    
    if( assetValues == nil)
        assetValues = [[NSMutableDictionary alloc] initWithCapacity:20];
    
    return assetValues;
}
//returns an array of list structure objects or nil if there is no values matching
//the list type parameter
- (NSMutableArray *) loadAssetsListFromFile : (NSString *)listType{
    NSString *path = [self getAssetFilePath : @LIST_STRUCTURE_PLIST];
    NSMutableArray *assetList = nil;
    NSMutableDictionary *structureList = nil;
    NSData *assetData = [NSData dataWithContentsOfFile:path];
    if( assetData != nil)
        structureList = [NSKeyedUnarchiver unarchiveObjectWithData:assetData];
    
    if( structureList != nil){
        assetList = [structureList objectForKey:listType];
    }
    else{
        assetList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return assetList;
}

//returns an array of user favorites
- (NSMutableArray *) loadFavoritesFromFile {
    NSString *path = [self getAssetFilePath : @FAVORITES_PLIST];
    NSMutableArray *favList = nil;
    
    NSData *assetData = [NSData dataWithContentsOfFile:path];
    if( assetData != nil)
        favList = [NSKeyedUnarchiver unarchiveObjectWithData:assetData];
    
    if( favList == nil){
        favList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return favList;
}

- (NSString *) getUserId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"userId"];
    if( userId == nil || [userId isEqualToString:@""])
        userId = @"NoUser";
    return userId;
}

- (NSString *) getAssetFilePath : (NSString *) fileName{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:fileName]];
    return path;
}


- (void) addAssetToStack : (NSString *) fileName{
    if( assetStack == nil)
        assetStack = [[NSMutableArray alloc] initWithCapacity:20];
    //update the stack
    if( fileName != nil && ![fileName isEqualToString:@""])
        [assetStack addObject:fileName];
}


- (NSString *) retrieveFromStack{
    
    NSString *fileName = @"";
    if( assetStack != nil && ([assetStack count] > 0 )){
        fileName = [assetStack lastObject];
        
    }
    return fileName;
}
- (NSString *) popFromStack{

    NSString *fileName = @"";
    if( assetStack != nil && ([assetStack count] > 0 )){
        fileName = [assetStack lastObject];
        [assetStack removeLastObject];
        
    }
    return fileName;
}

@end
