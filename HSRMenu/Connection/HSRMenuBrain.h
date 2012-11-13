//
//  HSRMenuBrain.h
//  HSRMenu
//
//  Created by Florian Bentele on 09.11.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSRMenuBrain : NSObject {
    NSMutableData *data;
    NSMutableArray *menu;
    NSString *plistPath;
}

-(NSDictionary *) menuforday:(int)day enforcedReload:(BOOL)forced;

@end
