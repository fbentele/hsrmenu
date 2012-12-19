//
//  SettingsViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 04.10.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "HSRSettingsViewController.h"
#import "KeychainItemWrapper.h"


@implementation HSRSettingsViewController

@synthesize uipass, uiuser;

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
}

- (BOOL)safeCredentialsToKeychain
{    
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
