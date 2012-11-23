//
//  HSRRatingView.m
//  HSRMenu
//
//  Created by Florian Bentele on 15.11.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "HSRRatingView.h"
#import "DLStarRatingControl.h"

@implementation HSRRatingView
@synthesize ratingControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        myrating = [[UILabel alloc] initWithFrame:CGRectMake(130, 20, 130, 20)];
        [myrating setText:@"Meine Bewertung:"];
        [myrating setFont:[UIFont fontWithName:@"Futura" size:15]];
        [myrating setBackgroundColor:[UIColor clearColor]];
        [myrating setTextColor:[UIColor whiteColor]];
        
        ratingControl = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(85, 50, 220, 70) andStars:5 isFractional:NO];
        [ratingControl setTag:0];
        backgroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 134)];
        background = [UIImage imageNamed:@"menu_background.png"];
        [backgroundImageView setImage:background];
        
        [self addSubview:backgroundImageView];
        [self addSubview:myrating];
        [self addSubview:ratingControl];
    }
    return self;
}

-(void) setTag:(NSInteger)menuid
{
    [[self ratingControl] setTag:menuid];
}



@end
