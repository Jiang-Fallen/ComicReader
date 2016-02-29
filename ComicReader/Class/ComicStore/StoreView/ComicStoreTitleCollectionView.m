//
//  ComicStoreTitleCollectionView.m
//  ComicReader
//
//  Created by Jiang on 3/26/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ComicStoreTitleCollectionView.h"
#import "ComicStoreTitleCollectionViewCell.h"
#import "NewStoreTitleModel.h"

@interface ComicStoreTitleCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) CALayer *selectedLayer;

@end

@implementation ComicStoreTitleCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 10;
    [_layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self = [super initWithFrame:frame collectionViewLayout:_layout];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        [self registerNib:[UINib nibWithNibName:@"ComicStoreTitleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ComicStoreTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NewStoreTitleModel *listModel = self.listModelArray[indexPath.row];
    cell.titleLabel.text = listModel.CatalogName;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listModelArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        _layout.minimumInteritemSpacing = 0;
        return CGSizeMake((kScreenWidth - 30)/ 4, kNavicationBarHeigth);
    }else{
        _layout.minimumInteritemSpacing = 10;
        NewStoreTitleModel *listModel = self.listModelArray[indexPath.row];
        NSString *string = listModel.CatalogName;
        CGSize size = [string sizeWithFont:[UIFont boldSystemFontOfSize:15]];
        size.height = kNavicationBarHeigth;
        return size;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self settingSelectedLayerLocation];
    [self.titleCollectionDelegate currentSelectItem:indexPath];
}

- (void)setListModelArray:(NSArray *)listModelArray{
    _listModelArray = listModelArray;
    [self reloadData];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self selectItemAtIndexPath:index animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self didSelectItemAtIndexPath:index];
    [self selectedLayer];
}

- (CALayer *)selectedLayer{
    if (!_selectedLayer) {
        _selectedLayer = [CALayer layer];
        _selectedLayer.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5].CGColor;
        _selectedLayer.frame = CGRectMake(0, kNavicationBarHeigth - 8, 60, 2);
        _selectedLayer.zPosition = 5;
        [self.layer addSublayer:_selectedLayer];
    }
    return _selectedLayer;
}

- (void)settingSelectedLayerLocation{
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:[self indexPathsForSelectedItems][0]];
    if (cell) {
        CGPoint point = self.selectedLayer.position;
        point.x = cell.center.x;
        point.y = CGRectGetMaxY(cell.frame) - 6;
        CGRect rect = self.selectedLayer.frame;
        rect.size.width = cell.frame.size.width;
        self.selectedLayer.frame = rect;
        self.selectedLayer.position = point;
    }
}

- (void)setIsShowAll:(BOOL)isShowAll{
    if (!isShowAll) {
        self.frame = CGRectMake(5, kStatusBarHeight, kScreenWidth - kNavicationBarHeigth - 5, kNavicationBarHeigth);
        [self.layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    }else{
        self.frame = CGRectMake(0, kNavicationBarAndStatusBar, kScreenWidth, 180);
        [self.layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    [self settingSelectedLayerLocation];
}

@end
