//
//  HSRMenuBrain.m
//  HSRMenu
//
//  Created by Florian Bentele on 09.11.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "HSRMenuBrain.h"

@implementation HSRMenuBrain



-(NSMutableArray *)menuforday:(int)day enforcedReload:(BOOL)forced
{
    //return the menu nsdictionary for the day 'day' from persitency layer if available
    
    if (![self loadMenusFromPersistencyLayerIfAvailable:day] || forced){
        [self initJsonConnection:day];
    }
    return menu;
}

-(int) menuidForDay:(int)day
{
    NSNumber *menuid = [menu objectAtIndex:0];
    return [menuid intValue];
}


- (void)initJsonConnection:(int)day
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://florian.bentele.me/HSRMenu/api.php?day=%d", day];
    NSURL* apiurl = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:apiurl];
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
    
    //Parsing JSON
    NSError *e = nil;
    menu = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error: &e];
    if (e) {
        NSLog(@"Error parsing JSON: %@", e);
    } else {
        [self safeMenusToFile];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *noconnection = [[UIAlertView alloc] initWithTitle:@"Keine Verbindung" message:@"Es wurden keine neuen Daten geladen, da keine Verbindung zum Server aufgebaut werden konnte" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [noconnection show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (BOOL)loadMenusFromPersistencyLayerIfAvailable:(int) currentday
{
    NSString *plistDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [plistDirectory stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"menus%d.plist", currentday]];
    if([[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        NSLog(@"[Info] plist ok, and readable");
        menu = [NSMutableArray arrayWithContentsOfFile:plistPath];
        if ([menu count] > 4) {
            int cachetime =[[[menu objectAtIndex:4] objectForKey:@"time"] intValue];
            int now = (int)[[NSDate date ]timeIntervalSince1970];
            NSLog(@"[Info] cachetime is:%d", cachetime);
            NSLog(@"[Info] now is      :%d", now);
            if (cachetime +3600 > now){
                NSLog(@"[Info] cache is fresh, no connection needed");
                return YES;
            } else {
                NSLog(@"[Info] cache is old, connection needed");
                return NO;
            }
        }
    } else {
        NSLog(@"[Info] No Plist available");
        return NO;
    }
    return NO;
}

-(void)rateMenu:(int)menuid withRating:(int)rating
{
    NSString *post = [[NSString alloc] initWithFormat:@"menuid=%d&rating=%d", menuid, rating];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://florian.bentele.me/HSRMenu/api.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", returnString);
    NSLog(@"i posted to the server %@", post);
}

- (void)safeMenusToFile{
    [menu writeToFile:plistPath atomically:YES];
    NSLog(@"[Info] Plist written");
}

@end
