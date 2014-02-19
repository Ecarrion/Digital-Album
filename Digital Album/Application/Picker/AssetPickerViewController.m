//
//  AssetPickerViewController.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/18/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "AssetPickerViewController.h"

#import "AssetCell.h"

#import "AlbumManager.h"
#import "DAAlbum.h"

@interface AssetPickerViewController () <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) DAAlbum * selectedAlbum;

@end

@implementation AssetPickerViewController

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
    [imagesCollectionView registerNib:[UINib nibWithNibName:@"AssetCell" bundle:nil] forCellWithReuseIdentifier:@"AssetCell"];
    imagesCollectionView.allowsMultipleSelection = YES;
    
    [AlbumManager phoneAlbumsWithBlock:^(NSArray *albums, NSError *error) {
        
        if (!error) {
            
            self.phoneAlbums = albums;
            self.selectedAlbum = [self.phoneAlbums lastObject];
            [imagesCollectionView reloadData];
        }
    }];
}

#pragma mark - CollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.selectedAlbum.images count];
}

/*
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return ALBUM_CELL_SIZE;
}
 */

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DAImage * image = self.selectedAlbum.images[indexPath.row];
    AssetCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCell" forIndexPath:indexPath];
    cell.thumbImageView.image = [image localThumbnailPreservingAspectRatio:YES];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
