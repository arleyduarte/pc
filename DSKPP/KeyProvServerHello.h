//
//  KeyProvServerHello.h
//  poc-otp
//
//  Created by Arley Mauricio Duarte on 4/3/13.
//  Copyright (c) 2013 Excelsys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyProvServerHello : NSObject
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *session_id;
@property (nonatomic, copy) NSString *encryption_key;
@property (nonatomic, copy) NSString *server_random;
-(id)initWithJSONObject:(NSData *) urlData;

@end
