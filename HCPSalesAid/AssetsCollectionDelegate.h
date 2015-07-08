//
//  AssetsCollectionDelegate.h
//  HCPSalesAid
//
//  Created by cmholden on 06/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AssetsCollectionDelegate <NSObject>

- (void) manageFavorite : (NSString *)fileName addAsFavorite : (BOOL)addFavorite;


@end
