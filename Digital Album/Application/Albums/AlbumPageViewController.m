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
#import "TextMakerViewController.h"

#import "UIView+GestureRecognizers.h"

@interface AlbumPageViewController () <UIGestureRecognizerDelegate, AssetPickerDelegate, TextMakerDelegate> {
    
    BOOL inEditMode;
}

@property (nonatomic, strong) NSMutableArray * imageViews;
@property (nonatomic, strong) NSMutableArray * labels;

@property (nonatomic, strong) NSMutableArray * tempImageViews;
@property (nonatomic, strong) NSMutableArray * tempLabels;

@property (nonatomic, strong) NSMutableArray * tempDAImages;
@property (nonatomic, strong) NSMutableArray * tempDATexts;

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
        self.tempDATexts = [NSMutableArray array];
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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self enableEditMode:NO];
    [self redrawView];
     
}

-(void)redrawView {
    
    [self cleanCanvas];
    
    for (DAImage * image in self.page.images) {
        
        UIImageView * view = [self viewForImage:image];
        [self setUpEditionImageGestureRecognizersToView:view];
        [self.canvas addSubview:view];
        [self.imageViews addObject:view];
        view.layer.zPosition = image.zPosition;
    }
    
    for (DAText * text in self.page.texts) {
        
        UILabel * label = [self viewForText:text firstTime:NO];
        [self setUpEditionImageGestureRecognizersToView:label];
        [self.canvas addSubview:label];
        [self.labels addObject:label];
    }
    
    [self showBackgroundImageViewIfNecesary];
}

-(void)showBackgroundImageViewIfNecesary {
    
    NSUInteger viewCount = self.imageViews.count + self.tempImageViews.count + self.labels.count + self.tempLabels.count;
    
    [UIView transitionWithView:backgroundImageView duration:0.2f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
        if (viewCount == 0) {
            backgroundImageView.image = [UIImage imageNamed:@"long-press-text.png"];
        } else {
            backgroundImageView.image = nil;
        }
        
    } completion:nil];
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

#pragma mark - View Handling

-(void)commitChangesOnCompletion:(void(^)(NSArray * imagesToDelete, NSArray * textToDelete))block {
    
    //Images
    [self.imageViews addObjectsFromArray:self.tempImageViews];
    NSArray * allImages = [self.page.images arrayByAddingObjectsFromArray:self.tempDAImages];
    NSMutableArray * newImages = [NSMutableArray array];
    NSMutableArray * imagesToDelete = [NSMutableArray array];
    
    [self.imageViews.copy enumerateObjectsUsingBlock:^(UIImageView * imgV, NSUInteger idx, BOOL *stop) {
        
        if (imgV.alpha > 0) {
            
            DAImage * image = allImages[idx];
            image.viewCenter = imgV.center;
            image.viewTransform = imgV.transform;
            image.zPosition = [self.canvas.subviews indexOfObject:imgV];
            [newImages addObject:image];
            
        } else {
            
            DAImage * image = allImages[idx];
            [imagesToDelete addObject:image];
            [imgV removeFromSuperview];
            [self.imageViews removeObject:imgV];
        }
    }];
    
    self.page.images = [newImages copy];
    [self.tempImageViews removeAllObjects];
    [self.tempDAImages removeAllObjects];
    
    
    //Texts
    [self.labels addObjectsFromArray:self.tempLabels];
    NSArray * allTexts = [self.page.texts arrayByAddingObjectsFromArray:self.tempDATexts];
    NSMutableArray * newTexts = [NSMutableArray array];
    NSMutableArray * textsToDelete = [NSMutableArray array];
    
    [self.labels.copy enumerateObjectsUsingBlock:^(UILabel * label, NSUInteger idx, BOOL *stop) {
        
        if (label.alpha > 0) {
            
            DAText * text = allTexts[idx];
            text.viewCenter = label.center;
            text.viewTransform = label.transform;
            text.zPosition = [self.canvas.subviews indexOfObject:label] + 100;
            [newTexts addObject:text];
            
        } else {
            
            DAText * text = allTexts[idx];
            [textsToDelete addObject:text];
            [label removeFromSuperview];
            [self.labels removeObject:label];
        }
    }];
    
    self.page.texts = [newTexts copy];
    [self.tempLabels removeAllObjects];
    [self.tempDATexts removeAllObjects];
    
    [self showBackgroundImageViewIfNecesary];
    
    if (block) {
        block(imagesToDelete, textsToDelete);
    }
}

-(void)disregardChanges {
    
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * imgV, NSUInteger idx, BOOL *stop) {
        
        DAImage * image = self.page.images[idx];
        imgV.center = image.viewCenter;
        imgV.transform = image.viewTransform;
        imgV.layer.zPosition = image.zPosition;
        imgV.alpha = 1;
        
    }];
    
    [self.labels enumerateObjectsUsingBlock:^(UILabel * label, NSUInteger idx, BOOL *stop) {
        
        DAText * text = self.page.texts[idx];
        label.center = text.viewCenter;
        label.transform = text.viewTransform;
        label.layer.zPosition = text.zPosition;
        label.alpha = 1;
    }];
    
    [self.tempImageViews enumerateObjectsUsingBlock:^(UIImageView * imgV, NSUInteger idx, BOOL *stop) {
        [imgV removeFromSuperview];
    }];
    
    [self.tempLabels enumerateObjectsUsingBlock:^(UILabel * label, NSUInteger idx, BOOL *stop) {
        [label removeFromSuperview];
    }];
    
    [self.tempDAImages removeAllObjects];
    [self.tempImageViews removeAllObjects];
    [self.tempDATexts removeAllObjects];
    [self.tempLabels removeAllObjects];
    [self showBackgroundImageViewIfNecesary];
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

-(UILabel *)viewForText:(DAText *)text firstTime:(BOOL)firstTime {
    
    CGSize size = [text.text boundingRectWithSize:DEFAULT_DATEXT_MAX_SIZE options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : DEFAULT_DATEXT_FONT} context:nil].size;
    UILabel * view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.text = text.text;
    view.numberOfLines = 0;
    view.layer.allowsEdgeAntialiasing = YES;
    view.userInteractionEnabled = YES;
    view.transform = text.viewTransform;
    view.font = DEFAULT_DATEXT_FONT;
    view.textColor = DEFAULT_DATEXT_COLOR;
    view.layer.zPosition = text.zPosition;
    view.textAlignment = NSTextAlignmentCenter;
    
    
    if (firstTime) {
        CGSize  superSize = self.view.frame.size;
        view.center = CGPointMake(superSize.width / 2.0, superSize.height / 2.0);
    } else {
        view.center = text.viewCenter;
    }
    
    return view;
}

-(void)deleteImageForImageView:(UIImageView *)imageView {
    
    //Deletion of a saved image
    NSUInteger index = [self.imageViews indexOfObject:imageView];
    if (index != NSNotFound) {
        
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformScale(imageView.transform, 0.1, 0.1);
        } completion:^(BOOL finished) {
            imageView.transform = CGAffineTransformIdentity;
            imageView.alpha = 0;
        }];
    }
    
    //Deletion of a temporal image
    index = [self.tempImageViews indexOfObject:imageView];
    if (index != NSNotFound) {
        
        [self.tempDAImages removeObjectAtIndex:index];
        [self.tempImageViews removeObjectAtIndex:index];
        
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformScale(imageView.transform, 0.1, 0.1);
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
        }];
    }
}

-(void)deleteTextForLabel:(UILabel *)view {
    
    //Deletion of a saved text
    NSUInteger index = [self.labels indexOfObject:view];
    if (index != NSNotFound) {
        
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformScale(view.transform, 0.1, 0.1);
        } completion:^(BOOL finished) {
            view.transform = CGAffineTransformIdentity;
            view.alpha = 0;
        }];
    }
    
    //Deletion of a temporal text
    index = [self.tempLabels indexOfObject:view];
    if (index != NSNotFound) {
        
        [self.tempDATexts removeObjectAtIndex:index];
        [self.tempLabels removeObjectAtIndex:index];
        
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformScale(view.transform, 0.1, 0.1);
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
}

#pragma mark - Text Maker

-(void)launchTextMaker {
    
    TextMakerViewController * tmvc = [[TextMakerViewController alloc] init];
    tmvc.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:tmvc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void)didFinishGeneratingText:(DAText *)text {
    
    UILabel * view = [self viewForText:text firstTime:YES];
    [self.canvas addSubview:view];
    [self setUpEditionImageGestureRecognizersToView:view];
    
    [self.tempDATexts addObject:text];
    [self.tempLabels addObject:view];
    
    [self showBackgroundImageViewIfNecesary];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Creation"     // Event category (required)
                                                          action:@"Text added"  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];
    
}

#pragma mark - Asset Picker

-(void)launchAssetPicker {
    
    AssetPickerViewController * apvc = [[AssetPickerViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:apvc];
    apvc.delegate = self;
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)didSelectImages:(NSArray *)images {
    
    int lowerBound = -20;
    int upperBound = 20;
    int lastAngle = 0;
    int newAngle = 0;
    
    for (DAImage * image in images) {
        
        while (newAngle == lastAngle) {
            newAngle = lowerBound + arc4random() % (upperBound - lowerBound);
        }
        lastAngle = newAngle;
        
        UIImageView * imgV = [self viewForImage:image];
        imgV.transform = CGAffineTransformRotate(imgV.transform, (double)newAngle * M_PI / 180.0);
        [self setUpEditionImageGestureRecognizersToView:imgV];
        
        [self.canvas addSubview:imgV];
        [self.tempImageViews addObject:imgV];
        [self.tempDAImages addObject:image];
        
        imgV.layer.zPosition = 100;
    }
    
    [self showBackgroundImageViewIfNecesary];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Creation"     // Event category (required)
                                                          action:@"Images added"  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];
}

#pragma mark - Gestures Recognizers

-(void)removeGesturesRecognizersToView:(UIView *)view {
    
    for (UIGestureRecognizer * gr in view.gestureRecognizers) {
        [view removeGestureRecognizer:gr];
    }
}

-(void)setUpReadOnlyGesturesRecognizers {
    
    [self removeGesturesRecognizersToView:self.view];
    self.canvas.userInteractionEnabled = NO;
    
    UITapGestureRecognizer * tapGestureRecornizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tapGestureRecornizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecornizer];
    
    
    UILongPressGestureRecognizer * longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    [self.view addGestureRecognizer:longPressRecognizer];
}

-(void)setUpMainEditionGestureRecognizers {
    
    [self removeGesturesRecognizersToView:self.view];
    self.canvas.userInteractionEnabled = YES;
    
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
        
        self.canvas.userInteractionEnabled = YES;
        CGPoint point = [gestureRecognizer locationInView:self.canvas];
        UIView * view = [self.canvas hitTest:point withEvent:nil];
        self.canvas.userInteractionEnabled = NO;
                
        NSUInteger index = [self.imageViews indexOfObject:view];
        if (index != NSNotFound) {
            
            DAImage * image = self.page.images[index];
            [self.delegate pageController:self imageTapped:image];
        }
    }
}

-(void)scale:(UIPinchGestureRecognizer *)gestureRecognizer {
    
    UIView * view = gestureRecognizer.view;
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        view.lastScale = 1.0;
        view.layer.zPosition = 100;
        
        if ([view isKindOfClass:[UILabel class]]) {
            
            view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
            view.layer.zPosition = 100;
        }
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        if ([view isKindOfClass:[UILabel class]]) {
            view.backgroundColor = [UIColor clearColor];
        }
    }
    
    CGFloat scale = 1.0 - (view.lastScale - [gestureRecognizer scale]);
    
    CGAffineTransform currentTransform = view.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [view setTransform:newTransform];    
    view.lastScale = [gestureRecognizer scale];
}

-(void)rotate:(UIRotationGestureRecognizer *)gestureRecognizer {
    
    UIView * view = gestureRecognizer.view;
    
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        view.layer.zPosition = 100;
        if ([view isKindOfClass:[UILabel class]]) {
            
            view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
            view.layer.zPosition = 200;
        }
    }
    
    if([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
     
        if ([view isKindOfClass:[UILabel class]]) {
            view.backgroundColor = [UIColor clearColor];
        }
        
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
        [self.canvas bringSubviewToFront:view];
        view.layer.zPosition = 100;
        
        if ([view isKindOfClass:[UILabel class]]) {
            
            view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
            view.layer.zPosition = 200;
        }
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        if ([view isKindOfClass:[UILabel class]]) {
            view.backgroundColor = [UIColor clearColor];
        }
    }
    
    translatedPoint = CGPointMake(view.firstX + translatedPoint.x, view.firstY + translatedPoint.y);
    [view setCenter:translatedPoint];
}

-(void)longPressRecognized:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    if (inEditMode) {
        
        [self launchEditModeLongPressActionSheet:gestureRecognizer];
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(WillEnterInEditMode)]) {
            
            [self.delegate WillEnterInEditMode];
            [self launchNonEditModeLongPressActionSheet];
        }
        
    }
}

-(void)launchEditModeLongPressActionSheet:(UIGestureRecognizer *)recon {
    
    BOOL deletePage = NO;
    BOOL deleteImage = NO;
    BOOL deleteText = NO;
    
    NSString * destructive = @"";
    CGPoint point = [recon locationInView:self.canvas];
    UIView * view = [self.canvas hitTest:point withEvent:nil];
    if ([view isKindOfClass:[UIImageView class]]) {
        deleteImage = YES;
        destructive = @"Delete Image";
    }
    else if ([view isKindOfClass:[UILabel class]]) {
        deleteText = YES;
        destructive = @"Delete Text";
    }
    else {
        deletePage = YES;
        destructive = @"Delete Page";
    }
    
    
    [UIActionSheet showInView:self.navigationController.view withTitle:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:destructive otherButtonTitles:@[@"Add New Page", @"Add Images", @"Add Text"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        
        switch (buttonIndex) {
                
            case 0: {
                if (deletePage) {
                    if ([self.delegate respondsToSelector:@selector(didSelectDeletePage)]) {
                        [self.delegate didSelectDeletePage];
                    }
                } else if (deleteImage) {
                    
                    [self deleteImageForImageView:(UIImageView *)view];
                    
                } else if (deleteText) {
                    
                    [self deleteTextForLabel:(UILabel *)view];
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
                [self launchTextMaker];
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

-(void)launchNonEditModeLongPressActionSheet {
    
    [UIActionSheet showInView:self.navigationController.view withTitle:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Page" otherButtonTitles:@[@"Add New Page", @"Add Images", @"Add Text", @"Edit"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        
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
                [self launchTextMaker];
                break;
            }
                
            case 4: {
                //Do nothing
                break;
            }
                
                
            case 5: {
                if ([self.delegate respondsToSelector:@selector(willLeaveEditMode)]) {
                    [self.delegate willLeaveEditMode];
                }
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

-(void)cleanCanvas {
    
    for (UIView * view in self.canvas.subviews) {
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
    [self.tempDATexts removeAllObjects];
}

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
