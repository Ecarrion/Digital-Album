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
-(void)WillEnterInEditMode;

@end

@interface AlbumPageViewController : UIViewController {
    
    __weak IBOutlet UIImageView *backgroundImageView;
}


@property (strong, nonatomic) DAPage * page;
@property (nonatomic, weak) id<AlbumPageDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIView * canvas;

-(id)initWithPage:(DAPage *)page;
-(void)enableEditMode:(BOOL)edit;

-(void)commitChanges;
-(void)redrawView;
-(void)disregardChanges;

@end
