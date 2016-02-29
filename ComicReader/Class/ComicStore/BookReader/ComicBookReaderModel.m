//
//  ComicBookReaderModel.m
//  ComicReader
//
//  Created by Jiang on 5/10/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ComicBookReaderModel.h"

@implementation ComicBookReaderModel

- (instancetype)initWithDictionary:(NSDictionary*)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        ComicBookReaderModel *model = [[ComicBookReaderModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
