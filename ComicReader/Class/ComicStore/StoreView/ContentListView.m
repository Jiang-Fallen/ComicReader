//
//  ContentListView.m
//  ComicReader
//
//  Created by Jiang on 1/14/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ContentListView.h"
#import "ComicStoreContentListCollectionView.h"
#import "ResizeLabel.h"

@interface ContentListView ()

//content列表ViewGo back按钮ICON
@property (nonatomic, weak) UIImageView *contentBackIcon;

@property (nonatomic, weak) UIView *selectedView;

@property (nonatomic, weak) UIView *rightHintView;
@property (nonatomic, weak) UILabel *rightHintViewLabel;
//是否在动画完毕之后执行删除rightHintView操作
@property (nonatomic, assign, getter=isExecutionRemove) BOOL executionRemove;
@end

@implementation ContentListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(-5, 0);
        self.layer.shadowOpacity = 1;
        
        [self initSubViews];
    }
    return self;
}
//bookshelf_import_control_left

- (void)initSubViews{
    ComicStoreContentListCollectionView *contentCollection = [[ComicStoreContentListCollectionView alloc]initWithFrame:self.bounds];
    CGRect rect = self.bounds;
    rect.size.width = 2;
    CALayer *layer = [CALayer layer];
    layer.frame = rect;
    layer.backgroundColor = [UIColor orangeColor].CGColor;
    layer.zPosition = 1;
    [self.layer addSublayer:layer];
    
    UIView *contentBack = [[UIView alloc]initWithFrame:CGRectMake(0, kHeaderHeight, kListLiftBar, self.bounds.size.height - kHeaderHeight)];
    contentBack.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:contentCollection];
    [self addSubview:contentBack];
    
    self.comicStoreContentListCollectionView = contentCollection;
    self.contentBack = contentBack;
}

- (void)addSelectedView{
    self.selectedView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    __unsafe_unretained typeof(self) p = self;
    [UIView animateWithDuration:0.25 animations:^{
        p.selectedView.transform = CGAffineTransformIdentity;
        p.contentBackIcon.transform = CGAffineTransformIdentity;
    }];
}

- (void)removeSelectedView{
    __unsafe_unretained typeof(self) p = self;
    [UIView animateWithDuration:0.25 animations:^{
        p.contentBackIcon.transform = CGAffineTransformMakeRotation(M_PI);
        p.selectedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [p.selectedView removeFromSuperview];
    }];
}

- (void)openSelectedView{
    if (!_selectedView) {
        [self addSelectedView];
    }else{
        [self removeSelectedView];
    }
}

- (void)setContentBack:(UIView *)contentBack{
    _contentBack = contentBack;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openSelectedView)];
    [contentBack addGestureRecognizer:tap];
    
    UIImage *image = [UIImage imageNamed:@"back_bnt_hl.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect imageViewRect = imageView.frame;
    imageViewRect.origin.y += 10;
    imageViewRect.origin.x += 5;
    imageView.frame = imageViewRect;
    self.contentBackIcon = imageView;
    [_contentBack addSubview:imageView];
    
    CGRect rect = _contentBack.bounds;
    rect.origin.y = CGRectGetMaxY(imageView.frame) + 10;
    rect.size.height -= 10;
    ResizeLabel *label = [[ResizeLabel alloc]initWithFrame:rect];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:kListLiftBarTitle];
    label.textAlignment = NSTextAlignmentCenter;
    label.shadowOffset = CGSizeMake(1, 1);
    label.text = @"热门推荐";
    self.currentListTitle = label;
    [_contentBack addSubview:label];
    
    self.contentBackIcon.transform = CGAffineTransformMakeRotation(M_PI);
}

- (void)setListRowContentModelArray:(NSArray *)listRowContentModelArray{
    _listRowContentModelArray = listRowContentModelArray;
    self.comicStoreContentListCollectionView.listRowContentModelArray = listRowContentModelArray;
    self.comicStoreContentListCollectionView.contentOffset = CGPointZero;
    [self.comicStoreContentListCollectionView reloadData];
}

- (void)showRefreshState:(RefreshState)refreshState{
    self.executionRemove = NO;
    CGRect rightHintRect = CGRectMake(self.bounds.size.width, 80, 120.0, 45.0);
    self.rightHintView.frame = rightHintRect;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissRefreshState) object:nil];
//      在dismiss动画执行的0.25秒内刷新存在bug
//        [self.rightHintView removeFromSuperview];
    switch (refreshState) {
        case stateSuccess:
            self.rightHintViewLabel.text = @"刷新成功!";
            break;
        case stateFailure:
            self.rightHintViewLabel.text = @"刷新失败!";
            break;
        case stateLoading:
            self.rightHintViewLabel.text = @"加载中!";
            break;
        default:
            break;
    }
    __block CGRect rect = self.rightHintView.frame;
    __unsafe_unretained typeof(self) p = self;
    [UIView animateWithDuration:0.25 animations:^{
        rect.origin.x -= rect.size.width;
        p.rightHintView.frame = rect;
    } completion:^(BOOL finished) {
        p.executionRemove = YES;
        [p performSelector:@selector(dismissRefreshState) withObject:nil afterDelay:2.0];
    }];
}

- (void)dismissRefreshState{
    __block CGRect rect = self.rightHintView.frame;
    __unsafe_unretained typeof(self) p = self;
    [UIView animateWithDuration:0.25 animations:^{
        rect.origin.x = p.frame.size.width;
        p.rightHintView.frame = rect;
    } completion:^(BOOL finished) {
        if (p.executionRemove) {
            [p.rightHintView removeFromSuperview];
        }
    }];
}

- (UIView *)rightHintView{
    if (!_rightHintView) {
        CGRect rect = CGRectMake(self.bounds.size.width, 20, 120.0, 45.0);
        UIView *view = [[UIView alloc]initWithFrame:rect];
        UIImage *image = [UIImage imageNamed:@"bookshelf_import_control_left"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.alpha = 0.9;
        imageView.frame = view.bounds;
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:view.bounds];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.font = [UIFont boldSystemFontOfSize:13.0];
        [view addSubview:label];
        _rightHintViewLabel = label;
        
        [self addSubview:view];
        _rightHintView = view;
    }
    return _rightHintView;
}

- (UIView *)selectedView{
    if (!_selectedView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.alpha = 0.9;
        view.layer.anchorPoint = CGPointMake(0, 0);
        view.layer.position = CGPointMake(kListLiftBarTitle + 10, self.contentBack.frame.origin.y + 20);
        UIImage *image = [UIImage imageNamed:@"selectedViewBackImage.png"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = view.bounds;
        [view addSubview:imageView];
        
        UIButton *buttonLeft = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 80, 30)];
        [buttonLeft addTarget:self action:@selector(selectedViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonLeft setTitle:@"人气漫画" forState:UIControlStateNormal];
        [buttonLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonLeft.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        buttonLeft.tag = 21;
        
        UIButton *buttonRight = [[UIButton alloc]initWithFrame:CGRectMake(15, 50, 80, 30)];
        [buttonRight addTarget:self action:@selector(selectedViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonRight setTitle:@"最新更新" forState:UIControlStateNormal];
        [buttonRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonRight.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        buttonRight.tag = 22;
        
        [view addSubview:buttonLeft];
        [view addSubview:buttonRight];
        
        [self addSubview:view];
        _selectedView = view;
    }
    return _selectedView;
}

- (void)selectedViewButtonAction:(UIButton*)button{
    [self removeSelectedView];
    if (button.tag == 21) {
        self.currentListTitle.text = @"人气漫画";
    }else{
        self.currentListTitle.text = @"最新更新";
    }
    if ([self.delegate respondsToSelector:@selector(comicOrderSelectedIndex:)]) {
        [self.delegate comicOrderSelectedIndex:button.tag - 21];
    }
}

- (void)setCurrentScrollViewOffset:(CGPoint)offset{
    if (offset.y > kHeaderHeight) {
        if (self.contentBack.frame.origin.y > 0) {
            offset.y = kHeaderHeight;
        }else{
            return;
        }
    }
    CGRect rect = self.contentBack.frame;
    rect.origin.y = kHeaderHeight - offset.y;
    self.contentBack.frame = rect;
    
    if (!_selectedView) {
        return;
    }
    rect = self.selectedView.frame;
    rect.origin.y = kHeaderHeight - offset.y + 20;
    self.selectedView.frame = rect;
}

@end
