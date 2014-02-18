//
//  GalleryCell.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/18/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "GalleryCell.h"
#import "UIImageView+AspectSize.h"

@implementation GalleryCell {
    
    
    __weak IBOutlet UIScrollView *zoomScrollView;
}

-(void)awakeFromNib {
    
    zoomScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.fullImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    self.fullImageView.frame = [self centeredFrameForScrollView:zoomScrollView andUIView:self.fullImageView];
}


-(void)resizeImageView {
    
    [zoomScrollView setZoomScale:1.f animated:NO];
    
    self.fullImageView.frame = zoomScrollView.bounds;
    self.fullImageView.frame = [self.fullImageView contentModetRect];
    self.fullImageView.center = zoomScrollView.center;
}



- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
    
    CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    
    return frameToCenter;
}


@end
