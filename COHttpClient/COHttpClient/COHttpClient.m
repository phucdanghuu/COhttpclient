//
//  ServerDispatcher.m
//  Baggable
//
//  Created by Nguyen Hai Dang on 6/22/15.
//  Copyright (c) 2015 Nguyen Hai Dang. All rights reserved.
//

#import "COHttpClient.h"

#define kCOHttpClientDeviceTypeKey @"X-Device-Type"
#define kCOHttpClientAPIVersionKey @"X-App-Version"
#define kCOHttpClientAccessTokenKey @"X-Access-Token"
@interface COHttpClient () {
  AFHTTPSessionManager * _manager;
}

@end

@implementation COHttpClient

- (id)initWithBaseURL:(NSURL *)baseUrl apiVersion:(NSString *)version {
  self = [self initWithBaseURL:baseUrl];

  if (self) {
    _apiVersion = version;
  }

  return self;
}

- (id)initWithBaseURL:(NSURL *)baseUrl apiVersion:(NSString *)version deviceType:(NSString *)deviceType {
  self = [self initWithBaseURL:baseUrl apiVersion:version];

  if (self) {
    _deviceType = deviceType;
  }

  return self;
}

- (id)initWithBaseURL:(NSURL *)baseUrl {
  self = [super init];
  if(self)
    {
    _deviceType = @"IOS";
    _apiVersion = @"";

    // Init your data here
    _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = nil;

    }
  return self;
}



- (void)setDefaultHeader:(AFHTTPRequestSerializer *)requestSerializer {

  if (self.deviceType) {
    [requestSerializer setValue:self.deviceType forHTTPHeaderField:kCOHttpClientDeviceTypeKey];
  }

  if (self.apiVersion) {
    [requestSerializer setValue:self.apiVersion  forHTTPHeaderField:kCOHttpClientAPIVersionKey];
  }

  if (self.accessToken) {
    [requestSerializer setValue:self.accessToken forHTTPHeaderField:kCOHttpClientAccessTokenKey];
  }

  if (self.dataSource && [self.dataSource respondsToSelector:@selector(httpClientWithDefaultHeaderFields:)]) {

    NSDictionary *dic = [self.dataSource httpClientWithDefaultHeaderFields:self];

    for (NSString *key in [dic allKeys]) {
      [requestSerializer setValue:dic[key] forHTTPHeaderField:key];
    }
  }
}

- (COHttpResponseObject *)responseObjectFromTask:(NSURLSessionDataTask *)operation andDictionnary:(id)responseObject {

  if (self.dataSource && [self.dataSource respondsToSelector:@selector(httpClient:responseObjectFromTask:andDictionnary:)]) {

    COHttpResponseObject *httpResponseObject = [self.dataSource httpClient:self responseObjectFromTask:operation andDictionnary:responseObject];

    NSAssert(httpResponseObject != nil, @"httpClient:responseObjectFromTask:andDictionnary: MUST BE RETURN NOT NIL");

    return httpResponseObject;
  } else {

    COHttpResponseObject *httpResponseObject = [[COHttpResponseObject alloc] initWithResponseDic:responseObject];
    return httpResponseObject;
  }
}


- (void)didCatchFailure:(NSURLSessionDataTask *)operation error:(NSError *)error {
  if (self.dataSource && [self.dataSource respondsToSelector:@selector(httpClient:didCatchFailure:error:)]) {
    [self.dataSource httpClient:self didCatchFailure:operation error:error];
  }
}


- (NSURLSessionDataTask *) GET:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure {

  [self setDefaultHeader:_manager.requestSerializer];
  HCLOG(@"header %@, params%@", _manager.requestSerializer.HTTPRequestHeaders, parameters);

  return [_manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {

  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    COHttpResponseObject* response = [self responseObjectFromTask:task andDictionnary:responseObject];
    success (task, response);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    [self didCatchFailure:task error:error];
    failure(task, error);
  }];
}

- (NSURLSessionDataTask *) POST:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure {
  [self setDefaultHeader:_manager.requestSerializer];

  HCLOG(@"header %@, params%@", _manager.requestSerializer.HTTPRequestHeaders, parameters);

  return [_manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {

  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    COHttpResponseObject* response = [self responseObjectFromTask:task andDictionnary:responseObject];
    success (task, response);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    [self didCatchFailure:task error:error];
    failure(task, error);
  }];

}

- (NSURLSessionDataTask *) PUT:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure {
  [self setDefaultHeader:_manager.requestSerializer];

  HCLOG(@"header %@, params%@", _manager.requestSerializer.HTTPRequestHeaders, parameters);

  return [_manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    COHttpResponseObject* response = [self responseObjectFromTask:task andDictionnary:responseObject];
    success (task, response);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    [self didCatchFailure:task error:error];
    failure(task, error);
  }];

}

- (NSURLSessionDataTask *) DELETE:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void (^)(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure {
  [self setDefaultHeader:_manager.requestSerializer];

  HCLOG(@"header %@, params%@", _manager.requestSerializer.HTTPRequestHeaders, parameters);

  return [_manager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    COHttpResponseObject* response = [self responseObjectFromTask:task andDictionnary:responseObject];
    success (task, response);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    [self didCatchFailure:task error:error];
    failure(task, error);
  }];
}

@end
