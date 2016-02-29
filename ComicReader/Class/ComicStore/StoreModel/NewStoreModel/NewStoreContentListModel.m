//
//  NewStoreContentListModel.m
//  ComicReader
//
//  Created by Jiang on 3/27/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "NewStoreContentListModel.h"

@implementation NewStoreContentListModel

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
    
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        NewStoreContentListModel *model = [[NewStoreContentListModel alloc]initWithDictionary:dict];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
