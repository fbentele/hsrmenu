//
//  SingleMenuViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 29.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.

#import "HSRMenuViewController.h"
#import "HSRMenuConnection.h"

@implementation HSRMenuViewController
@synthesize scroller, currentday, plistPath, ratescroller3, ratescroller1, ratescroller2, refresher, titlebartitle;
@synthesize menucontent1, menucontent2, menucontent3, int1, int2, int3, ext1, ext2, ext3, averageRatingForMenu1, averageRatingForMenu2, averageRatingForMenu3;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    menuConnection = [[HSRMenuConnection alloc] init];
    [menuConnection setDelegate:self];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.scroller];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    //Set Title
    NSArray *weekdays = [NSArray arrayWithObjects:@" ", @"Montag", @"Dienstag", @"Mittwoch", @"Donnerstag", @"Freitag", nil];
    [titlebartitle setTitle:[weekdays objectAtIndex:currentday]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_background.png"]];

    CGRect rect = imageView.frame;
    rect.size.height = 134;
    rect.size.width = 320;
    imageView.frame = rect;
    
    [ratescroller3 addSubview:imageView];
    [ratescroller3 addSubview:menucontent3];
    [ratescroller3 addSubview:int3];
    [ratescroller3 addSubview:ext3];
    [ratescroller3 addSubview:averageRatingForMenu3];
    
    rater3 = [[HSRRatingView alloc] initWithFrame:CGRectMake(320, 0, 320, 134)];
    [[rater3 ratingControl] setDelegate:self];
    
    [ratescroller3 addSubview:rater3];
    [ratescroller3 setContentSize:CGSizeMake((2 * 320), [ratescroller3 bounds].size.height)];
    
    UIImageView *secondMenu = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 134)];
    [secondMenu setImage:[UIImage imageNamed:@"menu_background.png"]];
    [ratescroller2 addSubview:secondMenu];
    [ratescroller2 addSubview:menucontent2];
    [ratescroller2 addSubview:int2];
    [ratescroller2 addSubview:ext2];
    [ratescroller2 addSubview:averageRatingForMenu2];
    
    rater2 = [[HSRRatingView alloc] initWithFrame:CGRectMake(320, 0, 320, 134)];
    [[rater2 ratingControl] setDelegate:self];
    [ratescroller2 addSubview:rater2];
    [ratescroller2 setContentSize:CGSizeMake((2 * 320), 134)];
    
    UIImageView *firstMenu = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 134)];
    [firstMenu setImage:[UIImage imageNamed:@"menu_background.png"]];
    [ratescroller1 addSubview:firstMenu];
    [ratescroller1 addSubview:menucontent1];
    [ratescroller1 addSubview:int1];
    [ratescroller1 addSubview:ext1];
    [ratescroller1 addSubview:averageRatingForMenu1];
    
    rater1 = [[HSRRatingView alloc] initWithFrame:CGRectMake(320, 0, 320, 134)];
    [[rater1 ratingControl] setDelegate:self];
    [ratescroller1 addSubview:rater1];
    [ratescroller1 setContentSize:CGSizeMake((2 * 320), 134)];
    
    [self refreshValuesWithEnforcedReloading:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setMenuDay:(int)theday
{
    currentday = theday;
}

- (void)refreshValuesWithEnforcedReloading:(BOOL)enforced
{
    NSMutableArray *menu = [menuConnection menuforday:currentday enforcedReload:enforced];
    [self updateUi:menu];
}

-(UIImage *)getRatingImage:(id)stars
{
    int i = [stars integerValue];
    NSArray *rating = [NSArray arrayWithObjects:@"stars0.png", @"stars1.png", @"stars2.png", @"stars3.png", @"stars4.png", @"stars5.png", nil];
    return [UIImage imageNamed:[rating objectAtIndex:i]];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    [self refreshValuesWithEnforcedReloading:YES];
    [self setRefresher:refreshControl];
}

-(void)newRating:(DLStarRatingControl *)control :(float)rating {
    if (![menuConnection rateMenu:[control tag] withRating:(int)rating]){
        UIAlertView *noconnection = [[UIAlertView alloc] initWithTitle:@"Bereits gewählt" message:@"Es wurde bereits ein Rating empfangen" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [noconnection show];
    }
}

-(void)didFailLoading:(HSRMenuConnection *)sender {
    [refresher endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertView *noconnection = [[UIAlertView alloc] initWithTitle:@"Keine Verbindung" message:@"Es wurden keine neuen Daten geladen, da keine Verbindung zum Server aufgebaut werden konnte" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [noconnection show];
}

-(void)didFinishLoading:(HSRMenuConnection *)sender withNewMenu:(NSMutableArray *)menu
{
    [refresher endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateUi:menu];
}

- (void)updateUi:(NSMutableArray *)menu
{
    NSDictionary *item = [menu objectAtIndex:0];
    if ([menu count] == 5){
        int menuid = [[item objectForKey:@"menuid"] integerValue];
        [rater1 setTag:menuid];
        [menucontent1 setText:[item objectForKey:@"menu"]];
        [int1 setText:[item objectForKey:@"priceint"]];
        [ext1 setText:[item objectForKey:@"priceext"]];
        [averageRatingForMenu1 setImage:[self getRatingImage:[item objectForKey:@"rating"]]];
        [rater1 setRating:[self userRatingForMenu:menuid]];
        
        item = [menu objectAtIndex:3];
        menuid = [[item objectForKey:@"menuid"] integerValue];
        [rater2 setTag:menuid];
        [menucontent2 setText:[item objectForKey:@"menu"]];
        [int2 setText:[item objectForKey:@"priceint"]];
        [ext2 setText:[item objectForKey:@"priceext"]];
        [averageRatingForMenu2 setImage:[self getRatingImage:[item objectForKey:@"rating"]]];
        [rater2 setRating:[self userRatingForMenu:menuid]];
        
        item = [menu objectAtIndex:1];
        menuid = [[item objectForKey:@"menuid"] integerValue];
        [rater3 setTag:menuid];
        [menucontent3 setText:[item objectForKey:@"menu"]];
        [int3 setText:[item objectForKey:@"priceint"]];
        [ext3 setText:[item objectForKey:@"priceext"]];
        [averageRatingForMenu3 setImage:[self getRatingImage:[item objectForKey:@"rating"]]];
        [rater3 setRating:[self userRatingForMenu:menuid]];
    } else {
        [menucontent1 setText:@"Für Heute ist leider kein Menu verfügbar"];
        [int1 setText:@""];
        [ext1 setText:@""];
        [menucontent2 setText:@" "];
        [int2 setText:@""];
        [ext2 setText:@""];
        [menucontent3 setText:@" "];
        [int3 setText:@""];
        [ext3 setText:@""];
    }
}

- (float)userRatingForMenu:(int)menuid
{
    NSUserDefaults *userrating = [NSUserDefaults standardUserDefaults];
    id a = [userrating objectForKey:[NSString stringWithFormat:@"%d", menuid]];
    return [a floatValue];
}


- (void)viewDidUnload
{
    menucontent1 = nil;
    menucontent2 = nil;
    menucontent3 = nil;
    int1 = nil;
    ext1 = nil;
    int2 = nil;
    ext2 = nil;
    int3 = nil;
    ext3 = nil;
    averageRatingForMenu3 = nil;
    averageRatingForMenu2 = nil;
    averageRatingForMenu1 = nil;
    ratescroller3 = nil;
    ratescroller2 = nil;
    ratescroller1 = nil;
    [self setRatescroller2:nil];
    [self setRatescroller3:nil];
    [super viewDidUnload];
}

@end
