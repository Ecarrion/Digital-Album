//
//  ImageManager.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "ImageManager.h"
#import "DAImage.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ImageManager


+(void)phoneImagesWithBlock:(void(^)(NSArray * photos, NSError * error))block {
    
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    __block NSMutableArray * imagesArray = [NSMutableArray array];
    
    
    [lib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result) {
                NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                if ([assetType isEqualToString:ALAssetTypePhoto]) {
                   
                    DAImage * image = [DAImage imageWithLocalAsset:result];
                    [imagesArray addObject:image];
                }
            }
        }];
        
        //If the group is nill is because the iteration has ended
        if (!group) {
            block(imagesArray, nil);
        }
        
    } failureBlock:^(NSError *error) {
        
        if (block)
            block(nil, error);
    }];
}

@end
