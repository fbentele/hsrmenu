//
//  HSRFirstViewController.h
//  HSRMenu
//
//  Created by Florian Bentele on 25.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSRFirstViewController : UITableViewController {
    NSArray* menu;
    NSMutableData* data;
}

@property (weak, nonatomic) IBOutlet UILabel *display;

@end
