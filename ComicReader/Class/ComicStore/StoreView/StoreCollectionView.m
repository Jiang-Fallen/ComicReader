////
////  StoreCollectionView.m
////  ComicReader
////
////  Created by Jiang on 1/7/15.
////  Copyright (c) 2015 Mac. All rights reserved.
////
//
//#import "StoreCollectionView.h"
//
//#import "ListModel.h"
//#import "ListCellRectModel.h"
//#import "ListComicModelTool.h"
//#import "ComicStoreListRowCollectionView.h"
//#import "ComicStoreAchieveListBackImageOfStore.h"
//#import "ComicStoreListCollectionViewCell.h"
//#import "SpringyFlowLayout.h"
//
//@interface StoreCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
//
////headerView所需模型数据数组
//@property (nonatomic, strong) NSArray *headerModelArray;
////图书列表背景图片数组
//@property (nonatomic, strong) NSArray *listBackImageArray;
////图书列表模型数据数组
//@property (nonatomic, strong) NSArray *listModelArray;
////图书列表cell的frame属性数组
//@property (nonatomic, strong) NSArray *listRectModelArray;
//
//@property (nonatomic, strong) SpringyFlowLayout *springyFlowLayout;
//
//@end
//
//
//static NSString *kComicStoreListCellIdentifier = @"ComicStoreListCellIdentifier";
//static NSString *kComicStoreHeaderIdentifier = @"ComicStoreHeaderIdentifier";
//
//@implementation StoreCollectionView
//
//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame collectionViewLayout:self.springyFlowLayout]) {
//        self.backgroundColor = [UIColor clearColor];
//        self.delegate = self;
//        self.dataSource = self;
//        [self registerAttributeOfView];
//    }
//    return self;
//}
//
//#pragma mark - 代理方法
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    ListCellRectModel *model = self.listRectModelArray[indexPath.row];
//    ComicStoreListCollectionViewCell *cell = (ComicStoreListCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
//    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
//    
//    [cell setHeight:100];
//    //    CATransition *transition = [CATransition animation];
//    //    transition.type = @"cube";
//    //
//    //    __unsafe_unretained typeof(self) p = self;
//    //    [self.collectionView performBatchUpdates:^{
//    //        model.height += 100;
//    //        [p.springyFlowLayout reloadData];
//    //    } completion:^(BOOL finished) {
//    //        CGRect rect = CGRectMake(0, 0, 0, 0);
//    //        rect.size = model.size;
//    //        ListModel *listModel = self.listModelArray[indexPath.row];
//    //        ComicStoreListRowCollectionView *collectionListView = [[ComicStoreListRowCollectionView alloc]initWithFrame:rect listModelDatas:listModel.bigbooksjson];
//    //        collectionListView.transform = CGAffineTransformScale(collectionListView.transform, 1, 0.8);
//    //        [MPFoldTransition transitionFromView:cell toView:collectionListView duration:1 style:MPFoldStyleUnfold transitionAction:MPTransitionActionShowHide completion:^(BOOL finished) {
//    //
//    //        }];
//    //
//    ////        [collectionView insertSubview:collectionListView belowSubview:cell];
//    ////        [UIView animateWithDuration:0.5 animations:^{
//    ////            cell.contentView.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
//    ////        }];
//    //    }];
//}
//
//#pragma mark - 数据源方法
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    StoreCollectionViewHeader *collectionReusableView = nil;
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        collectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kComicStoreHeaderIdentifier forIndexPath:indexPath];
//        [collectionReusableView setModelArray:self.headerModelArray];
//    }
//    return collectionReusableView;
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(kScreenWidth, kHeaderHeight + kSpace);
//}
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    ComicStoreListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kComicStoreListCellIdentifier forIndexPath:indexPath];
//    if (self.listModelArray) {
//        ListModel *listModel = self.listModelArray[indexPath.row];
//        cell.titleLabel.text = listModel.name;
//        cell.backGroundImage = self.listBackImageArray[indexPath.row];
//    }
//    return cell;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    ListCellRectModel *rectModel = self.listRectModelArray[indexPath.row];
//    return rectModel.size;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    
//    return self.listModelArray.count;
//}
//
//#pragma mark 注册header and cell
//- (void)registerAttributeOfView{
//    [self registerClass:[StoreCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kComicStoreHeaderIdentifier];
//    
//    [self registerNib:[UINib nibWithNibName:@"ComicStoreListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kComicStoreListCellIdentifier];
//}
//
//- (void)setListModelArray:(NSArray *)listModelArray{
//    _listModelArray = listModelArray;
//    self.listRectModelArray = [ListCellRectModel modelWithNumber:listModelArray.count];
//    self.listBackImageArray = [ComicStoreAchieveListBackImageOfStore achieveListBackImageForSumNumber:listModelArray.count];
//}
//
//- (void)setStoreModelDictionary:(NSDictionary *)storeModelDictionary{
//    self.headerModelArray = storeModelDictionary[kHeaderModelIdentifier];
//    self.listModelArray = storeModelDictionary[kListModelIdentifier];
//    [self reloadForSpringyLayout];
//}
//
//- (void)reloadForSpringyLayout{
//    [_springyFlowLayout reloadDataWithElementCount:self.listModelArray.count];
//    [self reloadData];
//}
//
//- (SpringyFlowLayout *)springyFlowLayout{
//    if (!_springyFlowLayout) {
//        _springyFlowLayout = [[SpringyFlowLayout alloc] init];
//        //    _springyFlowLayout.estimatedItemSize = CGSizeMake(300, 100);
//        [self setCollectionViewLayout:_springyFlowLayout];
//    }
//    return _springyFlowLayout;
//}
//
//@end
