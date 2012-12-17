//
//  HSRSecondViewController.h
//  HSRMenu
//
//  Created by Florian Bentele on 25.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSRBadgeConnection.h"
#import "ODRefreshControl.h"


@interface HSRBadgeViewController : UIViewController <HSRBadgeConnectionDelegate>{
    __weak IBOutlet UILabel *money;
    __weak IBOutlet UILabel *lastupdate;
    HSRBadgeConnection *badgesaldo;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) ODRefreshControl *refresher;

@end
