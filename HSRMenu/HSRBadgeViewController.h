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
    HSRBadgeConnection *badgesaldo;
}

@property (weak, nonatomic) IBOutlet UILabel *lastupdate;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) ODRefreshControl *refresher;

@end
