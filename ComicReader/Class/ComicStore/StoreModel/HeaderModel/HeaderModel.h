//
//  HeaderModel.h
//  ComicReader
//
//  Created by Jiang on 14/12/10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeaderModel : NSObject

@property (nonatomic, copy) NSString *cornermark;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, copy) NSString *imageurl;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, strong) NSNumber *targetargument;
@property (nonatomic, strong) NSNumber *targetmethod;
@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *other;

+ (instancetype)headerModelWithDictionary:(NSDictionary*)dict;
- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
