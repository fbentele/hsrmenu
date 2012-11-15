//
//  SingleMenuViewController.h
//  HSRMenu
//
//  Created by Florian Bentele on 29.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSRMenuBrain.h"


@interface SingleMenuViewController : UIViewController{
    NSMutableData *data;
    HSRMenuBrain *model;
    
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
}

@property (nonatomic, retain) UIView *ratescroller3;

-(void)setMenuDay:(int)day;


@end
