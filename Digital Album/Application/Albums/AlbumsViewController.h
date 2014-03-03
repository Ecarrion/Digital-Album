//
//  AlbumsViewController.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumsViewController : GAITrackedViewController {
    
    
    __weak IBOutlet UICollectionView *albumsCollectionView;
    __weak IBOutlet UIImageView *noAlbumsImageView;
    
    
}

@end
