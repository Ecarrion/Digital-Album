//
//  AlbumPageViewController.h
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAImage.h"

@protocol AlbumPageDelegate <NSObject>

-(void)imageTapped:(DAImage *)image;

@end

@interface AlbumPageViewController : UIViewController {
    
    __weak IBOutlet UIImageView *imageView;
}

@property (strong, nonatomic)  DAImage * image;
@property (nonatomic, weak) id<AlbumPageDelegate> delegate;

-(id)initWithImage:(DAImage *)image;

@end
