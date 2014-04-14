//
//  POCEncodeUtils.m
//  poc-otp
//
//  Created by Arley Mauricio Duarte on 2/28/13.
//  Copyright (c) 2013 Excelsys. All rights reserved.
//

#import "POCEncodeUtils.h"

@implementation POCEncodeUtils

-(NSString *) base64Encode:(NSString *)plainText{
    NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainTextData base64EncodedString];
    return base64String;
}

-(NSString *) base64Decode:(NSString *)base64String{
    NSData *plainTextData = [NSData dataFromBase64String:base64String];
    NSString *plainText = [[NSString alloc] initWithData:plainTextData encoding:NSUTF8StringEncoding];
    return plainText;
}
-(void)  printNSData:(NSData *)data{
    NSString *value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"print NSData: %@", value);
}

@end
