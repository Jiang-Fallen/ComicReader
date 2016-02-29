//
//  ListRowContentModel.h
//  ComicReader
//
//  Created by Jiang on 1/13/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListRowContentModel : NSObject

//作者
@property (nonatomic, copy) NSString *bigbook_author;
//id
@property (nonatomic, strong) NSNumber *bigbook_id;
//书名
@property (nonatomic, copy) NSString *bigbook_name;
//人数
@property (nonatomic, strong) NSNumber *bigbookview;
//url
@property (nonatomic, copy) NSString *coverurl;
//查询关键字
@property (nonatomic, copy) NSString *key_name;
//是否完结
@property (nonatomic, strong) NSNumber *progresstype;
//主题名
@property (nonatomic, copy) NSString *subject_name;


- (instancetype)initWithDictionary:(NSDictionary*)dict;

- (void)setComicRowContentDictionary:(NSDictionary*)dict;

+ (instancetype)comicRowContentModelWithDictionary:(NSDictionary*)dict;

@end
