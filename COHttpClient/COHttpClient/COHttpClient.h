//
//  COHttpClient.h
//  COHttpClient
//
//  Created by Tran Kien on 4/27/16.
//  Copyright © 2016 Cogini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "COHttpResponseObject.h"
//#import <AFNetworking/AFHTTPSessionManager.h>
//#import ""

#define kIS_SHOW_ERROR NO


#ifdef CLSNSLog
#define HCLOG(__FORMAT__, ...) CLSNSLog((@"%s line %d $ " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define HCLOG(__FORMAT__, ...)
#endif


@class COHttpResponseObject;

@interface COHttpClientHelper :NSObject

- (COHttpResponseObject *)responseObjectFromDictionnary:(id)responseObject;
- (void)handleFail:(NSURLSessionDataTask *)operation error:(NSError *)error;
@end

@protocol COHttpClientDataSource

- (NSDictionary *)httpClientWithDefaultHeaderFields;
- (void)httpClientDidCatchFailure:(NSURLSessionDataTask *)operation error:(NSError *)error;
@end


@interface COHttpClient : NSObject {
  AFHTTPSessionManager * _manager;
}

@property (nonatomic, strong) COHttpClientHelper *httpHelper;

- (NSURLSessionDataTask *) GET:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

- (NSURLSessionDataTask *) POST:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void (^)(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

- (NSURLSessionDataTask *) PUT:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

- (NSURLSessionDataTask *) DELETE:(NSString *)URLString
                         parameters:(id)parameters
                            success:(void (^)(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject))success
                            failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;
@end
