//
//  Album+TableRepresentation.h
//  MemoryAndCommandDemo
//
//  Created by Bruce on 15/8/16.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "Album.h"

@interface Album (TableRepresentation)

- (NSDictionary *)br_tableRepresentation;

@end
