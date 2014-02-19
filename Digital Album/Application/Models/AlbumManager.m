//
//  ImageManager.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#import "AlbumManager.h"
#import "DAImage.h"
#import "DAAlbum.h"


@implementation AlbumManager


+ (ALAssetsLibrary *) defaultAssetsLibrary {
    
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}


+(void)phoneAlbumsWithBlock:(void (^)(NSArray *, NSError *))block {
    
    ALAssetsLibrary *lib = [AlbumManager defaultAssetsLibrary];
    __block NSMutableArray * albumsArray = [NSMutableArray array];
    
    [lib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group) {
        
            DAAlbum * album = [DAAlbum AlbumWithGroup:group];
            NSMutableArray * imagesArray = [NSMutableArray array];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result) {
                    
                    NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                    if ([assetType isEqualToString:ALAssetTypePhoto]) {
                        
                        DAImage * image = [DAImage imageWithLocalAsset:result];
                        [imagesArray addObject:image];
                    }
                }
            }];
            
            
            if (imagesArray.count > 0) {
                album.images = [imagesArray copy];
                [albumsArray addObject:album];
            }
            imagesArray = nil;
            
        } else {
            
            //Group nil
            //Iteration ended
            if (block) {
                block([albumsArray copy], nil);
                albumsArray = nil;
            }
        }
     
    } failureBlock:^(NSError *error) {
        
        if (block)
            block(nil, error);
    }];
    
}


@end
