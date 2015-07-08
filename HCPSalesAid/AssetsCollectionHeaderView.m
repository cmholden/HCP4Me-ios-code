//
//  AssetsCollectionHeaderView.m
//  HCPSalesAid
//
//  Created by cmholden on 29/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "AssetsCollectionHeaderView.h"

@implementation AssetsCollectionHeaderView

@synthesize isSelected;
@synthesize rightImage;
@synthesize downImage;
@synthesize buttonImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isSelected = NO;
        rightImage = [UIImage imageNamed:@"UIButtonBarArrowRight.png"];
        downImage = [UIImage imageNamed:@"UIButtonBarArrowDown.png"];
        buttonImage = [[UIImageView alloc]init];
        [buttonImage setContentMode:UIViewContentModeRight];
        buttonImage.image = rightImage;
    }
    
    return self;
}

- (void) setArrowImage : (BOOL) select{
    isSelected = select;
    buttonImage.image = isSelected? downImage : rightImage;
}

@end
