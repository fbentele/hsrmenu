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
    
    NSMutableData *data;    
    HSRMenuConnection *menuConnection;
    
    __weak IBOutlet UINavigationItem *titlebartitle;
    
    __weak IBOutlet UILabel *menucontent1;
    __weak IBOutlet UILabel *menucontent2;
    __weak IBOutlet UILabel *menucontent3;

    
    __weak IBOutlet UILabel *int1;
    __weak IBOutlet UILabel *ext1;
    __weak IBOutlet UIImageView *averageRatingForMenu1;
    
    __weak IBOutlet UILabel *int2;
    __weak IBOutlet UILabel *ext2;
    __weak IBOutlet UIImageView *averageRatingForMenu2;
    
    __weak IBOutlet UILabel *int3;
    __weak IBOutlet UILabel *ext3;
    __weak IBOutlet UIImageView *averageRatingForMenu3;
    
    
    IBOutlet UIScrollView *ratescroller1;
    IBOutlet UIScrollView *ratescroller2;
    IBOutlet UIScrollView *ratescroller3;
    
    HSRRatingView *rater3;
    HSRRatingView *rater2;
    HSRRatingView *rater1;
}

@property (nonatomic, retain) UIView *ratescroller3;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (nonatomic) int currentday;
@property (strong, nonatomic, readwrite) NSString *plistPath;
@property (strong, nonatomic) ODRefreshControl *refresher;

-(void)setMenuDay:(int)day;

@end
