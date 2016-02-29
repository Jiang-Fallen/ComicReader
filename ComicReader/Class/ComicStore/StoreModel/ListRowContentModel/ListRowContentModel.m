//
//  ListRowContentModel.m
//  ComicReader
//
//  Created by Jiang on 1/13/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ListRowContentModel.h"

@implementation ListRowContentModel

- (instancetype)initWithDictionary:(NSDictionary*)dict{
    if (self = [super init]) {
        [self setComicRowContentDictionary:dict];
    }
    return self;
}

- (void)setComicRowContentDictionary:(NSDictionary *)dict{
    [self setValuesForKeysWithDictionary:dict];
}

+ (instancetype)comicRowContentModelWithDictionary:(NSDictionary*)dict{
    ListRowContentModel *comicContentModel = [[ListRowContentModel alloc]initWithDictionary:dict];
    return comicContentModel;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
