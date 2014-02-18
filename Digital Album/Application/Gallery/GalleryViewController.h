//
//  GalleryViewController.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/18/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAAlbum.h"

@interface GalleryViewController : UIViewController {
    
    __weak IBOutlet UICollectionView *imagesCollectionView;
    
}

@property (nonatomic, strong) DAAlbum * album;
@property (nonatomic, assign) int startingIndex;

-(void)toggleNavControls;

@end
