//
//  ServerDispatcher.m
//  Baggable
//
//  Created by Nguyen Hai Dang on 6/22/15.
//  Copyright (c) 2015 Nguyen Hai Dang. All rights reserved.
//

#import "COHttpClient.h"


@interface COHttpClient () {
//  AFHTTPSessionManager * _manager;
}

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation COHttpClient

- (id)initWithBaseURL:(NSURL *)baseUrl sessionConfiguration:(NSURLSessionConfiguration *)configuration apiVersion:(NSString *)version {
  self = [self initWithBaseURL:baseUrl sessionConfiguration:configuration];

  if (self) {
    _apiVersion = version;
  }

  return self;
}

- (id)initWithBaseURL:(NSURL *)baseUrl sessionConfiguration:(NSURLSessionConfiguration *)configuration apiVersion:(NSString *)version deviceType:(NSString *)deviceType {
  self = [self initWithBaseURL:baseUrl sessionConfiguration:configuration apiVersion:version];

  if (self) {
    _deviceType = deviceType;
  }

  return self;
}

- (id)initWithBaseURL:(NSURL *)baseUrl sessionConfiguration:(NSURLSessionConfiguration *)configuration {
  self = [super init];
  if(self)
    {
    _deviceType = @"IOS";
    _apiVersion = @"";

    // Init your data here
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl sessionConfiguration:configuration];
    self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.sessionManager.responseSerializer.acceptableContentTypes = nil;

    }
  return self;
}

- (instancetype)init {
  self = [super init];

  if (self) {
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.sessionManager.responseSerializer.acceptableContentTypes = nil;

  }

  return self;
}

- (void)setRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer {
  self.sessionManager.requestSerializer = requestSerializer;
}

- (AFHTTPRequestSerializer *)requestSerializer {
  return self.sessionManager.requestSerializer;
}

- (void)setResponseSerializer:(AFHTTPResponseSerializer *)responseSerializer {
  self.sessionManager.responseSerializer = responseSerializer;
}

- (AFHTTPResponseSerializer *)responseSerializer {
  return self.sessionManager.responseSerializer;
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
  [self.requestSerializer setValue:value forHTTPHeaderField:field];
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
  } else {
    [requestSerializer setValue:@"" forHTTPHeaderField:kCOHttpClientAccessTokenKey];

  }

  if (self.delegate && [self.delegate respondsToSelector:@selector(httpClientWithDefaultHeaderFields:)]) {

    NSDictionary *dic = [self.delegate httpClientWithDefaultHeaderFields:self];

    for (NSString *key in [dic allKeys]) {
      [requestSerializer setValue:dic[key] forHTTPHeaderField:key];
    }
  }
}

- (COHttpResponseObject *)responseObjectFromTask:(NSURLSessionDataTask *)operation andDictionnary:(id)responseObject {

  if (self.delegate && [self.delegate respondsToSelector:@selector(httpClient:responseObjectFromTask:andDictionary:)]) {
    COHttpResponseObject *httpResponseObject = [self.delegate httpClient:self responseObjectFromTask:operation andDictionary:responseObject];
    NSAssert(httpResponseObject != nil, @"httpClient:responseObjectFromTask:andDictionnary: MUST BE RETURN NOT NIL");
    return httpResponseObject;
  } else {
    COHttpResponseObject *httpResponseObject = [[COHttpResponseObject alloc] initWithResponseDic:responseObject];
    return httpResponseObject;
  }
}

- (void)didCatchFailure:(NSURLSessionDataTask *)operation error:(NSError *)error {
  if (self.delegate && [self.delegate respondsToSelector:@selector(httpClient:didCatchFailure:error:)]) {
    [self.delegate httpClient:self didCatchFailure:operation error:error];
  }
}

- (NSURLSessionDataTask *) GET:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure {

  [self setDefaultHeader:self.sessionManager.requestSerializer];
  HCLOG(@"URL: %@, header %@, params%@", URLString, self.sessionManager.requestSerializer.HTTPRequestHeaders, parameters);

    return [self.sessionManager GET:URLString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HCLOG(@"response %@", responseObject);

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
  [self setDefaultHeader:self.sessionManager.requestSerializer];

  HCLOG(@"URL: %@, header %@, params%@", URLString ,self.sessionManager.requestSerializer.HTTPRequestHeaders, parameters);

    return [self.sessionManager POST:URLString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HCLOG(@"response %@", responseObject);
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
  [self setDefaultHeader:self.sessionManager.requestSerializer];

  HCLOG(@"URL: %@, header %@, params%@", URLString,self.sessionManager.requestSerializer.HTTPRequestHeaders, parameters);

    return [self.sessionManager PUT:URLString parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HCLOG(@"response %@", responseObject);
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
  [self setDefaultHeader:self.sessionManager.requestSerializer];

  HCLOG(@"URL: %@, header %@, params%@", URLString ,self.sessionManager.requestSerializer.HTTPRequestHeaders, parameters);

    return [self.sessionManager DELETE:URLString parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HCLOG(@"response %@", responseObject);
        COHttpResponseObject* response = [self responseObjectFromTask:task andDictionnary:responseObject];
        success (task, response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self didCatchFailure:task error:error];
        failure(task, error);
    }];
}

@end
