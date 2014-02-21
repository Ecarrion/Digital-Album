//
//  ImageManager.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAImage.h"
#import "DAAlbum.h"

@interface AlbumManager : NSObject

+(AlbumManager *)manager;
-(void)phoneAlbumsWithBlock:(void(^)(NSArray * albums, NSError * error))block;

-(BOOL)saveAlbum:(DAAlbum *)album;
-(BOOL)saveImage:(DAImage *)image inAlbum:(DAAlbum *)album;
-(BOOL)saveImage:(DAImage *)image atURL:(NSURL *)imageUrl;

@end
