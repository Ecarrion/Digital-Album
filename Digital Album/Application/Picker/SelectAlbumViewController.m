//
//  SelectAlbumViewController.m
//  Digital Album
//
//  Created by Ernesto Carrión on 2/19/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "SelectAlbumViewController.h"

@interface SelectAlbumViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SelectAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    albumsTableView.layer.cornerRadius = 10;
    albumsTableView.tableFooterView = [[UIView alloc] init];
    
    [self adjustTableViewSize];
}

-(void)adjustTableViewSize {
 
    CGRect frame = albumsTableView.frame;
    double fiveAlbumsHeight = (5 * SELECT_ALBUM_CELL_HEIGHT) + 10;
    int height = (self.albums.count * SELECT_ALBUM_CELL_HEIGHT) + 10;
    if (height > fiveAlbumsHeight) { //5 albums
        height = fiveAlbumsHeight;
    }
    
    frame.size.height = height;
    albumsTableView.frame = frame;
    
}

- (IBAction)screenPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didCancelSelection)]) {
        [self.delegate didCancelSelection];
    }
}

-(void)showTableViewWithAnimationOnCompletion:(void (^)(void))block {

    
    CGAffineTransform identity = CGAffineTransformIdentity;
    CGAffineTransform viewTransform = CGAffineTransformScale(identity, 0.1, 0.1);
    viewTransform = CGAffineTransformTranslate(viewTransform, 0, -2200);
    self.view.transform = viewTransform;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.transform = identity;
        
    } completion:^(BOOL finished) {
        
        if (block) {
            block();
        }
    }];
}

-(void)hideTableViewWithAnimationOnCompletion:(void (^)(void))block {
 
    CGAffineTransform identity = CGAffineTransformIdentity;
    CGAffineTransform viewTransform = CGAffineTransformScale(identity, 0.1, 0.1);
    viewTransform = CGAffineTransformTranslate(viewTransform, 0, -2200);
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.transform = viewTransform;
        
    } completion:^(BOOL finished) {
        
        if (block) {
            block();
        }
    }];
    
}


#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.albums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumCellID"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AlbumCellID"];
        cell.textLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:18];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Noteworthy-Light" size:16];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    DAAlbum * album = self.albums[indexPath.row];
    cell.imageView.image = [[album topImage] localThumbnailPreservingAspectRatio:NO];
    cell.textLabel.text = album.name;
    
    if (album.images.count > 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", album.images.count];
        
    } else {
        cell.detailTextLabel.text = @"1 photo";
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(didSelectAlbum:)]) {
        [self.delegate didSelectAlbum:self.albums[indexPath.row]];
    }
}

#pragma mark - memory

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
