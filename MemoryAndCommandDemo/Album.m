//
//  Album.m
//  MemoryAndCommandDemo
//
//  Created by Bruce on 15/8/16.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "Album.h"

@implementation Album

- (id)initWithTitle:(NSString *)title artist:(NSString *)artist genre:(NSString *)genre coverUrl:(NSString *)coverUrl year:(NSString *)year {
    self = [super init];
    if (self) {
        _title = title;
        _artist = artist;
        _genre = genre;
        _coverUrl = coverUrl;
        _year = year;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.artist forKey:@"artist"];
    [aCoder encodeObject:self.genre forKey:@"genre"];
    [aCoder encodeObject:self.coverUrl forKey:@"cover_url"];
    [aCoder encodeObject:self.year forKey:@"year"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _artist = [aDecoder decodeObjectForKey:@"artist"];
        _genre = [aDecoder decodeObjectForKey:@"genre"];
        _coverUrl = [aDecoder decodeObjectForKey:@"cover_url"];
        _year = [aDecoder decodeObjectForKey:@"year"];
    }
    
    return self;
}

@end
