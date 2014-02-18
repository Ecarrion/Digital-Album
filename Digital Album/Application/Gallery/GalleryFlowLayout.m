//
//  GalleryFlowLayout.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/18/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "GalleryFlowLayout.h"

@implementation GalleryFlowLayout


- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.minimumLineSpacing = 0;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = self.collectionView.bounds.size;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return self;
}


-(void)reloadLayout {
    
    self.minimumLineSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}


@end
