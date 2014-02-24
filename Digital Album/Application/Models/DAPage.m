//
//  DAPage.m
//  Digital Album
//
//  Created by Ernesto Carrión on 2/23/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "DAPage.h"

#define kPageImagesKey @"kPageImagesKey"
#define kPageTextKey @"kPageTextKey"

@implementation DAPage

- (id)init
{
    self = [super init];
    if (self) {
        
        self.images = [NSArray array];
        self.texts = [NSArray array];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    DAPage * page = [[DAPage alloc] init];
    page.images = [aDecoder decodeObjectForKey:kPageImagesKey];
    page.texts = [aDecoder decodeObjectForKey:kPageTextKey];
    
    return page;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.images forKey:kPageImagesKey];
    [aCoder encodeObject:self.texts forKey:kPageTextKey];
}

@end
