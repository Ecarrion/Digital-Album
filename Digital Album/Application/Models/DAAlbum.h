//
//  DAAlbum.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAPage.h"

@interface DAAlbum : NSObject <NSCoding>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * coverImageName;
@property (nonatomic, strong) NSArray * pages;


-(NSArray *)allImages;
-(DAImage *)topImage;


@end
