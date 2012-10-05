//
//  SettingsViewController.h
//  HSRMenu
//
//  Created by Florian Bentele on 04.10.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController {
    
}

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
-(IBAction)textFieldReturn:(id)sender;
-(IBAction)backgroundTouched:(id)sender;
@end
