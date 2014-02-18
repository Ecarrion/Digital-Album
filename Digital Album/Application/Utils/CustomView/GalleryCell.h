//
//  GalleryCell.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/18/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryCell : UICollectionViewCell <UIScrollViewDelegate> {
    
    
}

@property (nonatomic, weak) IBOutlet UIImageView * fullImageView;

-(void)resizeImageView;

@end
