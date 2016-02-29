//
//  StoreTableViewHeader.m
//  ComicReader
//
//  Created by Jiang on 14/12/10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ComicStoreHeaderView.h"
#import "HeaderModel.h"
#import "UIImageView+WebCache.h"

typedef enum{
    previous = 0,
    current,
    next
} ScrollAction;

@interface ComicStoreHeaderView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIPageControl *page;

@property (nonatomic, assign) int index;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSMutableArray *showPictureImageArray;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ComicStoreHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight)]) {
        UIImage *backImage = [UIImage imageNamed:@"back_day.png"];
        self.backgroundColor = [UIColor colorWithPatternImage:backImage];
//        self.layer.zPosition = 5;
//        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(0, 5);
//        self.layer.shadowOpacity = 0.8;
        
        [self setScrollViewParameter];
        [self scrollViewAddContentView];
        [self addElement];
        self.scrollView.delegate = self;
        [self scrollViewDidEndDecelerating:self.scrollView];
        [self startTimer];
    }
    return self;
}

- (void)setModelArray:(NSArray *)modelArray{
    _modelArray = modelArray;
    _page.numberOfPages = _modelArray.count;
    CGRect rect = _page.frame;
    rect.size.width = 15 * _modelArray.count;
    rect.origin.x = kScreenWidth - rect.size.width - kSpace;
    _page.frame = rect;

    [self resetScrollViewContentLocation];
}

#pragma mark 重置ImageView位置
- (void)resetScrollViewContentLocation{
    self.page.currentPage = _index;
    //设置tabel文字
    HeaderModel *currentModel = self.modelArray[_index];
    self.label.text = currentModel.title;

    for (int i = 0; i < self.showPictureImageArray.count; i ++) {
        NSInteger index = _index - 1 + i;
        if (index < 0) {
            index = self.modelArray.count + index;
        }else if(index >= self.modelArray.count){
            index = index - self.modelArray.count;
        }
        UIImageView *imageView = self.showPictureImageArray[i];
        
        NSURL *currentURL = [NSURL URLWithString:currentModel.imageurl];
        [imageView sd_setImageWithURL:currentURL placeholderImage:self.placeholderImage];
    }
    
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
}

#pragma mark 启动计时器
- (void)startTimer{
    _timer = [NSTimer timerWithTimeInterval:4.0 target:self
                      selector:@selector(nextImageViewForScrollView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
#pragma mark 向右翻页
- (void)nextImageViewForScrollView{
    [UIView animateWithDuration:1.0 animations:^{
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth * 2, 0)];
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}

#pragma mark - 代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int index = (scrollView.contentOffset.x)/kScreenWidth;
    if (index == current || !self.modelArray) return;
    if (index == previous) {
        _index = _index - 1 < 0? (int)self.modelArray.count - 1: _index - 1;
    }else if(index == next){
        _index = _index + 1 > self.modelArray.count - 1? 0: _index + 1;;
    }
    [self resetScrollViewContentLocation];
}
#pragma mark  用户拖动scrollview时使计时器失效
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer setFireDate:[NSDate distantFuture]];
}
#pragma mark  拖动scrollview结束时计时器开始
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSDate *date = [NSDate dateWithTimeInterval:4.0 sinceDate:[NSDate date]];
    [self.timer setFireDate:date];
}

#pragma mark - 初始化View
#pragma mark 为View添加bar、标签、标签页
- (void)addElement{
    //设置ViewBar  Rect
    CGFloat label_y = self.bounds.size.height - kHeaderScrollLabelHeight;
    CGRect rect = CGRectMake(0, label_y, kScreenWidth, kHeaderScrollLabelHeight);
    //添加ViewBar
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = rect;
    layer.opacity = 0.8;
    layer.colors = @[(id)[[UIColor orangeColor]colorWithAlphaComponent:1.0].CGColor,
                     (id)[[UIColor orangeColor]colorWithAlphaComponent:0.0].CGColor];
    layer.locations = @[@0.8, @1];
    layer.startPoint = CGPointMake(0, 1);
    layer.endPoint = CGPointMake(0.9, 0.8);
    [self.layer addSublayer:layer];
    
    //设置label  Rect
    rect.origin.x += kSpace;
    rect.size.width = kHeaderScrollLabelWidth;
    //添加label
    _label = [[UILabel alloc]initWithFrame:rect];
    _label.font = [UIFont boldSystemFontOfSize:14];
    _label.textColor = [UIColor whiteColor];
    [self addSubview:_label];
    
    //添加page
    _page = [[UIPageControl alloc]initWithFrame:rect];
    _page.pageIndicatorTintColor = [UIColor whiteColor];
    _page.currentPageIndicatorTintColor = [UIColor cyanColor];
    [self addSubview:_page];
    
}
#pragma mark 为ScrollView设置属性
- (void)setScrollViewParameter{
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setPagingEnabled:YES];
}

#pragma mark 为ScrollView添加内容元素
- (void)scrollViewAddContentView{
    self.showPictureImageArray = [NSMutableArray arrayWithCapacity:3];
    
    for (int i = 0; i < 3; i++) {
        CGRect rect = CGRectMake(i * kScreenWidth, 0, kScreenWidth, kHeaderHeight);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.image = self.placeholderImage;
        
        [self.scrollView addSubview:imageView];
        [self.showPictureImageArray addObject:imageView];
    }
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
}
#pragma mark -

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        self.scrollView.contentSize = CGSizeMake(3 * kScreenWidth, 0);
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
//占位图片
- (UIImage *)placeholderImage{
    if (_placeholderImage == nil) {
        _placeholderImage = [UIImage imageNamed:@"community_cover_item"];
    }
    return _placeholderImage;
}

@end
