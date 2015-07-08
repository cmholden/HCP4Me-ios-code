//
//  AssetDataObject.m
//  HCPSalesAid
//
//  Created by cmholden on 26/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "AssetDataObject.h"

@implementation AssetDataObject

@synthesize fileName;
@synthesize assetId;
@synthesize assetType;
@synthesize category;
@synthesize fileLength;
@synthesize desc;
@synthesize format;
@synthesize tstamp;
@synthesize version;
@synthesize fileTime;
@synthesize title;
@synthesize trainingType;
@synthesize topic;
@synthesize sizeDesc;
@synthesize internal;

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:fileName forKey:@"fileName"];
    [encoder encodeObject:assetId forKey:@"assetId"];
    [encoder encodeObject:assetType forKey:@"assetType"];
    [encoder encodeObject:category forKey:@"category"];
    [encoder encodeObject:desc forKey:@"desc"];
    [encoder encodeObject:format forKey:@"format"];
    [encoder encodeObject:version forKey:@"version"];
    [encoder encodeDouble:tstamp forKey:@"tstamp"];
    [encoder encodeInt:fileLength forKey:@"fileLength"];
    [encoder encodeObject:fileTime forKey:@"fileTime"];
    [encoder encodeObject:title forKey:@"title"];
    [encoder encodeObject:trainingType forKey:@"trainingType"];
    [encoder encodeObject:topic forKey:@"topic"];
    [encoder encodeObject:sizeDesc forKey:@"sizeDesc"];
    [encoder encodeObject:internal forKey:@"internal"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    self.fileName = [decoder decodeObjectForKey:@"fileName"];
    self.assetId = [decoder decodeObjectForKey:@"assetId"];
    self.assetType = [decoder decodeObjectForKey:@"assetType"];
    self.category = [decoder decodeObjectForKey:@"category"];
    self.desc = [decoder decodeObjectForKey:@"desc"];
    self.format = [decoder decodeObjectForKey:@"format"];
    self.version = [decoder decodeObjectForKey:@"version"];
    self.tstamp = [decoder decodeFloatForKey:@"tstamp"];
    self.fileLength = [decoder decodeIntForKey:@"fileLength"];
    self.fileTime = [decoder decodeObjectForKey:@"fileTime"];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.trainingType = [decoder decodeObjectForKey:@"trainingType"];
    self.topic = [decoder decodeObjectForKey:@"topic"];
    self.sizeDesc = [decoder decodeObjectForKey:@"sizeDesc"];
    self.internal = [decoder decodeObjectForKey:@"internal"];
    return self;
}

@end
