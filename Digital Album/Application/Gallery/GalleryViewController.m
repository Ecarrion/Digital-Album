//
//  GalleryViewController.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/18/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "GalleryViewController.h"

#import "GalleryCell.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [imagesCollectionView registerNib:[UINib nibWithNibName:@"GalleryCell" bundle:nil] forCellWithReuseIdentifier:@"GalleryCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self hideNavControls:NO];
    
    if (self.startingIndex != NSNotFound) {
        [imagesCollectionView setContentOffset:CGPointMake(self.startingIndex * imagesCollectionView.frame.size.width, 0) animated:NO];
        self.startingIndex = NSNotFound;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self hideNavControls:NO];
}

#pragma mark - CollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.album.images count];
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return collectionView.bounds.size;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DAImage * image = self.album.images[indexPath.row];
    
    GalleryCell * cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"GalleryCell" forIndexPath:indexPath];
    cell.fullImageView.image = [image localImage];
    [cell resizeImageView];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self toggleNavControls];
    
}

-(void)toggleNavControls {
    
    BOOL hidden = !self.navigationController.navigationBarHidden;
    [self hideNavControls:hidden];
}

-(void)hideNavControls:(BOOL)hidden {
    
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationSlide];
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
