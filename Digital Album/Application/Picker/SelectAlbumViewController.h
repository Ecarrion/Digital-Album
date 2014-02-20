//
//  SelectAlbumViewController.h
//  Digital Album
//
//  Created by Ernesto Carrión on 2/19/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAAlbum.h"

#define SELECT_ALBUM_CELL_HEIGHT 64.f

@protocol SelectAlbumDelegate <NSObject>

-(void) didSelectAlbum:(DAAlbum *) album;
-(void) didCancelSelection;

@end

@interface SelectAlbumViewController : UIViewController {
    
    __weak IBOutlet UITableView *albumsTableView;
    
}


@property (nonatomic, strong) NSArray * albums;
@property (nonatomic, strong) id<SelectAlbumDelegate> delegate;



-(void)showTableViewWithAnimationOnCompletion:(void(^)(void))block;
-(void)hideTableViewWithAnimationOnCompletion:(void(^)(void))block;

@end
