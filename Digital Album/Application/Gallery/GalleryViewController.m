//
//  GalleryViewController.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/18/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "GalleryViewController.h"

#import "GalleryCell.h"
#import "GalleryFlowLayout.h"

#import <Google-AdMob-Ads-SDK/GADBannerView.h>


@interface GalleryViewController () {
    
    GADBannerView * bannerView;
}

@property (nonatomic, strong) NSArray * images;

@end

@implementation GalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.screenName = @"Gallery Screen";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.images = self.album.allImages;
    
    [imagesCollectionView registerNib:[UINib nibWithNibName:@"GalleryCell" bundle:nil] forCellWithReuseIdentifier:@"GalleryCell"];
    [(GalleryFlowLayout *)imagesCollectionView.collectionViewLayout reloadLayout];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITapGestureRecognizer * gestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleNavControls)];
    gestureR.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gestureR];
    
    [self createBanner];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.startingIndex != NSNotFound) {
        [imagesCollectionView setContentOffset:CGPointMake(self.startingIndex * imagesCollectionView.frame.size.width, 0) animated:NO];
        self.startingIndex = NSNotFound;
        
    } else {
        
        [self hideNavControls:NO];
    }
}


-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self hideNavControls:NO];
}

-(void)createBanner {
    
    if ([[UIScreen mainScreen] bounds].size.height >= 568) {
        
        [bannerView removeFromSuperview];
        bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        CGRect frame = bannerView.frame;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        bannerView.frame = frame;
        
        // Specify the ad unit ID.
        bannerView.adUnitID = GALLERY_BANNER_UNIT_ID;
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView.rootViewController = self;
        [self.view addSubview:bannerView];
        
        // Initiate a generic request to load it with an ad.
        [bannerView loadRequest:[GADRequest request]];
    }
}


#pragma mark - CollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.images count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DAImage * image = self.images[indexPath.row];
    
    GalleryCell * cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"GalleryCell" forIndexPath:indexPath];
    cell.fullImageView.image = [image localImage];
    [cell resizeImageView];
    
    return cell;
}

-(void)toggleNavControls {
    
    BOOL hidden = !self.navigationController.navigationBarHidden;
    [self hideNavControls:hidden];
}

-(void)hideNavControls:(BOOL)hidden {
    
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationSlide];
    
    CGRect frame = bannerView.frame;
    frame.origin.y = hidden ? self.view.frame.size.height : self.view.frame.size.height - frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        bannerView.frame = frame;
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
