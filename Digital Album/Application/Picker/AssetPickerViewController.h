//
//  AssetPickerViewController.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/18/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateAlbumViewController.h"


@protocol AssetPickerDelegate <NSObject>

-(void)didSelectImages:(NSArray *)images;

@end

@interface AssetPickerViewController : GAITrackedViewController {
    
    __weak IBOutlet UICollectionView *imagesCollectionView;
    IBOutlet UIButton *titleButtonView;
    
}

@property (nonatomic, strong) NSArray * phoneAlbums;
@property (nonatomic, weak) id<AssetPickerDelegate> delegate;

@end
