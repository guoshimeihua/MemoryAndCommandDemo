//
//  HTTPClient.h
//  MemoryAndCommandDemo
//
//  Created by Bruce on 15/8/16.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HTTPClient : NSObject

- (id)getRequest:(NSString*)url;

- (id)postRequest:(NSString*)url body:(NSString*)body;

- (UIImage*)downloadImage:(NSString*)url;

@end
