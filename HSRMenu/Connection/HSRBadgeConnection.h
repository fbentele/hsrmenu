//
//  HSRBadgeConnection.h
//  HSRMenu
//
//  Created by Florian Bentele on 22.11.12.
//  Copyright (c) 2012 Florian Bentele. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSRBadgeConnection;

@protocol HSRBadgeConnectionDelegate
-(void)didFinishLoading:(HSRBadgeConnection *)sender withNewSaldo:(float)saldo andTimestamp:(NSNumber *)timestamp;
-(void)didFailLoading:(HSRBadgeConnection *)sender;
@end

@interface HSRBadgeConnection : NSObject
{
    NSMutableData *data;
    NSString *plistPath;
    int statuscode;
}

@property (nonatomic, weak) id <HSRBadgeConnectionDelegate> delegate;

-(float)getSaldoIfPossible:(BOOL)enforced;
-(NSNumber *)getTimestamp;

@end
