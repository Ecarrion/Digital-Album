//
//  DAPhoneAlbum.m
//  Digital Album
//
//  Created by Ernesto Carrión on 2/23/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "DAPhoneAlbum.h"

@implementation DAPhoneAlbum

+(DAPhoneAlbum *)AlbumWithGroup:(ALAssetsGroup *)group {
    
    DAPhoneAlbum * album = [[DAPhoneAlbum alloc] init];
    album.name = [group valueForProperty:ALAssetsGroupPropertyName];
    album.id = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
    
    return album;
}

-(DAImage *)topImage {
    
    return [self.images firstObject];
}

@end
