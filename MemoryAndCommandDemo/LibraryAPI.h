//
//  LibraryAPI.h
//  MemoryAndCommandDemo
//
//  Created by Bruce on 15/8/16.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"
@interface LibraryAPI : NSObject

+ (LibraryAPI *)sharedInstance;

- (NSArray *)getAlbums;

- (void)addAlbum:(Album*)album atIndex:(int)index;

- (void)deleteAlbumAtIndex:(int)index;

- (void)saveAlbums;

@end
