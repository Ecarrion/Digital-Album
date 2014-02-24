//
//  AssetCell.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/19/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "AssetCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation AssetCell

-(void)awakeFromNib {
    
    self.layer.borderWidth = 3;
    self.layer.borderColor = [UIColor clearColor].CGColor;
}

-(void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    
    self.selectionImageView.hidden = !selected;
    
    UIColor * color = selected ? [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood-texture-2.png"]] : [UIColor clearColor];
    self.layer.borderColor = color.CGColor;
    
}

-(void)prepareForReuse {
    
    [super prepareForReuse];
    [self setCounterNumber:0];
}

-(void)setCounterNumber:(int)counter {
    
    self.counterLabel.hidden = counter <= 0;
    self.counterLabel.text = [NSString stringWithFormat:@"%d", counter];
}


@end
