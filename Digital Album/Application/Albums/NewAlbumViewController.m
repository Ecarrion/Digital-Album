//
//  NewAlbumViewController.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/18/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "NewAlbumViewController.h"

@interface NewAlbumViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSArray * coverNames;
@property (nonatomic, strong) NSArray * coverImages;

@end

@implementation NewAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"New Album";
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
        self.navigationItem.leftBarButtonItem = item;
        
        item = [[UIBarButtonItem alloc] initWithTitle:@"Add Photos" style:UIBarButtonItemStylePlain target:self action:@selector(addPhotosPressed)];
        self.navigationItem.rightBarButtonItem = item;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shrinked-paper2.png"]];
    [self setUpScrollView];
    
    albumNametextField.layer.borderColor = [UIColor colorWithRed:73.0/255.0 green:47.0/255.0 blue:14.0/255.0 alpha:1].CGColor;
    albumNametextField.layer.borderWidth = 2.f;
    
    [albumNametextField becomeFirstResponder];
}

-(void)setUpScrollView {
    
    float gap = 20;
    __block float x = 12;
    float y = 6;
    float w = 79;
    float h = 127;
    
    self.coverNames = COVERS();
    NSMutableArray * coversImages = [NSMutableArray array];
    
    [self.coverNames enumerateObjectsUsingBlock:^(NSString * name, NSUInteger idx, BOOL *stop) {
        
        UIButton * cover = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [cover setImage:[UIImage imageNamed:self.coverNames[idx]] forState:UIControlStateNormal];
        [cover addTarget:self action:@selector(coverPressed:) forControlEvents:UIControlEventTouchUpInside];
        [coversImages addObject:cover];
        [coversScrollView addSubview:cover];
        x += w + gap;
    }];
    
    self.coverImages = [coversImages copy];
    coversScrollView.contentSize = CGSizeMake(x, coversScrollView.frame.size.height);
    
    coversScrollView.layer.borderColor = [UIColor colorWithRed:73.0/255.0 green:47.0/255.0 blue:14.0/255.0 alpha:1].CGColor;
    coversScrollView.layer.borderWidth = 2.f;
}

-(void)coverPressed:(UIButton *)tappedCoverImage {
    
    for (UIButton * coverImages in self.coverImages) {
        coverImages.highlighted = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        tappedCoverImage.highlighted = YES;
    });
    
}

-(void)cancelPressed {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addPhotosPressed {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate 


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
