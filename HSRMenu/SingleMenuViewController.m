//
//  SingleMenuViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 29.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.

#import "SingleMenuViewController.h"
#import "HSRFirstViewController.h"
#import "ODRefreshControl.h"


@interface SingleMenuViewController ()
@property (strong, nonatomic) NSMutableArray *menu;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UILabel *menuTitle1;
@property (weak, nonatomic) IBOutlet UILabel *menuContent1;
@property (weak, nonatomic) IBOutlet UILabel *menuTitle2;
@property (weak, nonatomic) IBOutlet UILabel *menuContent2;
@property (weak, nonatomic) IBOutlet UILabel *menuTitle3;
@property (weak, nonatomic) IBOutlet UILabel *menuContent3;
@property (nonatomic) int currentday;
@property (strong, nonatomic, readwrite) NSString *plistPath;
@end

@implementation SingleMenuViewController
@synthesize menu;
@synthesize scroller;
@synthesize menuContent1;
@synthesize menuTitle1;
@synthesize menuContent2;
@synthesize menuTitle2;
@synthesize menuContent3;
@synthesize menuTitle3;
@synthesize currentday;
@synthesize plistPath;

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
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.scroller];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    if(![self loadMenusFromPersistencyLayerIfAvailable]){
        [self initJsonConnection];
    }
    
    [self writeMenuToUi];
    }


//persistence layer
- (BOOL)loadMenusFromPersistencyLayerIfAvailable
{
    NSString *plistDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [plistDirectory stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"menus%d.plist", currentday]];
    if([[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        NSLog(@"[Info] plist ok, and readable");
        self.menu = [NSMutableArray arrayWithContentsOfFile:plistPath];
        int cachetime =[[[menu objectAtIndex:4] objectForKey:@"time"] intValue];
        int now = (int)[[NSDate date ]timeIntervalSince1970];
        NSLog(@"cachetime is:%d", cachetime);
        NSLog(@"now is      :%d", now);

        if (cachetime +3600 > now){
            NSLog(@"[Info] cache is fresh, no connection needed");
            return YES;
        }
    } else {
        [self initJsonConnection];
        NSLog(@"[Error] Calling JSONConnection because no plist loaded from path %@", plistPath);
    }
    return NO;
}

//the connection stuff
//====================
- (void)initJsonConnection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://florian.bentele.me/HSRMenu/api.php?day=%d", currentday];
    NSURL* apiurl = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:apiurl];
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)safeMenusToFile{
    [menu writeToFile:plistPath atomically:YES];
    NSLog(@"[Info] Plist written");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setMenuDay:(int)theday
{
    NSLog(@"der tag ist: %d", theday);
    currentday = theday;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

//the connection delegate part
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
        [self writeMenuToUi];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *noconnection = [[UIAlertView alloc] initWithTitle:@"Keine Verbindung" message:@"Es wurden keine neuen Daten geladen, da keine Verbindung zum Server aufgebaut werden konnte" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [noconnection show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)writeMenuToUi
{
    NSDictionary *item = [menu objectAtIndex:0];
    
    [menuTitle1 setText:[item objectForKey:@"title"]];
    [menuContent1 setText:[item objectForKey:@"menu"]];
    item = [menu objectAtIndex:1];
    [menuTitle2 setText:[item objectForKey:@"title"]];
    [menuContent2 setText:[item objectForKey:@"menu"]];
    item = [menu objectAtIndex:3];
    [menuTitle3 setText:[item objectForKey:@"title"]];
    [menuContent3 setText:[item objectForKey:@"menu"]];
}


// pull to refresh
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 1.0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    [self initJsonConnection];
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
}



@end