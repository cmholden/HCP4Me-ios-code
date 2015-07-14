//
//  DownloadView.m
//  HCPSalesAid
//
//  Created by cmholden on 11/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "DownloadView.h"

@implementation DownloadView


@synthesize titleLabel;
@synthesize fileNameLabel;
@synthesize downloadSizeLabel;
@synthesize downloadBar;
@synthesize downloadOutline;
#define DOWNLOAD_BAR_WIDTH 296.0f;
-(void)setup{
    
    self.backgroundColor = [UIColor blackColor];
   // self.alpha = 0.75f;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                (self.frame.size.width - 300)/2,
                                                75, 300, 35)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Updating Assets from HCP";
    titleLabel.font = [Utilities getFont:22];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    
    downloadSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                           (self.frame.size.width - 300)/2,
                                                           75 + 35, 300, 35)];
    downloadSizeLabel.textAlignment = NSTextAlignmentCenter;
    downloadSizeLabel.text = @"";
    downloadSizeLabel.font = [Utilities getFont:22];
    downloadSizeLabel.textColor = [UIColor whiteColor];
    [self addSubview:downloadSizeLabel];
    
    
    fileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake( (self.frame.size.width - 300)/2,
                                                                  75 + 35 + 35, 300, 35)];
    fileNameLabel.textAlignment = NSTextAlignmentCenter;
    fileNameLabel.text = @"";
    fileNameLabel.font = [Utilities getFont:12];
    fileNameLabel.textColor = [UIColor whiteColor];
    [self addSubview:fileNameLabel];
    
    downloadOutline = [[UIView alloc] initWithFrame:CGRectMake(
                                                               (self.frame.size.width - 300)/2,
                                                               75 + 35 + 35 +35 + 10, 300, 35)];
    downloadOutline.backgroundColor = [UIColor blackColor];
    downloadOutline.layer.borderColor = [UIColor whiteColor].CGColor;
    downloadOutline.layer.borderWidth = 2;
    [self addSubview:downloadOutline];
    
    downloadBar = [[UIView alloc] initWithFrame:CGRectMake(
                                                           (self.frame.size.width - 296)/2,
                                                               75 + 35 + 35 + 35 + 10 + 2, 0, 31)];
    downloadBar.backgroundColor = [Utilities getSAPGold];
    [self addSubview:downloadBar];
    
    
}

- (void) setDownloadSizeLabelText : (NSString *) txt{
    self.downloadSizeLabel.text = txt;
}

- (void) setFileNameText : (NSString *) txt{
    self.fileNameLabel.text = txt;
}

- (void) updateBarWidth : (float) fraction {
    CGRect rect = downloadBar.frame;
    rect.size.width = fraction * DOWNLOAD_BAR_WIDTH;
    downloadBar.frame = rect;
}

@end
