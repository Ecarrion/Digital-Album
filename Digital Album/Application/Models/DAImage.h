//
//  ADImage.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface DAImage : NSObject <NSCoding>

//Digital Album Image
@property (nonatomic, strong) NSString * imagePath;
@property (nonatomic, strong) UIImage * modifiedImage;

@property (nonatomic, assign) CGAffineTransform viewTransform;
@property (nonatomic, assign) CGPoint viewCenter;

-(BOOL)saveModifiedImage;

//Phone Image
@property(nonatomic, strong) ALAsset * localAsset;
@property(nonatomic, assign) ALAssetsGroupType groupType;

+(DAImage *)imageWithLocalAsset:(ALAsset *)asset;
-(UIImage *)localThumbnailPreservingAspectRatio:(BOOL)preservingAspectRatio;



//Common
-(UIImage *)localImage;


@end
