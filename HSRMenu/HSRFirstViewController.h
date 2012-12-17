//
//  HSRFirstViewController.h
//  HSRMenu
//
//  Created by Florian Bentele on 25.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODRefreshControl.h"

@interface HSRFirstViewController : UITableViewController {
    NSArray *menu;
    NSMutableData *data;
}

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (nonatomic) int day;
@property (strong, nonatomic) IBOutlet UITableView *thetable;
@property (weak, nonatomic) IBOutlet UITableViewCell *monday;
@property (weak, nonatomic) IBOutlet UITableViewCell *tuesday;
@property (weak, nonatomic) IBOutlet UITableViewCell *wednesday;
@property (weak, nonatomic) IBOutlet UITableViewCell *thursday;
@property (weak, nonatomic) IBOutlet UITableViewCell *friday;
@property (strong, nonatomic) NSMutableArray *week;

@end
