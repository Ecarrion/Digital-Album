//
//  TextMakerViewController.m
//  Digital Album
//
//  Created by Ernesto Carrión on 3/2/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "TextMakerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Google-AdMob-Ads-SDK/GADBannerView.h>

@interface TextMakerViewController () {
    
    GADBannerView * bannerView;
}

@end

@implementation TextMakerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
        self.screenName = @"Add Text Screen";
        self.title = @"Add Text";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [textView becomeFirstResponder];
    
    //Border
    UIColor * color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood-texture-2.png"]];
    textViewHolder.layer.borderWidth = 6;
    textViewHolder.layer.borderColor = color.CGColor;
    
    //Shadown
    textViewHolder.layer.shadowRadius = 5.f;
    textViewHolder.layer.shadowOpacity = .9;
    textViewHolder.layer.shadowOffset = CGSizeZero;
    textViewHolder.layer.masksToBounds = NO;
    
    //Corner
    textViewHolder.layer.cornerRadius = 6.f;
    
    //Placeholder
    textView.placeholder = @" Type to add text";
}

-(DAText *)textObject {
    
    DAText * text = [[DAText alloc] init];
    text.text = textView.text;
    text.viewTransform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    text.zPosition = 200;
    
    return text;
}

-(void)donePressed {
    
    if (textView.text.length > 0) {
        
        DAText * text = [self textObject];
        if ([self.delegate respondsToSelector:@selector(didFinishGeneratingText:)]) {
            [self.delegate didFinishGeneratingText:text];
        }
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelPressed {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createBanner {
    
    if ([[UIScreen mainScreen] bounds].size.height >= 568) {
    
        [bannerView removeFromSuperview];
        bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        CGRect frame = bannerView.frame;
        frame.origin.y = self.view.frame.size.height - 248;
        bannerView.frame = frame;
        
        // Specify the ad unit ID.
        bannerView.adUnitID = ADD_TEXT_BANNER_UNIT_ID;
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView.rootViewController = self;
        [self.view addSubview:bannerView];
        
        // Initiate a generic request to load it with an ad.
        [bannerView loadRequest:[GADRequest request]];
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
