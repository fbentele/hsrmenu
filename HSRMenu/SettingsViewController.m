//
//  SettingsViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 04.10.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize username;
@synthesize password;

//hit 'done' in the keyboard an the keyboard disappears
-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

//touch anywhere and the keyboard disappears
-(IBAction)backgroundTouched:(id)sender
{
    [username resignFirstResponder];
    [password resignFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUsername:nil];
    [self setPassword:nil];
    [super viewDidUnload];
}
@end
