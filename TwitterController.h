//
//  TwitterController.h
//  TwitterExample2
//
//  Created by Michael Droz on 11/9/14.
//  Copyright (c) 2014 Michael Droz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterController : NSObject

+ (id)sharedInstance;

- (void)authorizeAccount;
- (void)getTweetsInUserTimelineWithCompletionHandler:(void(^)(NSArray *tweets))handler; 

@end
