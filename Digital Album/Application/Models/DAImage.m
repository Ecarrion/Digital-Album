//
//  ADImage.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "DAImage.h"
#import "AlbumManager.h"

#define kImagePathKey @"kImagePathKey"


@interface DAImage ()

@end 

@implementation DAImage

#pragma mark - NSCopying

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    DAImage * image = [[DAImage alloc] init];
    image.imagePath = [aDecoder decodeObjectForKey:kImagePathKey];
    return image;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.imagePath forKey:kImagePathKey];
}

#pragma mark - Digital Album Image

-(BOOL)saveModifiedImage {
    
    return [[AlbumManager manager] saveImage:self atPath:self.imagePath];
}

#pragma mark - Phone Image
+(DAImage *)imageWithLocalAsset:(ALAsset *)asset {
    
    DAImage * image  = [[DAImage alloc] init];
    image.localAsset = asset;
    
    return image;
}


-(UIImage *)localThumbnailPreservingAspectRatio:(BOOL)preservingAspectRatio {
    
    if(self.localAsset) {
        
        CGImageRef tImage = nil;
        
        if (preservingAspectRatio) {
            tImage = self.localAsset.aspectRatioThumbnail;
        } else {
            tImage = self.localAsset.thumbnail;
        }
        
        return [UIImage imageWithCGImage:tImage];
    }
    
    return nil;
}

#pragma mark - Common

-(UIImage *)localImage {
    
    UIImage * image = nil;
    if (self.localAsset) {
        
        image = [UIImage imageWithCGImage:self.localAsset.defaultRepresentation.fullScreenImage];
        
    } else if (self.imagePath) {
        
        NSData * data = [NSData dataWithContentsOfFile:self.imagePath];
        image = [[UIImage alloc] initWithData:data scale:1];
    }
    
    return image;
}

@end
