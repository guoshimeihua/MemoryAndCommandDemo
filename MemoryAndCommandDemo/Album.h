//
//  Album.h
//  MemoryAndCommandDemo
//
//  Created by Bruce on 15/8/16.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
// 遵守NSCoding协议，让其可以进行归档。
@interface Album : NSObject <NSCoding>

@property (nonatomic, copy, readonly) NSString *title, *artist, *genre, *coverUrl, *year;

- (id)initWithTitle:(NSString *)title artist:(NSString *)artist genre:(NSString *)genre coverUrl:(NSString *)coverUrl year:(NSString *)year;

@end
