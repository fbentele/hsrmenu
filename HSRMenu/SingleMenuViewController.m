//
//  SingleMenuViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 29.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.

#import "SingleMenuViewController.h"
#import "HSRFirstViewController.h"
#import "ODRefreshControl.h"
#import "HSRMenuBrain.h"


@interface SingleMenuViewController (){
    ODRefreshControl *_refresher;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (nonatomic) int currentday;
@property (strong, nonatomic, readwrite) NSString *plistPath;
@property (strong, nonatomic) ODRefreshControl *refresher;
@end

@implementation SingleMenuViewController
@synthesize scroller, currentday, plistPath, ratescroller3;
@synthesize refresher = _refresher;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    model = [[HSRMenuBrain alloc] init];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.scroller];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    NSArray *weekdays = [NSArray arrayWithObjects:@" ", @"Montag", @"Dienstag", @"Mittwoch", @"Donnerstag", @"Freitag", nil];
    [titlebartitle setTitle:[weekdays objectAtIndex:currentday]];
    
    
    //Not enforceing a reload
    [self refreshValues:NO];
    
    UIImage *tempimage = [UIImage imageNamed:@"single3.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:tempimage];

    CGRect rect = imageView.frame;
    rect.size.height = 134;
    rect.size.width = 320;
    imageView.frame = rect;
    imageView.tag = 1;
    [ratescroller3 addSubview:imageView];
    [ratescroller3 addSubview:menucontent3];
    [ratescroller3 addSubview:int3];
    [ratescroller3 addSubview:ext3];
    [ratescroller3 addSubview:rating3];

    tempimage = [UIImage imageNamed:@"rating.png"];
    imageView = [[UIImageView alloc] initWithImage:tempimage];
    imageView.tag = 2;
    [ratescroller3 addSubview:imageView];
    [self layoutScrollImages];
}

- (void)layoutScrollImages
{
	UIImageView *view = nil;
	NSArray *subviews = [ratescroller3 subviews];
    
	CGFloat curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
			curXLoc += (320);
		}
	}
	[ratescroller3 setContentSize:CGSizeMake((2 * 320), [ratescroller3 bounds].size.height)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setMenuDay:(int)theday
{
    currentday = theday;
}

- (void)refreshValues:(BOOL)enforced
{
    NSMutableArray *menu = [model menuforday:currentday enforcedReload:enforced];
    NSDictionary *item = [menu objectAtIndex:0];
    
    if ([menu count] == 5){
        [menucontent1 setText:[item objectForKey:@"menu"]];
        [int1 setText:[item objectForKey:@"priceint"]];
        [ext1 setText:[item objectForKey:@"priceext"]];
        [rating1 setImage:[self getRatingImage:[item objectForKey:@"rating"]]];
        
        item = [menu objectAtIndex:3];
        [menucontent2 setText:[item objectForKey:@"menu"]];
        [int2 setText:[item objectForKey:@"priceint"]];
        [ext2 setText:[item objectForKey:@"priceext"]];
        [rating2 setImage:[self getRatingImage:[item objectForKey:@"rating"]]];

        item = [menu objectAtIndex:1];
        [menucontent3 setText:[item objectForKey:@"menu"]];
        [int3 setText:[item objectForKey:@"priceint"]];
        [ext3 setText:[item objectForKey:@"priceext"]];
        [rating3 setImage:[self getRatingImage:[item objectForKey:@"rating"]]];
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

-(UIImage *)getRatingImage:(id)stars
{
    int i = [stars integerValue];
    NSArray *rating = [NSArray arrayWithObjects:@"stars0.png", @"stars1.png", @"stars2.png", @"stars3.png", @"stars4.png", @"stars5.png", nil];
    return [UIImage imageNamed:[rating objectAtIndex:i]];
}


// pull to refresh
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    [self refreshValues:YES];
    [self setRefresher:refreshControl];
    [[self refresher] endRefreshing];
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
    ratescroller3 = nil;
    rating3 = nil;
    rating2 = nil;
    rating1 = nil;
    [super viewDidUnload];
}


@end
