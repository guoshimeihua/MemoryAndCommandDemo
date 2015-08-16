//
//  PersistencyManager.m
//  MemoryAndCommandDemo
//
//  Created by Bruce on 15/8/16.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "PersistencyManager.h"

@interface PersistencyManager () {
    NSMutableArray *albums;
}

@end

@implementation PersistencyManager

- (id)init {
    self = [super init];
    if (self) {
        // 先看下有缓存的数据没
        NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/albums.bin"]];
        albums = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        // 如果没有缓存，就把其给创建出来。
        if (albums == nil) {
            albums = [NSMutableArray arrayWithArray:
                              @[[[Album alloc] initWithTitle:@"存在" artist:@"汪峰" genre:@"摇滚" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_david%20bowie_best%20of%20bowie.png" year:@"2005"],
                                [[Album alloc] initWithTitle:@"中国风" artist:@"周杰伦" genre:@"中国风" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_no%20doubt_its%20my%20life%20%20bathwater.png" year:@"2003"],
                                [[Album alloc] initWithTitle:@"默" artist:@"那英" genre:@"流行音乐" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_sting_nothing%20like%20the%20sun.png" year:@"1999"],
                                [[Album alloc] initWithTitle:@"音乐教父" artist:@"刘欢" genre:@"流行殿堂" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_u2_staring%20at%20the%20sun.png" year:@"2000"],
                                [[Album alloc] initWithTitle:@"笨小孩" artist:@"刘德华" genre:@"流行音乐" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_madonna_american%20pie.png" year:@"2000"]]];
            [self saveAlbums]; //保存相册
        }
    }
    
    return self;
}

- (NSArray *)getAlbums {
    return albums;
}

- (void)addAlbum:(Album *)album atIndex:(int)index {
    if (index <= albums.count) {
        [albums insertObject:album atIndex:index];
    }else {
        [albums addObject:album];
    }
}

- (void)deleteAlbumAtIndex:(int)index {
    [albums removeObjectAtIndex:index];
}

- (void)saveImage:(UIImage *)image filename:(NSString *)filename {
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:filename atomically:YES];
}

- (UIImage *)getImage:(NSString *)filename {
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData *data = [NSData dataWithContentsOfFile:filename];
    return [UIImage imageWithData:data];
}

- (void)saveAlbums {
    NSString *filename = [NSHomeDirectory() stringByAppendingString:@"/Documents/albums.bin"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:albums];
    [data writeToFile:filename atomically:YES];
}

@end
