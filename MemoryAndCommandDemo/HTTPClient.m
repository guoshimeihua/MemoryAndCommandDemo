//
//  HTTPClient.m
//  MemoryAndCommandDemo
//
//  Created by Bruce on 15/8/16.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "HTTPClient.h"

@implementation HTTPClient

- (id)getRequest:(NSString *)url {
    return nil;
}

- (id)postRequest:(NSString *)url body:(NSString *)body {
    return nil;
}

- (UIImage *)downloadImage:(NSString *)url {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    return [UIImage imageWithData:data];
}

@end
