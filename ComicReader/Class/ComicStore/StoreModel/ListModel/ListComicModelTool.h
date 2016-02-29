//
//  MyComicTool.h
//  ComicReader
//
//  Created by Jiang on 14/12/9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListComicModelTool : NSObject

+ (NSMutableArray*)comicModelWithDictionary:(NSDictionary*)dict;
- (NSMutableArray*)parseComicModelWithDictionay:(NSDictionary*)dict;

@end
