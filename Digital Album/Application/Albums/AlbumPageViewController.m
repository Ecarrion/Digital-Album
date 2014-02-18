//
//  AlbumPageViewController.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "AlbumPageViewController.h"

@interface AlbumPageViewController ()

@property (nonatomic, strong) UITapGestureRecognizer * tapGestureRecornizer;

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
    imageView.image = [self.image localImage];
    
    self.tapGestureRecornizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    self.tapGestureRecornizer.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:self.tapGestureRecornizer];
}

-(void)imageTapped {
    
    if ([self.delegate respondsToSelector:@selector(imageTapped:)]) {
        
        [self.delegate imageTapped:self.image];
    }
}

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

-(void)dealloc {
    
    self.tapGestureRecornizer = nil;
}

@end
