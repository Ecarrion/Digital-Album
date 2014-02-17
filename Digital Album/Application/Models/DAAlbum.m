//
//  DAAlbum.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "DAAlbum.h"


@implementation DAAlbum


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
