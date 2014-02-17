//
//  ADImage.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "DAImage.h"
#import <CoreLocation/CoreLocation.h>

typedef void (^completionGeocodeBlock)();

@interface DAImage ()

@property (atomic, copy) completionGeocodeBlock completionBlock;

@end



@implementation DAImage


+(DAImage *)imageWithLocalAsset:(ALAsset *)asset {
    
    DAImage * image  = [[DAImage alloc] init];
    image.localAsset = asset;
    image.date = [image.localAsset valueForProperty:ALAssetPropertyDate];
    
    return image;
}

-(UIImage *)localImage {
	return [UIImage imageWithCGImage:self.localAsset.defaultRepresentation.fullScreenImage];
}

-(UIImage *)localThumbnailPreservingAspectRatio:(BOOL)preservingAspectRatio
{
	CGImageRef tImage = nil;
    
    if (preservingAspectRatio) {
        tImage = self.localAsset.aspectRatioThumbnail;
    } else {
        tImage = self.localAsset.thumbnail;
    }
	
	return [UIImage imageWithCGImage:tImage];
}



-(void)locationDescriptionWithBlock:(void (^)(NSString *, NSError *))block {
    
    self.completionBlock = block;
    if (self.locationDescription) {
        
        if (self.completionBlock) {
            self.completionBlock(self.locationDescription, nil);
            self.completionBlock = nil;
        }
        return;
    }
    
    CLLocation * location = [self.localAsset valueForProperty:ALAssetPropertyLocation];
    if (!location) {
        
        NSError * error = [NSError errorWithDomain:@"Location Domain" code:404 userInfo:nil];
        
        if (self.completionBlock) {
            self.completionBlock(self.locationDescription, error);
            self.completionBlock = nil;
        }
        
        return;
    }
    
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (!error && placemarks.count) {
            
            CLPlacemark * mark = placemarks[0];
            self.locationDescription = @"";
            
            NSString * city = mark.addressDictionary[@"City"];
            if (mark.subLocality && city) {
                self.locationDescription = [NSString stringWithFormat:@"%@, %@", mark.subLocality, city];
            } else {
                if (city) {
                    self.locationDescription = city;
                }
            }
        }
        
        if (self.completionBlock) {
            self.completionBlock(self.locationDescription, error);
            self.completionBlock = nil;
        }
        
    }];
}

@end
