//
//  HSRMenuBrain.h
//  HSRMenu
//
//  Created by Florian Bentele on 09.11.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSRMenuConnection;

@protocol HSRMenuConnectionDelegate
-(void)didFinishLoading:(HSRMenuConnection *)sender withNewMenu:(NSMutableArray *)menu;
-(void)didFailLoading:(HSRMenuConnection *)sender;
@end

@interface HSRMenuConnection : NSObject {
    NSMutableData *data;
    NSMutableArray *menu;
    NSString *plistPath;
    NSUserDefaults *userratings;

    BOOL hasrated;
}

@property (nonatomic, weak) id <HSRMenuConnectionDelegate> delegate;

-(NSMutableArray *) menuforday:(int)day enforcedReload:(BOOL)forced;
-(int) menuidForDay:(int)day;
-(BOOL) rateMenu:(int)menuid withRating:(int)rating;
@end
