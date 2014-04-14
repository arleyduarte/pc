//
//  KeyProvisioningProtocol.h
//  Test
//
//  Created by Arley Mauricio Duarte on 3/26/13.
//  Copyright (c) 2013 Arley Mauricio Duarte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyProvisioningProtocol : NSObject

-(NSString *) DSKPP_PRF_SHA256:(NSString *) key randomizingMaterial:(NSString *) randomizingMaterial desiredLength:(int ) dsLen;
-(NSString *) applyMod32:(NSString *) text;
-(NSString *) AuthenticationDataMacWithClienteRandom:(NSString *) client_random
                                        ServerRandom:(NSString *)server_random ServerKey:(NSString *)server_key ClientId:(NSString *)client_id Password:(NSString *)password;
@end
