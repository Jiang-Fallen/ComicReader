//
//  HeaderModel.m
//  ComicReader
//
//  Created by Jiang on 14/12/10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HeaderModel.h"
#import "NSObject+KVCKeyword.h"

@implementation HeaderModel

+ (instancetype)headerModelWithDictionary:(NSDictionary *)dict{
    return [[HeaderModel alloc]initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
//        [self setValuesForKeywordsWithDictionary:dict];
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}

@end
