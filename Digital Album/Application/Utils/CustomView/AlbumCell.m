//
//  AlbumCell.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "AlbumCell.h"

@implementation AlbumCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib {
    
    float distance = 500;
    CATransform3D basicTrans = CATransform3DIdentity;
    basicTrans.m34 = 1.0 / -distance;
    basicTrans = CATransform3DRotate(basicTrans, 25 * M_PI / 180, 0.0f, 1.0f, 0.0f);
    self.nameLabel.layer.transform = basicTrans;
    self.nameLabel.layer.zPosition = 20;
    
}

-(void)prepareForReuse {
    
    self.thumbImageView.image = nil;
    self.nameLabel.text = @"";
}

@end
