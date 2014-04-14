//
//  POCCryptoManager.h
//  poc-otp
//
//  Created by Arley Mauricio Duarte on 2/28/13.
//  Copyright (c) 2013 Excelsys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@interface POCCryptoManager : NSObject

+(NSData *) encryptedDataForData:(NSData *) data
                        password:(NSString *) password
                              iv:(NSData **) iv
                            salt:(NSData **) salt
                           error:(NSError **) error;

+(NSData *) decryptedDataForData:(NSData *) data
                        password:(NSString *)password
                              iv:(NSData *)iv
                            salt:(NSData *)salt
                           error:(NSError **)error;

@end
