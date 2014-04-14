//
//  KeyProvClientNonce.m
//  poc-otp
//
//  Created by Arley Mauricio Duarte on 4/3/13.
//  Copyright (c) 2013 Excelsys. All rights reserved.
//

#import "KeyProvClientNonce.h"
#import "DDKPCrypoManager.h"
#import "KeyProvisioningProtocol.h"

@implementation KeyProvClientNonce


-(id)initWithSessionId:(NSString *) sessionId EncryptationKey: (NSString *) encryptationKey ServerRandom: (NSString *) serverRandom ActivationCode: (NSString *) activationCode{
    self = [super init];
    if (self) {

        self.session_id = (NSString *)sessionId;
        self.encryption_key = (NSString *) encryptationKey;
        self.server_random = (NSString *)serverRandom;
        self.activation_code = (NSString *) activationCode;
        
    }
    return self;
}

-(NSString *) getKeyProvClientNonceMessage{
    
    NSString *client_id = [self.activation_code substringWithRange:NSMakeRange(0, 8)];
       // NSString *client_id = @"V9UNZJL4";
    
    NSLog(@"Client id %@", client_id);
    
    NSString *post =[NSString stringWithFormat: @"{\"KeyProvClientNonce\": {"
                     @"\"session_id\": \"%@\","
                     @"\"encrypted_nonce\": \"%@\","
                     @"\"authentication_data\":{"
                     @"\"client_id\": \"%@\","
                     @"\"authentication_code_mac\": \"%@\""
                     
                     @"}}}",self.session_id, [self computeEncryptedNonce],client_id, [self AuthenticationCodeMac]];
    
    
    return post;
}

-(NSString *) computeEncryptedNonce{
    DDKPCrypoManager *crypoManager = [[DDKPCrypoManager alloc] init];
    
    self.client_random = [crypoManager calculeRandomNumber];
    // 'encrypt', the 'data' buffer is transformed in-place.
    
    NSString *result64 = [crypoManager encryptedXOR:self.client_random withKey:self.encryption_key];
    

    NSData *dataString = [result64 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *resultEndode = [crypoManager base64forData:dataString];
    
    NSLog(@"result2: %@", resultEndode);
    
    
    return resultEndode;
}

-(NSString *) AuthenticationCodeMac{
    
    NSString *password =[self.activation_code substringWithRange:NSMakeRange(8, 8)];
    NSString *client_id = [self.activation_code substringWithRange:NSMakeRange(0, 8)];

    KeyProvisioningProtocol *keyProvisioningProtocol = [[KeyProvisioningProtocol alloc] init];
    
    
    
    return [keyProvisioningProtocol AuthenticationDataMacWithClienteRandom:self.client_random ServerRandom:self.server_random ServerKey:self.encryption_key ClientId:client_id Password:password];
}

@end
