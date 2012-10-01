//
//  HSRFirstViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 25.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "HSRFirstViewController.h"

@interface HSRFirstViewController ()

@end

@implementation HSRFirstViewController

@synthesize display = _display;



- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURL* apiurl = [NSURL URLWithString:@"http://florian.bentele.me/hsrmenu/api.php?day=1"];
    NSURLRequest* request = [NSURLRequest requestWithURL:apiurl];
    NSObject* hello = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"%@", hello);
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)jsondata{
    [data appendData:jsondata];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //Parsing JSON
    menu = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    NSString *test = [[menu objectAtIndex:0] objectForKey:@"menu"];
    NSLog(@"%@", test);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *noconnection = [[UIAlertView alloc] initWithTitle:@"No Connection" message:@"Could not load data, no connection to the internet" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [noconnection show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
