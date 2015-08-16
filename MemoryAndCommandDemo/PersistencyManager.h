//
//  PersistencyManager.h
//  MemoryAndCommandDemo
//
//  Created by Bruce on 15/8/16.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Album.h"
@interface PersistencyManager : NSObject

- (NSArray*)getAlbums;

- (void)addAlbum:(Album*)album atIndex:(int)index;

- (void)deleteAlbumAtIndex:(int)index;

- (void)saveImage:(UIImage*)image filename:(NSString*)filename;

- (UIImage*)getImage:(NSString*)filename;

- (void)saveAlbums;

@end
