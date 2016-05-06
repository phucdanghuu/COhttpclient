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

#ifdef CLSNSLog
#define HCLOG(__FORMAT__, ...) CLSNSLog((@"%s line %d $ " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define HCLOG(__FORMAT__, ...) NSLog((@"%s line %d $ " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif


#define kCOHttpClientDeviceTypeKey @"X-Device-Type"
#define kCOHttpClientAPIVersionKey @"X-App-Version"
#define kCOHttpClientAccessTokenKey @"X-Access-Token"

@class COHttpResponseObject;
@class COHttpClient;

/**
 *  This delegate purpose is to customized header fields, response object or error handling
 */
@protocol COHttpClientDataDelegate <NSObject>

/**
 *  Beside of three default header fields (Device Type, API Version, Access token). This delegate method determines another header fields
 *
 *  @param httpClient Http
 *
 *  @return return header fields NSDictionary
 */
- (NSDictionary *)httpClientWithDefaultHeaderFields:(COHttpClient *)httpClient;

/**
 *  This delegate method will be called when COHttpClient receives any network error
 *
 *  @param httpClient COHttpClient
 *  @param operation  NSURLSessionDataTask
 *  @param error      NSError
 */
- (void)httpClient:(COHttpClient *)httpClient didCatchFailure:(NSURLSessionDataTask *)operation error:(NSError *)error;

/**
 *  This delegate method determines COHttpResponseObject from object, which received from server. If this method return nil, COHttpClient will create default COHttpResponseObject from received data
 *
 *  @param httpClient     COHttpClient
 *  @param operation      NSURLSessionDataTask
 *  @param responseObject received data from server
 *
 *  @return <#return value description#>
 */
- (COHttpResponseObject *)httpClient:(COHttpClient *)httpClient responseObjectFromTask:(NSURLSessionDataTask *)operation andDictionary:(id)responseObject;
@end


/**
 *  This class is a wrapper class of AFHTTPSessionManager. It is created to support for easily calling API with Mobile Api Convention ( https://gitlab.cogini.com/cogini/wiki/wikis/Mobile-API-Convention )
 */
@interface COHttpClient : NSObject

@property (nonatomic, strong) id<COHttpClientDataDelegate> delegate;

/**
 *  According to Cogini Mobile API Convention, this field value that determines API Version, is set on header fields
 */
@property (nonatomic, readonly) NSString *apiVersion;

/**
 *  According to Cogini Mobile API Convention, this field value that determines device type, is set on header fields
 */
@property (nonatomic, readonly) NSString *deviceType;

/**
 *  According to Cogini Mobile API Convention, this field value that determines access token, is set on header fields
 */
@property (nonatomic) NSString *accessToken;

//@property (nonatomic) NSTimeInterval timeout;

@property (nonatomic, strong, readonly) AFHTTPRequestSerializer *requestSerializer;
@property (nonatomic, strong, readonly) AFHTTPResponseSerializer *responseSerializer;


- (instancetype)initWithBaseURL:(NSURL *)baseUrl sessionConfiguration:(NSURLSessionConfiguration *)configuration apiVersion:(NSString *)version deviceType:(NSString *)deviceType;

/**
 *  Construction, with setting deviceType to default value "IOS"
 *
 *  @param baseUrl base API Url
 *  @param version API version
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithBaseURL:(NSURL *)baseUrl sessionConfiguration:(NSURLSessionConfiguration *)configuration apiVersion:(NSString *)version;

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
