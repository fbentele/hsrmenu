//
//  SingleMenuViewController.h
//  HSRMenu
//
//  Created by Florian Bentele on 29.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSRMenuConnection.h"
#import "DLStarRatingControl.h"
#import "HSRRatingView.h"
#import "ODRefreshControl.h"

@interface HSRMenuViewController : UIViewController<DLStarRatingDelegate, HSRMenuConnectionDelegate>{
    HSRRatingView *rater3;
    HSRRatingView *rater2;
    HSRRatingView *rater1;
    HSRMenuConnection *menuConnection;
}

@property (weak, nonatomic) IBOutlet UIScrollView *ratescroller3;
@property (weak, nonatomic) IBOutlet UIScrollView *ratescroller2;
@property (weak, nonatomic) IBOutlet UIScrollView *ratescroller1;

@property (weak, nonatomic) IBOutlet UILabel *menucontent1;
@property (weak, nonatomic) IBOutlet UILabel *menucontent2;
@property (weak, nonatomic) IBOutlet UILabel *menucontent3;

@property (weak, nonatomic) IBOutlet UILabel *int1;
@property (weak, nonatomic) IBOutlet UILabel *int2;
@property (weak, nonatomic) IBOutlet UILabel *int3;

@property (weak, nonatomic) IBOutlet UILabel *ext1;
@property (weak, nonatomic) IBOutlet UILabel *ext2;
@property (weak, nonatomic) IBOutlet UILabel *ext3;

@property (weak, nonatomic) IBOutlet UIImageView *averageRatingForMenu1;
@property (weak, nonatomic) IBOutlet UIImageView *averageRatingForMenu2;
@property (weak, nonatomic) IBOutlet UIImageView *averageRatingForMenu3;

@property (weak, nonatomic) IBOutlet UINavigationItem *titlebartitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@property (nonatomic) int currentday;
@property (strong, nonatomic, readwrite) NSString *plistPath;
@property (strong, nonatomic) ODRefreshControl *refresher;

-(void)setMenuDay:(int)day;

@end
