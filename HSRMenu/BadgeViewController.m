//
//  HSRSecondViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 25.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "BadgeViewController.h"
#import "ODRefreshControl.h"
#import "HSRBadgeConnection.h"

@interface BadgeViewController (){
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) ODRefreshControl *refresher;

@end

@implementation BadgeViewController
@synthesize  scrollView, refresher;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    badgesaldo = [[HSRBadgeConnection alloc] init];
    [badgesaldo setDelegate:self];
    
    //Pull to refresh
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.scrollView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [self requestData:NO];
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
    [self requestData:YES];
    [self setRefresher:refreshControl];
}

- (void)requestData:(BOOL)enforced
{
    float saldo = [badgesaldo getSaldoIfPossible:enforced];
    NSNumber *timestamp = [badgesaldo getTimestamp];
    [self updateUiWith:saldo and:timestamp];
}

-(void)updateUiWith:(float)saldo and:(NSNumber *)timestamp
{
    NSString *nice = [[NSString alloc] initWithFormat:@"CHF %.2f", saldo];
    [money setText:nice];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    [lastupdate setText:[@"Stand: " stringByAppendingString: formattedDateString]];
}

-(void)didFailLoading:(HSRBadgeConnection *)sender{
    [refresher endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertView *noconnection = [[UIAlertView alloc] initWithTitle:@"Keine Verbindung" message:@"Es wurden keine neuen Daten geladen, da keine Verbindung zum Server aufgebaut werden konnte" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [noconnection show];
}

-(void)didFinishLoading:(HSRBadgeConnection *)sender withNewSaldo:(float)saldo andTimestamp:(NSNumber *)timestamp{
    [refresher endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateUiWith:saldo and:timestamp];

}

@end
