//
//  DDKPCrypoManager.m
//  poc-otp
//
//  Created by Arley Mauricio Duarte on 4/3/13.
//  Copyright (c) 2013 Excelsys. All rights reserved.
//

#import "DDKPCrypoManager.h"

@implementation DDKPCrypoManager
- (NSString *)encryptedXOR:(NSString *)string withKey:(NSString *)key
{
    
    NSData *input = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char* pBytesInput = (unsigned char*)[input bytes];
    unsigned char* pBytesKey   = (unsigned char*)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    unsigned int vlen = [input length];
    unsigned int klen = [key length];
    
    unsigned int k = vlen % klen;
    unsigned char c;
    
    for (int v=0; v < vlen; v++) {
        c = pBytesInput[v] ^ pBytesKey[k];
        pBytesInput[v] = c;
        
        k = (++k < klen ? k : 0);
    }
    
    return [[NSString alloc] initWithData:input encoding:NSUTF8StringEncoding];
}


-(NSString *) calculeRandomNumber{
    UInt32 randomResult = 0;
    int result = SecRandomCopyBytes(kSecRandomDefault, sizeof(int), (uint8_t*)&randomResult);
    NSString *str = [[NSString alloc] initWithFormat:@"%u",randomResult];
    return str;
    
}

- (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    //static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ23456789";
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
}


@end
