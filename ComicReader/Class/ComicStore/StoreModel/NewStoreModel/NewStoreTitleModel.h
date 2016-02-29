//
//  NewStoreModel.h
//  ComicReader
//
//  Created by Jiang on 3/25/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewStoreTitleModel : NSObject

@property (nonatomic, copy) NSNumber *CatalogID;
@property (nonatomic, copy) NSString *CatalogName;
@property (nonatomic, copy) NSString *CatalogDescription;
@property (nonatomic, copy) NSString *CatalogOtherURL;
@property (nonatomic, copy) NSString *CatalogSelfURL;
@property (nonatomic, copy) NSString *CatalogTargetURL1;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray*)modelArrayByDataArray:(NSArray*)array;

@end
