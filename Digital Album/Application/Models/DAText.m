//
//  DAText.m
//  Digital Album
//
//  Created by Ernesto Carrión on 2/23/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "DAText.h"
#import "AlbumManager.h"

//Archive
#define kTextContentKey @"kTextContentKey"
#define kTextViewDictionaryKey @"kTextViewDictionaryKey"

//View Dictionary
#define kTextViewTransformKey @"kTextViewTransformKey"
#define kTextViewCenterKey @"kTextViewCenterKey"
#define kTextViewZPositionKey @"kTextViewZPositionKey"

@interface DAText ()

@property (nonatomic, strong) NSMutableDictionary * viewDictionary;

@end

@implementation DAText

#pragma mark - NSCopying

- (id)init {
    
    self = [super init];
    if (self) {
        
        self.viewDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    DAText * text = [[DAText alloc] init];
    text.text = [aDecoder decodeObjectForKey:kTextContentKey];
    text.viewDictionary = [aDecoder decodeObjectForKey:kTextViewDictionaryKey];
    return text;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.text forKey:kTextContentKey];
    [aCoder encodeObject:self.viewDictionary forKey:kTextViewDictionaryKey];
}

-(void)setViewTransform:(CGAffineTransform)viewTransform {
    
    NSString * transformString = NSStringFromCGAffineTransform(viewTransform);
    self.viewDictionary[kTextViewTransformKey] = transformString;
}

-(CGAffineTransform)viewTransform {
    
    NSString * transformString = self.viewDictionary[kTextViewTransformKey];
    if (transformString) {
        return CGAffineTransformFromString(transformString);
    }
    
    return CGAffineTransformIdentity;
}

-(void)setViewCenter:(CGPoint)viewCenter {
    
    NSString * centerString = NSStringFromCGPoint(viewCenter);
    self.viewDictionary[kTextViewCenterKey] = centerString;
}

-(CGPoint)viewCenter {
    
    NSString * centerString = self.viewDictionary[kTextViewCenterKey];
    if (centerString) {
        return CGPointFromString(centerString);
    }
    
    return CGPointZero;
}

-(void)setZPosition:(NSInteger)zPosition {
    
    NSString * zPositionString = [@(zPosition) stringValue];
    self.viewDictionary[kTextViewZPositionKey] = zPositionString;
}

-(NSInteger)zPosition {
    
    NSString * zPositionString = self.viewDictionary[kTextViewZPositionKey];
    return [zPositionString integerValue];
}


@end
