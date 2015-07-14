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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.forumWebView.hidden = YES;
    /*
    NSURL *pageURL = [NSURL URLWithString:@"http://www.theverge.com/forums/mobile"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:pageURL];
    self.forumWebView.delegate = self;
    [self.forumWebView loadRequest:requestObj];
     */
    UILabel *forumDesc = [[UILabel alloc] initWithFrame:CGRectMake(20, 120,  self.view.frame.size.width - 40, 65)];
    forumDesc.textColor = [UIColor blackColor];
    forumDesc.numberOfLines = 3;
    forumDesc.text = @"To Join the HCP4Me JAM forum, you will need to open it in the Safari Browser";
    forumDesc.textAlignment = NSTextAlignmentLeft;
    forumDesc.font = [Utilities getFont:18];
    [self.view addSubview:forumDesc];
    
    UIButton *viewForum = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 40, 45)];
    [viewForum setTitle:@"GO TO FORUM" forState:UIControlStateNormal];
    viewForum.tintColor = [UIColor whiteColor];
    viewForum.titleLabel.font = [Utilities getBoldFont:18];
    viewForum.backgroundColor = [Utilities getSAPGold];
    [viewForum addTarget:self action:@selector(viewForumClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewForum];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewForumClicked : (id) sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.google.co.uk"]];
}

//**** WEB View delegate  ***/

UIActivityIndicatorView* activityIndicator1;

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType{
    if( activityIndicator1 == nil){
        activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator1.frame = CGRectMake(self.view.frame.size.width/2 - 25,
                                             self.view.frame.size.height/2 - 25, 50, 50 );
    }
    [activityIndicator1 startAnimating];
    [self.view addSubview:activityIndicator1];
    
    return YES;
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if( activityIndicator1 != nil){
        [activityIndicator1 stopAnimating];
        [activityIndicator1 removeFromSuperview];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if( activityIndicator1 != nil){
        [activityIndicator1 stopAnimating];
        [activityIndicator1 removeFromSuperview];
    }
}

@end

