//
//  ImageManager.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAImage.h"

@interface ImageManager : NSObject

+(void)phoneImagesWithBlock:(void(^)(NSArray * photos, NSError * error))block;

@end
