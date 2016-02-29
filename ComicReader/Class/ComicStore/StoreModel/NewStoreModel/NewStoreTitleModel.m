//
//  NewStoreModel.m
//  ComicReader
//
//  Created by Jiang on 3/25/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "NewStoreTitleModel.h"

@implementation NewStoreTitleModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (NSMutableArray*)modelArrayByDataArray:(NSArray*)array{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    [mutableArray insertObject:@{@"CatalogName": @"热门推荐"} atIndex:0];
    [mutableArray insertObject:@{@"CatalogName": @"每日更新"} atIndex:1];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (NSDictionary *dict in mutableArray) {
        NewStoreTitleModel *model = [[NewStoreTitleModel alloc]initWithDictionary:dict];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
