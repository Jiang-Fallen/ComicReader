//
//  MyComicContentModel.m
//  ComicReader
//
//  Created by Jiang on 14/12/9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ListContentModel.h"

@interface ListContentModel ()

@end

@implementation ListContentModel

- (instancetype)initWithDictionary:(NSDictionary*)dict{
    if (self = [super init]) {
        [self setComicContentModelWithDictionary:dict];
    }
    return self;
}

- (void)setComicContentModelWithDictionary:(NSDictionary*)dict{
    [self setValuesForKeysWithDictionary:dict];
}

+ (instancetype)comicContentModelWithDictionary:(NSDictionary*)dict{
    ListContentModel *comicContentModel = [[ListContentModel alloc]initWithDictionary:dict];
    return comicContentModel;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
