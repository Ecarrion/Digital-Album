//
//  AssetCell.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/19/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "AssetCell.h"

@implementation AssetCell


-(void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    self.selectionImageView.hidden = !selected;
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
