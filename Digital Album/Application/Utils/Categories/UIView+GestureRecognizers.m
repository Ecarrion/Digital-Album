//
//  UIView+GestureRecognizers.m
//  Digital Album
//
//  Created by Ernesto Carrión on 2/24/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "UIView+GestureRecognizers.h"
#import <objc/runtime.h>


@implementation UIView (GestureRecognizers)

static char const * firstXKey = "firstXKey";
static char const * firstYKey = "firstYKey";

@dynamic firstX;
@dynamic firstY;

-(void)setFirstX:(double)firstX {
    
    objc_setAssociatedObject(self, firstXKey, @(firstX), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setFirstY:(double)firstY {
    
    objc_setAssociatedObject(self, firstYKey, @(firstY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(double)firstX {
    
    return [objc_getAssociatedObject(self, firstXKey) doubleValue];
}

-(double)firstY {
    
    return [objc_getAssociatedObject(self, firstYKey) doubleValue];
}

@end
