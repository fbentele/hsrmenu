//
//  HSRRatingView.h
//  HSRMenu
//
//  Created by Florian Bentele on 15.11.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"

@interface HSRRatingView : UIView

@property (nonatomic, strong) DLStarRatingControl *ratingControl;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImage *background;
@property (nonatomic, strong) UILabel *myrating;


-(void) setTag:(NSInteger)menuid;
-(void) setRating:(float)stars;

@end
