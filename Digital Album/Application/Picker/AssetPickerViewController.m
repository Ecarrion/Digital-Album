//
//  AssetPickerViewController.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/18/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "AssetPickerViewController.h"
#import "SelectAlbumViewController.h"

#import "AssetCell.h"

#import "AlbumManager.h"
#import "DAAlbum.h"

@interface AssetPickerViewController () <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SelectAlbumDelegate>

@property (nonatomic, strong) DAAlbum * selectedAlbum;
@property (nonatomic, strong) SelectAlbumViewController * albumController;
@property (nonatomic, strong) NSMutableOrderedSet * selectedImages;

@end

@implementation AssetPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"Finish" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.rightBarButtonItem = item;
        
        self.selectedImages = [[NSMutableOrderedSet alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [imagesCollectionView registerNib:[UINib nibWithNibName:@"AssetCell" bundle:nil] forCellWithReuseIdentifier:@"AssetCell"];
    imagesCollectionView.allowsMultipleSelection = YES;
    
    self.navigationItem.titleView = titleButtonView;
    [self setTitleButtonViewText];
    
    [AlbumManager phoneAlbumsWithBlock:^(NSArray *albums, NSError *error) {
        
        if (!error) {
            
            self.phoneAlbums = albums;
            self.selectedAlbum = [self.phoneAlbums lastObject];
            [self reloadCollectionView];
            
            self.navigationItem.titleView = titleButtonView;
            [self setTitleButtonViewText];
        }
    }];
}

-(void)setTitleButtonViewText {
    
    NSString * title = self.selectedAlbum.name;
    [titleButtonView setTitle:title forState:UIControlStateNormal];
    UIFont * font = titleButtonView.titleLabel.font;
    CGSize size = [title boundingRectWithSize: titleButtonView.frame.size
                                      options: NSStringDrawingUsesLineFragmentOrigin
                                   attributes: @{ NSFontAttributeName: font }
                                      context: nil].size;
    
    int leftInset = (titleButtonView.frame.size.width / 2.0) + (size.width / 2.0);
    titleButtonView.imageEdgeInsets = UIEdgeInsetsMake(8., leftInset, 0., 0.);
    titleButtonView.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0., 0.);
}

-(IBAction)presetAlbumSelectController {
    
    self.albumController = [[SelectAlbumViewController alloc] init];
    self.albumController.delegate = self;
    self.albumController.albums = self.phoneAlbums;
    
    [self.navigationController addChildViewController:self.albumController];
    [self.navigationController.view addSubview:self.albumController.view];
    [self.albumController didMoveToParentViewController:self.navigationController];
    
    [self.albumController showTableViewWithAnimationOnCompletion:nil];
}

-(void)removeSelectAlbumController {
    
    [self.albumController hideTableViewWithAnimationOnCompletion:^{
        
        [self.albumController.view removeFromSuperview];
        [self.albumController removeFromParentViewController];
        self.albumController = nil;
        
    }];
}

#pragma mark - Selection Album Delegate

-(void)didSelectAlbum:(DAAlbum *)album {
    
    self.selectedAlbum = album;
    [self reloadCollectionView];
    [self setTitleButtonViewText];
    [self removeSelectAlbumController];
}

-(void)didCancelSelection {
    
    [self removeSelectAlbumController];
}

#pragma mark - CollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.selectedAlbum.images count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DAImage * image = self.selectedAlbum.images[indexPath.row];
    AssetCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCell" forIndexPath:indexPath];
    cell.thumbImageView.image = [image localThumbnailPreservingAspectRatio:YES];
    
    NSUInteger index = [self.selectedImages indexOfObject:image];
    if (index != NSNotFound) {
        [cell setCounterNumber:(int)index + 1];
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DAImage * image = self.selectedAlbum.images[indexPath.row];
    [self.selectedImages addObject:image];
    [self reloadCollectionView];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DAImage * image = self.selectedAlbum.images[indexPath.row];
    [self.selectedImages removeObject:image];
    [self reloadCollectionView];
}


-(void)reloadCollectionView {
    
    [imagesCollectionView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (int i = 0; i < self.selectedAlbum.images.count; i++) {
            DAImage * img = self.selectedAlbum.images[i];
            if ([self.selectedImages containsObject:img]) {
                NSIndexPath * ip =  [NSIndexPath indexPathForRow:i inSection:0];
                [imagesCollectionView selectItemAtIndexPath:ip animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
        
    });
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
