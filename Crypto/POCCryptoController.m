//
//  POCCryptoController.m
//  poc-otp
//
//  Created by Arley Mauricio Duarte on 2/28/13.
//  Copyright (c) 2013 Excelsys. All rights reserved.
//

#import "POCCryptoController.h"

@implementation POCCryptoController
@synthesize encryptedData = encryptedData_;
@synthesize iv= iv_;
@synthesize salt = salt_;


+(POCCryptoController *) sharedController {
    static POCCryptoController *sShareController;
    if(!sShareController){
        sShareController = [[POCCryptoController alloc] init];
    }
    
    return sShareController;
}

-(BOOL) encryptData:(NSData *) data password:(NSString *) password error:(NSError **) error
{
    NSLog(@"ecryptData");
    
    NSData *iv;
    NSData *salt;
    self.encryptedData = [POCCryptoManager encryptedDataForData:data
                                                       password:password
                                                             iv:&iv
                                                           salt:&salt
                                                          error:error];
    self.iv = iv;
    self.salt = salt;
    
    return self.encryptedData ? YES : NO;
    
    
}

-(NSData *) decryptDataWithPassword:(NSString *) password error:(NSError **) error
{
    return [POCCryptoManager decryptedDataForData:self.encryptedData password:password iv:self.iv salt:self.salt error:error];
}

@end
