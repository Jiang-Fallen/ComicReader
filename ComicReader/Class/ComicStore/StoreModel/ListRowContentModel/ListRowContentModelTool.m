//
//  ListRowContentModelTool.m
//  ComicReader
//
//  Created by Jiang on 1/13/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ListRowContentModelTool.h"
#import "ListRowContentModel.h"

@implementation ListRowContentModelTool

+ (NSMutableArray *)comicModelWithDictionary:(NSDictionary *)dict{
    NSMutableArray *comicArray = [NSMutableArray array];
    NSArray *array = dict[@"info"][@"comicsList"];
    for (NSDictionary *dict in array) {
        ListRowContentModel *comicModel = [ListRowContentModel comicRowContentModelWithDictionary:dict];
        [comicArray addObject:comicModel];
    }
    return comicArray;
}

- (NSMutableArray *)parseComicModelWithDictionay:(NSDictionary *)dict{
    return [ListRowContentModelTool comicModelWithDictionary:dict];
}

@end
