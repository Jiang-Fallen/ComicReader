//
//  ComicStoreBookContentListViewController.m
//  ComicReader
//
//  Created by Jiang on 5/9/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ComicStoreBookContentListViewController.h"
#import "ComicStoreBookContentListModel.h"
#import "AFNetworking.h"
#import "ComicBookReaderController.h"
#import "ComicBookListCollectionViewCell.h"
#import "TWSpringyFlowLayout.h"
#import "KVNProgress.h"

@interface ComicStoreBookContentListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *selectedContentView;
@property (weak, nonatomic) IBOutlet UIButton *reverseSortButton;
- (IBAction)reverseSortButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *positiveSortButton;
- (IBAction)positiveSortButtonAction:(UIButton *)sender;

//----
@property (nonatomic, strong) CALayer *selectedLayer;
@property (nonatomic, strong) NSArray *contentModelArray;
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) TWSpringyFlowLayout *contentCollectionLayout;

@end


static NSString *cellIdentifier = @"ComicStoreCollectionViewCellIdentifier";
@implementation ComicStoreBookContentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavagationBar];
    [self initSubViews];
    [self requestData];
}

- (void)requestData{
    NSDictionary *parameters = @{@"method": @"sectionlist",
                                 @"bookid": self.bookID};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kNewRequestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.contentModelArray = [ComicStoreBookContentListModel modelArrayForDataArray:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [KVNProgress showErrorWithParameters:@{KVNProgressViewParameterStatus: @"网络不给力！",
                                               KVNProgressViewParameterFullScreen: @(YES)}];
    }];
}

- (void)dealloc{
    
}

- (void)initNavagationBar{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = self.titleText;
    label.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = label;
}

- (void)initSubViews{
    [self initContentCollectionView];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_day.png"]];
    self.view.backgroundColor = color;
    
    self.selectedContentView.backgroundColor = [color colorWithAlphaComponent:0.9];
    
    self.selectedContentView.layer.zPosition = 5;
    self.selectedContentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenWidth, 40)].CGPath;
    self.selectedContentView.layer.shadowColor = color.CGColor;
    self.selectedContentView.layer.shadowOffset = CGSizeMake(0, 5);
    self.selectedContentView.layer.shadowOpacity = 0.8;
    
    self.selectedLayer = [CALayer layer];
    _selectedLayer.frame = CGRectMake(0, 35, 90, 2);
    _selectedLayer.zPosition = 5;
    _selectedLayer.backgroundColor = [[UIColor orangeColor]colorWithAlphaComponent:0.8].CGColor;
    [self.selectedContentView.layer addSublayer:_selectedLayer];
    
    UIColor *selectedColor = [[UIColor orangeColor]colorWithAlphaComponent:0.7];
    UIColor *normalColor = [[UIColor grayColor]colorWithAlphaComponent:1];
    [self.reverseSortButton setTitleColor:normalColor forState:UIControlStateNormal];
    [self.positiveSortButton setTitleColor:normalColor forState:UIControlStateNormal];
    [self.reverseSortButton setTitleColor:selectedColor forState:UIControlStateSelected];
    [self.positiveSortButton setTitleColor:selectedColor forState:UIControlStateSelected];
    
    _reverseSortButton.selected = YES;
}

- (void)initContentCollectionView{
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_day.png"]];
     _contentCollectionLayout = [[TWSpringyFlowLayout alloc]init];
    _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) collectionViewLayout:_contentCollectionLayout];
    _contentCollectionView.alwaysBounceVertical = YES;
    _contentCollectionView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    _contentCollectionView.backgroundColor = color;
    [self.view insertSubview:_contentCollectionView atIndex:0];
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"ComicBookListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIButton *button = _reverseSortButton.selected? _reverseSortButton: _positiveSortButton;
    CGPoint point = _selectedLayer.position;
    point.x = button.center.x;
    _selectedLayer.position = point;
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    [_contentCollectionView reloadData];
    [_contentCollectionLayout reloadLayout];
}

- (IBAction)reverseSortButtonAction:(UIButton *)sender {
    if([sender isSelected]) return;
    self.positiveSortButton.selected = NO;
    self.reverseSortButton.selected = YES;
    CGPoint point = _selectedLayer.position;
    point.x = sender.center.x;
    _selectedLayer.position = point;
    
    [_contentCollectionView reloadData];
    _contentCollectionView.contentOffset = CGPointZero;
}

- (IBAction)positiveSortButtonAction:(UIButton *)sender {
    if([sender isSelected]) return;
    self.positiveSortButton.selected = YES;
    self.reverseSortButton.selected = NO;
    CGPoint point = _selectedLayer.position;
    point.x = sender.center.x;
    _selectedLayer.position = point;
    
    [_contentCollectionView reloadData];
    _contentCollectionView.contentOffset = CGPointZero;
}

#pragma mark - collectionView delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _contentModelArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ComicBookListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    NSInteger index = _reverseSortButton.selected? indexPath.row: _contentModelArray.count - indexPath.row - 1;
    ComicStoreBookContentListModel *model = self.contentModelArray[index];
    cell.titleLabel.text = model.SectionName;
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%d页", model.PicCount.intValue];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth - 30, 44);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = _reverseSortButton.selected? indexPath.row: _contentModelArray.count - indexPath.row - 1;
    ComicStoreBookContentListModel *model = self.contentModelArray[index];
    ComicBookReaderController *controller = [[ComicBookReaderController alloc]initWithNibName:@"ComicBookReaderController" bundle:nil];
    controller.sectionID = model.SectionID;
    controller.titleText = _titleText;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
