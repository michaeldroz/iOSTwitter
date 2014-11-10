//
//  TwitterController.m
//  TwitterExample2
//
//  Created by Michael Droz on 11/9/14.
//  Copyright (c) 2014 Michael Droz. All rights reserved.
//

#import "TwitterController.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

static NSString * const kSavedTwitterAccountKey = @"SavedTwitterAccount";

@implementation TwitterController {
    ACAccountStore *_accountStore;
    ACAccount *_twitterAccount;
}

+ (id)sharedInstance
{
    static id _sharedInstance = nil;
    
    if (_sharedInstance == nil) {
        _sharedInstance = [[self alloc] init];
    }
    return _sharedInstance;
    
    }

- (id)init
{
    self = [super init];
    
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
        // If we've previously saved the account, load it now
        NSString *accountId = [[NSUserDefaults standardUserDefaults] stringForKey:kSavedTwitterAccountKey];
        
        if (accountId) {
            _twitterAccount = [_accountStore accountWithIdentifier:accountId];
        }
    }
    return self;
        }

- (void)authorizeAccount
{
    if (_twitterAccount == nil) {
        ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [_accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
            if (granted ) {
                NSArray *twitterAccounts = [_accountStore accountsWithAccountType:accountType];
                if ([twitterAccounts count] > 0 ) {
                    _twitterAccount = [twitterAccounts objectAtIndex:0];
                
                    NSString *identifer = [_twitterAccount identifier];
                    
                    [userDefaults setObject:identifer forKey:kSavedTwitterAccountKey];
                    [userDefaults synchronize];
                }
            }
        }];
    }
}

- (void)getTweetsInUserTimelineWithCompletionHandler:(void (^)(NSArray *))handler
{
    NSString *timelinePath = @"https://api.twitter.com/1/statuses/home_timeline.json"; NSURL *timelineURL = [NSURL URLWithString:timelinePath];
    
    TWRequest *timelineRequest = [[TWRequest alloc] initWithURL:timelineURL parameters:nil requestMethod:TWRequestMethodGET];
    
    [timelineRequest setAccount:_twitterAccount];
    [timelineRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            id topLevelObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];
            
            if ([topLevelObject isKindOfClass:[NSArray class]]) {
                if (handler != NULL) {
                    handler(topLevelObject);
                    
                }
            }
        }
    }];
}



@end
