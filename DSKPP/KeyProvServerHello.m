//
//  KeyProvServerHello.m
//  poc-otp
//
//  Created by Arley Mauricio Duarte on 4/3/13.
//  Copyright (c) 2013 Excelsys. All rights reserved.
//

#import "KeyProvServerHello.h"

@implementation KeyProvServerHello

-(id)initWithJSONObject:(NSData *) urlData {
    self = [super init];
    if (self) {
            NSError *myError = nil;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableLeaves error:&myError];
        
         NSLog(@"KeyProvServerHello: %@", res);
        
        self.encryption_key = [res valueForKeyPath:@"KeyProvServerHello.encryption_key"];
        self.session_id = [res valueForKeyPath:@"KeyProvServerHello.session_id"];
        
        self.server_random = [res valueForKeyPath:@"KeyProvServerHello.payload.nonce"];

    }
    return self;
}

@end
