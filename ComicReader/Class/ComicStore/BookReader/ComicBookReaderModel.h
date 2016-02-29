//
//  ComicBookReaderModel.h
//  ComicReader
//
//  Created by Jiang on 5/10/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComicBookReaderModel : NSObject

@property (nonatomic, strong) NSNumber *PictureID;
@property (nonatomic, strong) NSNumber *SectionID;

@property (nonatomic, copy) NSString *PictureURL;
@property (nonatomic, copy) NSString *PictureRefererURL;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end
