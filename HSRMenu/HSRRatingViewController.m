//
//  HSRRatingViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 13.11.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "HSRRatingViewController.h"

@interface HSRRatingViewController ()

@end

@implementation HSRRatingViewController

int currentmenuid;

-(void)setMenuid:(int)menuid
{
    currentmenuid = menuid;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)dosomething:(id)sender {
    UIButton *rater = sender;

    NSString *post = [[NSString alloc] initWithFormat:@"menuid=%d&rating=%@", currentmenuid, [[rater titleLabel] text]];
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
    NSLog(@"Yayyy, works if menuid is %d", currentmenuid);
    NSLog(@"and the rating is %@", [[rater titleLabel] text]);
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setGoback:nil];
    [super viewDidUnload];
}
@end
