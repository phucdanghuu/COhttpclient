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

//#define kIS_SHOW_ERROR NO


#ifdef CLSNSLog
#define HCLOG(__FORMAT__, ...) CLSNSLog((@"%s line %d $ " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define HCLOG(__FORMAT__, ...)
#endif


@class COHttpResponseObject;
@class COHttpClient;

@protocol COHttpClientDataSource <NSObject>
- (NSDictionary *)httpClientWithDefaultHeaderFields:(COHttpClient *)httpClient;
- (void)httpClient:(COHttpClient *)httpClient didCatchFailure:(NSURLSessionDataTask *)operation error:(NSError *)error;
- (COHttpResponseObject *)httpClient:(COHttpClient *)httpClient responseObjectFromTask:(NSURLSessionDataTask *)operation andDictionnary:(id)responseObject;
@end


@interface COHttpClient : NSObject

@property (nonatomic, strong) id<COHttpClientDataSource> dataSource;

@property (nonatomic, readonly) NSString *apiVersion;
@property (nonatomic, readonly) NSString *deviceType;
@property (nonatomic, readonly) NSString *accessToken;

- (id)initWithBaseURL:(NSURL *)baseUrl apiVersion:(NSString *)version deviceType:(NSString *)deviceType;
- (id)initWithBaseURL:(NSURL *)baseUrl apiVersion:(NSString *)version;

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
