//
//  ComicStoreShowBookViewController.m
//  ComicReader
//
//  Created by Jiang on 5/9/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ComicStoreShowBookViewController.h"
#import "ComicShowBookModel.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "ComicStoreBookContentListViewController.h"
#import "ComicBookInfoContextModel.h"
#import "AppDelegate.h"
#import "KVNProgress.h"

@interface ComicStoreShowBookViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *showBookBackImage;
@property (weak, nonatomic) IBOutlet UIImageView *showBookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookPopularityLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookRenewalDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookContentDescrptionLabel;
@property (weak, nonatomic) IBOutlet UIView *bookResourceContentView;
@property (weak, nonatomic) IBOutlet UITableView *bookResourceContentTableView;

@property (weak, nonatomic) IBOutlet UIImageView *showStateImageView;
@property (weak, nonatomic) IBOutlet UILabel *showStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *showCollectButton;
- (IBAction)showCollectButtonAction:(UIButton *)sender;

@property (assign, nonatomic) BOOL unfinished;

//-----
@property (nonatomic, strong) NSArray *contentModelArray;

@end

@implementation ComicStoreShowBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initSubViews];
    [self requestData];
}

- (void)initSubViews{
    self.contentView.userInteractionEnabled = NO;
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_day.png"]];
    self.view.backgroundColor = color;
    self.contentScrollView.contentSize = CGSizeMake(kScreenWidth, self.contentView.bounds.size.height + 20);
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 4.0;
    self.bookResourceContentTableView.tableFooterView = [[UIView alloc]init];
    
    UIImage *image = [UIImage imageNamed:@"download_space_normal"];
    self.showBookBackImage.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.bookResourceContentView.backgroundColor = color;
    self.bookResourceContentView.layer.masksToBounds = YES;
    self.bookResourceContentView.layer.cornerRadius = 4.0;
    self.bookNameLabel.text = self.bookName;
    self.showStateLabel.transform = CGAffineTransformMakeRotation(-M_PI_4);
    
    self.bookResourceContentTableView.delegate = self;
    self.bookResourceContentTableView.dataSource = self;
    self.bookResourceContentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CALayer *layer = [CALayer layer];
    CGRect frame = self.showCollectButton.frame;
    layer.frame = CGRectMake(0, frame.size.height - 4, frame.size.width, 2);
    layer.backgroundColor = color.CGColor;
    layer.zPosition = 5;
    [self.showCollectButton.layer addSublayer:layer];
}

- (void)initNavigationBar{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = _bookName;
    label.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.9];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = label;
    self.navigationItem.backBarButtonItem.title = @"";
    self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)requestData{
    NSDictionary *parameters = @{@"method": @"booksite",
                                 @"bookname": self.bookName,
                                 @"bookid": self.bookID};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kNewRequestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.contentView.userInteractionEnabled = YES;
        self.contentModelArray = [ComicShowBookModel modelArrayForDataArray:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [KVNProgress showErrorWithParameters:@{KVNProgressViewParameterStatus: @"网络不给力！",
                                               KVNProgressViewParameterFullScreen: @(YES)}];
    }];
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    ComicShowBookModel *model = [contentModelArray firstObject];
    [self.showBookImageView sd_setImageWithURL:[NSURL URLWithString:model.BookIconOtherURL]];
    self.bookNameLabel.text = model.BookName;
    self.bookCategoryLabel.text = [NSString stringWithFormat:@"所属类别：%@", model.CatalogName];
    self.bookAuthorLabel.text = [NSString stringWithFormat:@"作       者：%@", model.BookAuthor];
    self.bookPopularityLabel.text = [NSString stringWithFormat:@"人       气：%d", model.BookClickCount.intValue];
    self.bookRenewalDateLabel.text = [NSString stringWithFormat:@"最后更新：%@", model.BookUpdateDate];
    
    NSString *descripition = [NSString stringWithFormat:@"内容摘要：%@", model.BookDescription];
    CGSize size = [descripition boundingRectWithSize:CGSizeMake(self.bookContentDescrptionLabel.frame.size.width, 0) options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
    CGRect frame = self.bookContentDescrptionLabel.frame;
    frame.size.height = size.height + 20;
    self.bookContentDescrptionLabel.frame = frame;
    
    frame = self.bookResourceContentView.frame;
    frame.origin.y += size.height - 5;
    frame.size.height = contentModelArray.count * 44.0;
    self.bookResourceContentView.frame = frame;
    
    frame = self.contentView.frame;
    frame.size.height = MAX(CGRectGetMaxY(self.bookResourceContentView.frame) + 15.0, self.contentScrollView.frame.size.height - 20);
    self.contentView.frame = frame;
    
    self.contentScrollView.contentSize = CGSizeMake(kScreenWidth, self.contentView.bounds.size.height + 20);
    
    NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc]initWithString:descripition];
    [descriptionString addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0],
                                       NSStrokeColorAttributeName: [[UIColor whiteColor]colorWithAlphaComponent:0.7]} range:NSMakeRange(0, 5)];
    [descriptionString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0],
                                       NSStrokeColorAttributeName: [UIColor whiteColor]} range:NSMakeRange(5, model.BookDescription.length)];
    self.bookContentDescrptionLabel.attributedText = descriptionString;
    
    self.unfinished = model.BookState.intValue == 1;
    [self.bookResourceContentTableView reloadData];
}

- (void)setUnfinished:(BOOL)unfinished{
    if (unfinished) {
        self.showStateLabel.text = @"连载中";
        self.showStateImageView.image = [UIImage imageNamed:@"bc_corner_red.png"];
    }else{
        self.showStateLabel.text = @"已完结";
        self.showStateImageView.image = [UIImage imageNamed:@"bc_corner_blue.png"];
    }
    _unfinished = unfinished;
}

#pragma mark - table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"UITableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14.0];
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor grayColor].CGColor;
        layer.frame = CGRectMake(0, 43.5, kScreenWidth, 0.5);
        [cell.contentView.layer addSublayer:layer];
    }
    ComicShowBookModel *model = self.contentModelArray[indexPath.row];
    cell.textLabel.text = model.SiteName;
    if (model.BookState.intValue == 1) {
        cell.detailTextLabel.text = model.BookUpdateSection;
    }else{
        cell.detailTextLabel.text = @"已完结";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    ComicStoreBookContentListViewController *controller = [[ComicStoreBookContentListViewController alloc]initWithNibName:@"ComicStoreBookContentListViewController" bundle:nil];
    ComicShowBookModel *model = self.contentModelArray[indexPath.row];
    controller.bookID = model.BookID;
    controller.titleText = model.BookName;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)showCollectButtonAction:(UIButton *)sender {
    if (!_contentModelArray) {
        [KVNProgress showErrorWithStatus:@"收藏失败！"];
        return;
    }
    ComicShowBookModel *bookModel = [_contentModelArray firstObject];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ComicBookInfoContextModel"];
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    for (ComicBookInfoContextModel *model in array) {
        if (model.bookID.intValue == bookModel.BookID.intValue) {
            [KVNProgress showErrorWithStatus:@"你已收藏过此漫画！"];
            return;
        }
    }
    ComicBookInfoContextModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"ComicBookInfoContextModel" inManagedObjectContext:context];
    model.bookIconOtherURL = bookModel.BookIconOtherURL;
    model.bookID = bookModel.BookID;
    model.bookState = bookModel.BookState;
    model.bookUpdateSection = bookModel.BookUpdateSection;
    model.bookName = bookModel.BookName;
    if ([context save:nil]) {
        [KVNProgress showSuccessWithStatus:@"收藏成功"];
    }else{
        [KVNProgress showErrorWithStatus:@"收藏失败！"];
    }
}
@end
