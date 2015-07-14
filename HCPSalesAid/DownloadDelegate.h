//
//  DownloadDelegate.h
//  HCPSalesAid
//
//  Created by cmholden on 02/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadDelegate <NSObject>

- (void) setNumberOfDownloads : (int) numDownloads downloadSize : (int) filesSize;

- (void) fileDownloaded : (NSString *)fileName;

- (void) downloadCompleted : (BOOL) completed;

- (void) downloadStatus : (float) fractionCompleted;

@optional

- (void) synchronizationComplete;

@end
