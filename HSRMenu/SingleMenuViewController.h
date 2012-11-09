//
//  SingleMenuViewController.h
//  HSRMenu
//
//  Created by Florian Bentele on 29.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SingleMenuViewController : UIViewController{
    NSMutableData *data;
    
    __weak IBOutlet UINavigationItem *titlebartitle;
    
    // todo add lables here...
    __weak IBOutlet UILabel *menucontent1;
    __weak IBOutlet UILabel *menucontent2;
    __weak IBOutlet UILabel *menucontent3;

    
    __weak IBOutlet UILabel *int1;
    __weak IBOutlet UILabel *ext1;
    
    __weak IBOutlet UILabel *int2;
    __weak IBOutlet UILabel *ext2;
    
    __weak IBOutlet UILabel *int3;
    __weak IBOutlet UILabel *ext3;
    IBOutlet UIScrollView *ratescroller3;
}

@property (nonatomic, retain) UIView *ratescroller3;

-(void)setMenuDay:(int)day;
-(void)safeMenusToFile;


@end
