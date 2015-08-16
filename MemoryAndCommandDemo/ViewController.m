//
//  ViewController.m
//  MemoryAndCommandDemo
//
//  Created by Bruce on 15/8/16.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "ViewController.h"
#import "LibraryAPI.h"
#import "Album+TableRepresentation.h"
#import "HorizontalScroller.h"
#import "AlbumView.h"
#import "Album.h"
@interface ViewController () <UITableViewDataSource, UITableViewDelegate, HorizontalScrollerDelegate> {
    UITableView *dataTable;
    
    NSArray *allAlbums;
    NSDictionary *currentAlbumData;
    int currentAlbumIndex;
    HorizontalScroller *scroller;
    
    UIToolbar *toolbar;
    // We will use this array as a stack to push and pop operation for the undo option
    NSMutableArray *undoStack;
}

@end

@implementation ViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAttributes];
    [self initTable];
    [self initScroller];
    [self initCallFunction];
    [self initToolbar];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

- (void)initAttributes {
    self.view.backgroundColor = [UIColor colorWithRed:0.76f green:0.81f blue:0.87f alpha:1];
    currentAlbumIndex = 0;
    
    allAlbums = [[LibraryAPI sharedInstance] getAlbums];
    
    undoStack = [[NSMutableArray alloc] init];
}

- (void)initScroller {
    [self loadPreviousState];
    scroller = [[HorizontalScroller alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 120)];
    scroller.backgroundColor = [UIColor colorWithRed:0.24f green:0.35f blue:0.49f alpha:1];
    scroller.delegate = self;
    [self.view addSubview:scroller];
}

- (void)initTable {
    dataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 240, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-240) style:UITableViewStyleGrouped];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.backgroundView = nil;
    [self.view addSubview:dataTable];
}

- (void)initCallFunction {
    [self showDataForAlbumAtIndex:currentAlbumIndex];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)initToolbar {
    toolbar = [[UIToolbar alloc] init];
    UIBarButtonItem *undoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoAction)];
    undoItem.enabled = NO;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAlbum)];
    [toolbar setItems:@[undoItem, space, delete]];
    [self.view addSubview:toolbar];
}

- (void)viewWillLayoutSubviews {
    toolbar.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44);
    dataTable.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height - 200);
}

#pragma mark - HorizontalScrollerDelegate

- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller*)scroller {
    return allAlbums.count;
}

- (UIView*)horizontalScroller:(HorizontalScroller*)scroller viewAtIndex:(int)index {
    Album *album = allAlbums[index];
    return [[AlbumView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) albumCover:album.coverUrl];
}

- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller *)scroller {
    return currentAlbumIndex;
}

- (void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index {
    currentAlbumIndex = index;
    [self showDataForAlbumAtIndex:index];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [currentAlbumData[@"titles"] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = currentAlbumData[@"titles"][indexPath.row];
    cell.detailTextLabel.text = currentAlbumData[@"values"][indexPath.row];
    
    return cell;
}

#pragma mark - private methods

- (void)reloadScroller
{
    allAlbums = [[LibraryAPI sharedInstance] getAlbums];
    if (currentAlbumIndex < 0) {
        currentAlbumIndex = 0;
    }else if (currentAlbumIndex >= allAlbums.count) {
        currentAlbumIndex = (int)allAlbums.count-1;
    }
    
    [scroller reload];
    
    [self showDataForAlbumAtIndex:currentAlbumIndex];
}

- (void)showDataForAlbumAtIndex:(int)albumIndex{
    // defensive code: make sure the requested index is lower than the amount of albums
    if (albumIndex < allAlbums.count){
        // fetch the album
        Album *album = allAlbums[albumIndex];
        // save the albums data to present it later in the tableview
        currentAlbumData = [album br_tableRepresentation];
    }
    else {
        currentAlbumData = nil;
    }
    
    // we have the data we need, let's refresh our tableview
    [dataTable reloadData];
}

- (void)saveCurrentState {
    // When the user leaves the app and then comes back again, he wants it to be in the exact same state
    // he left it. In order to do this we need to save the currently displayed album.
    // Since it's only one piece of information we can use NSUserDefaults.
    [[NSUserDefaults standardUserDefaults] setInteger:currentAlbumIndex forKey:@"currentAlbumIndex"];
    [[LibraryAPI sharedInstance] saveAlbums];
}

- (void)loadPreviousState {
    currentAlbumIndex = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"currentAlbumIndex"];
    [self showDataForAlbumAtIndex:currentAlbumIndex];
}

#pragma mark - Ablum actions

- (void)addAlbum:(Album*)album atIndex:(int)index {
    [[LibraryAPI sharedInstance] addAlbum:album atIndex:index];
    currentAlbumIndex = index;
    [self reloadScroller];
}

- (void)deleteAlbum{
    Album *deletedAlbum = allAlbums[currentAlbumIndex];
    
    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(addAlbum:atIndex:)];
    NSInvocation *undoAction = [NSInvocation invocationWithMethodSignature:sig];
    [undoAction setTarget:self];
    [undoAction setSelector:@selector(addAlbum:atIndex:)];
    [undoAction setArgument:&deletedAlbum atIndex:2];
    [undoAction setArgument:&currentAlbumIndex atIndex:3];
    [undoAction retainArguments];
    
    [undoStack addObject:undoAction];
    
    [[LibraryAPI sharedInstance] deleteAlbumAtIndex:currentAlbumIndex];
    [self reloadScroller];
    
    [toolbar.items[0] setEnabled:YES];
}

- (void)undoAction{
    if (undoStack.count > 0)
    {
        NSInvocation *undoAction = [undoStack lastObject];
        [undoStack removeLastObject];
        [undoAction invoke];
    }
    
    if (undoStack.count == 0)
    {
        [toolbar.items[0] setEnabled:NO];
    }
}

@end
