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
    //the dictionary with the file name key vs the file size
    NSMutableDictionary *fileSizes;
    
}
@synthesize downloadDelegate;
@synthesize downloadSize;

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
        if( [fileName isEqualToString:@""])
            continue;
        
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
    downloadSize = 0;
    //reset file size store
    fileSizes= [[NSMutableDictionary alloc] init];
    //see what we need to update
    for( NSString *fileName in resultValues){
        AssetDataObject *dobj = [resultValues objectForKey:fileName];
        if( [localAssetValues objectForKey:fileName] == nil){ //not there so add to stack
            [assetStack addObject:fileName];
            downloadSize += dobj.fileLength;
            [fileSizes setObject:[NSNumber numberWithInt:dobj.fileLength] forKey:fileName];
        }
        else{
            NSNumber *num = [localAssetValues objectForKey:fileName];
            double localTs = [num doubleValue];
            
            double serverTs = dobj.tstamp;
            if( serverTs > localTs){
                [assetStack addObject:fileName];
                downloadSize += dobj.fileLength;
                [fileSizes setObject:[NSNumber numberWithInt:dobj.fileLength] forKey:fileName];
            }
        }
    }
    if( downloadDelegate != nil)
        [downloadDelegate setNumberOfDownloads:(int32_t)[assetStack count]  downloadSize : downloadSize ];
        
    /*
    if( [assetStack count] > 0){
        [self downloadAsset];
    }
     */
}

NSMutableData *downLoadData;
NSURLConnection *downloadConnection;
NSString *currentFileName;

- (void) downloadAsset {
    downLoadData = nil;
    NSString *fileName = [self retrieveFromStack];
    if( [fileName isEqualToString:@""])
        return; //nothing to download
    currentFileName = fileName;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *assetsURL = [[defaults objectForKey:@"baseurl"] stringByAppendingString:@"/DownloadDocuments?userId="];
    
    assetsURL = [assetsURL stringByAppendingString:[self getUserId]];
    assetsURL = [assetsURL stringByAppendingString:@"&fileName="];
    assetsURL = [assetsURL stringByAppendingString:[Utilities urlEncodeWithString:fileName] ];
    NSURL *url = [NSURL URLWithString:assetsURL];
    
    //inform listeners there is a new file
    [downloadDelegate fileDownloaded:fileName];
    /*
    dispatch_async(kBgQueue, ^{
        
        [self performSelectorOnMainThread:@selector(handleDownloadCall:)
                               withObject:[NSData dataWithContentsOfURL: url] waitUntilDone:YES];
    });
    
    
        }
        */
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    downloadConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; //notice how delegate set to self object
}

//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    
    if (downLoadData==nil) { downLoadData = [[NSMutableData alloc] initWithCapacity:2048]; }
    int currentLen = 0.0f;
    if( currentFileName != nil){
        NSNumber *num = [fileSizes objectForKey:currentFileName];
        currentLen = num.intValue;
    }
    [downLoadData appendData:incrementalData];
    [downloadDelegate downloadStatus:((float)[downLoadData length]/currentLen)];
    //NSLog(@"SI %d %d  %f",[downLoadData length], currentLen, ((float)[downLoadData length]/currentLen));
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //reset the download data
    downloadConnection = nil;
    downLoadData = nil;
}
- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return cachedResponse;
}
//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
   
    if( downLoadData != nil){
        
        [self performSelectorOnMainThread:@selector(handleDownloadCall:)
                               withObject:downLoadData waitUntilDone:YES];

    }
    else{
        //TODO HANDLE A BAD DOWNLOAD - NEED TO CLEAR MAIN BACKGROUND SCREEN
    }
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
    
    BOOL isAssessment = [[fileName lowercaseString] rangeOfString:@ASSESSMENT_CSV].location != NSNotFound &&
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
        if( !isWeeklyFocus && !isAssessment){
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
    //handle the focus zip
    if( isWeeklyFocus){
        [self manageWeeklyFocus : path];
    }
    //handle the assessment csv
    if( isAssessment){
        [self manageAssessmentCSV : path];
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
        [self removeResignNotification];
        [self writeAssetsToFile:localAssetValues : @LOCAL_ASSET_PLIST];
        [self writeAssetsToFile:localAssetDescs : @LOCAL_DESC_PLIST];
        
        //update user asset views
        [self addNewUserViews];
        //tell the listeners download has finished
        [downloadDelegate downloadCompleted:YES];
        //plus update the last update time
        NSDate *dt = [[NSDate alloc] init];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setDouble:dt.timeIntervalSince1970 forKey:@"updateTime"];
        [defaults synchronize];
       
    }
}

- (void) manageWeeklyFocus  : (NSString *)path{
    [self unzipFile:path directory:@WEEKLY_FOCUS];
    
}
- (void) manageAssessmentCSV : (NSString *)path{
    if( [self unzipFile:path directory:@ASSESSMENT_CSV] ){
        //get the csv file
        NSString *dirPath = [self getAssetFilePath : @ASSESSMENT_CSV];
        dirPath = [dirPath stringByAppendingPathComponent:@ASSESSMENT_CSV];
        dirPath = [dirPath stringByAppendingPathExtension:@"csv"];
        NSURL *url = [NSURL fileURLWithPath:dirPath];
        
        NSArray *assessments = [NSArray arrayWithContentsOfCSVURL:url];
        [self manageAssessmentData:assessments];
    }
    
}
- (BOOL) unzipFile : (NSString *)path directory: (NSString *)destDir{
    BOOL success = NO;
    NSString *dirPath = [self getAssetFilePath : destDir];
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
            success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@%@", dirPath, file] error:&error];
            if (!success || error) {
                // it failed.
            }
        }
    }
    //now unzip files
    success = [SSZipArchive unzipFileAtPath:path toDestination:dirPath];
    return success;
}
//These notification methods handle a connection for moving in and out of active
//status. If the connection is lost, the download is resumed at the last item
//that was running when the app became inactive.

- (void) addResignNotification {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResign)
     name:UIApplicationWillResignActiveNotification
     object:NULL];
}

- (void) addResumeNotification {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResume)
     name:UIApplicationWillEnterForegroundNotification
     object:NULL];
}
- (void) applicationWillResign {
    [self removeResignNotification];
    //NSLog(@"About to lose focus");
    [self addResumeNotification];
}

- (void) applicationWillResume {
    //NSLog(@"CONNNECTION %@",[downloadConnection description]);
    [self addResignNotification];
    if( downloadConnection == nil)
        [self downloadAsset];// reset current download
    [self removeResumeNotification];
}
- (void) removeResignNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                name:UIApplicationWillResignActiveNotification
                                              object:NULL];
}

- (void) removeResumeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:NULL];
}

//=========== Update Assesment Data ===============//

- (void) manageAssessmentData : (NSArray *)assessments {
    //get the stored local files
    NSMutableArray *assessData = [self loadAssessmentDataFromFile];
    NSMutableArray *assessList = [[NSMutableArray alloc]init];//[self loadAssessmentOrdererListFromFile];
    
    //create a convenience dictionary to test if object already exists
    NSMutableDictionary *categories = [[NSMutableDictionary alloc] initWithCapacity:10];
    for( int i=0; i<[assessData count]; i++){
        AssessmentDataObject *dataObj = (AssessmentDataObject *)[assessData objectAtIndex:i];
        NSString *category = dataObj.category;
        NSMutableArray *questions = [categories objectForKey:category];
        if( questions == nil){ //create a new array for the category group
            questions = [[NSMutableArray alloc]initWithCapacity:10];
        }
        [questions addObject:dataObj];
        [categories setObject:questions forKey:category];
    }
    
    //now reset array for writing as weve have the values in a dictionary
    assessData = [[NSMutableArray alloc]init];
    assessList = [[NSMutableArray alloc]init];
    //now handle the downloaded data
    for( int i=0; i<[assessments count]; i++){
        NSArray *newValues = [assessments objectAtIndex:i];
        int numItems = (int)[newValues count];
        NSString *catName = nil;
        if( numItems > 0){
            catName = [[newValues objectAtIndex:0]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        if( catName == nil )
            continue; //cant handle
        
        //now update the other values
        NSString *question = nil;
        if(numItems > 1){
            question = [[newValues objectAtIndex:1]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        if( question == nil)
            continue;
        //see if a value exits
        NSMutableArray *dataObjList = (NSMutableArray *)[categories objectForKey:catName ];
        AssessmentDataObject *dataObj = nil;
        if( dataObjList != nil)
            dataObj = [self getDataObjectForQuestion:dataObjList :question];
        
        if( dataObj == nil){
            //create a new one
            dataObj = [[AssessmentDataObject alloc]init];
            dataObj.category = catName;
            dataObj.question = question;
        }
        
        NSString *answer1 = nil;
        if(numItems > 2){
            answer1 = [[newValues objectAtIndex:2]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        if( answer1 != nil)
            dataObj.answer1 = answer1;
        
        NSString *answer2 = nil;
        if(numItems > 3){
            answer2 = [[newValues objectAtIndex:3]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        if( answer2 != nil)
            dataObj.answer2 = answer2;
        
        NSString *answer3 = nil;
        if(numItems > 4){
            answer3 = [[newValues objectAtIndex:4]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        if( answer3 != nil)
            dataObj.answer3 = answer3;
        
        NSString *answer4 = nil;
        if(numItems > 5){
            answer4 = [[newValues objectAtIndex:5]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        if( answer4 != nil)
            dataObj.answer4 = answer4;
        
        NSString *answer5 = nil;
        if(numItems > 6){
            answer5 = [[newValues objectAtIndex:6]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        if( answer5 != nil)
            dataObj.answer5 = answer5;
        
        NSString *correct = nil;
        if(numItems > 7){
            correct = [[newValues objectAtIndex:7]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        NSArray *correctAnswers = [correct componentsSeparatedByString:@";"];
        NSMutableArray *correctInts = [[NSMutableArray alloc]initWithCapacity:5];
        if( correctAnswers == nil || [correctAnswers count] == 0){
            [correctInts addObject:[NSNumber numberWithInt:[correct intValue] - 1]];
        }
        else{
            for( NSString *answ in correctAnswers){
                [correctInts addObject:[NSNumber numberWithInt:[answ intValue]-1]];
            }
        }
        if( correctInts != nil)
            dataObj.correctAnswer = correctInts;
        
        //add to the array list
        [assessData addObject: dataObj];
        
        if( ![assessList containsObject:catName])
            [assessList addObject:catName];
        
    }
    [self writeArrayToFile:assessData :@ASSESS_DATA_PLIST ];
    [self writeArrayToFile:assessList :@ASSESS_ORDER_PLIST ];
}

- (AssessmentDataObject *) getDataObjectForQuestion : (NSMutableArray *) objList : (NSString *)question {
    AssessmentDataObject *dobj = nil;
    for( int i=0; i<[objList count]; i++){
        AssessmentDataObject *tmpObj = (AssessmentDataObject *)[objList objectAtIndex:i];
        if( [tmpObj.question isEqualToString:question]){
            dobj = tmpObj;
            break;
        }
    }
    
    return dobj;
    
}
//=========== Update User Views with local data ===================//

// Test all items are in user views - if not update and save
- (void) addNewUserViews {
    if( localAssetDescs == nil)
        return;
    NSMutableDictionary *userViews = [self loadAssetsFromFile:@USER_VIEWS_PLIST];
    for (NSString *fileName in localAssetDescs){
        NSString *currentFile = [userViews objectForKey:fileName];
        if( currentFile == nil) { //need to add
            UserAssetStatus *status = [[UserAssetStatus alloc] init];
            status.fileName = fileName;
            status.percentComplete = 0;
            status.numViews = 0;
            status.tstamp = 0.0f;
            [userViews setObject:status forKey:fileName];
        }
    }
    
    [self writeAssetsToFile:userViews : @USER_VIEWS_PLIST];
}
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
    updateURL = [updateURL stringByAppendingString:userId];
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
    
    
    NSArray *errors = [json objectForKey:@"error"];
    if( errors != nil){
        NSLog(@"No values returned for User View Update");
    }
    else{
        NSArray *results = [json objectForKey:@"results"];
        [self synchronizeAssets:results];
    }
    
    [self updateOnlineAssessmentStatus];
    
}

- (void) synchronizeAssets : (NSArray *)results{
    NSUInteger total = [results count];
    if( total == 0)
        return;
    
    NSMutableDictionary *userViews = [self loadAssetsFromFile:@USER_VIEWS_PLIST];
    for( int i=0; i<total;i++){
        NSDictionary *result = [results objectAtIndex:i];
        
        NSString *fileName = [Utilities uRLDecode : [result objectForKey:@"fileName"]];
        if( fileName == nil)
            fileName = @"";
        if( [fileName isEqualToString:@""])
            continue;
        
        NSString *timestamp = [Utilities uRLDecode : [result objectForKey:@"timestamp"]];
        if( timestamp == nil)
            timestamp = @"";
        double ts = [timestamp doubleValue];
        
        NSString *percent = [Utilities uRLDecode : [result objectForKey:@"percent"]];
        if( percent == nil)
            percent = @"";
        int pct = [percent intValue];
        //see if there is a record of the file
        UserAssetStatus *status = [userViews objectForKey:fileName];
        if( status != nil){
            status.percentComplete = pct;
            status.tstamp = ts;
        }
        
        [userViews setObject:status forKey:fileName];
    }
    //save the updates
    
    [self writeAssetsToFile:userViews : @USER_VIEWS_PLIST];
}

//=========== Update Asssessment Status with local data ===================//

- (void) updateOnlineAssessmentStatus {
    
    NSMutableArray *assessmentArray = [self loadAssessmentDataFromFile];
    NSString *userId = [self getUserId];
    
    NSString *jsonText = @"{\"results\":[";
    int len = (int32_t)[assessmentArray count];
    int count = 0;
    
    for( int i=0; i<len; i++){
        AssessmentDataObject *dataObj = (AssessmentDataObject *)[assessmentArray objectAtIndex:i];
        jsonText = [jsonText stringByAppendingString:[dataObj valuesAsJSON]];
        if( count < len - 1)
            jsonText = [jsonText stringByAppendingString:@","];
        count++;
    }
    jsonText = [jsonText stringByAppendingString:@"]}"];
    jsonText = [Utilities urlEncodeWithString:jsonText];
    NSData *jsonData = [jsonText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *updateURL = [[[NSUserDefaults standardUserDefaults] objectForKey:@"baseurl"]
                           stringByAppendingString:@"/UpdateQuizResponses?userId="];
    updateURL = [updateURL stringByAppendingString:userId];
    NSURL *url = [NSURL URLWithString:updateURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [self handleUpdateAssessStatusJSONCall : data];
    }];
}

- (void)handleUpdateAssessStatusJSONCall:(NSData *)responseData {
    
    if( responseData == nil){
        //   [self stopBusyIndicator];
        NSLog(@"Data nil from updateOnlineAssessmentStatus");
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
        NSLog(@"No new assessment values");
    }
    else{
        results = [json objectForKey:@"results"];
        if( results != nil)
            [self synchronizeAssessments:results];
    }
    //inform delegates done
    [downloadDelegate synchronizationComplete];
}

- (void) synchronizeAssessments : (NSArray *)results{
    NSUInteger total = [results count];
    if( total == 0)
        return;
    
    //first create a dictionary of changes to access quickly in update
    NSMutableDictionary *changes = [[NSMutableDictionary alloc] initWithCapacity:10];
    NSMutableArray *assessmentArray = [self loadAssessmentDataFromFile];
    for( int i=0; i<total;i++){
        NSDictionary *result = [results objectAtIndex:i];
        
        NSString *catName = [Utilities uRLDecode : [result objectForKey:@"catName"]];
        if( catName == nil || [catName isEqualToString:@""])
            continue;
        NSString *question = [Utilities uRLDecode : [result objectForKey:@"question"]];
        if( question == nil || [question isEqualToString:@""])
            continue;
        [changes setObject:result forKey:[catName stringByAppendingString:question]];
        
    }
    //now loop through assessments to see where change needed
    for( int i=0; i<[assessmentArray count]; i++){
        AssessmentDataObject *dataObj = [assessmentArray objectAtIndex:i];
        if( dataObj == nil)
            continue;
        
        NSString *key = [dataObj.category stringByAppendingString:dataObj.question];
        NSDictionary *result = [changes objectForKey:key];
        if( result == nil)
            continue;
        
        NSString *timestamp = [Utilities uRLDecode : [result objectForKey:@"timestamp"]];
        if( timestamp == nil)
            timestamp = @"";
        dataObj.tstamp = [timestamp doubleValue];
        
        NSString *aresult = [Utilities uRLDecode : [result objectForKey:@"result"]];
        if( aresult == nil)
            aresult = @"";
        dataObj.result = [aresult intValue];
        
        NSString *status = [Utilities uRLDecode : [result objectForKey:@"status"]];
        if( status == nil)
            status = @"Not Started";
        if( [status isEqualToString:@"Completed"])
            dataObj.status = 2;
        else if( [status isEqualToString:@"In Progress"])
            dataObj.status = 1;
        else
            dataObj.status = 0;
        //update the object
        [assessmentArray setObject:dataObj atIndexedSubscript:i];
        
    }
    //save the updates
    [self writeArrayToFile:assessmentArray :@ASSESS_DATA_PLIST ];
    
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
//returns an array of assessment data
- (NSMutableArray *) loadAssessmentDataFromFile {
    NSString *path = [self getAssetFilePath: @ASSESS_DATA_PLIST];
    NSMutableArray *assessList = nil;
    
    NSData *assetData = [NSData dataWithContentsOfFile:path];
    if( assetData != nil)
        assessList = [NSKeyedUnarchiver unarchiveObjectWithData:assetData];
    
    if( assessList == nil){
        assessList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return assessList;
}

//returns an array of assessment list objects in order
- (NSMutableArray *) loadAssessmentOrdererListFromFile {
    NSString *path = [self getAssetFilePath: @ASSESS_ORDER_PLIST];
    NSMutableArray *assessList = nil;
    
    NSData *assetData = [NSData dataWithContentsOfFile:path];
    if( assetData != nil)
        assessList = [NSKeyedUnarchiver unarchiveObjectWithData:assetData];
    
    if( assessList == nil){
        assessList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return assessList;
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
