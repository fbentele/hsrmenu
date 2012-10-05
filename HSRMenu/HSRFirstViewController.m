//
//  HSRFirstViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 25.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "HSRFirstViewController.h"
#import "SingleMenuViewController.h"

@interface HSRFirstViewController ()
@property (nonatomic) int day;
@property (strong, nonatomic) IBOutlet UITableView *thetable;
@property (weak, nonatomic) IBOutlet UITableViewCell *monday;

@end

@implementation HSRFirstViewController

@synthesize display = _display;
@synthesize day = _day;

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)viewDidUnload {
    [self setThetable:nil];
    [self setMonday:nil];
    [super viewDidUnload];
}
@end
