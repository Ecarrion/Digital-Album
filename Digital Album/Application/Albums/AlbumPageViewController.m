//
//  AlbumPageViewController.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "AlbumPageViewController.h"
#import "UIImageView+AspectSize.h"

@interface AlbumPageViewController () <UIGestureRecognizerDelegate> {
    
    double lastScale;
    double lastRotation;
    double firstX;
    double firstY;
    
    BOOL inEditMode;
}

@end

@implementation AlbumPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithPage:(DAPage *)page {
    
    self = [super init];
    if (self) {
        
        self.page = page;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.imageView.image = [self.image localImage];
#warning figure out local image

    #warning figure out view pimping
    /*
    CGPoint center = self.imageView.center;
    self.imageView.frame = [self.imageView contentModetRect];
    self.imageView.center = center;
    self.imageView.layer.allowsEdgeAntialiasing = YES;
    
    self.imageView.layer.borderWidth = 3;
     */
    
    [self enableEditMode:NO];
    [self showBackgroundImageViewIfNecesary];
    [self loadViewAttributes];
     
}

-(void)showBackgroundImageViewIfNecesary {
    
    [UIView transitionWithView:backgroundImageView duration:0.2f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
        if (inEditMode) {
            
            if (!self.page.images.count && !self.page.texts.count) {
                backgroundImageView.image = [UIImage imageNamed:@"long-press-text.png"];
            } else {
                backgroundImageView.image = nil;
            }
            
        } else {
            
            if (!self.page.images.count && !self.page.texts.count) {
                backgroundImageView.image = [UIImage imageNamed:@"tap-edit-text.png"];
            } else {
                backgroundImageView.image = nil;
            }
        }
        
    } completion:nil];
}

-(void)loadViewAttributes {
    
#warning figure out views transforms
    /*
    self.imageView.transform = self.image.viewTransform;
    
    CGPoint center = self.image.viewCenter;
    if (!CGPointEqualToPoint(center, CGPointZero)) {
        
        self.imageView.center = center;
        
    } else {
        
        self.imageView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    }
     */
}

-(void)enableEditMode:(BOOL)edit {
    
    inEditMode = edit;
    
    if (edit) {
        
        [self setUpEditionImageGestureRecognizers];
        
    } else {
        
        [self setUpReadOnlyGesturesRecognizers];
        
    }
    
    [self showBackgroundImageViewIfNecesary];
    
    //UIColor * color = edit ? [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood-texture-2.png"]] : [UIColor clearColor];
    //self.imageView.layer.borderColor = color.CGColor;
#warning border
}

-(void)commitChanges {
    
#warning figure out commit changes
    
    /*
    self.image.viewTransform = self.imageView.transform;
    self.image.viewCenter = self.imageView.center;
     */
}

#pragma mark - Gestures Recognizers

-(void)removeGesturesRecognizers {
    
    for (UIGestureRecognizer * gr in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gr];
    }
    
#warning gestureRecognizers
    /*
    for (UIGestureRecognizer * gr in self.imageView.gestureRecognizers) {
        [self.imageView removeGestureRecognizer:gr];
    }
     */
}

-(void)setUpReadOnlyGesturesRecognizers {
    
    [self removeGesturesRecognizers];
    
    UITapGestureRecognizer * tapGestureRecornizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tapGestureRecornizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecornizer];
}

-(void)setUpEditionImageGestureRecognizers {
    
    [self removeGesturesRecognizers];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
	[self.view addGestureRecognizer:pinchRecognizer];
    pinchRecognizer.delegate = self;
    
	UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
	[self.view addGestureRecognizer:rotationRecognizer];
    rotationRecognizer.delegate = self;
    
    UILongPressGestureRecognizer * longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    [self.view addGestureRecognizer:longPressRecognizer];
    
    #warning gestureRecognizers
    /*
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[self.imageView addGestureRecognizer:panRecognizer];
    panRecognizer.delegate = self;
     */
}

-(void)imageTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    if ([self.delegate respondsToSelector:@selector(pageController:imageTapped:)]) {
        
#warning figure out wich image was tapped
        //[self.delegate pageController:self imageTapped:self.image];
    }
}

-(void)scale:(UIPinchGestureRecognizer *)gestureRecognizer {
    
    #warning gestureRecognizers
    /*
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (lastScale - [gestureRecognizer scale]);
    
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [self.imageView setTransform:newTransform];
    
    lastScale = [gestureRecognizer scale];
     */
}

-(void)rotate:(UIRotationGestureRecognizer *)gestureRecognizer {
    
    #warning gestureRecognizers
    /*
    if([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        
        lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (lastRotation - [gestureRecognizer rotation]);
    
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [self.imageView setTransform:newTransform];
    lastRotation = [gestureRecognizer rotation];
     */
}

-(void)move:(UIPanGestureRecognizer *)gestureRecognizer {
    
    #warning gestureRecognizers
    /*
    CGPoint translatedPoint = [gestureRecognizer translationInView:self.view];
    
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        firstX = [self.imageView center].x;
        firstY = [self.imageView center].y;
    }
    
    translatedPoint = CGPointMake(firstX + translatedPoint.x, firstY + translatedPoint.y);
    [self.imageView setCenter:translatedPoint];
     */
}

-(void)longPressRecognized:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    [UIActionSheet showInView:self.navigationController.view withTitle:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete page" otherButtonTitles:@[@"Add new page", @"Add images", @"Add text"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        
        switch (buttonIndex) {
            
            case 0: {
                if ([self.delegate respondsToSelector:@selector(didSelectDeletePage)]) {
                    [self.delegate didSelectDeletePage];
                }
                break;
            }
                
            case 1: {
                if ([self.delegate respondsToSelector:@selector(didSelectCreateNewPage)]) {
                    [self.delegate didSelectCreateNewPage];
                }
                break;
            }
                
            case 2: {
                if ([self.delegate respondsToSelector:@selector(didSelectAddImages)]) {
                    [self.delegate didSelectCreateNewPage];
                }
                break;
            }
                
            case 3: {
                puts("Text");
                break;
            }
            
                
            case 4: {
                //Cancel
                break;
            }
                
            default:
                break;
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && self.view.window == nil) {
        
        self.view = nil;
    }
    
    if (![self isViewLoaded]) {
        
        //Clean outlets here
    }
    
    //Clean rest of resources here eg:arrays, maps, dictionaries, etc
}


@end
