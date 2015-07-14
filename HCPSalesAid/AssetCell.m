//
//  AssetCell.m
//  HCPSalesAid
//
//  Created by cmholden on 28/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "AssetCell.h"

@implementation AssetCell

@synthesize imageView;
//@synthesize title;
@synthesize titleText;
@synthesize detailText;
@synthesize userViewText;
@synthesize favoritesButton;
@synthesize fileName;
@synthesize usesFavorites;

@synthesize assetDataObject;
@synthesize favsList;
@synthesize isFavorite;
@synthesize isEditing;

@synthesize favsOffImg;
@synthesize favsOnImg;
@synthesize trashImg;

@synthesize assetsCollectionDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // NSLog(@"INIT");
    }
    [self setup];
    return self;
}

-(void) setup{
    
    self.backgroundColor = [UIColor whiteColor];
    float titleIndent = 5;
    float leftIndent = 5.0f;
    float htGap = 2;
    UIFont *fBoldBody = [UIFont fontWithName:@"Arial-BoldMT" size:14];// preferredFontForTextStyle:UIFontTextStyleCaption2];
    
 //   UIFont *fBodySub = [UIFont fontWithName:@"ArialMT" size:14];
    UIFont *fBody = [UIFont fontWithName:@"ArialMT" size:13];

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(titleIndent, htGap, 24, 24)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:imageView];
    
    
    self.titleText = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + leftIndent,
                                       htGap,
                                       self.frame.size.width - self.imageView.frame.size.width - leftIndent - 60,
                                       38)];
    [self.titleText setNumberOfLines:0];
    self.titleText.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleText.font = fBoldBody;
    self.titleText.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleText];

    favsOffImg = [UIImage imageNamed:@"Favourites List Icon-Add.png"];
    favsOnImg = [UIImage imageNamed:@"Favourites List Icon.png"];
    trashImg = [UIImage imageNamed:@"22-NavBar-Trash.png"];
    
    favoritesButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 79.0f, -5.0f, 90.0f, 90.0f)];
    favoritesButton.imageEdgeInsets = UIEdgeInsetsMake(-35, 35, 0, 0);
    favoritesButton.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
    [favoritesButton setImage:favsOffImg forState:UIControlStateNormal];
    [favoritesButton addTarget:self action:@selector(didSelectFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:favoritesButton];
  

    self.detailText = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                self.titleText.frame.origin.x,
                                                            self.titleText.frame.origin.y + self.titleText.frame.size.height ,
                                                            self.frame.size.width - self.imageView.frame.size.width - titleIndent * 6, 28)];
    [self.detailText setNumberOfLines:0];
    self.detailText.font = fBody;
    self.detailText.lineBreakMode = NSLineBreakByWordWrapping;
    self.detailText.textColor = [Utilities getDarkGray];
    [self.detailText setText:@""];
    [self.contentView addSubview:self.detailText];
    
    
    self.userViewText = [[UILabel alloc] initWithFrame:CGRectMake(self.detailText.frame.origin.x ,
                                                                self.detailText.frame.origin.y + self.detailText.frame.size.height ,
                                                                self.frame.size.width - self.imageView.frame.size.width - titleIndent * 6, 22)];
    [self.userViewText setNumberOfLines:0];
    self.userViewText.font = fBody;
    self.userViewText.lineBreakMode = NSLineBreakByWordWrapping;
    self.userViewText.textColor = [Utilities getDarkGray];
    [self.userViewText setText:@""];
    [self.contentView addSubview:self.userViewText];
    
}

-(void) updateCell : (AssetDataObject *)dataObject userAssetViews :  (UserAssetStatus *)userViews{
    self.assetDataObject = dataObject;
    if( dataObject == nil){
        [self resetCell];
        return;
    }
    
    
    //store the file name
    fileName = dataObject.fileName;
    if( usesFavorites){
        favoritesButton.hidden = NO;
        if( [favsList containsObject:fileName]){
            [favoritesButton setImage:favsOnImg forState:UIControlStateNormal];
            isFavorite = YES;
        }
        else{
            [favoritesButton setImage:favsOffImg forState:UIControlStateNormal];
            isFavorite = NO;
        }
    }
    else if( isEditing){
        favoritesButton.hidden = NO;
        [favoritesButton setImage:trashImg forState:UIControlStateNormal];
    }
    else{
        favoritesButton.hidden = YES;
    }
    
    NSString *type = dataObject.assetType;
    if( [[type lowercaseString] isEqualToString:@"video"]){
        [imageView setImage: [UIImage imageNamed:@"Media Format-Video.png"]];
    }
    else if( [[type lowercaseString] isEqualToString:@"pdf"]){
        [imageView setImage: [UIImage imageNamed:@"Media Format-PDF.png"]];
    }
    else if( [[type lowercaseString] isEqualToString:@"audio"]){
        [imageView setImage: [UIImage imageNamed:@"Media Format-Audio.png"]];
    }
    else if( [[type lowercaseString] isEqualToString:@"web"]){
        [imageView setImage: [UIImage imageNamed:@"web.png"]];
    }
    else if( [[type lowercaseString] isEqualToString:@"other"]){
        [imageView setImage: [UIImage imageNamed:@"other.png"]];
    }
    
    NSString *tmpStr = dataObject.title;
    if( tmpStr == nil)
       [titleText setText:@""];
    else
        [titleText setText:tmpStr];
    
    [self.detailText setAttributedText: [self getDetailString:dataObject]];
    
    [self.userViewText setAttributedText:[self getUserViewsString : userViews]];

}

-(NSMutableAttributedString *) getDetailString :(AssetDataObject *)dataObject{
    UIColor *color = [Utilities getDarkGray];
    NSTextAttachment *attachment;
    UIFont *fBody = [UIFont fontWithName:@"ArialMT" size:13];
    NSMutableAttributedString *detailTxt = [[NSMutableAttributedString alloc] init];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:color,
                                 NSFontAttributeName:fBody};
    //dp we need time icon
    NSString *tmpStr = dataObject.assetType;
    if( tmpStr != nil){
        tmpStr = [tmpStr lowercaseString];
        if( [tmpStr isEqualToString:@"video"] || [tmpStr isEqualToString:@"audio"]){
            UIImage *time = [UIImage imageNamed:@"MetaInfo-LengthTime.png"];
            attachment = [[NSTextAttachment alloc] init];
            attachment.image = time;
            attachment.bounds = CGRectMake(0, -3, 16, 16);
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attachment];
            
            [detailTxt appendAttributedString:attrStringWithImage ];
            
        }
    }
    tmpStr = dataObject.sizeDesc;
    if( tmpStr != nil){
        tmpStr = [tmpStr stringByAppendingString:@"  |  "];
        NSMutableAttributedString *timeDetail = [[NSMutableAttributedString alloc] initWithString:tmpStr];
        [detailTxt appendAttributedString:timeDetail];
    }
    
    UIImage *disk = [UIImage imageNamed:@"MetaInfo-FileSize.png"];
    attachment = [[NSTextAttachment alloc] init];
    attachment.bounds = CGRectMake(0, -3, 16, 16);
    attachment.image = disk;
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attachment];
    
    [detailTxt appendAttributedString:attrStringWithImage ];
    
    int fileLen = dataObject.fileLength;
    tmpStr = [Utilities getSizeAsDiskSize : fileLen];
    if( tmpStr != nil){
        tmpStr = [tmpStr stringByAppendingString:@"  |  "];
        NSMutableAttributedString *timeDetail = [[NSMutableAttributedString alloc] initWithString:tmpStr];
        [detailTxt appendAttributedString:timeDetail];
    }
    
    UIImage *intExternal;
    tmpStr = dataObject.internal;
    if( [tmpStr isEqualToString:@"y"]){
        intExternal = [UIImage imageNamed:@"MetaInfo-Internal.png"];
        tmpStr = @"Internal";
    }
    else{
        intExternal = [UIImage imageNamed:@"MetaInfo-External.png"];
        tmpStr = @"External";
        
    }
    attachment = [[NSTextAttachment alloc] init];
    attachment.bounds = CGRectMake(0, -3, 16, 16);
    attachment.image = intExternal;
    attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attachment];
    
    [detailTxt appendAttributedString:attrStringWithImage ];
    
    if( tmpStr != nil){
        tmpStr = [tmpStr stringByAppendingString:@"  |  "];
        NSMutableAttributedString *timeDetail = [[NSMutableAttributedString alloc] initWithString:tmpStr];
        [detailTxt appendAttributedString:timeDetail];
    }
    UIImage *tool = [UIImage imageNamed:@"MetaInfo-Sales Tool.png"];
    attachment = [[NSTextAttachment alloc] init];
    attachment.bounds = CGRectMake(0, -3, 16, 16);
    attachment.image = tool;
    attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attachment];
    
    [detailTxt appendAttributedString:attrStringWithImage ];
    
    tmpStr = dataObject.trainingType;
    if( tmpStr != nil){
        NSMutableAttributedString *timeDetail = [[NSMutableAttributedString alloc] initWithString:tmpStr];
        [detailTxt appendAttributedString:timeDetail];
    }
    
    
    [detailTxt addAttributes:attributes range:NSMakeRange(0, [detailTxt length])];
    return detailTxt;
}

-(NSMutableAttributedString *) getUserViewsString :  (UserAssetStatus *)userViews{
    UIColor *color = [Utilities getDarkGray];
    NSTextAttachment *attachment;
    UIFont *fBody = [UIFont fontWithName:@"ArialMT" size:13];
    NSMutableAttributedString *userViewsTxt = [[NSMutableAttributedString alloc] init];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:color,
                                 NSFontAttributeName:fBody};
    
    
    NSString *tmpStr = @"";
    UIImage *status;
    int percent = userViews.percentComplete;
    if( percent == 0){
        status = [UIImage imageNamed:@"notstarted16.png"];
        tmpStr = @" Not Started  |  ";
    }
    else if( percent == 100){
        status = [UIImage imageNamed:@"completed16.png"];
        tmpStr = @" Completed  |  ";
    }
    else {
        status = [UIImage imageNamed:@"inprogress16.png"];
        tmpStr = @" In Progress  |  ";
    }
    attachment = [[NSTextAttachment alloc] init];
    attachment.bounds = CGRectMake(0, -3, 16, 16);
    attachment.image = status;
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attachment];

    [userViewsTxt appendAttributedString:attrStringWithImage ];
    
    NSMutableAttributedString *tmpViews = [[NSMutableAttributedString alloc] initWithString:tmpStr];
    [userViewsTxt appendAttributedString:tmpViews];
    
    NSTimeInterval viewTime = userViews.tstamp/1000;
    if( viewTime == 0){
        tmpStr = @"Not yet viewed";
    }
    else{
        NSDate *dt = [[NSDate alloc] initWithTimeIntervalSince1970:viewTime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M/d/yy"];
        tmpStr = [formatter stringFromDate:dt];
        tmpStr = [@"Last viewed : " stringByAppendingString:tmpStr];
    }
    tmpViews = [[NSMutableAttributedString alloc] initWithString:tmpStr];
    [userViewsTxt appendAttributedString:tmpViews];
    
    [userViewsTxt addAttributes:attributes range:NSMakeRange(0, [userViewsTxt length])];
    return userViewsTxt;
}


- (void) didSelectFavorite : (UIButton *) button{
    if( fileName == nil || favsList == nil )
        return;
    isFavorite = !isFavorite;
    
    if( assetsCollectionDelegate != nil){
        [assetsCollectionDelegate manageFavorite:fileName addAsFavorite:isFavorite];
    }
    
    
}

- (void) resetCell {
    [self.titleText setText:@""];
    [self.detailText setText:@""];
    [self.userViewText setText:@""];
}

@end
