//
//  ComicSearchActionViewController.m
//  ComicReader
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ComicSearchActionViewController.h"
#import "ComicStoreListRowCollectionViewCell.h"
#import "NewStoreContentListModel.h"
#import "ComicStoreShowBookViewController.h"
#import "AFNetworking.h"
#import "KVNProgress.h"

@interface ComicSearchActionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (nonatomic, strong) NSArray *contentModelArray;

@end

static NSString *cellIdentifier = @"ComicListContentCellIdentifier";
@implementation ComicSearchActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
    [self requestData];
}

- (void)requestData{
    NSDictionary *parameters = @{@"method": @"search",
                                 @"name": _searchName,
                                 @"type": @0};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __unsafe_unretained typeof(self) p = self;
    [manager GET:kNewRequestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        p.contentModelArray = [NewStoreContentListModel modelArrayByDataArray:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [KVNProgress showErrorWithParameters:@{KVNProgressViewParameterStatus: @"网络不给力！",
                                               KVNProgressViewParameterFullScreen: @(YES)}];
    }];
}

- (void)initSubViews{
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_day.png"]];
    self.contentCollectionView.backgroundColor = color;
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.alwaysBounceVertical = YES;
    self.contentCollectionView.contentInset = UIEdgeInsetsMake(5.0, 15, 0, 15);
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"ComicStoreListRowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = self.searchName;
    label.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.9];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = label;
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    if (contentModelArray.count == 0) return;
    
    _contentModelArray = contentModelArray;
    [self.contentCollectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ComicStoreListRowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NewStoreContentListModel *model = self.contentModelArray[indexPath.row];
    cell.listRowContentModel = model;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentModelArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (kScreenWidth - 30)/3;
    return CGSizeMake(width, 175 * width/130.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ComicStoreShowBookViewController *controller = [[ComicStoreShowBookViewController alloc]initWithNibName:@"ComicStoreShowBookViewController" bundle:nil];
    NewStoreContentListModel *model = self.contentModelArray[indexPath.row];
    controller.bookID =  model.BookID;
    controller.bookName = model.BookName;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
