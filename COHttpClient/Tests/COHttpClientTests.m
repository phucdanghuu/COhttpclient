//
//  Tests.m
//  Tests
//
//  Created by Tran Kien on 5/4/16.
//  Copyright © 2016 Cogini. All rights reserved.
//





@interface COHttpClientTests : XCTestCase
@property (nonatomic, strong) COHttpClient *client;

@end

@implementation COHttpClientTests

- (void)setUp {
    [super setUp];

   [[LSNocilla sharedInstance] start];
  self.client = [[COHttpClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://httpclient.com/"] sessionConfiguration:nil apiVersion:@"1" deviceType:@"IOS"];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];

  [[LSNocilla sharedInstance] clearStubs];
  [[LSNocilla sharedInstance] stop];
}

- (void)testWithStatusOK_DataEmpty {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

  stubRequest(@"GET", @"https://httpclient.com/test").andReturn(200).withBody([@{
                                                                                 @"status" : @"OK",
                                                                                 @"data" : @{}
                                                                                 } JSONString]);

  StartBlock();

  [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

    NSAssert(responseObject != nil, @"COHttpResponseObject must be not nil");
    NSAssert(responseObject.status == COHttpResponseObjectStatusTypeSuccess, @"responseObject.status must be COHttpResponseObjectStatusTypeSuccess");

    EndBlock();
  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSAssert(false, @"Should not successful response");
    EndBlock();
  }];

  WaitUntilBlockCompletes();
}

- (void)testWithStatusOK_DataEmptyCheckHeaderFields {
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the correct results.
  stubRequest(@"GET", @"https://httpclient.com/test").andReturn(200).withBody([@{
                                                                                 @"status" : @"OK",
                                                                                 @"data" : @{}
                                                                                 } JSONString]);

  self.client.accessToken = @"test access token";
  StartBlock();

  [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

    NSAssert([[operation.currentRequest.allHTTPHeaderFields objectForKey:kCOHttpClientAPIVersionKey] isEqualToString:@"1"], @"kCOHttpClientAPIVersionKey is wrong value");
    NSAssert([[operation.currentRequest.allHTTPHeaderFields objectForKey:kCOHttpClientDeviceTypeKey] isEqualToString:@"IOS"], @"kCOHttpClientDeviceTypeKey is wrong value");
    NSAssert([[operation.currentRequest.allHTTPHeaderFields objectForKey:kCOHttpClientAccessTokenKey] isEqualToString: @"test access token"], @"kCOHttpClientAccessTokenKey is wrong value");

    EndBlock();
  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSAssert(false, @"Should not successful response");
    EndBlock();
  }];

  WaitUntilBlockCompletes();
}

- (void)testWithStatusOK_DataEmptyCheckHeaderFields_ThenSetAccessTokenNil {
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the correct results.
  stubRequest(@"GET", @"https://httpclient.com/test").andReturn(200).withBody([@{
                                                                                 @"status" : @"OK",
                                                                                 @"data" : @{}
                                                                                 } JSONString]);

  self.client.accessToken = @"test access token";
  StartBlock();

  [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

    NSAssert([[operation.currentRequest.allHTTPHeaderFields objectForKey:kCOHttpClientAPIVersionKey] isEqualToString:@"1"], @"kCOHttpClientAPIVersionKey is wrong value");
    NSAssert([[operation.currentRequest.allHTTPHeaderFields objectForKey:kCOHttpClientDeviceTypeKey] isEqualToString:@"IOS"], @"kCOHttpClientDeviceTypeKey is wrong value");
    NSAssert([[operation.currentRequest.allHTTPHeaderFields objectForKey:kCOHttpClientAccessTokenKey] isEqualToString: @"test access token"], @"kCOHttpClientAccessTokenKey is wrong value");

    self.client.accessToken = nil;

    [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

      NSAssert([[operation.currentRequest.allHTTPHeaderFields objectForKey:kCOHttpClientAPIVersionKey] isEqualToString:@"1"], @"kCOHttpClientAPIVersionKey is wrong value");
      NSAssert([[operation.currentRequest.allHTTPHeaderFields objectForKey:kCOHttpClientDeviceTypeKey] isEqualToString:@"IOS"], @"kCOHttpClientDeviceTypeKey is wrong value");
      NSAssert([[operation.currentRequest.allHTTPHeaderFields objectForKey:kCOHttpClientAccessTokenKey] isEqualToString: @""], @"kCOHttpClientAccessTokenKey must be empty");

      EndBlock();

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
      NSAssert(false, @"Should not successful response");
      EndBlock();
    }];

  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSAssert(false, @"Should not successful response");
    EndBlock();
  }];

  WaitUntilBlockCompletes();
}


- (void)testWithStatusERROR_MessageError {
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the correct results.

#define ERROR_MESSAGE @"Server has a problem"

  stubRequest(@"GET", @"https://httpclient.com/test").andReturn(200).withBody([@{
                                                                                 @"status" : @"ERROR",
                                                                                 @"message" : ERROR_MESSAGE
                                                                                 } JSONString]);

  // Set the flag to YES
  StartBlock();


  [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

    NSAssert(responseObject != nil, @"COHttpResponseObject must be not nil");
    NSAssert(responseObject.status == COHttpResponseObjectStatusTypeError, @"responseObject.status must be COHttpResponseObjectStatusTypeError");
    NSAssert([responseObject.errorMessage isEqualToString:ERROR_MESSAGE], @"Error message is not equal to sample data");

    EndBlock();

  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSAssert(false, @"Should not successful response");

    EndBlock();
  }];

//  [[UnitTestCoreDataQueue sharedQueue] addOperation:operation];


  WaitUntilBlockCompletes();
}

- (void)testWithStatusLOGIN_FAILED_MessageError {
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the correct results.

#define ERROR_MESSAGE @"Server has a problem"

  stubRequest(@"GET", @"https://httpclient.com/test").andReturn(200).withBody([@{
                                                                                 @"status" : @"LOGIN_FAILED",
                                                                                 @"message" : ERROR_MESSAGE
                                                                                 } JSONString]);

  // Set the flag to YES
  StartBlock();


  [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

    NSAssert(responseObject != nil, @"COHttpResponseObject must be not nil");
    NSAssert(responseObject.status == COHttpResponseObjectStatusTypeLoginFailed, @"responseObject.status must be COHttpResponseObjectStatusTypeError");
    NSAssert([responseObject.errorMessage isEqualToString:ERROR_MESSAGE], @"Error message is not equal to sample data");

    EndBlock();

  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSAssert(false, @"Should not successful response");

    EndBlock();
  }];

  //  [[UnitTestCoreDataQueue sharedQueue] addOperation:operation];

  
  WaitUntilBlockCompletes();
}

- (void)testWithStatusPERMISSION_DENIED_MessageError {
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the correct results.

#define ERROR_MESSAGE @"Server has a problem"

  stubRequest(@"GET", @"https://httpclient.com/test").andReturn(200).withBody([@{
                                                                                 @"status" : @"PERMISSION_DENIED",
                                                                                 @"message" : ERROR_MESSAGE
                                                                                 } JSONString]);

  // Set the flag to YES
  StartBlock();


  [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

    NSAssert(responseObject != nil, @"COHttpResponseObject must be not nil");
    NSAssert(responseObject.status == COHttpResponseObjectStatusTypePermissionDenied, @"responseObject.status must be COHttpResponseObjectStatusTypePermissionDenied");
    NSAssert([responseObject.errorMessage isEqualToString:ERROR_MESSAGE], @"Error message is not equal to sample data");

    EndBlock();

  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSAssert(false, @"Should not successful response");

    EndBlock();
  }];

  //  [[UnitTestCoreDataQueue sharedQueue] addOperation:operation];


  WaitUntilBlockCompletes();
}

- (void)testWithStatusVERSION_UPDATE_REQUIRED_MessageError {
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the correct results.

#define ERROR_MESSAGE @"Server has a problem"

  stubRequest(@"GET", @"https://httpclient.com/test").andReturn(200).withBody([@{
                                                                                 @"status" : @"VERSION_UPDATE_REQUIRED",
                                                                                 @"message" : ERROR_MESSAGE
                                                                                 } JSONString]);

  // Set the flag to YES
  StartBlock();


  [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

    NSAssert(responseObject != nil, @"COHttpResponseObject must be not nil");
    NSAssert(responseObject.status == COHttpResponseObjectStatusTypeUpdateVersionRequired, @"responseObject.status must be COHttpResponseObjectStatusTypeUpdateVersionRequired");
    NSAssert([responseObject.errorMessage isEqualToString:ERROR_MESSAGE], @"Error message is not equal to sample data");

    EndBlock();

  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSAssert(false, @"Should not successful response");

    EndBlock();
  }];

  //  [[UnitTestCoreDataQueue sharedQueue] addOperation:operation];


  WaitUntilBlockCompletes();
}

- (void)testWithStatusVALIDATION_FAILED_MessageError {
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the correct results.

#define ERROR_MESSAGE @"Server has a problem"

  stubRequest(@"GET", @"https://httpclient.com/test").andReturn(200).withBody([@{
                                                                                 @"status" : @"VALIDATION_FAILED",
                                                                                 @"message" : ERROR_MESSAGE
                                                                                 } JSONString]);

  // Set the flag to YES
  StartBlock();

  [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

    NSAssert(responseObject != nil, @"COHttpResponseObject must be not nil");
    NSAssert(responseObject.status == COHttpResponseObjectStatusTypeValidationFailed, @"responseObject.status must be COHttpResponseObjectStatusTypeValidationFailed");
    NSAssert([responseObject.errorMessage isEqualToString:ERROR_MESSAGE], @"Error message is not equal to sample data");

    EndBlock();

  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSAssert(false, @"Should not successful response");

    EndBlock();
  }];

  //  [[UnitTestCoreDataQueue sharedQueue] addOperation:operation];


  WaitUntilBlockCompletes();
}

- (void)testWithStatusVALIDATION_FAILED_MessageError_Fields {
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the correct results.

#define ERROR_MESSAGE @"Server has a problem"

  stubRequest(@"GET", @"https://httpclient.com/test").andReturn(200).withBody([@{
                                                                                 @"status" : @"VALIDATION_FAILED",
                                                                                 @"message" : ERROR_MESSAGE,
                                                                                 @"fields" : @[
                                                                                     @{
                                                                                       @"key": @"username",
                                                                                       @"message": @"username is required"
                                                                                       }
                                                                                   ]
                                                                                 } JSONString]);

  // Set the flag to YES
  StartBlock();

  [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

    NSAssert(responseObject != nil, @"COHttpResponseObject must be not nil");
    NSAssert(responseObject.status == COHttpResponseObjectStatusTypeValidationFailed, @"responseObject.status must be COHttpResponseObjectStatusTypeValidationFailed");
    NSAssert([responseObject.errorMessage isEqualToString:ERROR_MESSAGE], @"Error message is not equal to sample data");
    NSAssert(responseObject.validationFailedFields && [responseObject.validationFailedFields count] == 1, @"validationFailedFields must be not empty");

    COValidationFailedField *field = responseObject.validationFailedFields.firstObject;

    NSAssert([field.key isEqualToString:@"username"], @"field.key must be username");
    NSAssert([field.message isEqualToString:@"username is required"], @"field.message must be username is required");

    EndBlock();

  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSAssert(false, @"Should not successful response");

    EndBlock();
  }];

  //  [[UnitTestCoreDataQueue sharedQueue] addOperation:operation];


  WaitUntilBlockCompletes();
}

- (void)testWithStatusREQUEST_INVALID_MessageError {
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the correct results.

#define ERROR_MESSAGE @"Server has a problem"

  stubRequest(@"GET", @"https://httpclient.com/test").andReturn(200).withBody([@{
                                                                                 @"status" : @"REQUEST_INVALID",
                                                                                 @"message" : ERROR_MESSAGE
                                                                                 } JSONString]);

  // Set the flag to YES
  StartBlock();

  [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

    NSAssert(responseObject != nil, @"COHttpResponseObject must be not nil");
    NSAssert(responseObject.status == COHttpResponseObjectStatusTypeRequestInvalid, @"responseObject.status must be COHttpResponseObjectStatusTypeRequestInvalid");
    NSAssert([responseObject.errorMessage isEqualToString:ERROR_MESSAGE], @"Error message is not equal to sample data");

    EndBlock();

  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSAssert(false, @"Should not successful response");

    EndBlock();
  }];

  //  [[UnitTestCoreDataQueue sharedQueue] addOperation:operation];


  WaitUntilBlockCompletes();
}

- (void)testWithStatusDATA_NOT_FOUND_MessageError {
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the correct results.

#define ERROR_MESSAGE @"Server has a problem"

  stubRequest(@"GET", @"https://httpclient.com/test").andReturn(200).withBody([@{
                                                                                 @"status" : @"DATA_NOT_FOUND",
                                                                                 @"message" : ERROR_MESSAGE
                                                                                 } JSONString]);

  // Set the flag to YES
  StartBlock();

  [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

    NSAssert(responseObject != nil, @"COHttpResponseObject must be not nil");
    NSAssert(responseObject.status == COHttpResponseObjectStatusTypeDataNotFound, @"responseObject.status must be COHttpResponseObjectStatusTypeDataNotFound");
    NSAssert([responseObject.errorMessage isEqualToString:ERROR_MESSAGE], @"Error message is not equal to sample data");

    EndBlock();

  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSAssert(false, @"Should not successful response");

    EndBlock();
  }];

  //  [[UnitTestCoreDataQueue sharedQueue] addOperation:operation];


  WaitUntilBlockCompletes();
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
