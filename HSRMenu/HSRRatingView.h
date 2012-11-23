//
//  HSRRatingView.h
//  HSRMenu
//
//  Created by Florian Bentele on 15.11.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"

@interface HSRRatingView : UIView{
    UIImage *background;
    UIImageView *backgroundImageView;
    CGRect *rect;
    UILabel *myrating;
    UIButton *ratebutton1;
    UIButton *ratebutton2;
    UIButton *ratebutton3;
    UIButton *ratebutton4;
    UIButton *ratebutton5;
}

@property (nonatomic, strong) DLStarRatingControl *ratingControl;

-(void) setTag:(NSInteger)menuid;

@end
