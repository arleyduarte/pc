//
//  POCCryptoManager.m
//  poc-otp
//
//  Created by Arley Mauricio Duarte on 2/28/13.
//  Copyright (c) 2013 Excelsys. All rights reserved.
//

#import "POCCryptoManager.h"

const CCAlgorithm kAlgorithm = kCCAlgorithmAES128;
const NSUInteger kAlgorithmKeySize = kCCKeySizeAES128;
const NSUInteger kAlgorithmBlockSize = kCCBlockSizeAES128;
const NSInteger kAlgorithmIVSize = kCCBlockSizeAES128;
const NSUInteger kPBKDFSaltSize = 8;
const NSUInteger kPBKDFRounds = 10000;

@implementation POCCryptoManager

+(NSData *)randomDataOfLength:(size_t) length{
    NSMutableData *data = [NSMutableData dataWithLength:length];
    
    int result = SecRandomCopyBytes(kSecRandomDefault, length, data.mutableBytes);
    
    NSAssert(result == 0, @"Unable to generate random bytes");
    
        NSLog(@"print NSData: %d", result);
        NSLog(@"print NSData data: %@", data);
    
    NSString *value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"print value: %@", value);
    
    return data;
}


+(NSData *) AESKeyForPassword:(NSString *) password  salt: (NSData *) salt{
    NSMutableData *derivedKey = [NSMutableData dataWithLength:kAlgorithmKeySize];
    
    int result = CCKeyDerivationPBKDF(kCCPBKDF2,
                                      password.UTF8String,
                                      password.length,
                                      salt.bytes,
                                      salt.length,
                                      kCCPRFHmacAlgSHA1,
                                      kPBKDFRounds,
                                      derivedKey.mutableBytes,
                                      derivedKey.length);
    
    NSAssert(result == kCCSuccess, @"Unable to create AES key for password %d", result);
    
    return  derivedKey;
    
}

+(NSData *) encryptedDataForData:(NSData *) data
                        password:(NSString *) password
                              iv:(NSData **) iv
                            salt:(NSData **) salt
                           error:(NSError **) error {
    
    
    NSLog(@"POCCrypoManger ecryptedDataForData");
    
    *iv = [self randomDataOfLength:kAlgorithmIVSize];
    *salt = [self randomDataOfLength:kPBKDFSaltSize];
    
    

    
    NSData *key = [self AESKeyForPassword:password salt:*salt];
    
    size_t outLength;
    
    NSMutableData *cipherData = [NSMutableData dataWithLength:data.length+kAlgorithmBlockSize];
    
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt,
                                     kAlgorithm,
                                     kCCOptionPKCS7Padding,
                                     key.bytes,
                                     key.length,
                                     (*iv).bytes,
                                     data.bytes,
                                     data.length,
                                     cipherData.mutableBytes,
                                     cipherData.length,
                                     &outLength);
    
    if(result == kCCSuccess){
        cipherData.length = outLength;
    }
    NSString *value = [[NSString alloc] initWithData:cipherData encoding:NSUTF8StringEncoding];
    NSLog(@"print cipherData: %@", value);
    return cipherData;
    
}

+(NSData *) decryptedDataForData:(NSData *) data password:(NSString *) password  iv:(NSData *) iv salt:(NSData *) salt error:(NSError **) error{
    
    NSData *key = [self AESKeyForPassword:password salt:salt];
    
    size_t outLength;
    
    NSMutableData *decryptedData = [NSMutableData dataWithLength:data.length];
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt,
                                     kAlgorithm,
                                     kCCOptionPKCS7Padding,
                                     key.bytes, key.length,
                                     iv.bytes, data.bytes, data.length,
                                     decryptedData.mutableBytes,
                                     decryptedData.length, &outLength);
    
    if(result == kCCSuccess){
        [decryptedData setLength:outLength];
    }
    
    return decryptedData;
}

@end
