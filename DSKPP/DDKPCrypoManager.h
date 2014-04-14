//
//  DDKPCrypoManager.h
//  poc-otp
//
//  Created by Arley Mauricio Duarte on 4/3/13.
//  Copyright (c) 2013 Excelsys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDKPCrypoManager : NSObject
- (NSString *)encryptedXOR:(NSString *)string withKey:(NSString *)key;
-(NSString *) calculeRandomNumber;
- (NSString*)base64forData:(NSData*)theData;
@end
