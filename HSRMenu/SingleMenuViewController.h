//
//  SingleMenuViewController.h
//  HSRMenu
//
//  Created by Florian Bentele on 29.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleMenuViewController : UIViewController{
    NSDictionary *dailymenu;

    IBOutlet UILabel *day;
    IBOutlet UILabel *menu;
    IBOutlet UILabel *price;
}

@property (nonatomic, copy) NSDictionary *dailymenu;



@end
