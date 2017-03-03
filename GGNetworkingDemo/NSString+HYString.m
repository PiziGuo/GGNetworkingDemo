//
//  NSString+HYString.m
//  HYiTong
//
//  Created by David on 2016/12/30.
//  Copyright © 2016年 com.HROCLoud. All rights reserved.
//

#import "NSString+HYString.h"
#include <CommonCrypto/CommonDigest.h>

@implementation NSString (HYString)


+ (instancetype)safeStringWithObject:(id)object {
    
    if ([object isKindOfClass:[NSString class]]) {
        
        if (![self isBlank:object] && object) {
            return object;
        }else{
            return @"";
        }
        
    } else if ([object isKindOfClass:[NSNumber class]]) {
        
        NSString *tempStr = [NSString stringWithFormat:@"%@",object];
        return tempStr;
        
    } else if (object == [NSNull null]){
        
        return @"";
    } else {
        
        return @"";
    }
}



+(BOOL)isBlank:(id)object {
    
    if ([object isKindOfClass:[NSString class]]) {
        
        if ( object == nil || object == NULL || [object isEqualToString : @"(null)" ] || [object isEqualToString : @"" ] || [object isEqual:[NSNull null]] || [object isEqualToString:@"<null>"]) {
            return YES ;
        }
        
        if ( [object isKindOfClass:[NSNull class]] ) {
            return YES ;
        }
        if ((id)object == [NSNull null]) {
            return YES;
        }
        if ( [[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 ) {
            return YES;
        }
        
    } else if ([object isKindOfClass:[NSNumber class]]) {
        
        NSString *boolStr = [NSString stringWithFormat:@"%@",object];
        return boolStr.boolValue;
        
    } else if (object == [NSNull null]) {
        
        return YES;
    }
    return NO ;
}


- (NSString *)AX_md5
{
    NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
    
    NSMutableString *hashStr = [NSMutableString string];
    int i = 0;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i){
        [hashStr appendFormat:@"%02x", outputData[i]];
    }
    //    hashStr = [hashStr uppercaseString];
    return hashStr;
}



@end
