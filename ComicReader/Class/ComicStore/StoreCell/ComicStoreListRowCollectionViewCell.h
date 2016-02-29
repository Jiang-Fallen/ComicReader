//
//  ComocStoreListRowCollectionViewCell.h
//  ComicReader
//
//  Created by Jiang on 14/12/22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewStoreContentListModel;

@interface ComicStoreListRowCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NewStoreContentListModel *listRowContentModel;

@end
