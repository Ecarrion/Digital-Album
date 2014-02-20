//
//  AssetCell.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/19/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;

-(void)setCounterNumber:(int)counter;


@end
