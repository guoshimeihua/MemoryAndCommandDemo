//
//  AlbumView.m
//  MemoryAndCommandDemo
//
//  Created by Bruce on 15/8/16.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "AlbumView.h"

@interface AlbumView () {
    UIImageView *coverImage;
    UIActivityIndicatorView *indicatorView;
}

@end

@implementation AlbumView

- (id)initWithFrame:(CGRect)frame albumCover:(NSString *)albumCover {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        [self addSubview:coverImage];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.center = self.center;
        [indicatorView startAnimating]; //在创建相册view的时候，就让其转动起来。
        [self addSubview:indicatorView];
        
        // 给coverImage添加KVO，观察其image属性发生了变化没，若发生变化，让indicatorView停止转动。
        [coverImage addObserver:self forKeyPath:@"image" options:0 context:nil];
        
        // 发送通知，把coverImage与albumCover给传递出去
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BrDownLoadImageNotification" object:self userInfo:@{@"imageView":coverImage, @"coverUrl":albumCover}];
    }
    
    return self;
}

- (void)dealloc {
    [coverImage removeObserver:self forKeyPath:@"image"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        [indicatorView stopAnimating];
    }
}

@end
