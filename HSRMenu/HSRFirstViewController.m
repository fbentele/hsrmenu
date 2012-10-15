//
//  HSRFirstViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 25.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "HSRFirstViewController.h"
#import "SingleMenuViewController.h"
#import "ODRefreshControl.h"


@interface HSRFirstViewController ()
@property (nonatomic) int day;
@property (strong, nonatomic) IBOutlet UITableView *thetable;
@property (weak, nonatomic) IBOutlet UITableViewCell *monday;
@property (weak, nonatomic) IBOutlet UITableViewCell *tuesday;
@property (weak, nonatomic) IBOutlet UITableViewCell *wednesday;
@property (weak, nonatomic) IBOutlet UITableViewCell *thursday;
@property (weak, nonatomic) IBOutlet UITableViewCell *friday;

@property (strong, nonatomic) NSMutableArray *week;


@end

@implementation HSRFirstViewController

@synthesize monday;
@synthesize tuesday;
@synthesize wednesday;
@synthesize thursday;
@synthesize friday;
@synthesize display;
@synthesize day;
@synthesize week;

- (void)viewDidLoad
{
    [super viewDidLoad];
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.thetable];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setDayandShowMenu:(indexPath.row+1)];
}


-(void)setDayandShowMenu:(int)selectedday
{
    self.day = selectedday;
    [self performSegueWithIdentifier:@"ShowMenu" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowMenu"]){
        [segue.destinationViewController setMenuDay:self.day];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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


- (void)initJsonConnection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://florian.bentele.me/HSRMenu/day.php"];
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
    week = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error: &e];
    if (e) {
        NSLog(@"Error parsing JSON: %@", e);
    } else {
        NSLog(@"everything ok");
        [[monday detailTextLabel] setText:[week objectAtIndex:0]];
        [[tuesday detailTextLabel] setText:[week objectAtIndex:1]];
        [[wednesday detailTextLabel] setText:[week objectAtIndex:2]];
        [[thursday detailTextLabel] setText:[week objectAtIndex:3]];
        [[friday detailTextLabel] setText:[week objectAtIndex:4]];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *noconnection = [[UIAlertView alloc] initWithTitle:@"No Connection" message:@"Could not load data, no connection to the internet" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [noconnection show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)viewDidUnload {
    [self setThetable:nil];
    [self setMonday:nil];
    [super viewDidUnload];
}
@end
