//
//  ServerDispatcher.m
//  Baggable
//
//  Created by Nguyen Hai Dang on 6/22/15.
//  Copyright (c) 2015 Nguyen Hai Dang. All rights reserved.
//

#import "COHttpClient.h"
//#import "SSKeychain.h"
//#import "BAConfigs.h"
//#import "AppDelegate.h"




@implementation COHttpClientHelper

- (COHttpResponseObject *)responseObjectFromDictionnary:(id)responseObject {
  COHttpResponseObject *response = [[COHttpResponseObject alloc] initWithResponseDic:responseObject];

  switch (response.status) {
    case COHttpResponseObjectErrorTypeRequestValid:

      break;
    case COHttpResponseObjectErrorTypeUnAuthentication:

      break;
    case COHttpResponseObjectErrorTypeUpdateVersionRequired:
      break;
    case COHttpResponseObjectErrorTypeUnknown:
      break;
    case COHttpResponseObjectErrorTypeSuccess:

    default:
      break;
  }

  return response;
}

- (void)handleFail:(NSURLSessionDataTask *)operation error:(NSError *)error{
  HCLOG(@"%@, error %ld",error, (long)operation.response.statusCode);

  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;

  //    Your token is invalid or has expired. Please login again!
  if ([httpResponse statusCode] == 403
      || [httpResponse statusCode] == 404) {
  }
}

@end


@interface COHttpClient ()
@end

@implementation COHttpClient

- (id) initWithBaseURL:(NSURL *)baseUrl {
  self = [super init];
  if(self)
    {
    // Init your data here
    _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = nil;
//    self.httpHelper = [[COHttpClientHelper alloc] init];

    }
  return self;
}



- (void)setDefaultHeader:(AFHTTPRequestSerializer *)requestSerializer {

//  [requestSerializer setValue:[[NSUserDefaults standardUserDefaults] cc_UDID] forHTTPHeaderField:@"X-Device-Id"];
//  [requestSerializer setValue:KAPI_DEVICE_TYPE forHTTPHeaderField:@"X-Device-Type"];
//  [requestSerializer setValue:[KAPI_VERSION stringValue]  forHTTPHeaderField:@"x-app-version"];
//
//  if ([self activeUser]&& self.accessToken) {
//    [requestSerializer setValue:self.accessToken forHTTPHeaderField:@"X-Access-Token"];

}

- (NSURLSessionDataTask *) GET:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure {

  [self setDefaultHeader:_manager.requestSerializer];
  HCLOG(@"header %@, params%@", _manager.requestSerializer.HTTPRequestHeaders, parameters);

  return [_manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {

  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    COHttpResponseObject* response = [self.httpHelper responseObjectFromDictionnary:responseObject];
    success (task, response);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    [self.httpHelper handleFail:task error:error];
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
    COHttpResponseObject* response = [self.httpHelper responseObjectFromDictionnary:responseObject];
    success (task, response);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    [self.httpHelper handleFail:task error:error];
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
    COHttpResponseObject* response = [self.httpHelper responseObjectFromDictionnary:responseObject];
    success (task, response);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    [self.httpHelper handleFail:task error:error];
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
    COHttpResponseObject* response = [self.httpHelper responseObjectFromDictionnary:responseObject];
    success (task, response);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    [self.httpHelper handleFail:task error:error];
    failure(task, error);
  }];
}

@end
