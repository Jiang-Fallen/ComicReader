//
//  ComicStoreTitleTableView.m
//  ComicReader
//
//  Created by Jiang on 1/9/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ComicStoreTitleTableView.h"
#import "ComicStoreTitleTableViewCell.h"
#import "UIImageView+WebCache.h"
//#import "ListModel.h"
#import "NewStoreTitleModel.h"

@interface ComicStoreTitleTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

static NSString *titleTableViewIdentifier = @"TitleTableViewIdentifier";
@implementation ComicStoreTitleTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
        [self registerNib:[UINib nibWithNibName:@"ComicStoreTitleTableViewCell" bundle:nil] forCellReuseIdentifier:titleTableViewIdentifier];
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kToolBarHeight)];
        self.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 10)];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)reloadData{
    [super reloadData];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self didSelectRowAtIndexPath:index];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ComicStoreTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleTableViewIdentifier forIndexPath:indexPath];
    NewStoreTitleModel *listModel = self.listModelArray[indexPath.row];
    cell.contentTitleLabel.text = listModel.CatalogName;
//    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:listModel.CatalogOtherURL]];
//    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.titleListDelegate currentSelectItem:indexPath];
}

@end
