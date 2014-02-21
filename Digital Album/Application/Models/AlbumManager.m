//
//  ImageManager.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "AlbumManager.h"

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

-(NSString *)pathForAlbum:(DAAlbum *)album {
    
    return [self.documentsDirectoryPath stringByAppendingPathComponent:album.name];
}

-(NSString *)pathForImage:(DAImage *)image inAlbum:(DAAlbum *)album {
    
    if (image.imagePath) {
        return image.imagePath;
    }
    
    NSString * albumPath = [self pathForAlbum:album];
    int count = (int)[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:albumPath error:nil] count];
    NSString * imagePath = [albumPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image-%d.jpg", count]];
    
    return imagePath;
}


- (id)init
{
    self = [super init];
    if (self) {
        
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        self.documentsDirectoryPath = basePath;
    }
    return self;
}

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

-(BOOL)saveAlbum:(DAAlbum *)album {
    
    for (DAImage * image in album.images) {
        
        [self saveImage:image inAlbum:album];
    }
    
    return YES;
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
    
    if (!image.modifiedImage || imagePath <= 0) {
        return NO;
    }
    
    BOOL result = [UIImageJPEGRepresentation(image.modifiedImage, 1.0) writeToFile:imagePath atomically:YES];
    if (result) {
        
        image.modifiedImage = nil;
        image.imagePath = imagePath;
    }
    
    return result;
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
