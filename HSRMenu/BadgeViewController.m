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
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (strong, nonatomic) NSMutableData *data;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation BadgeViewController
@synthesize data, money, scrollView;

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
    [self setMoney:nil];
    [self setScrollView:nil];
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
    NSURL* apiurl = [NSURL URLWithString:@"https://152.96.80.18/VerrechnungsportalService.svc/json/getBadgeSaldo"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:apiurl];
    
//    NSLog(@"the url is %@", apiurl);
    
    //get user and pass from keychain
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"HSRMenuLogin" accessGroup:nil];
    
    NSString *username = [keychain objectForKey:CFBridgingRelease(kSecAttrAccount)];
    NSString *password = [keychain objectForKey:CFBridgingRelease(kSecValueData)];
    
    NSLog(@"the username is %@", username);
    NSLog(@"the password is %@", password);
    
    
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
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)jsondata
{
    NSLog(@"[Info] data received");
    [data appendData:jsondata];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSError *e =nil;
    NSDictionary *test = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error: &e];
    //NSLog(@"the json thing is %@", test.description);
    //NSLog(@"the test i want is %@", [test objectForKey:@"badgeSaldo"]);
    
    if (!e){
        [self writeSaldoToUi:[test objectForKey:@"badgeSaldo"]];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *noconnection = [[UIAlertView alloc] initWithTitle:@"No Connection" message:@"Could not load data, no connection to the internet" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [noconnection show];
    NSLog(@"%@", error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)writeSaldoToUi:(NSString *)saldo
{
    NSLog(@"the new value is: %@", saldo);
    NSString *nice = [[NSString alloc] initWithFormat:@"%@ CHF", saldo];
    [money setText:nice];
}



@end
