//
//  AlbumPageViewController.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "AlbumPageViewController.h"

@interface AlbumPageViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
