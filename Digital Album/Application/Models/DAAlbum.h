//
//  DAAlbum.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAImage.h"

@interface DAAlbum : NSObject <NSCoding>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * coverImageName;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, strong) NSArray * pages;

+(DAAlbum *)AlbumWithGroup:(ALAssetsGroup *)group;
-(DAImage *)topImage;


@end
