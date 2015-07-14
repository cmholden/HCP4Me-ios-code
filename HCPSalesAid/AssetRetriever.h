//
//  AssetRetriever.h
//  HCPSalesAid
//
//  Created by cmholden on 26/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssetDataObject.h"
#import "AssessmentDataObject.h"
#import "CHCSVParser.h"
#import "DownloadDelegate.h"
#import "Utilities.h"
#import "ListStructureObject.h"
//#import <MediaPlayer/MediaPlayer.h>
#import "UserAssetStatus.h"
#import "SSZipArchive.h"

@interface AssetRetriever : NSObject

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define ASSESSMENT_CSV "assessment"

#define ASSESS_DATA_PLIST "assessment.plist"

#define ASSESS_ORDER_PLIST "assessmentOrder.plist"

#define ASSET_PLIST "assetList.plist"

#define IMAGE_PATH "images"
#define FAVORITES_PLIST "favorites.plist"
#define LOCAL_ASSET_PLIST "localAssetList.plist"
#define LOCAL_DESC_PLIST "localDescList.plist"
//#define SORTED_ASSET_PLIST "sortedAssetList.plist"
#define LIST_STRUCTURE_PLIST "listStructure.plist"
#define SALES_TOOLS "Sales Tool"
#define USER_VIEWS_PLIST "userViews.plist"
#define WEEKLY_FOCUS "weeklyfocus"

@property (strong, nonatomic) id<DownloadDelegate> downloadDelegate;

@property (nonatomic) int downloadSize;

- (void) loadJSONAssetList;

- (void) downloadAsset;

- (NSMutableArray *) loadAssetsListFromFile: (NSString *)listType;

- (NSMutableDictionary *) loadAssetsFromFile : (NSString *) fileName;

- (void) loadJSONListStructure;

- (NSString *) getAssetFilePath : (NSString *) fileName;

- (void) downloadNewAssets;

- (void) updateUserViews : (NSString *) fileName percentViewed : (double)percent ;

- (void) updateOnlineUserViews;

- (void) updateOnlineAssessmentStatus;

- (NSMutableArray *) loadFavoritesFromFile;

- (void) writeArrayToFile : (NSMutableArray *)arrayToSave : (NSString *) fileName;

- (NSMutableArray *) loadAssessmentDataFromFile;

- (NSMutableArray *) loadAssessmentOrdererListFromFile;

- (void) addResignNotification;


@end
