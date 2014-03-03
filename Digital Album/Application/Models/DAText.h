//
//  DAText.h
//  Digital Album
//
//  Created by Ernesto Carrión on 2/23/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAText : NSObject <NSCoding>

//Digital Album Image
@property (nonatomic, strong) NSString * text;

@property (nonatomic, assign) CGAffineTransform viewTransform;
@property (nonatomic, assign) CGPoint viewCenter;
@property (nonatomic, assign) NSInteger zPosition;


@end
