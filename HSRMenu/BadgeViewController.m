//
//  HSRSecondViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 25.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "BadgeViewController.h"
#import "KeychainItemWrapper.h"
#import "NSData+Base64.h"
#import "ODRefreshControl.h"

@interface BadgeViewController ()
@property (strong, nonatomic) NSMutableData *data;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation BadgeViewController
@synthesize data, scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initJsonConnection];
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.scrollView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    lastupdate = nil;
    [super viewDidUnload];
}


- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    [self initJsonConnection];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
}


//connection
- (void)initJsonConnection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;    
    NSURL* apiurl = [NSURL URLWithString:@"https://verrechnungsportal.hsr.ch:4450/VerrechnungsportalService.svc/JSON/getBadgeSaldo"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:apiurl];

    //get user and pass from keychain
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"HSRMenuLogin" accessGroup:nil];
    
    NSString *username = [@"hsr\\" stringByAppendingString:[keychain objectForKey:CFBridgingRelease(kSecAttrAccount)]];
    NSString *password = [keychain objectForKey:CFBridgingRelease(kSecValueData)];

    NSString *authStr = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedString]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}



//delegate part
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"[info] i didReceiveAuthenticationChallenge");
    if ([challenge previousFailureCount] == 0){
        NSLog(@"failurecount was zero");

        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"HSRMenuLogin" accessGroup:nil];
        
        NSString *username = [@"hsr\\" stringByAppendingString:[keychain objectForKey:CFBridgingRelease(kSecAttrAccount)]];
        NSString *password = [keychain objectForKey:CFBridgingRelease(kSecValueData)];

        NSURLCredential *newCredential;
        newCredential = [NSURLCredential credentialWithUser:username
                                                   password:password
                                                persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
        
        
        //[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        //[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        UIAlertView *wrongpass = [[UIAlertView alloc] initWithTitle:@"Login fehlgeschlagen" message:@"Benutzername oder Kennwort falsch" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [wrongpass show];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)jsondata
{
    NSLog(@"[Info] data from Badgeportal received");
    [data appendData:jsondata];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSError *e =nil;
    NSDictionary *test = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error: &e];
    if (!e){
        [self writeSaldoToUi:[test objectForKey:@"badgeSaldo"]];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *noconnection = [[UIAlertView alloc] initWithTitle:@"Keine Verbindung" message:@"Es wurden keine neuen Daten geladen, da keine Verbindung zum Server aufgebaut werden konnte" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [noconnection show];
    NSLog(@"%@", error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)writeSaldoToUi:(NSString *)saldo
{
    NSLog(@"[Info] the new value is: %@", saldo);
    NSString *nice = [[NSString alloc] initWithFormat:@"CHF %@", saldo];
    [money setText:nice];
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSString *formattedDateString = [dateFormatter stringFromDate:now];
 
    [lastupdate setText:[@"Stand: " stringByAppendingString: formattedDateString]];
    
}



@end
