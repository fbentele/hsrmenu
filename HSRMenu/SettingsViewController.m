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
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *pass;
@property (weak, nonatomic) IBOutlet UITextField *uiuser;
@property (weak, nonatomic) IBOutlet UITextField *uipass;

@end

@implementation SettingsViewController
@synthesize username;
@synthesize password;
@synthesize uiuser;
@synthesize uipass;
@synthesize user;
@synthesize pass;


//hit 'done' in the keyboard an the keyboard disappears
-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    [self safeCredentialsToKeychain];
}

//touch anywhere and the keyboard disappears
-(IBAction)backgroundTouched:(id)sender
{
    [username resignFirstResponder];
    [password resignFirstResponder];
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
    user = [uiuser text];
    pass = [uipass text];
    NSLog(@"[Info] the username is %@", user);
    NSLog(@"[Info] the password is %@", pass);
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"HSRMenuLogin" accessGroup:nil];
    
    [keychain setObject:pass forKey:CFBridgingRelease(kSecValueData)];
    [keychain setObject:user forKey:CFBridgingRelease(kSecAttrAccount)];    
    return YES;
}

-(void)fillUIifKeychainobjectExists
{
    KeychainItemWrapper *keychain;
    @try {
        keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"HSRMenuLogin" accessGroup:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"No keychain found");
    }
    @finally {
        
    }
    //KeychainWrapper *keychain = [[KeychainWrapper alloc] initWithIdentifier:@"HSRMenuLogin" accessGroup:nil];
    //[uiuser text] =[keychain objectForKey:CFBridgingRelease(kSecAttrAccount)];
    uiuser.text = [keychain objectForKey:CFBridgingRelease(kSecAttrAccount)];
    uipass.text = [keychain objectForKey:CFBridgingRelease(kSecValueData)];
    
    //NSLog(@"well well user: %@", kcusername);
    //NSLog(@"well well user: %@", kcpassword);
    NSLog(@"[Info] User/pass stored");
}

- (void)viewDidUnload {
    [self setUsername:nil];
    [self setPassword:nil];
    [self setUiuser:nil];
    [self setUipass:nil];
    [super viewDidUnload];
}
@end
