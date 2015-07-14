//
//  DownloadView.h
//  HCPSalesAid
//
//  Created by cmholden on 11/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

@interface DownloadView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *fileNameLabel;
@property (strong, nonatomic) UILabel *downloadSizeLabel;
@property (strong, nonatomic) UIView *downloadOutline;
@property (strong, nonatomic) UIView *downloadBar;


- (void) setDownloadSizeLabelText : (NSString *) txt;

- (void) setFileNameText : (NSString *) txt;

- (void) setup;

- (void) updateBarWidth : (float) fraction;

@end
