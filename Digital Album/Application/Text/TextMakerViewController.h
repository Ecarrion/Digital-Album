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

@protocol TextMakerDelegate <NSObject>

-(void)didFinishGeneratingText:(DAText *)text;

@end

@interface TextMakerViewController : UIViewController {
    

    __weak IBOutlet DATextView *textView;
    __weak IBOutlet UIView *textViewHolder;
    
}

@property (nonatomic, weak) id<TextMakerDelegate> delegate;

@end
