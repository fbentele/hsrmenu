//
//  HSRSecondViewController.m
//  HSRMenu
//
//  Created by Florian Bentele on 25.09.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import "BadgeViewController.h"

@interface BadgeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *money;

@end

@implementation BadgeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setMoney:nil];
    [super viewDidUnload];
}

@end
