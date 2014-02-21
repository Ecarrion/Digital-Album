//
//  ADImage.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "DAImage.h"

@interface DAImage ()

@end 



@implementation DAImage

#pragma mark - Digital Album Image

-(DAImage *)imageByCopyingLocalAsset:(ALAsset *)imageAsset {
    
    DAImage * image  = [[DAImage alloc] init];
    return image;
}

-(UIImage *)image {
    
    return nil;
}

#pragma mark - Phone Image
+(DAImage *)imageWithLocalAsset:(ALAsset *)asset {
    
    DAImage * image  = [[DAImage alloc] init];
    image.localAsset = asset;
    image.date = [image.localAsset valueForProperty:ALAssetPropertyDate];
    
    return image;
}

-(UIImage *)localImage {
    
	return [UIImage imageWithCGImage:self.localAsset.defaultRepresentation.fullScreenImage];
}

-(UIImage *)localThumbnailPreservingAspectRatio:(BOOL)preservingAspectRatio {
    
	CGImageRef tImage = nil;
    
    if (preservingAspectRatio) {
        tImage = self.localAsset.aspectRatioThumbnail;
    } else {
        tImage = self.localAsset.thumbnail;
    }
	
	return [UIImage imageWithCGImage:tImage];
}


@end
