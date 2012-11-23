//
//  HSRBadgeConnection.m
//  HSRMenu
//
//  Created by Florian Bentele on 22.11.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "HSRBadgeConnection.h"
#import "KeychainItemWrapper.h"
#import "NSData+Base64.h"
#import "ODRefreshControl.h"

@implementation HSRBadgeConnection
@synthesize delegate, badgedata;

-(id)init
{
    self = [super init];
    return self;
}

-(float)getSaldoIfPossible:(BOOL)enforced {
    if ([self loadSaldoFromCache] && !enforced){
        NSLog(@"[Info] I delivered cachedata");
        return [[badgedata objectAtIndex:0] floatValue];
    } else {
        [self initJsonConnection];
        NSLog(@"[Info] I delivered fresh data");
        return [[badgedata objectAtIndex:0] floatValue];
    }
    return 0;
}

-(NSNumber *)getTimestamp{
    return [badgedata objectAtIndex:1];
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
    //NSLog(@"[Info] data from Badgeportal received");
    [data appendData:jsondata];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //eye candy
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *e =nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error: &e];
    if (!e){
        //NSLog(@"[Info] new saldo received: %@", [json objectForKey:@"badgeSaldo"]);
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        [temp addObject:[json objectForKey:@"badgeSaldo"]];
        [temp addObject:[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]]];
        badgedata = temp;
    }
    
    float saldo = [[badgedata objectAtIndex:0] floatValue];
    NSNumber *timestamp= [badgedata objectAtIndex:1];
    
    [delegate didFinishLoading:self withNewSaldo:saldo andTimestamp:timestamp];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    [[self delegate] didFailLoading:self];
}

- (BOOL)loadSaldoFromCache
{
    NSString *plistDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [[NSString alloc] initWithString:[plistDirectory stringByAppendingPathComponent:@"badge.plist"]];

    if([[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        //NSLog(@"[Info] plist ok, and readable");
        badgedata =[NSMutableArray arrayWithContentsOfFile:plistPath];
        if ([badgedata count] >= 2) {
            int cachetime =[[badgedata objectAtIndex:1] intValue];
            int now = (int)[[NSDate date]timeIntervalSince1970];
            if (cachetime + 3600 > now){
                //NSLog(@"[Info] cache is fresh, no connection needed");
                return YES;
            } else {
                //NSLog(@"[Info] cache is old, update needed");
                return NO;
            }
        }
    }
    return NO;
}

-(BOOL)writeSaldoToCache
{
    //NSLog(@"[Info] writing badgedata to plist: %@", [badgedata description]);
    return [badgedata writeToFile:plistPath atomically:YES];
}

@end

