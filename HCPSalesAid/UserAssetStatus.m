//
//  UserAssetStatus.m
//  HCPSalesAid
//
//  Created by cmholden on 03/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "UserAssetStatus.h"

@implementation UserAssetStatus

@synthesize fileName;
@synthesize tstamp;
@synthesize percentComplete;
@synthesize numViews;

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:fileName forKey:@"fileName"];
    [encoder encodeDouble:tstamp forKey:@"tstamp"];
    [encoder encodeDouble:percentComplete forKey:@"percentComplete"];
    [encoder encodeInt:numViews forKey:@"numViews"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    self.fileName = [decoder decodeObjectForKey:@"fileName"];
    self.tstamp = [decoder decodeFloatForKey:@"tstamp"];
    self.percentComplete = [decoder decodeFloatForKey:@"percentComplete"];
    self.numViews = [decoder decodeIntForKey: @"numViews"];
    return self;
}

- (NSString *) valuesAsJSON {
    NSString *json = @"{\"fileName\":\"";
    json = [json stringByAppendingString:self.fileName];
    json = [json stringByAppendingString:@"\"\"timeStamp\":\""];
    
    NSString *ts = [NSString stringWithFormat:@"%0.f", tstamp];

    json = [json stringByAppendingString:ts];
    json = [json stringByAppendingString:@"\"\"percent\":\""];
    
    NSString *pct = [NSString stringWithFormat:@"%d", (int)self.percentComplete];
    
    json = [json stringByAppendingString:pct];
    json = [json stringByAppendingString:@"\"\"numViews\":\""];
    
    NSString *views = [NSString stringWithFormat:@"%d", self.numViews];
    
    json = [json stringByAppendingString:views];
    json = [json stringByAppendingString:@"\"}"];
    
    
    return json;
}

@end
