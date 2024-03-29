//
//  NSStringHexToBytes.m
//  Test
//
//  Created by Arley Mauricio Duarte on 3/26/13.
//  Copyright (c) 2013 Arley Mauricio Duarte. All rights reserved.
//

#import "NSStringHexToBytes.h"

@implementation NSString (NSStringHexToBytes)
-(NSData*) hexToBytes {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
@end
