//
//  AlbumPageViewController.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "AlbumPageViewController.h"
#import "UIImageView+AspectSize.h"
#import "AssetPickerViewController.h"

#import "UIView+GestureRecognizers.h"

@interface AlbumPageViewController () <UIGestureRecognizerDelegate, AssetPickerDelegate> {
    
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
        
        [self setUpMainEditionGestureRecognizers];
        
    } else {
        
        [self setUpReadOnlyGesturesRecognizers];
        
    }
    
    [self showBackgroundImageViewIfNecesary];
    
}

-(void)commitChanges {
    
#warning figure out commit changes
    
    /*
    self.image.viewTransform = self.imageView.transform;
    self.image.viewCenter = self.imageView.center;
     */
}

-(void)launchAssetPicker {
    
    AssetPickerViewController * apvc = [[AssetPickerViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:apvc];
    apvc.delegate = self;
    [self presentViewController:navController animated:YES completion:nil];
}

-(UIImageView *)viewForImage:(DAImage *)image {
    
    UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    view.contentMode = UIViewContentModeScaleAspectFit;
    view.image = [image localImage];
    view.frame = [view contentModetRect];
    view.layer.allowsEdgeAntialiasing = YES;
    view.userInteractionEnabled = YES;
    
    CGSize  superSize = self.view.frame.size;
    view.center = CGPointMake(superSize.width / 2.0, superSize.height / 2.0);
    
    UIColor * color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood-texture-2.png"]];
    view.layer.borderWidth = 5;
    view.layer.borderColor = color.CGColor;
    
    return view;
}

#pragma mark - Asset Picker delegate

-(void)didSelectImages:(NSArray *)images {
    
    int lowerBound = -20;
    int upperBound = 20;
    
    for (DAImage * image in images) {
        
        int angle = lowerBound + arc4random() % (upperBound - lowerBound);
        
        UIImageView * imgV = [self viewForImage:image];
        imgV.transform = CGAffineTransformRotate(imgV.transform, angle * M_PI / 180.0);
        [self.view addSubview:imgV];
        
        [self setUpEditionImageGestureRecognizersToView:imgV];
    }
    
    self.page.images = [self.page.images arrayByAddingObjectsFromArray:images]; 
    [self showBackgroundImageViewIfNecesary];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Gestures Recognizers

-(void)removeGesturesRecognizersToView:(UIView *)view {
    
    for (UIGestureRecognizer * gr in view.gestureRecognizers) {
        [view removeGestureRecognizer:gr];
    }
}

-(void)setUpReadOnlyGesturesRecognizers {
    
    [self removeGesturesRecognizersToView:self.view];
    
    UITapGestureRecognizer * tapGestureRecornizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tapGestureRecornizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecornizer];
}

-(void)setUpMainEditionGestureRecognizers {
    
    [self removeGesturesRecognizersToView:self.view];
    
    UILongPressGestureRecognizer * longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    [self.view addGestureRecognizer:longPressRecognizer];
}

-(void)setUpEditionImageGestureRecognizersToView:(UIView *)view {
    
    
    [self removeGesturesRecognizersToView:view];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
	[view addGestureRecognizer:pinchRecognizer];
    pinchRecognizer.delegate = self;
    
	UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
	[view addGestureRecognizer:rotationRecognizer];
    rotationRecognizer.delegate = self;
    
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[view addGestureRecognizer:panRecognizer];
    panRecognizer.delegate = self;
}

-(void)imageTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    if ([self.delegate respondsToSelector:@selector(pageController:imageTapped:)]) {
        
#warning figure out wich image was tapped
        //[self.delegate pageController:self imageTapped:self.image];
    }
}

-(void)scale:(UIPinchGestureRecognizer *)gestureRecognizer {
    
    UIView * view = gestureRecognizer.view;
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        view.lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (view.lastScale - [gestureRecognizer scale]);
    
    CGAffineTransform currentTransform = view.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [view setTransform:newTransform];
    
    view.lastScale = [gestureRecognizer scale];
}

-(void)rotate:(UIRotationGestureRecognizer *)gestureRecognizer {
    
    UIView * view = gestureRecognizer.view;
    if([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        
        view.lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (view.lastRotation - [gestureRecognizer rotation]);
    
    CGAffineTransform currentTransform = view.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [view setTransform:newTransform];
    view.lastRotation = [gestureRecognizer rotation];

}

-(void)move:(UIPanGestureRecognizer *)gestureRecognizer {
    

    CGPoint translatedPoint = [gestureRecognizer translationInView:self.view];
    UIView * view = gestureRecognizer.view;
    
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        view.firstX = [view center].x;
        view.firstY = [view center].y;
    }
    
    translatedPoint = CGPointMake(view.firstX + translatedPoint.x, view.firstY + translatedPoint.y);
    [view setCenter:translatedPoint];
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
                [self launchAssetPicker];
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
