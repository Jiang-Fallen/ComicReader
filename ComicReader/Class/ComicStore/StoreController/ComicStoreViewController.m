//
//  ComicStoreTableViewController.m
//  ComicReader
//
//  Created by Jiang on 14/12/10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ComicStoreViewController.h"
#import "ComicStoreTool.h"
#import "ShowWaitView.h"
#import "ComicStoreHeaderView.h"
#import "ComicStoreTitleTableView.h"
#import "ContentListView.h"
#import "ListModel.h"
#import "ComicStoreContentListCollectionView.h"
#import "ComicStoreTitleCollectionView.h"
#import "NewStoreTitleModel.h"
#import "ComicStoreShowBookViewController.h"
#import "NewStoreContentListModel.h"
#import "UIScrollView+UzysAnimatedGifLoadMore.h"

@interface ComicStoreViewController ()<ComicStoreCollectionViewDelegate, ComicStoreTitleCollectionViewDelegate, ComicStoreContentListCollectionViewDelegate>
{
    NSInteger _orderIndex;
    NSIndexPath *_currentIndexPath;
    NSInteger _pageIndex;
}

//加载等待画面
@property (nonatomic, weak) ShowWaitView *showWaitView;

@property (nonatomic, weak) ComicStoreTitleCollectionView *comicStoreTitleView;
//content列表View
@property (nonatomic, weak) ComicStoreContentListCollectionView *comicStoreContentListCollectionView;
//content列表View容器
@property (nonatomic, weak) ContentListView *contentListView;
//headerView所需模型数据数组
@property (nonatomic, strong) NSMutableArray *headerModelArray;
//图书列表模型数据数组
@property (nonatomic, strong) NSMutableArray *listModelArray;
//图书列表页内容模型数据数组
@property (nonatomic, strong) NSMutableArray *listRowContentModelArray;

@property (nonatomic, strong) UIView *headerBackView;

@property (nonatomic, strong) NSIndexPath *currentSelectedIndexPath;
@end

@implementation ComicStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.masksToBounds = YES;
    [self settingBackGround];
    [self initWithContentView];
    [self insertShowWaitView];
    [self.showWaitView showWait];
}

#pragma mark - 数据加载载

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)loadModelData{
    __unsafe_unretained typeof(self) p = self;
    [[ComicStoreTool sharedRequestTool]requestComicStoreNewModelCompletion:^(NSMutableArray *blockHeaderArray, NSMutableArray *blockListArray) {
        [p.showWaitView removeFromSuperview];
        p.headerModelArray = blockHeaderArray;
        p.listModelArray = blockListArray;
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [p.showWaitView performSelector:@selector(showError) withObject:nil afterDelay:1.5];
    }];
}

- (void)refreshAddAction{
    _pageIndex = (_listRowContentModelArray.count + 20)/ 21;
    [self requestData:_currentSelectedIndexPath];
} 

#pragma mark 加载等待控件
- (void)insertShowWaitView{
    __unsafe_unretained typeof(self) p = self;
    ShowWaitView *showWaitView = [[ShowWaitView alloc]initWithOperation:^{
        [p loadModelData];
    }];
    [self.view insertSubview:showWaitView aboveSubview:self.view];
    _showWaitView = showWaitView;
}

#pragma mark - TitleView代理

- (void)currentSelectItem:(NSIndexPath *)indexPath{
    if (indexPath.row == _currentSelectedIndexPath.row && _currentSelectedIndexPath) {
        return;
    }
    _currentSelectedIndexPath = indexPath;
    _pageIndex = 0;
    [self requestData:indexPath];
}

- (void)requestData:(NSIndexPath*)indexPath{
    [self.contentListView showRefreshState:stateLoading];
    NSDictionary *dict = @{@"pageindex": @(_pageIndex), @"pagesize": @21};
    __unsafe_unretained typeof(self) p = self;
    switch (indexPath.row) {
        case 0:
            [[ComicStoreTool sharedRequestTool] requestComicStoreContentListNewModelCompletion:kNewListContentHotMethod parameters:dict success:^(NSMutableArray *blockRowListArray) {
                [p setContentListData:blockRowListArray];
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
                [p.contentListView showRefreshState:stateFailure];
            }];
            self.contentListView.contentBack.userInteractionEnabled = NO;
            self.contentListView.currentListTitle.text = @"热门推荐";
            break;
        case 1:
            [[ComicStoreTool sharedRequestTool] requestComicStoreContentListNewModelCompletion:kNewListContentDayMethod parameters:dict success:^(NSMutableArray *blockRowListArray) {
                [p setContentListData:blockRowListArray];
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
                [p.contentListView showRefreshState:stateFailure];
            }];
            self.contentListView.contentBack.userInteractionEnabled = NO;
            self.contentListView.currentListTitle.text = @"每日更新";
            break;
        default:
        {
            _currentIndexPath = indexPath;
            _orderIndex = 0;
            [self otherCatalogListRequest:indexPath];
        }
            break;
    }
}

- (void)otherCatalogListRequest:(NSIndexPath *)indexPath{
    NewStoreTitleModel *listModel = self.listModelArray[indexPath.row];
    NSDictionary *dictionary = @{@"pageSize": @21,
                                 @"cataID": listModel.CatalogID,
                                 @"state": @0,
                                 @"order": @(_orderIndex),
                                 @"pageIndex": @(_pageIndex)};
    __unsafe_unretained typeof(self) p = self;
    [[ComicStoreTool sharedRequestTool] requestComicStoreContentListNewModelCompletion:kNewListContentMethod parameters:dictionary success:^(NSMutableArray *blockRowListArray) {
        [p setContentListData:blockRowListArray];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [p.contentListView showRefreshState:stateFailure];
    }];
    self.contentListView.contentBack.userInteractionEnabled = YES;
    self.contentListView.currentListTitle.text = listModel.CatalogName;
}

- (void)setContentListData:(NSMutableArray*)responseArray{
    __unsafe_unretained typeof(self) p = self;
    if (_pageIndex == 0) {
        p.listRowContentModelArray = responseArray;
    }else{
        [p.listRowContentModelArray addObjectsFromArray:responseArray];
        [p.comicStoreContentListCollectionView reloadData];
    }
    [p.contentListView showRefreshState:stateSuccess];
    [p.comicStoreContentListCollectionView stopLoadMoreAnimation];
}

- (void)comicOrderSelectedIndex:(NSInteger)index{
    _orderIndex = index;
    [self.contentListView showRefreshState:stateLoading];
    [self otherCatalogListRequest:_currentIndexPath];
}

- (void)loadCurrentSelectedData:(NSIndexPath *)indexPath{
    if (_listModelArray.count == 0 || !_listModelArray) {
        return;
    }
    ListModel *model = self.listModelArray[indexPath.row];
    if (!model) {
        return;
    }
    NSLog(@"%@", model.targetmethod);
    self.contentListView.currentListTitle.text = model.name;
    NSDictionary *dict = @{@"special": model.targetargument,
                           @"pagesize": @21,
                           @"pageno": @1};
    __unsafe_unretained typeof(self) p = self;
    [[ComicStoreTool sharedRequestTool] requestArrayByComicStoreRowListModel:dict Completion:^(NSMutableArray *blockRowListArray) {
        [p.contentListView showRefreshState:YES];
        p.listRowContentModelArray = blockRowListArray;
    } failure:^(NSError *error) {
        [p.contentListView showRefreshState:NO];
    }];
}

#pragma mark - contentCollectionView delegate
- (void)comicStoreCollectionDidScroll:(UIScrollView *)scrollView{
    [self.contentListView setCurrentScrollViewOffset:scrollView.contentOffset];
}

- (void)comicStoreCollectionDidSelected:(UICollectionView *)collectionView indePath:(NSIndexPath *)indexPath{
    ComicStoreShowBookViewController *controller = [[ComicStoreShowBookViewController alloc]initWithNibName:@"ComicStoreShowBookViewController" bundle:nil];
    NewStoreContentListModel *model = self.listRowContentModelArray[indexPath.row];
    controller.bookID =  model.BookID;
    controller.bookName = model.BookName;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - set and get
- (void)setHeaderModelArray:(NSMutableArray *)headerModelArray{
    self.comicStoreContentListCollectionView.headerModelArray = headerModelArray;
    [self.comicStoreContentListCollectionView reloadData];
    _headerModelArray = headerModelArray;
}

- (void)setListModelArray:(NSMutableArray *)listModelArray{
    _listModelArray = listModelArray;
    self.comicStoreTitleView.listModelArray = listModelArray;
}

- (void)setListRowContentModelArray:(NSMutableArray *)listRowContentModelArray{
    _listRowContentModelArray = listRowContentModelArray;
    self.contentListView.listRowContentModelArray = listRowContentModelArray;
}

- (ComicStoreContentListCollectionView *)comicStoreContentListCollectionView{
    return self.contentListView.comicStoreContentListCollectionView;
}

#pragma mark - action

- (void)showAllTitleList:(UIButton*)sender{
    sender.selected = ![sender isSelected];
    sender.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _comicStoreTitleView.isShowAll = sender.selected;
        sender.transform = CGAffineTransformMakeRotation(sender.selected? M_PI_2: -M_PI_2);
        _headerBackView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(_comicStoreTitleView.frame));
    }completion:^(BOOL finished) {
        sender.userInteractionEnabled = YES;
    }];
    
}

#pragma mark - 初始化控件

- (void)initWithContentView{
    CGRect rect = CGRectMake(0, kNavicationBarAndStatusBar, kScreenWidth, kScreenHeight - kNavicationBarAndStatusBar);
    ContentListView *contentListView = [[ContentListView alloc]initWithFrame:rect];
    contentListView.delegate = self;
    contentListView.comicStoreContentListCollectionView.comicStoreContentDelegate = self;
    [self.view insertSubview:contentListView atIndex:0];
    self.contentListView = contentListView;

    __unsafe_unretained typeof(self) p = self;
    [contentListView.comicStoreContentListCollectionView addLoadMoreActionHandler:^{
        [p refreshAddAction];
    } ProgressImagesGifName:@"farmtruck@2x.gif" LoadingImagesGifName:@"nevertoolate@2x.gif" ProgressScrollThreshold:30 LoadingImageFrameRate:30];
}

- (void)settingBackGround{
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _headerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavicationBarAndStatusBar)];
    _headerBackView.layer.zPosition = 5;
    _headerBackView.backgroundColor = [UIColor whiteColor];
    _headerBackView.layer.masksToBounds = YES;
    [self.view addSubview:_headerBackView];
    
    CALayer *layer = [CALayer layer];
    layer.opacity = 0.8;
    layer.frame = self.view.bounds;
    layer.backgroundColor = [UIColor orangeColor].CGColor;
    [_headerBackView.layer addSublayer:layer];
    
    ComicStoreTitleCollectionView *collectionView = [[ComicStoreTitleCollectionView alloc]initWithFrame:CGRectMake(5, kStatusBarHeight, kScreenWidth - kNavicationBarHeigth - 5, kNavicationBarHeigth)];
    collectionView.titleCollectionDelegate = self;
    collectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    [_headerBackView addSubview:collectionView];
    self.comicStoreTitleView = collectionView;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - kNavicationBarHeigth, kStatusBarHeight, kNavicationBarHeigth, kNavicationBarHeigth)];
    [button setImage:[UIImage imageNamed:@"back_bnt_hl"] forState:UIControlStateNormal];
    button.transform = CGAffineTransformMakeRotation(- M_PI_2);
    [button addTarget:self action:@selector(showAllTitleList:) forControlEvents:UIControlEventTouchUpInside];
    [_headerBackView addSubview:button];
}

#pragma mark - collectionDelegate

@end
