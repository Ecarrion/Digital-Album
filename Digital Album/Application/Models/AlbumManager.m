//
//  ImageManager.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "AlbumManager.h"

#define ALBUMS_OBJ_PATH @"albums.array"

@interface AlbumManager ()

@property (nonatomic, strong) ALAssetsLibrary * lib;
@property (nonatomic, strong) NSString * documentsDirectoryPath;
@end

@implementation AlbumManager

+(AlbumManager *)manager {
    
    static AlbumManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AlbumManager alloc] init];
    });
    
    return manager;
}

- (id)init {
    
    self = [super init];
    if (self) {
        
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        self.documentsDirectoryPath = basePath;
    }
    return self;
}

#pragma mark - Get

-(void)phoneAlbumsWithBlock:(void (^)(NSArray *, NSError *))block {
    
    if (!self.lib) {
        self.lib = [[ALAssetsLibrary alloc] init];
    }
    __block NSMutableArray * albumsArray = [NSMutableArray array];
    
    [self.lib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
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


-(NSArray *)savedAlbums {
    
    NSString * savedAlbumsPath = [self.documentsDirectoryPath stringByAppendingPathComponent:ALBUMS_OBJ_PATH];
    NSArray * savedAlbums = [NSKeyedUnarchiver unarchiveObjectWithFile:savedAlbumsPath];
    if (!savedAlbums)
        savedAlbums = [NSArray array];
    
    return savedAlbums;
}


#pragma mark - Save

-(void)saveAlbum:(DAAlbum *)album onCompletion:(void(^)(BOOL success))block {
    
    __block BOOL success = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (DAImage * image in album.images) {
            BOOL result = [self saveImage:image inAlbum:album];
            if (success)
                success = result;
        }
        
        if (success) {
            
            NSArray * savedAlbums = [[self savedAlbums] arrayByAddingObject:album];
            [self saveAlbumsToDisk:savedAlbums];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (block) {
                block(success);
            }
            
        });
    });
}

-(BOOL)saveAlbumsToDisk:(NSArray *)albums {
    
    NSString * savedAlbumsPath = [self.documentsDirectoryPath stringByAppendingPathComponent:ALBUMS_OBJ_PATH];
    return [NSKeyedArchiver archiveRootObject:albums toFile:savedAlbumsPath];
}

-(BOOL)saveImage:(DAImage *)image inAlbum:(DAAlbum *)album {
    
    BOOL result = NO;
    if ([self createFolderForAlbumIfNecesary:album]) {
    
        @autoreleasepool {
            
            NSString * imagePath = [self pathForImage:image inAlbum:album];
            result = [self saveImage:image atPath:imagePath];
        }
    }
    
    return result;
}

-(BOOL)saveImage:(DAImage *)image atPath:(NSString *)imagePath {
    
    if ((!image.modifiedImage || !image.localAsset) && imagePath.length <= 0) {
        return NO;
    }
    
    NSData * imageData = nil;
    if (image.modifiedImage) {
        imageData = UIImageJPEGRepresentation(image.modifiedImage, 1.0);
    }
    else if (image.localAsset) {
        imageData = UIImageJPEGRepresentation([image localImage], 1.0);
    }
    
    BOOL result = [imageData writeToFile:imagePath atomically:YES];
    imageData = nil;
    
    if (result) {
        
        image.modifiedImage = nil;
        image.localAsset = nil;
        image.imagePath = imagePath;
        
    }
    
    return result;
}

#pragma mark - Delete

-(BOOL)deleteAlbum:(DAAlbum *)album {
    
    NSString * albumPath = [self pathForAlbum:album];
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:albumPath error:nil];
    if (success) {
        
        NSMutableArray * savedAlbums = [self savedAlbums].mutableCopy;
        [savedAlbums removeObject:album];
        success = [self saveAlbumsToDisk:savedAlbums.copy];
    }
    
    return success;
}


#pragma mark - Utilities

-(NSString *)pathForAlbum:(DAAlbum *)album {
    
    return [self.documentsDirectoryPath stringByAppendingPathComponent:album.name];
}

-(NSString *)pathForImage:(DAImage *)image inAlbum:(DAAlbum *)album {
    
    if (image.imagePath) {
        return image.imagePath;
    }
    
    NSString * albumPath = [self pathForAlbum:album];
    int count = (int)[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:albumPath error:nil] count];
    NSString * imagePath = [albumPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image-%d.jpg", count + 1]];
    
    return imagePath;
}



-(BOOL)createFolderForAlbumIfNecesary:(DAAlbum *)album {
    
    NSString * path = [self.documentsDirectoryPath stringByAppendingPathComponent:album.name];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path isDirectory:nil]) {
        return [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return YES;
}


@end
