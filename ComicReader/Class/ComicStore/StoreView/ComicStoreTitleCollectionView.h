//
//  ComicStoreTitleCollectionView.h
//  ComicReader
//
//  Created by Jiang on 3/26/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ComicStoreTitleCollectionViewDelegate <NSObject>

- (void)currentSelectItem:(NSIndexPath*)indexPath;

@end

@interface ComicStoreTitleCollectionView : UICollectionView

@property (nonatomic, assign) id<ComicStoreTitleCollectionViewDelegate> titleCollectionDelegate;
//图书列表模型数据数组
@property (nonatomic, strong) NSArray *listModelArray;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) BOOL isShowAll;

@end
