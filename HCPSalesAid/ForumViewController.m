//
//  SecondViewController.m
//  HCPSalesAid
//
//  Created by cmholden on 26/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "ForumViewController.h"

@interface ForumViewController ()


@end

@implementation ForumViewController

AssetRetriever *downloadAssets;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    downloadAssets = [[AssetRetriever alloc] init];
    downloadAssets.downloadDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)downloadAssets:(id)sender {
    [downloadAssets updateOnlineUserViews];
    [downloadAssets loadJSONAssetList];
}

- (void) setNumberOfDownloads : (int) numDownloads{

    if( numDownloads == 0){
        [self alertUserNoDownloads];
    }
    else{
        NSString *msg = [NSString stringWithFormat:@"%d", numDownloads];
        msg = [msg stringByAppendingString:@" updates are available. Do you want to download them?"];
        [self alertUserDownload : msg];
    }
   
}

- (void) alertUserDownload: (NSString *)msg {
    
    UIAlertView *popup = [[UIAlertView alloc]
                          initWithTitle:@"Download Assets"
                          message:msg
                          delegate:nil
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Download", nil];
    popup.delegate = self;
    [popup show];
}

- (void) alertUserNoDownloads {
    
    UIAlertView *popup = [[UIAlertView alloc]
                          initWithTitle:@"Download Assets"
                          message:@"Your assets are up to date!"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil];
    [popup show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 1){
        [downloadAssets downloadAsset];
    }
    alertView.delegate = nil;
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    
}

@end

