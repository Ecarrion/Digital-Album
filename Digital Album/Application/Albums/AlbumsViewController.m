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
#import "AlbumManager.h"

@interface AlbumsViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CreateAlbumDelegate>

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
        
        self.albums = [NSArray array];
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
    
    NSArray * savedAlbums = [[AlbumManager manager] savedAlbums];
    self.albums = [self.albums arrayByAddingObjectsFromArray:savedAlbums];
    
    //Delete will be done by long presse
    UILongPressGestureRecognizer * longPressRecon = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedRecognizer:)];
    longPressRecon.delaysTouchesBegan = YES;
    longPressRecon.minimumPressDuration = 0.5;
    [albumsCollectionView addGestureRecognizer:longPressRecon];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(void)addAlbumPressed {
    
    SelectCoverViewController * scvc = [[SelectCoverViewController alloc] init];
    scvc.delegate = self;
    scvc.existingAlbums = self.albums;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:scvc];
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void)longPressedRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint p = [gestureRecognizer locationInView:albumsCollectionView];
        NSIndexPath * indexPath = [albumsCollectionView indexPathForItemAtPoint:p];
        if (indexPath != nil){
            
            DAAlbum * albumToBeDeleted = self.albums[indexPath.row];
            NSString * title = [NSString stringWithFormat:@"Delete %@?", albumToBeDeleted.name];
            
            [UIActionSheet showInView:self.navigationController.view withTitle:title cancelButtonTitle:@"No, Cancel" destructiveButtonTitle:@"Yes, Delete" otherButtonTitles:nil tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                
                if (buttonIndex == 0) {
                    
                    if ([[AlbumManager manager] deleteAlbum:albumToBeDeleted]) {
                        
                        NSMutableArray * newAlbums = self.albums.mutableCopy;
                        [newAlbums removeObject:albumToBeDeleted];
                        self.albums = newAlbums.copy;
                        [albumsCollectionView deleteItemsAtIndexPaths:@[indexPath]];
                    }
                }
            }];
        }
    }
}

#pragma mark - Create Album Delegate

-(void)albumCreated:(DAAlbum *)album {
    
    [SVProgressHUD showWithStatus:@"Creating Album..." maskType:SVProgressHUDMaskTypeGradient];
    [[AlbumManager manager] saveAlbum:album onCompletion:^(BOOL success) {
        [SVProgressHUD dismiss];
        
        self.albums = [self.albums arrayByAddingObject:album];
        [albumsCollectionView reloadData];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
}

#pragma mark - CollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    noAlbumsImageView.hidden = (self.albums.count > 0);
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
    if (album.coverImageName)
        cell.thumbImageView.image = [UIImage imageNamed:album.coverImageName];
    else
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
