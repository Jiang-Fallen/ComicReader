//
//  MyComicTool.m
//  ComicReader
//
//  Created by Jiang on 14/12/9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ListComicModelTool.h"
#import "ListModel.h"

@implementation ListComicModelTool

+ (NSMutableArray *)comicModelWithDictionary:(NSDictionary *)dict{
    if (!dict[@"info"]) {
        return nil;
    }
    NSMutableArray *comicArray = [NSMutableArray array];
    NSArray *array = dict[@"info"];
    for (NSDictionary *dict in array) {
        ListModel *comicModel = [ListModel comicModelWithDictionary:dict];
        [comicArray addObject:comicModel];
    }
    return [comicArray copy];
}

- (NSMutableArray *)parseComicModelWithDictionay:(NSDictionary *)dict{
    return [ListComicModelTool comicModelWithDictionary:dict];
}
@end
