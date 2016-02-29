//
//  ComicStoreTitleTableView.h
//  ComicReader
//
//  Created by Jiang on 1/9/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ComicStoreTitleTableViewDelegate <NSObject>

- (void)currentSelectItem:(NSIndexPath*)indexPath;

@end

@interface ComicStoreTitleTableView : UITableView

@property (nonatomic, assign) id<ComicStoreTitleTableViewDelegate> titleListDelegate;

//图书列表模型数据数组
@property (nonatomic, strong) NSArray *listModelArray;

@end
