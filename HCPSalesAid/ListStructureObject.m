//
//  ListStructureObject.m
//  HCPSalesAid
//
//  Created by cmholden on 30/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "ListStructureObject.h"

@implementation ListStructureObject

@synthesize category;
//@synthesize fileList;
@synthesize assetDataObjs;

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:category forKey:@"category"];
    [encoder encodeObject:assetDataObjs forKey:@"assetDataObjs"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    self.category = [decoder decodeObjectForKey:@"category"];
    self.assetDataObjs = [decoder decodeObjectForKey:@"assetDataObjs"];
    return self;
}

@end
