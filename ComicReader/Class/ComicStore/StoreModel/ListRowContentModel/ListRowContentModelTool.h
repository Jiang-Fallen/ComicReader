//
//  ListRowContentModelTool.h
//  ComicReader
//
//  Created by Jiang on 1/13/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListRowContentModelTool : NSObject

+ (NSMutableArray*)comicModelWithDictionary:(NSDictionary*)dict;
- (NSMutableArray*)parseComicModelWithDictionay:(NSDictionary*)dict;

@end
