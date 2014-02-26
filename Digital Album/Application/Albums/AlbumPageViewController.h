//
//  AlbumPageViewController.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAPage.h"

@class AlbumPageViewController;
@protocol AlbumPageDelegate <NSObject>

-(void)pageController:(AlbumPageViewController *)page imageTapped:(DAImage *)image;
-(void)didSelectCreateNewPage;
-(void)didSelectDeletePage;

@end

@interface AlbumPageViewController : UIViewController {
    
    __weak IBOutlet UIImageView *backgroundImageView;
    __weak IBOutlet UIView *canvas;
}


@property (strong, nonatomic) DAPage * page;
@property (nonatomic, weak) id<AlbumPageDelegate> delegate;

-(id)initWithPage:(DAPage *)page;
-(void)enableEditMode:(BOOL)edit;

-(void)commitChanges;
-(void)redrawView;
-(void)disregardChanges;

@end
