//
//  NewAlbumViewController.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/18/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SelectCoverViewController.h"

@interface SelectCoverViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSArray * coverNames;
@property (nonatomic, strong) NSArray * coverImages;
@property (nonatomic, strong) UIImageView * checkBoxImageView;

@end

@implementation SelectCoverViewController

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
    
    self.checkBoxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
    float distance = 500;
    CATransform3D basicTrans = CATransform3DIdentity;
    basicTrans.m34 = 1.0 / -distance;
    basicTrans = CATransform3DRotate(basicTrans, 25 * M_PI / 180, 0.0f, 1.0f, 0.0f);
    self.checkBoxImageView.layer.transform = basicTrans;
    self.checkBoxImageView.layer.zPosition = 20;
}

-(void)setUpScrollView {
    
    float gap = 20;
    __block float x = 12;
    float y = 6;
    float w = 79;
    float h = 127;
    
    if ([[UIScreen mainScreen] bounds].size.height <= 480) {
        
        w = 49;
        h = 77;
        
        CGRect frame = coversScrollView.frame;
        frame.size.height = 89;
        coversScrollView.frame = frame;
    }
    
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
    
    self.checkBoxImageView.center = CGPointMake(tappedCoverImage.center.x + 7, tappedCoverImage.center.y);
    [coversScrollView addSubview:self.checkBoxImageView];
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
