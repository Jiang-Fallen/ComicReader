//
//  ComicStoreContentListCollectionView.m
//  ComicReader
//
//  Created by Jiang on 1/9/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ComicStoreContentListCollectionView.h"
#import "ComicStoreContentListLayout.h"
#import "ComicStoreListRowCollectionViewCell.h"
#import "ListRowContentModel.h"
//#import "SRRefreshView.h"
#import "ComicStoreHeaderView.h"

@interface ComicStoreContentListCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

static NSString *ComicListContentCellIdentifier = @"ComicListContentCellIdentifier";
static NSString *headerIdentifier = @"ComicStoreHeaderIdentifier";
@implementation ComicStoreContentListCollectionView
- (instancetype)initWithFrame:(CGRect)frame{
    ComicStoreContentListLayout *layout = [[ComicStoreContentListLayout alloc]init];
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource = self;
        self.delegate = self;
        self.alwaysBounceVertical = YES;
        
        [self registerClass:[ComicStoreHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
        
        self.backgroundColor = [UIColor whiteColor];
        [self registerNib:[UINib nibWithNibName:@"ComicStoreListRowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ComicListContentCellIdentifier];
        
        [self initRefreshView];
    }
    return self;
}

- (void)initRefreshView{
    
}

- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (void)reloadData{
    [super reloadData];
}

#pragma mark - 数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ComicStoreListRowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ComicListContentCellIdentifier forIndexPath:indexPath];
    NewStoreContentListModel *model = self.listRowContentModelArray[indexPath.row];
    cell.listRowContentModel =  model;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listRowContentModelArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ComicStoreHeaderView *collectionReusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        collectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        collectionReusableView.modelArray = self.headerModelArray;
    }
    return collectionReusableView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, kHeaderHeight);
}

#pragma mark - 代理

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.comicStoreContentDelegate respondsToSelector:@selector(comicStoreCollectionDidSelected:indePath:)]) {
        [self.comicStoreContentDelegate comicStoreCollectionDidSelected:self indePath:indexPath];
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.comicStoreContentDelegate respondsToSelector:@selector(comicStoreCollectionDidScroll:)]) {
        [self.comicStoreContentDelegate comicStoreCollectionDidScroll:scrollView];
    }
}

@end
