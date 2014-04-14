//
//  KeyProvClientNonce.h
//  poc-otp
//
//  Created by Arley Mauricio Duarte on 4/3/13.
//  Copyright (c) 2013 Excelsys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyProvClientNonce : NSObject
@property (nonatomic, copy) NSString *session_id;
@property (nonatomic, copy) NSString *encryption_key;
@property (nonatomic, copy) NSString *client_random;
@property (nonatomic, copy) NSString *client_id;
@property (nonatomic, copy) NSString *server_random;
@property (nonatomic, copy) NSString *activation_code;
-(id)initWithSessionId:(NSString *) sessionId EncryptationKey: (NSString *) encryptationKey ServerRandom: (NSString *) serverRandom ActivationCode: (NSString *) activationCode;

-(NSString *) getKeyProvClientNonceMessage;

@end
