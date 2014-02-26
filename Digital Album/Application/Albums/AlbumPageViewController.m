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

@property (nonatomic, strong) NSMutableArray * imageViews;
@property (nonatomic, strong) NSMutableArray * labels;

@property (nonatomic, strong) NSMutableArray * tempImageViews;
@property (nonatomic, strong) NSMutableArray * tempLabels;

@property (nonatomic, strong) NSMutableArray * tempDAImages;
@property (nonatomic, strong) NSMutableArray * tempDALabels;

@end

@implementation AlbumPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.imageViews = [NSMutableArray array];
        self.labels = [NSMutableArray array];
        self.tempImageViews = [NSMutableArray array];
        self.tempLabels = [NSMutableArray array];
        self.tempDAImages = [NSMutableArray array];
        self.tempDALabels = [NSMutableArray array];
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
    
    [self enableEditMode:NO];
    [self redrawView];
     
}

-(void)showBackgroundImageViewIfNecesary {
    
    int viewCount = self.imageViews.count + self.tempImageViews.count + self.labels.count + self.tempLabels.count;
    
    [UIView transitionWithView:backgroundImageView duration:0.2f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
        if (inEditMode) {
            
            if (viewCount == 0) {
                backgroundImageView.image = [UIImage imageNamed:@"long-press-text.png"];
            } else {
                backgroundImageView.image = nil;
            }
            
        } else {
            
            if (viewCount == 0) {
                backgroundImageView.image = [UIImage imageNamed:@"tap-edit-text.png"];
            } else {
                backgroundImageView.image = nil;
            }
        }
        
    } completion:nil];
}

-(void)redrawView {
    
    [self cleanCanvas];
    
    for (DAImage * image in self.page.images) {
        
        UIImageView * view = [self viewForImage:image];
        [self setUpEditionImageGestureRecognizersToView:view];
        [canvas addSubview:view];
        [self.imageViews addObject:view];
    }
    
    //TODO: texts
    
    [self showBackgroundImageViewIfNecesary];
}

-(void)cleanCanvas {
    
    for (UIView * view in canvas.subviews) {
        [view removeFromSuperview];
    }
    [self cleanArrays];
}

-(void)cleanArrays {
    
    [self.imageViews removeAllObjects];
    [self.tempImageViews removeAllObjects];
    [self.labels removeAllObjects];
    [self.tempLabels removeAllObjects];
    [self.tempDAImages removeAllObjects];
    [self.tempDALabels removeAllObjects];
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
    
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * imgV, NSUInteger idx, BOOL *stop) {
        
        DAImage * image = self.page.images[idx];
        image.viewCenter = imgV.center;
        image.viewTransform = imgV.transform;
        
    }];
    
    
    [self.tempImageViews enumerateObjectsUsingBlock:^(UIImageView * imgV, NSUInteger idx, BOOL *stop) {
        
        DAImage * image = self.tempDAImages[idx];
        image.viewCenter = imgV.center;
        image.viewTransform = imgV.transform;
    }];
    
    self.page.images = [self.page.images arrayByAddingObjectsFromArray:self.tempDAImages];
    
}

-(void)disregardChanges {
    
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * imgV, NSUInteger idx, BOOL *stop) {
        
        DAImage * image = self.page.images[idx];
        imgV.center = image.viewCenter;
        imgV.transform = image.viewTransform;
        
    }];
    
    [self.tempImageViews enumerateObjectsUsingBlock:^(UIImageView * imgV, NSUInteger idx, BOOL *stop) {
        [imgV removeFromSuperview];
    }];
    [self.tempDAImages removeAllObjects];
    
    [self showBackgroundImageViewIfNecesary];
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
    
    //View saved Transformation
    view.transform = image.viewTransform;
    CGPoint center = image.viewCenter;
    
    if (!CGPointEqualToPoint(center, CGPointZero)) {
        view.center = center;
        
    } else {
        CGSize  superSize = self.view.frame.size;
        view.center = CGPointMake(superSize.width / 2.0, superSize.height / 2.0);
    }
    
    //Border
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
        [self setUpEditionImageGestureRecognizersToView:imgV];
        
        [canvas addSubview:imgV];
        [self.tempImageViews addObject:imgV];
        [self.tempDAImages addObject:image];

    }
    
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
    canvas.userInteractionEnabled = NO;
    
    UITapGestureRecognizer * tapGestureRecornizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tapGestureRecornizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecornizer];
}

-(void)setUpMainEditionGestureRecognizers {
    
    [self removeGesturesRecognizersToView:self.view];
    canvas.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer * longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    [self.view addGestureRecognizer:longPressRecognizer];
}

-(void)setUpEditionImageGestureRecognizersToView:(UIView *)view {
    
    
    if (view.gestureRecognizers.count == 0) {
        
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
        [self cleanArrays];
    }
    
    //Clean rest of resources here eg:arrays, maps, dictionaries, etc
}


@end
