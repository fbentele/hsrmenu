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
}

-(void)setMenuDay:(int)day;
-(void)safeMenusToFile;


@end
