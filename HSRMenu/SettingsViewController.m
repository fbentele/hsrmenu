//
//  SettingsViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 04.10.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "SettingsViewController.h"
#import "KeychainItemWrapper.h"

@interface SettingsViewController ()
@end

@implementation SettingsViewController

//hit 'next' in the keyboard an the keyboard disappears
-(IBAction)textFieldReturn:(id)sender
{
    [uipass becomeFirstResponder];
    [self safeCredentialsToKeychain];
}

//touch anywhere and the keyboard disappears
-(IBAction)backgroundTouched:(id)sender
{
    [uiuser resignFirstResponder];
    [uipass resignFirstResponder];
    [self safeCredentialsToKeychain];
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
   
    [self fillUIifKeychainobjectExists];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)safeCredentialsToKeychain
{
    NSLog(@"[Info] the username is %@", [uiuser text]);
    NSLog(@"[Info] the password is *******");
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"HSRMenuLogin" accessGroup:nil];
    [keychain setObject:[uipass text] forKey:CFBridgingRelease(kSecValueData)];
    [keychain setObject:[uiuser text] forKey:CFBridgingRelease(kSecAttrAccount)];
    return YES;
}

-(void)fillUIifKeychainobjectExists
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"HSRMenuLogin" accessGroup:nil];
    
    [uiuser setText:[keychain objectForKey:CFBridgingRelease(kSecAttrAccount)]];
    [uipass setText:[keychain objectForKey:CFBridgingRelease(kSecValueData)]];
    
    NSLog(@"[Info] Keychainobject Exists");
}

- (void)viewDidUnload {
    uiuser = nil;
    uipass = nil;
    [super viewDidUnload];
}

@end
