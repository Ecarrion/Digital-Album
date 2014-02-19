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


@end
