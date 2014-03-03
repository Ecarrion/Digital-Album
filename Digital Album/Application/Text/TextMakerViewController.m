//
//  TextMakerViewController.m
//  Digital Album
//
//  Created by Ernesto Carrión on 3/2/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "TextMakerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TextMakerViewController ()

@end

@implementation TextMakerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
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
