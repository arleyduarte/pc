//
//  KeyProvisioningProtocol.m
//  Test
//
//  Created by Arley Mauricio Duarte on 3/26/13.
//  Copyright (c) 2013 Arley Mauricio Duarte. All rights reserved.
//

#import "KeyProvisioningProtocol.h"
#import "CommonCrypto/CommonHMAC.h"
#import "CommonCrypto/CommonDigest.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import <Security/Security.h>
#import <Security/SecRandom.h>
#import "NSStringHexToBytes.h"

@implementation KeyProvisioningProtocol


-(NSString *) AuthenticationDataMacWithClienteRandom:(NSString *) client_random
ServerRandom:(NSString *)server_random ServerKey:(NSString *)server_key ClientId:(NSString *)client_id Password:(NSString *)password{
    

    NSString *server_url = @"http://localhost";

    NSMutableString *concatenateString = [NSMutableString string];
    [concatenateString appendString:client_random];
    [concatenateString appendString:server_key];
    
    
    NSLog(@"client_random =%@", client_random);
    NSLog(@"server_key =%@", server_key);
    NSLog(@"concatenateString =%@", concatenateString);
    
    NSString *k_ac = [self PKCS5:password salt:concatenateString iterations:1];
    
    
    
    NSLog(@"PKCS5 =%@", k_ac);
    
    
    
    NSMutableString *randomizingMaterial = [NSMutableString string];
    [randomizingMaterial appendString:client_id];
    [randomizingMaterial appendString:server_url];
    [randomizingMaterial appendString:client_random];
    [randomizingMaterial appendString:server_random];
    
    NSLog(@"client_id =%@", client_id);
    NSLog(@"server_url =%@", server_url);
    NSLog(@"client_random =%@", client_random);
    NSLog(@"server_random =%@", server_random);
    
    NSLog(@"RandomizingMaterial=%@",  randomizingMaterial);
    
    
    
    return [self DSKPP_PRF_SHA256:k_ac randomizingMaterial:randomizingMaterial desiredLength:16];
    
}

-(void) AuthenticationDataMac{
    
    NSString *password = @"5678EFGH";
    NSString *client_random =@"random_cliente";
    NSString *server_random =@"z9nbLqFUX4rfPr7+8ic3AgUhzK28aWTL96P1hGbASck=";
    NSString *server_key = @"server_key";
    NSString *client_id = @"1234ABCD";
    NSString *server_url = @"http://servicio.com/";
    
    NSMutableString *concatenateString = [NSMutableString string];
    [concatenateString appendString:client_random];
    [concatenateString appendString:server_key];
    NSLog(@"concatenateString =%@", concatenateString);
    
    //NSString *k_ac = PKCS5(password, concatenateString, 1);
    //NSLog(@"PKCS5 =%@", k_ac);
    
    NSMutableString *randomizingMaterial = [NSMutableString string];
    [randomizingMaterial appendString:client_id];
    [randomizingMaterial appendString:server_url];
    [randomizingMaterial appendString:client_random];
    [randomizingMaterial appendString:server_random];
    
    NSLog(@"RandomizingMaterial=%@",  randomizingMaterial);
    
    //NSLog(@"DSKPP_PRF_SHA256 = %@", DSKPP_PRF_SHA256(k_ac, randomizingMaterial, 16));
    
    
    
}

-(NSString *) applyMod32:(NSString *) text{
    static char table[] = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ";
    NSData *data = [text hexToBytes];
    const uint8_t* input = (const uint8_t*)[data bytes];
    NSMutableString *mutableString = [NSMutableString string];
    
    for(int i=0; i<data.length; i++){
        int inp = input[i];
        int mod = inp % 32;
        char value = table[mod];
        NSString* string = [NSString stringWithFormat:@"%c" , value];
        [mutableString appendString:string];
        //NSLog(@"i: %d, input: %d mod: %d, %c", i, inp, mod, value);
    }
    return mutableString;
}

//RFC 6063
//Apendix D.3.2
-(NSString *) DSKPP_PRF_SHA256:(NSString *) key randomizingMaterial:(NSString *) randomizingMaterial desiredLength:(int ) dsLen{
    NSString *digest =   [self hmacSHA256:randomizingMaterial withKey:key];
    // 1.  Let bLen be the output size of SHA-256 in octets of [FIPS180-SHA] (no truncation is done on the HMAC output):
    
    NSInteger bLen = digest.length/2;
    
    //# 3.  Let n be the number of bLen-octet blocks in the output data, rounding up, and let j be the number of octets in the last block:
    float bLenf = [[NSNumber numberWithInt: bLen] floatValue];
    float dsLenf = [[NSNumber numberWithInt: dsLen] floatValue];
    
    int n = ceil(dsLenf/bLenf);
    
    NSMutableString *mutableString = [NSMutableString string];
    
    NSString *result = [NSString stringWithString:mutableString];
    
    
    //    4.  For each block of the pseudorandom string DS, apply the function
    //    F defined below to the key k, the string s and the block index to
    //    compute the block:
    
    if((n-1)>0){
        
        for (int i = 1; i <= n; i++)
        {
            NSMutableString *concatenateString = [NSMutableString string];
            NSString *intString = [NSString stringWithFormat:@"%d", i];
            [concatenateString appendString:intString];
            [concatenateString appendString:randomizingMaterial];
            [mutableString appendString:[self hmacSHA256:concatenateString withKey:key]];
        }
        
        
        result = [NSString stringWithString:mutableString];
        
    }else{
        NSMutableString *concatenateString = [NSMutableString string];
        [concatenateString appendString:@"1"];
        [concatenateString appendString:randomizingMaterial];
        result = [self hmacSHA256:concatenateString withKey:key];
    }
    
    
    
    NSMutableString *partialResult = [NSMutableString string];
    
    for (int i = 0; i < dsLen*2; i++)
    {
        [partialResult appendFormat:@"%@", [NSString stringWithFormat:@"%C", [result characterAtIndex:i]]];
    }
    
    
    
    return partialResult;
}


-(NSString *) PKCS5:(NSString *) password salt: (NSString *) salt iterations:(int)iterations {
    NSMutableData *derivedKey = [NSMutableData dataWithLength:kCCKeySizeAES128];
    
    
    
    
    
    NSData *dsalt = [salt dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    CCKeyDerivationPBKDF(kCCPBKDF2,
                         password.UTF8String,
                         password.length,
                         dsalt.bytes,
                         dsalt.length,
                         kCCPRFHmacAlgSHA1,
                         iterations,
                         derivedKey.mutableBytes,
                         derivedKey.length);
    
    NSData *key = derivedKey;
    
    
    //NSString *someString = [NSString stringWithFormat:@"%@", key];
    NSCharacterSet *charsToRemove = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
    NSString *partialResult = [[key description] stringByTrimmingCharactersInSet:charsToRemove];
    NSString *result = [partialResult stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    
    
    return  result;
    
}


-(NSString *) hmacSHA256:(NSString *) data withKey:(NSString *) key{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < sizeof cHMAC; i++)
    {
        [result appendFormat:@"%02hhx", cHMAC[i]];
    }
    
    return result;
}

@end
