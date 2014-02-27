//
//  DAPage.h
//  Digital Album
//
//  Created by Ernesto Carrión on 2/23/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAImage.h"
#import "DAText.h"


@interface DAPage : NSObject <NSCoding>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, strong) NSArray * texts;

@end
