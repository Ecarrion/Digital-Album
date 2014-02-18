//
//  AlbumCell.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ALBUM_CELL_SIZE CGSizeMake(105, 149)

@interface AlbumCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end
