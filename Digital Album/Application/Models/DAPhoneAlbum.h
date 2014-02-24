//
//  DAPhoneAlbum.h
//  Digital Album
//
//  Created by Ernesto Carrión on 2/23/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DAImage.h"

@interface DAPhoneAlbum : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSArray * images;

+(DAPhoneAlbum *)AlbumWithGroup:(ALAssetsGroup *)group;
-(DAImage *)topImage;


@end
