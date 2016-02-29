//
//  ComicStoreAchieveListBackImageOfStore.m
//  ComicReader
//
//  Created by Jiang on 14/12/19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ComicStoreAchieveListBackImageOfStore.h"
#import <UIKit/UIKit.h>

static NSString *imageNamePrefix = @"ComicStoreList";
@implementation ComicStoreAchieveListBackImageOfStore

+ (NSArray*)achieveListBackImageForSumNumber:(NSInteger)number{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < number; i++) {
        NSString *string = [NSString stringWithFormat:@"%@%02d.png", imageNamePrefix, i%9 + 1];
        UIImage *image = [UIImage imageNamed:string];
        [array addObject:image];
    }
    return array;
}

@end
