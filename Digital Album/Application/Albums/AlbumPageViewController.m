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

-(id)initWithImage:(DAImage *)image {
    
    self = [super init];
    if (self) {
        
        self.image = image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = [self.image localImage];
    
    CGPoint center = self.imageView.center;
    self.imageView.frame = [self.imageView contentModetRect];
    self.imageView.center = center;
    self.imageView.layer.allowsEdgeAntialiasing = YES;
    
    self.imageView.layer.borderWidth = 3;
    
    [self enableEditMode:NO];
    [self loadViewAttributes];
}

-(void)loadViewAttributes {
    
    self.imageView.transform = self.image.viewTransform;
    
    CGPoint center = self.image.viewCenter;
    if (!CGPointEqualToPoint(center, CGPointZero)) {
        
        self.imageView.center = center;
        
    } else {
        
        self.imageView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    }
}

-(void)enableEditMode:(BOOL)edit {
    
    if (edit) {
        
        [self setUpEditionImageGestureRecognizers];
        
    } else {
        
        [self setUpReadOnlyGesturesRecognizers];
        
    }
    
    UIColor * color = edit ? [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood-texture-2.png"]] : [UIColor clearColor];
    self.imageView.layer.borderColor = color.CGColor;
}

-(void)commitChanges {
    
    self.image.viewTransform = self.imageView.transform;
    self.image.viewCenter = self.imageView.center;
}

#pragma mark - Gestures Recognizers

-(void)removeGesturesRecognizers {
    
    for (UIGestureRecognizer * gr in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gr];
    }
    
    for (UIGestureRecognizer * gr in self.imageView.gestureRecognizers) {
        [self.imageView removeGestureRecognizer:gr];
    }
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
	[pinchRecognizer setDelegate:self];
	[self.view addGestureRecognizer:pinchRecognizer];
    pinchRecognizer.delegate = self;
    
	UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
	[rotationRecognizer setDelegate:self];
	[self.view addGestureRecognizer:rotationRecognizer];
    rotationRecognizer.delegate = self;
    
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
	[self.imageView addGestureRecognizer:panRecognizer];
    panRecognizer.delegate = self;
}

-(void)imageTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    if ([self.delegate respondsToSelector:@selector(pageController:imageTapped:)]) {
        
        [self.delegate pageController:self imageTapped:self.image];
    }
}

-(void)scale:(UIPinchGestureRecognizer *)gestureRecognizer {
    
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (lastScale - [gestureRecognizer scale]);
    
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [self.imageView setTransform:newTransform];
    
    lastScale = [gestureRecognizer scale];
}

-(void)rotate:(UIRotationGestureRecognizer *)gestureRecognizer {
    
    if([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        
        lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (lastRotation - [gestureRecognizer rotation]);
    
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [self.imageView setTransform:newTransform];
    lastRotation = [gestureRecognizer rotation];
}

-(void)move:(UIPanGestureRecognizer *)gestureRecognizer {
    
    CGPoint translatedPoint = [gestureRecognizer translationInView:self.view];
    
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        firstX = [self.imageView center].x;
        firstY = [self.imageView center].y;
    }
    
    translatedPoint = CGPointMake(firstX + translatedPoint.x, firstY + translatedPoint.y);
    [self.imageView setCenter:translatedPoint];
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
