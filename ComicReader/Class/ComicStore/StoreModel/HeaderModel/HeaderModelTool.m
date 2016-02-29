//
//  HeaderModelTool.m
//  ComicReader
//
//  Created by Jiang on 14/12/10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HeaderModelTool.h"
#import "HeaderModel.h"

@implementation HeaderModelTool

+ (NSMutableArray*)headerModelByModelTool:(NSDictionary*)dict{
    if (!dict || ![[dict class]isSubclassOfClass:[NSDictionary class]] || !dict[@"info"]){
        return nil;
    }
    NSDictionary *infoDictionary = dict[@"info"];
    NSString *adlistjsonString = infoDictionary[@"adlistjson"];
    if (!infoDictionary || !adlistjsonString) return nil;
    
    NSData *adlistjsonData = [adlistjsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *adlistjsonArray = [NSJSONSerialization JSONObjectWithData:adlistjsonData options:0 error:nil];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dict in adlistjsonArray) {
        HeaderModel *headerModel = [HeaderModel headerModelWithDictionary:dict];
        [modelArray addObject:headerModel];
    }
    
    return modelArray;
}

@end
