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
    
    // todo add lables here...
    __weak IBOutlet UILabel *menutitle1;
    __weak IBOutlet UILabel *menucontent1;
    __weak IBOutlet UILabel *menucontent2;
    __weak IBOutlet UILabel *menutitle2;
    __weak IBOutlet UILabel *menutitle3;
    __weak IBOutlet UILabel *menucontent3;

}

-(void)setMenuDay:(int)day;
-(void)safeMenusToFile;


@end
