//
//  ADImage.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "DAImage.h"
#import "AlbumManager.h"

//Archive
#define kImagePathKey @"kImagePathKey"
#define kViewDictionaryKey @"kViewDictionaryKey"

//View Dictionary
#define kViewTransformKey @"kViewTransformKey"
#define kViewCenterKey @"kViewCenterKey"

@interface DAImage ()

@property (nonatomic, strong) NSMutableDictionary * viewDictionary;

@end 

@implementation DAImage

#pragma mark - NSCopying

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    DAImage * image = [[DAImage alloc] init];
    image.imagePath = [aDecoder decodeObjectForKey:kImagePathKey];
    image.viewDictionary = [aDecoder decodeObjectForKey:kViewDictionaryKey];
    return image;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.imagePath forKey:kImagePathKey];
    [aCoder encodeObject:self.viewDictionary forKey:kViewDictionaryKey];
}

#pragma mark - Digital Album Image

-(void)setViewTransform:(CGAffineTransform)viewTransform {
    
    NSString * transformString = NSStringFromCGAffineTransform(viewTransform);
    self.viewDictionary[kViewTransformKey] = transformString;
}

-(CGAffineTransform)viewTransform {
    
    NSString * transformString = self.viewDictionary[kViewTransformKey];
    if (transformString) {
        return CGAffineTransformFromString(transformString);
    }
    
    return CGAffineTransformIdentity;
}

-(void)setViewCenter:(CGPoint)viewCenter {
    
    NSString * centerString = NSStringFromCGPoint(viewCenter);
    self.viewDictionary[kViewCenterKey] = centerString;
}

-(CGPoint)viewCenter {
    
    NSString * centerString = self.viewDictionary[kViewCenterKey];
    if (centerString) {
        return CGPointFromString(centerString);
    }
    
    return CGPointZero;
}

#pragma mark - Phone Image
+(DAImage *)imageWithLocalAsset:(ALAsset *)asset {
    
    DAImage * image  = [[DAImage alloc] init];
    image.localAsset = asset;
    image.viewDictionary = [[NSMutableDictionary alloc] init];
    
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

-(BOOL)hasSomethingToSave {
    
    return self.modifiedImage != nil || self.localAsset != nil;
}

@end
