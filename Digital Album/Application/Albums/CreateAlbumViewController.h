//
//  NewAlbumViewController.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/18/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAAlbum.h"

@protocol CreateAlbumDelegate <NSObject>

-(void)albumCreated:(DAAlbum *)album;

@end

@interface CreateAlbumViewController : UIViewController {
    
    
    __weak IBOutlet UITextField *albumNametextField;
    __weak IBOutlet UIScrollView *coversScrollView;
}

@property (nonatomic, weak) id<CreateAlbumDelegate> delegate;
@property (nonatomic, strong) NSArray * existingAlbums;

@end
