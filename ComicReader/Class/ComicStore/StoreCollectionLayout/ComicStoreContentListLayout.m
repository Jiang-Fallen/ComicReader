//
//  ComicStoreContentListLayout.m
//  ComicReader
//
//  Created by Jiang on 1/12/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ComicStoreContentListLayout.h"

@interface ComicStoreContentListLayout ()


@end

@implementation ComicStoreContentListLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat width = (kScreenWidth - kListLiftBar)/3;
        self.sectionInset = UIEdgeInsetsMake(5.0, kListLiftBar, kToolBarHeight, 0);
        self.itemSize = CGSizeMake(width, 175 * width/130.0);
        self.minimumInteritemSpacing = 0;
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
//    [self registerClass:[LiftDecorationView class] forDecorationViewOfKind:@"LiftDecorationIdentifier"];
}

@end
