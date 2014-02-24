//
//  DAAlbum.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "DAAlbum.h"

#define kAlbumNameKey @"kAlbumNameKey"
#define kAlbumCoverImageNameKey @"kAlbumCoverImageNameKey"
#define kAlbumPagesKey @"kAlbumPagesKey"


@implementation DAAlbum

- (id)init {
    
    self = [super init];
    if (self) {
        
        self.pages = @[[[DAPage alloc] init]];
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    DAAlbum * album = [[DAAlbum alloc] init];
    album.name = [aDecoder decodeObjectForKey:kAlbumNameKey];
    album.coverImageName = [aDecoder decodeObjectForKey:kAlbumCoverImageNameKey];
    album.pages = [aDecoder decodeObjectForKey:kAlbumPagesKey];
    
    return album;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:kAlbumNameKey];
    [aCoder encodeObject:self.coverImageName forKey:kAlbumCoverImageNameKey];
    [aCoder encodeObject:self.pages forKey:kAlbumPagesKey];
}

-(BOOL)isEqual:(id)object {
    
    if ([object isKindOfClass:[DAAlbum class]]) {
        return [self.name isEqualToString:[object name]];
    }
    
    return NO;
}

-(NSArray *)allImages {
    
    NSMutableArray * allImages = [NSMutableArray array];
    for (DAPage * page in self.pages) {
        [allImages addObjectsFromArray:page.images];
    }
    
    return allImages;
}

-(DAImage *)topImage {
    
    return [[[self.pages firstObject] images] firstObject];
}

@end
