//
//  COHttpClientWithDelegate.m
//  COHttpClient
//
//  Created by Tran Kien on 5/4/16.
//  Copyright © 2016 Cogini. All rights reserved.
//


@interface COCustomizedHttpResponseObject : COHttpResponseObject
@property (nonatomic, strong) NSDate *date;

@end

@implementation COCustomizedHttpResponseObject

@end

@interface COHttpClientWithDelegate : XCTestCase<COHttpClientDataDelegate>
@property (nonatomic, strong) COHttpClient *client;
@property (nonatomic) BOOL didPassThroughDidCatchError;

@end



@implementation COHttpClientWithDelegate

- (void)setUp {
  [super setUp];

  [[LSNocilla sharedInstance] start];
  self.client = [[COHttpClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://httpclient.com/"] sessionConfiguration:nil  apiVersion:@"1" deviceType:@"IOS"];
  self.client.delegate = self;
  self.didPassThroughDidCatchError = NO;
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];

  [[LSNocilla sharedInstance] clearStubs];
  [[LSNocilla sharedInstance] stop];
  self.didPassThroughDidCatchError = NO;

}

- (void)testWithCustomizedResponse_StatusOK {
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the correct results.
  stubRequest(@"GET", @"https://httpclient.com/test").andReturn(200).withBody([@{
                                                                                 @"status" : @"OK",
                                                                                 @"data" : @{}
                                                                                 } JSONString]);

  StartBlock();

  [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

    NSAssert([responseObject isKindOfClass:[COCustomizedHttpResponseObject class]], @"responseObject must be an instance of COCustomizedHttpResponseObject");
    NSAssert(responseObject != nil, @"COHttpResponseObject must be not nil");
    NSAssert(responseObject.status == COHttpResponseObjectStatusTypeSuccess, @"responseObject.status must be COHttpResponseObjectStatusTypeSuccess");

    EndBlock();
  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSAssert(false, @"Should not successful response");
    EndBlock();
  }];

  WaitUntilBlockCompletes();
}

- (void)testWithCustomizedResponse_StatusOK_CustomizedHeaderFields {
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the correct results.
  stubRequest(@"GET", @"https://httpclient.com/test").andReturn(200).withBody([@{
                                                                                 @"status" : @"OK",
                                                                                 @"data" : @{}
                                                                                 } JSONString]);

  StartBlock();

  [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

    NSAssert([[operation.currentRequest.allHTTPHeaderFields objectForKey:@"test key"] isEqualToString:@"test value"], @"Cannot get customized header field in request");

    EndBlock();
  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSAssert(false, @"Should not successful response");
    EndBlock();
  }];

  WaitUntilBlockCompletes();
}

- (void)testWithCustomizedResponse_NetworkError {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  stubRequest(@"GET", @"https://httpclient.com/test").andReturn(404);

  StartBlock();

  [self.client GET:@"test" parameters:nil success:^(NSURLSessionDataTask *operation, COHttpResponseObject *responseObject) {

    NSAssert(false, @"Should not successful response");


    EndBlock();
  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSAssert(self.didPassThroughDidCatchError, @"didPassThroughDidCatchError must be YES");
    NSAssert(error, @"error must be not nil");
    EndBlock();
  }];

  WaitUntilBlockCompletes();
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void)httpClient:(COHttpClient *)httpClient didCatchFailure:(NSURLSessionDataTask *)operation error:(NSError *)error {

  self.didPassThroughDidCatchError = YES;
}

- (NSDictionary *)httpClientWithDefaultHeaderFields:(COHttpClient *)httpClient {
  return @{@"test key": @"test value"};
}

- (COHttpResponseObject *)httpClient:(COHttpClient *)httpClient responseObjectFromTask:(NSURLSessionDataTask *)operation andDictionary:(id)responseObject {
  COCustomizedHttpResponseObject *httpResponseObject = [[COCustomizedHttpResponseObject alloc] initWithResponseDic:responseObject];
  httpResponseObject.date = [NSDate date];

  return httpResponseObject;

}
@end
