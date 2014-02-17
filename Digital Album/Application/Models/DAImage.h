//
//  ADImage.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface DAImage : NSObject

@property (nonatomic, strong) __block NSString * locationDescription;
@property (nonatomic, strong) NSDate * date;
@property(nonatomic, strong) ALAsset * localAsset;


+(DAImage *)imageWithLocalAsset:(ALAsset *)asset;

-(UIImage *)localThumbnailPreservingAspectRatio:(BOOL)preservingAspectRatio;
-(UIImage *)localImage;
-(void)locationDescriptionWithBlock:(void(^)(NSString * locationString, NSError * error))block;


@end
