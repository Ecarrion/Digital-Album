//
//  AlbumsViewController.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "AlbumsViewController.h"
#import "AlbumViewController.h"
#import "SelectCoverViewController.h"

#import "AlbumCell.h"

#import "ImageManager.h"


@interface AlbumsViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray * albums;
@property (nonatomic, strong) NSArray * covers;

@end

@implementation AlbumsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"Albums";
        self.covers = COVERS();
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAlbumPressed)];
        [self.navigationItem setRightBarButtonItem:item];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIImageView * titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"album-title.png"]];
    self.navigationItem.titleView = titleImageView;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shrinked-paper2.png"]];
    [albumsCollectionView registerNib:[UINib nibWithNibName:@"AlbumCell" bundle:nil] forCellWithReuseIdentifier:@"AlbumCell"];
    
    [ImageManager phoneAlbumsWithBlock:^(NSArray *albums, NSError *error) {
        
        if (!error) {
            
            self.albums = albums;
            [albumsCollectionView reloadData];
        }
        
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(void)addAlbumPressed {
    
    SelectCoverViewController * navc = [[SelectCoverViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:navc];
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark - CollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.albums count];
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return ALBUM_CELL_SIZE;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DAAlbum * album = self.albums[indexPath.row];
    
    AlbumCell * cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"AlbumCell" forIndexPath:indexPath];
    cell.nameLabel.text = album.name;
    
    int index = (int)indexPath.row % (int)self.covers.count;
    cell.thumbImageView.image = [UIImage imageNamed:self.covers[index]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DAAlbum * album = self.albums[indexPath.row];
    AlbumViewController * avc = [[AlbumViewController alloc] init];
    avc.album = album;
    [self.navigationController pushViewController:avc animated:YES];
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
