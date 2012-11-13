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

@interface BadgeViewController (){
    NSMutableArray *_badgedata;
    ODRefreshControl *_refresher;
}
@property (strong, nonatomic) NSMutableData *data;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *badgedata;
@property (strong, nonatomic) NSString *plistPath;
@property (strong, nonatomic) ODRefreshControl *refresher;

@end

@implementation BadgeViewController
@synthesize data, scrollView, badgedata = _badgedata, plistPath;
@synthesize refresher = _refresher;

- (void)viewDidLoad
{
    //initialize plist
    NSString *plistDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [[NSString alloc] initWithString:[plistDirectory stringByAppendingPathComponent:@"badge.plist"]];

    [super viewDidLoad];
    
    if ([self loadSaldoFromCache]){
        [self writeSaldoToUi];
    } else {
        [self initJsonConnection];
    }
        
    //Pull to refresh
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
    [self setRefresher:refreshControl];
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
    if ([challenge previousFailureCount] == 0){
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
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
    //eye candy
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[self refresher] endRefreshing];
    
    NSError *e =nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error: &e];
    if (!e){
        NSLog(@"[Info] new saldo received: %@", [json objectForKey:@"badgeSaldo"]);
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        [temp addObject:[json objectForKey:@"badgeSaldo"]];
        [temp addObject:[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]]];
        [self setBadgedata:temp];
        [self writeSaldoToCache];
        [self writeSaldoToUi];

    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *noconnection = [[UIAlertView alloc] initWithTitle:@"Keine Verbindung" message:@"Es wurden keine neuen Daten geladen, da keine Verbindung zum Server aufgebaut werden konnte" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [noconnection show];
    NSLog(@"%@", error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[self refresher] endRefreshing];

}

- (void)writeSaldoToUi
{
    float saldo =[[[self badgedata] objectAtIndex:0] floatValue];    
    NSString *nice = [[NSString alloc] initWithFormat:@"CHF %.2f", saldo];
    [money setText:nice];
    
    NSNumber *timestamp = [[self badgedata] objectAtIndex:1];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    [lastupdate setText:[@"Stand: " stringByAppendingString: formattedDateString]];
}

- (BOOL)loadSaldoFromCache
{
    if([[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        NSLog(@"[Info] plist ok, and readable");
        [self setBadgedata:[NSMutableArray arrayWithContentsOfFile:plistPath]];
        if ([[self badgedata] count] >= 2) {
            int cachetime =[[[self badgedata] objectAtIndex:1] intValue];
            int now = (int)[[NSDate date]timeIntervalSince1970];
            if (cachetime + 3600 > now){
                NSLog(@"[Info] cache is fresh, no connection needed");
                return YES;
            } else {
                NSLog(@"[Info] cache is old, update needed");
                return NO;
            }
        }
    }
    return NO;
}

-(BOOL)writeSaldoToCache
{
    NSLog(@"[Info] writing badgedata to plist: %@", [[self badgedata] description]);
    return [[self badgedata] writeToFile:plistPath atomically:YES];
}



@end
