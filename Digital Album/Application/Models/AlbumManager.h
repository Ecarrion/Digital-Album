//
//  ImageManager.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAAlbum.h"
#import "DAPhoneAlbum.h"

@interface AlbumManager : NSObject

@property (nonatomic, readonly) NSString * documentsDirectoryPath;

+(AlbumManager *)manager;
-(void)phoneAlbumsWithBlock:(void(^)(NSArray * albums, NSError * error))block;
-(NSArray *)savedAlbums;

-(void)saveAlbum:(DAAlbum *)album onCompletion:(void(^)(BOOL success))block;
-(BOOL)deleteAlbum:(DAAlbum *)album;


-(BOOL)deleteDiskDataOfPage:(DAPage *)page inAlbum:(DAAlbum *)album;
-(BOOL)deleteDiskDataOfImage:(DAImage *)image;

@end
