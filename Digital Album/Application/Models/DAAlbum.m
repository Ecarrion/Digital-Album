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
#define kAlbumImagesKey @"kAlbumImagesKey"


@implementation DAAlbum

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    DAAlbum * album = [[DAAlbum alloc] init];
    album.name = [aDecoder decodeObjectForKey:kAlbumNameKey];
    album.coverImageName = [aDecoder decodeObjectForKey:kAlbumCoverImageNameKey];
    album.images = [aDecoder decodeObjectForKey:kAlbumImagesKey];
    
    return album;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:kAlbumNameKey];
    [aCoder encodeObject:self.coverImageName forKey:kAlbumCoverImageNameKey];
    [aCoder encodeObject:self.images forKey:kAlbumImagesKey];
}


+(DAAlbum *)AlbumWithGroup:(ALAssetsGroup *)group {
    
    DAAlbum * album = [[DAAlbum alloc] init];
    album.name = [group valueForProperty:ALAssetsGroupPropertyName];
    album.id = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
    
    return album;
}

-(DAImage *)topImage {
    
    return [self.images firstObject];
}

@end
