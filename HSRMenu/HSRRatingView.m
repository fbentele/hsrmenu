//
//  HSRRatingView.m
//  HSRMenu
//
//  Created by Florian Bentele on 15.11.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "HSRRatingView.h"

@implementation HSRRatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        myrating = [[UILabel alloc] initWithFrame:CGRectMake(130, 20, 130, 20)];
        [myrating setText:@"Meine Bewertung:"];
        [myrating setFont:[UIFont fontWithName:@"Futura" size:15]];
        [myrating setBackgroundColor:[UIColor clearColor]];
        [myrating setTextColor:[UIColor whiteColor]];
        
        ratebutton1 = [[UIButton alloc] initWithFrame:CGRectMake(85, 50, 40, 35)];
        [ratebutton1 setBackgroundImage:[UIImage imageNamed:@"astar_blank.png"] forState:UIControlStateNormal];
        
        ratebutton2 = [[UIButton alloc] initWithFrame:CGRectMake(130, 50, 40, 35)];
        [ratebutton2 setBackgroundImage:[UIImage imageNamed:@"astar_blank.png"] forState:UIControlStateNormal];
        
        ratebutton3 = [[UIButton alloc] initWithFrame:CGRectMake(175, 50, 40, 35)];
        [ratebutton3 setBackgroundImage:[UIImage imageNamed:@"astar_blank.png"] forState:UIControlStateNormal];
        
        ratebutton4 = [[UIButton alloc] initWithFrame:CGRectMake(220, 50, 40, 35)];
        [ratebutton4 setBackgroundImage:[UIImage imageNamed:@"astar_blank.png"] forState:UIControlStateNormal];
        
        ratebutton5 = [[UIButton alloc] initWithFrame:CGRectMake(265, 50, 40, 35)];
        [ratebutton5 setBackgroundImage:[UIImage imageNamed:@"astar_blank.png"] forState:UIControlStateNormal];
        
        backgroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 134)];
        background = [UIImage imageNamed:@"menu_background.png"];
        [backgroundImageView setImage:background];
        
        [self addSubview:backgroundImageView];
        [self addSubview:myrating];
        [self addSubview:ratebutton1];
        [self addSubview:ratebutton2];
        [self addSubview:ratebutton3];
        [self addSubview:ratebutton4];
        [self addSubview:ratebutton5];
    }
    return self;
}

@end
