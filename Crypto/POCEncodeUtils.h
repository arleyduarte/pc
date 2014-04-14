//
//  POCEncodeUtils.h
//  poc-otp
//
//  Created by Arley Mauricio Duarte on 2/28/13.
//  Copyright (c) 2013 Excelsys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Base64.h"

@interface POCEncodeUtils : NSObject

-(NSString *) base64Encode:(NSString *) plainText;
-(NSString *) base64Decode:(NSString *) base64String;
-(void) printNSData:(NSData *) data;

@end
