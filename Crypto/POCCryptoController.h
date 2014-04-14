//
//  POCCryptoController.h
//  poc-otp
//
//  Created by Arley Mauricio Duarte on 2/28/13.
//  Copyright (c) 2013 Excelsys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POCCryptoManager.h"

@interface POCCryptoController : NSObject
+(POCCryptoController *) sharedController;
@property (strong, nonatomic) NSData *encryptedData;
@property (strong, nonatomic) NSData *iv;
@property (strong, nonatomic) NSData *salt;



-(BOOL) encryptData:(NSData *) data password:(NSString *) password error:(NSError **)error;
-(NSData *) decryptDataWithPassword:(NSString *) password error:(NSError **) error;

@end
