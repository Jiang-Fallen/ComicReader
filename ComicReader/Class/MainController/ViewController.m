//
//  ViewController.m
//  ComicReader
//
//  Created by Jiang on 14-12-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITabBarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UINavigationBar *navigationBar = [UINavigationBar appearance];
    
    UIImage *image = [UIImage imageNamed:@"menu_bk_partten"];
//    UIImage *image = [UIImage imageNamed:@"s02.jpg"];
//    CGRect rect = CGRectMake(0, 0, image.size.width * 2, 128);
//    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
//    UIImage *navigationBackImage = [UIImage imageWithCGImage:imageRef scale:2 orientation:UIImageOrientationUp];
//    [navigationBar setBackgroundImage:navigationBackImage forBarMetrics:UIBarMetricsDefault];
    [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.tabBar.selectedImageTintColor = [UIColor orangeColor];
    [navigationBar setTintColor:[[UIColor whiteColor]colorWithAlphaComponent:0.8]];
    navigationBar.titleTextAttributes = @{NSStrokeColorAttributeName: [[UIColor whiteColor]colorWithAlphaComponent:0.8],
                                          NSFontAttributeName: [UIFont boldSystemFontOfSize:15]
                                          };
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    NSArray *array = self.tabBar.items;
    for (int i = 0; i < array.count; i++) {
        UITabBarItem *item = array[i];
        NSString *string = [NSString stringWithFormat:@"tab%d_sel.png", i+1];
        if (i == 2) {
            string = @"tab4_sel.png";
        }
        [item setSelectedImage:[UIImage imageNamed:string]];
    }
    [self setSelectedIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
