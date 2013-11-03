//
//  NetworkUtils.h
//  FacePet
//
//  Created by Paul Mans on 11/1/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkUtils : NSObject

+ (NSString *)getIPAddress:(BOOL)preferIPv4 preferCellular:(BOOL)preferCellular;
+ (NSDictionary *)getIPAddresses;

@end
