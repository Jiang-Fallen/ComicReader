//
//  ComicBookReaderController.m
//  ComicReader
//
//  Created by Jiang on 5/10/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ComicBookReaderController.h"
#import "ComicBookReaderModel.h"
#import "MONActivityIndicatorView.h"
#import "AFNetworking.h"

@interface ComicBookReaderController () <UIWebViewDelegate, MONActivityIndicatorViewDelegate>
{
    CGFloat _touchMove_Y;
}

@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (nonatomic, strong) NSArray *contentModelArray;
@property (nonatomic, weak) MONActivityIndicatorView *indicatorView;

@end

@implementation ComicBookReaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavagationBar];
    [self initSubViews];
    [self requestData];
}

- (void)initNavagationBar{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = self.titleText;
    label.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = label;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = NO;
}

- (void)initSubViews{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_day.png"]];
    self.view.backgroundColor = color;
    _contentWebView.delegate = self;
    _contentWebView.scrollView.minimumZoomScale = 1.0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchViewAction:)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAXFLOAT, MAXFLOAT)];
    view.backgroundColor = [UIColor clearColor];
    [view addGestureRecognizer:tap];
    [_contentWebView.scrollView addSubview:view];
}

- (MONActivityIndicatorView *)indicatorView{
    if (_indicatorView == nil) {
        MONActivityIndicatorView* indicatorView = [[MONActivityIndicatorView alloc] init];
        [self.view addSubview:indicatorView];
        _indicatorView = indicatorView;
        _indicatorView.delegate = self;
        _indicatorView.numberOfCircles = 6;
        _indicatorView.radius = 9;
        _indicatorView.internalSpacing = 9;
        _indicatorView.center = CGPointMake(kScreenWidth/ 2, kScreenHeight/ 2 - 64);
    }
    return _indicatorView;
}

- (void)touchViewAction:(UITapGestureRecognizer *)tap{
    self.navigationController.navigationBar.hidden = ![self.navigationController.navigationBar isHidden];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.navigationController.navigationBar.hidden = YES;
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.contentWebView.hidden = NO;
    [self.indicatorView stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.indicatorView startAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

#pragma mark - MONActivityIndicatorViewDelegate设置进度条颜色

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint location = [touch locationInView:self.view];
    _touchMove_Y = location.y;
    return YES;
}

- (void)requestData{
    NSDictionary *parameters = @{@"method": @"picturelist",
                                 @"sectionid": self.sectionID};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __unsafe_unretained typeof(self) p = self;
    [manager GET:kNewRequestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        p.contentModelArray = [ComicBookReaderModel modelArrayForDataArray:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    ComicBookReaderModel *model = [contentModelArray firstObject];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.PictureRefererURL]];
    [self.contentWebView loadRequest:request];
}

@end
