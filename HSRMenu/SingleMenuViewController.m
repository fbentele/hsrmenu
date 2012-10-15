//
//  SingleMenuViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 29.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.

#import "SingleMenuViewController.h"
#import "HSRFirstViewController.h"

@interface SingleMenuViewController ()
@property (strong, nonatomic) NSMutableArray *menu;
@property (nonatomic) id menuContent;
@property (nonatomic) id menuTitle;
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
@synthesize menuContent1;
@synthesize menuTitle1;
@synthesize menuContent2;
@synthesize menuTitle2;
@synthesize menuContent3;
@synthesize menuTitle3;
@synthesize currentday;
@synthesize menuContent;
@synthesize menuTitle;
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

    if(![self loadMenusFromPersistencyLayerIfAvailable]){
        [self initJsonConnection];
    }

    [self writeMenuToUi];
    }


//persistence layer
- (BOOL)loadMenusFromPersistencyLayerIfAvailable
{
    NSString *plistDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [plistDirectory stringByAppendingPathComponent:@"menus.plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        NSLog(@"[Info] plist ok, and readable");
        self.menu = [NSMutableArray arrayWithContentsOfFile:plistPath];
        if ([menu count]>0){
            NSLog(@"[Info] menu is having content, no connection needed");
            return YES;
        }
    } else {
        [self initJsonConnection];
        NSLog(@"[Error] Calling JSONConnection because no plist loaded from path %@", plistPath);
    }
    return NO;
}

//the connection stuff
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
    //NSLog(@"der tag ist: %d", theday);
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
    UIAlertView *noconnection = [[UIAlertView alloc] initWithTitle:@"No Connection" message:@"Could not load data, no connection to the internet" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
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


@end
