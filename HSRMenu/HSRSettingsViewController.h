//
//  SettingsViewController.h
//  HSRMenu
//
//  Created by Florian Bentele on 04.10.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSRSettingsViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *uiuser;
@property (nonatomic, weak) IBOutlet UITextField *uipass;


-(IBAction)textFieldReturn:(id)sender;
-(IBAction)backgroundTouched:(id)sender;
@end
