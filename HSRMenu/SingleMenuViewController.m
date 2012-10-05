//
//  SingleMenuViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 29.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "SingleMenuViewController.h"
#import "HSRFirstViewController.h"

@interface SingleMenuViewController ()
@property (nonatomic) id menuContent;
@property (nonatomic) id menuTitle;
@property (weak, nonatomic) IBOutlet UILabel *menuTitle1;
@property (weak, nonatomic) IBOutlet UILabel *menuContent1;
@property (weak, nonatomic) IBOutlet UILabel *menuTitle2;
@property (weak, nonatomic) IBOutlet UILabel *menuContent2;
@property (weak, nonatomic) IBOutlet UILabel *menuTitle3;
@property (weak, nonatomic) IBOutlet UILabel *menuContent3;
@property (nonatomic) int currentday;
@end

@implementation SingleMenuViewController
@synthesize menuContent1 = _menuContent1;
@synthesize menuTitle1 = _menuTitle1;
@synthesize menuContent2 = _menuContent2;
@synthesize menuTitle2 = _menuTitle2;
@synthesize menuContent3 = _menuContent3;
@synthesize menuTitle3 = _menuTitle3;
@synthesize currentday = _currentday;
@synthesize menuContent = _menuContent;
@synthesize menuTitle = _menuTitle;

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

    //the connection stuff
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://florian.bentele.me/HSRMenu/api.php?day=%d", _currentday];
    NSURL* apiurl = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:apiurl];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setMenuDay:(int)theday
{
    //NSLog(@"der tag ist: %d", theday);
    _currentday = theday;
}

- (void)viewDidUnload {
    [self setMenuTitle1:nil];
    [self setMenuTitle2:nil];
    [super viewDidUnload];
}


//the connection part

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)jsondata{
    NSLog(@"data received");
    [data appendData:jsondata];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //Parsing JSON
    NSError *e = nil;
    menu = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error: &e];
    if (e) {
        NSLog(@"Error parsing JSON: %@", e);
    } else {
        NSDictionary *item = [menu objectAtIndex:0];
        [_menuTitle1 setText:[item objectForKey:@"title"]];
        [_menuContent1 setText:[item objectForKey:@"menu"]];
        item = [menu objectAtIndex:1];
        [_menuTitle2 setText:[item objectForKey:@"title"]];
        [_menuContent2 setText:[item objectForKey:@"menu"]];
        item = [menu objectAtIndex:3];
        [_menuTitle3 setText:[item objectForKey:@"title"]];
        [_menuContent3 setText:[item objectForKey:@"menu"]];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *noconnection = [[UIAlertView alloc] initWithTitle:@"No Connection" message:@"Could not load data, no connection to the internet" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [noconnection show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



@end
