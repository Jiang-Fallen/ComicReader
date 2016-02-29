//
//  NewStoreContentListModel.h
//  ComicReader
//
//  Created by Jiang on 3/27/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewStoreContentListModel : NSObject

@property (nonatomic, copy) NSNumber *BookClickCount;
@property (nonatomic, copy) NSString *BookAuthor;
@property (nonatomic, copy) NSString *BookCreationDate;
@property (nonatomic, copy) NSString *BookDescription;
@property (nonatomic, copy) NSNumber *BookDownCount;
@property (nonatomic, copy) NSNumber *BookID;
@property (nonatomic, copy) NSString *BookIconOtherURL;
@property (nonatomic, copy) NSString *BookLinkURL;
@property (nonatomic, copy) NSString *BookName;
@property (nonatomic, copy) NSNumber *BookState;
@property (nonatomic, copy) NSString *BookStateName;
@property (nonatomic, copy) NSString *BookUpdateDate;
@property (nonatomic, copy) NSString *BookUpdateSection;
@property (nonatomic, copy) NSNumber *CatalogID;
@property (nonatomic, copy) NSString *CatalogName;
@property (nonatomic, copy) NSString *FistIndex;
@property (nonatomic, copy) NSNumber *SiteID;
@property (nonatomic, copy) NSString *SiteName;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray*)modelArrayByDataArray:(NSArray*)array;

@end
