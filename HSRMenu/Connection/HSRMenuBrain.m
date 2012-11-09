//
//  HSRMenuBrain.m
//  HSRMenu
//
//  Created by Florian Bentele on 09.11.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "HSRMenuBrain.h"

@implementation HSRMenuBrain



-(NSDictionary *)menuforday:(int)day
{
    //return the menu nsdictionary for the day 'day' from persitency layer if available
    return nil;
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
    //[[self refresher] endRefreshing];
    
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
            NSLog(@"cachetime is:%d", cachetime);
            NSLog(@"now is      :%d", now);
            if (cachetime +3600 > now){
                NSLog(@"[Info] cache is fresh, no connection needed");
                return YES;
            } else {
                NSLog(@"[Info] cache is old, connection needed");
            }
        }
    } else {
        //[self initJsonConnection];
        NSLog(@"[Info] Calling JSONConnection because no plist loaded from path %@", plistPath);
    }
    return NO;
}


- (void)safeMenusToFile{
    [menu writeToFile:plistPath atomically:YES];
    NSLog(@"[Info] Plist written");
}



@end
