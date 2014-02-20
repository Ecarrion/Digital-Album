//
//  AssetPickerViewController.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/18/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetPickerViewController : UIViewController {
    
    __weak IBOutlet UICollectionView *imagesCollectionView;
    
    IBOutlet UIButton *titleButtonView;
    
}

@property (nonatomic, strong) NSArray * phoneAlbums;

@end
