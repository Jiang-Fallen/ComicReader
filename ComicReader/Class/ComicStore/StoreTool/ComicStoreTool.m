//
//  ComicStoreTool.m
//  ComicReader
//
//  Created by Jiang on 1/13/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ComicStoreTool.h"
#import "RequestTool.h"
#import "HeaderModelTool.h"
#import "ListComicModelTool.h"
#import "ListRowContentModelTool.h"
#import "NewRequestTool.h"
#import "NewStoreTitleModel.h"
#import "NewStoreContentListModel.h"
#import "AFNetworking.h"
#import "DocumentTool.h"

@implementation ComicStoreTool

#pragma mark - Request Method
- (void)requestArrayByAsquireHeaderModelCompletion:(void (^)(NSMutableArray *blockHeaderArray))success
                                           failure:(void (^)(NSError *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", kRequestURL, kGetProad];
    NSDictionary *parmas = @{@"appVersionName": @"2.4.7",
                             @"mobileModel": @"iPhone4,1",
                             @"osVersionCode": [[UIDevice currentDevice] systemVersion],
                             @"channelid": @"appstore",};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:parmas success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        if (dict) {
            [DocumentTool sharedDocumentTool].headerDictionary = responseObject;
        }else{
            dict = [DocumentTool sharedDocumentTool].headerDictionary;
        }
        
        NSMutableArray *modelArray = [HeaderModelTool headerModelByModelTool:dict];
        if (!modelArray) {
            NSLog(@"返回数据为空!");
//            URL是抓包得来，请求失败率较高，顾先这样做
//                        failure(nil);
            success(nil);
        }else{
            success(modelArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failure(error);
        success(nil);
    }];
}

- (void)requestArrayByComicStoreListModelCompletion:(void (^)(NSMutableArray *blockListArray))success
                                               failure:(void (^)(NSError *error))failure{
    
    RequestTool *request = [RequestTool sharedRequestTool];
    [request requestArrayByAsquireComicStoreListModelCompletion:^(NSDictionary *responseObject) {
        NSMutableArray *modelArray = [ListComicModelTool comicModelWithDictionary:responseObject];
        if (!modelArray) {
            NSLog(@"返回数据为空!");
            failure(nil);
        }else{
            success(modelArray);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)requestArrayByComicStoreRowListModel:(id)parameters
                                  Completion:(void (^)(NSMutableArray *blockRowListArray))success
                                     failure:(void (^)(NSError *error))failure
{
    RequestTool *request = [RequestTool sharedRequestTool];
    [request requestArrayByComicStoreRowListModel:parameters Completion:^(NSDictionary *responseObject) {
        NSMutableArray *modelArray = [ListRowContentModelTool comicModelWithDictionary:responseObject];
        success(modelArray);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)requestArrayByComicStoreModelCompletion:(void (^)(NSMutableArray *blockHeaderArray,
                                                          NSMutableArray *blockListArray))success
                                        failure:(void (^)(NSError *error))failure
{
    [self requestArrayByAsquireHeaderModelCompletion:^(NSMutableArray *blockHeaderArray) {
//        NSLog(@"-----------------------------头数据请求完成");
        [self requestArrayByComicStoreListModelCompletion:^(NSMutableArray *blockListArray) {
            success(blockHeaderArray, blockListArray);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}


- (void)requestComicStoreNewModelCompletion:(void (^)(NSMutableArray *blockHeaderArray,
                                                      NSMutableArray *blockListArray))success
                                    failure:(void (^)(NSError *error))failure
{
    NewRequestTool *request = [NewRequestTool sharedRequestTool];
    [self requestArrayByAsquireHeaderModelCompletion:^(NSMutableArray *blockHeaderArray) {
        [request requestTitleModelCompletion:^(NSMutableArray *responseObject) {
            NSMutableArray *array = [NewStoreTitleModel modelArrayByDataArray:responseObject];
            success(blockHeaderArray, array);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}
- (void)requestComicStoreContentListNewModelCompletion:(NSString*)requestMethod
                               parameters:(id)parameters
                                  success:(void (^)(NSMutableArray *))success
                                  failure:(void (^)(NSError *))failure
{
    [[NewRequestTool sharedRequestTool] requestContentListModelCompletion:requestMethod parameters:parameters success:^(NSMutableArray *responseObject) {
        NSMutableArray *array = [NewStoreContentListModel modelArrayByDataArray:responseObject];
        success(array);
    } failure:^(NSError *error) {
        failure(error);
    }];
}



#pragma mark - 单例实现
static ComicStoreTool *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedRequestTool{
    _instance = [[ComicStoreTool alloc]init];
    return _instance;
}

@end
