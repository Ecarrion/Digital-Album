//
//  TextMakerViewController.h
//  Digital Album
//
//  Created by Ernesto Carrión on 3/2/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAText.h"
#import "DATextView.h"

#define DEFAULT_DATEXT_FONT [UIFont fontWithName:@"Noteworthy-Bold" size:17]
#define DEFAULT_DATEXT_COLOR [UIColor colorWithRed:73.0/255.0 green:47.0/255.0 blue:14.0/255.0 alpha:1]

@protocol TextMakerDelegate <NSObject>

-(void)didFinishGeneratingText:(DAText *)text;

@end

@interface TextMakerViewController : UIViewController {
    

    __weak IBOutlet DATextView *textView;
    __weak IBOutlet UIView *textViewHolder;
    
}

@property (nonatomic, weak) id<TextMakerDelegate> delegate;

@end
