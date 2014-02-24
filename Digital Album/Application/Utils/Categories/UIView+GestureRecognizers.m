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

static char const * lastScaleKey = "lastScaleKey";
static char const * lastRotationKey = "lastRotationKey";

@dynamic firstX;
@dynamic firstY;

@dynamic lastRotation;
@dynamic lastScale;

-(void)setFirstX:(double)firstX {
    
    objc_setAssociatedObject(self, firstXKey, @(firstX), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setFirstY:(double)firstY {
    
    objc_setAssociatedObject(self, firstYKey, @(firstY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setLastRotation:(double)lastRotation {
    
    objc_setAssociatedObject(self, lastRotationKey, @(lastRotation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setLastScale:(double)lastScale {
 
    objc_setAssociatedObject(self, lastScaleKey, @(lastScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(double)firstX {
    
    return [objc_getAssociatedObject(self, firstXKey) doubleValue];
}

-(double)firstY {
    
    return [objc_getAssociatedObject(self, firstYKey) doubleValue];
}

-(double)lastScale {
    
    return [objc_getAssociatedObject(self, lastScaleKey) doubleValue];
}

-(double)lastRotation {
    
    return [objc_getAssociatedObject(self, lastRotationKey) doubleValue];
}

@end
