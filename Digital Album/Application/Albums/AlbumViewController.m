//
//  AlbumViewController.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumPageViewController.h"
#import "GalleryViewController.h"

@interface AlbumViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, AlbumPageDelegate> {
    
    __weak IBOutlet UIView *pageControlerHolder;
    
}

@property (nonatomic, strong) UIPageViewController * pageViewController;

@end

@implementation AlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [super viewDidLoad];
    
    self.title = self.album.name;
    self.view.backgroundColor = [UIColor colorWithRed:209.0/255.0 green:195.0/255.0 blue:177.0/255.0 alpha:1];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.view.frame = pageControlerHolder.frame;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [pageControlerHolder removeFromSuperview];
    pageControlerHolder = nil;
    
    NSArray * array = @[[self pageControllerAtIndex:0]];
    [self.pageViewController setViewControllers:array direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - PageViewController

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    int currentIndex = [self currentIndex] + 1;
    if (currentIndex < self.album.images.count) {
        
        return [self pageControllerAtIndex:currentIndex];
    }
    
    return nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    int currentIndex = [self currentIndex] - 1;
    if (currentIndex >= 0) {
     
        return [self pageControllerAtIndex:currentIndex];
    }
    
    return nil;
}

-(int)currentIndex {
    
    AlbumPageViewController * pageController = (AlbumPageViewController *)self.pageViewController.viewControllers[0];
    DAImage * image = pageController.image;
    return  (int)[self.album.images indexOfObject:image];
    
}

-(AlbumPageViewController *)pageControllerAtIndex:(int)index {
    
    AlbumPageViewController * page = [[AlbumPageViewController alloc] initWithImage:self.album.images[index]];
    page.delegate = self;
    return page;
}

-(void)pageController:(AlbumPageViewController *)page imageTapped:(DAImage *)image {
    
    
    UIView  * blackOverlay = [[UIView alloc] initWithFrame:self.view.window.bounds];
    blackOverlay.backgroundColor = [UIColor blackColor];
    blackOverlay.alpha = 0;
    [self.view.window addSubview:blackOverlay];
    
    UIImageView * imgvToZoom = [[UIImageView alloc] initWithImage:image.localImage];
    imgvToZoom.contentMode = page.imageView.contentMode;
    imgvToZoom.frame = [self.view.window convertRect:page.imageView.frame fromView:page.view];
    [self.view.window addSubview:imgvToZoom];
    
    
    [UIView animateWithDuration:0.2 animations:^{
       
        blackOverlay.alpha = 1;
        imgvToZoom.frame = self.view.window.bounds;
        
    } completion:^(BOOL finished) {
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        GalleryViewController * gvc = [[GalleryViewController alloc] init];
        gvc.album = self.album;
        gvc.startingIndex = (int)[self.album.images indexOfObject:image];
        [self.navigationController pushViewController:gvc animated:NO];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            blackOverlay.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [blackOverlay removeFromSuperview];
            [imgvToZoom removeFromSuperview];
        }];
        
    }];
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
