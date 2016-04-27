//
//  COResponseObject.m
//  COHttpClient
//
//  Created by Tran Kien on 4/27/16.
//  Copyright © 2016 Cogini. All rights reserved.
//

#import "COHttpResponseObject.h"

#define kErrorMapping  @{@"OK": @(COHttpResponseObjectErrorTypeSuccess), \
@"REQUEST_INVALID": @(COHttpResponseObjectErrorTypeRequestValid), \
@"VERSION_UPDATE_REQUIRED": @(COHttpResponseObjectErrorTypeUpdateVersionRequired), \
@"UNAUTHENTICATION": @(COHttpResponseObjectErrorTypeUnAuthentication), \
@"LOGIN_FAILED" : @(COHttpResponseObjectErrorTypeUnLoginFailed), \
@"VALIDATION_FAILED" : @(COHttpResponseObjectErrorTypeValidationFailed), \
@"ERROR" : @(COHttpResponseObjectErrorTypeError), \
@"DATA_NOT_FOUND" : @(COHttpResponseObjectErrorTypeDataNotFound) \
}

@implementation CCValidationFailedField


@end


@interface COHttpResponseObject ()

@end

@implementation COHttpResponseObject
- (instancetype)initWithResponseDic:(id)response {

  if (self = [super init]) {

    HCLOG(@"response %@", response);

    NSString *status = [response objectForKey:@"status"];

    if (status) {
      self.status = [kErrorMapping objectForKey:status] ?[[kErrorMapping objectForKey:status] integerValue]
      : COHttpResponseObjectErrorTypeUnknown;
    }
    else {
      self.status = COHttpResponseObjectErrorTypeUnknown;
    }

    if (self.status == COHttpResponseObjectErrorTypeSuccess) {
      self.data = [response objectForKey:@"data"];
    } else {

      id message = [response objectForKey:@"message"];
      self.errorMessage = [message isKindOfClass:[NSArray class]] ? [message componentsJoinedByString:@"\n"] : message;



    }

    if (self.status == COHttpResponseObjectErrorTypeValidationFailed) {
      id fields = [response objectForKey:@"fields"];


      if ([fields isKindOfClass:[NSArray class]]) {
        NSMutableArray *validationFailedFields = [NSMutableArray array];

        for (id dic  in fields) {
          CCValidationFailedField *field = [[CCValidationFailedField alloc] init];
          field.key = dic[@"key"];
          field.message = dic[@"message"];

          [validationFailedFields addObject:field];
        }

        self.validationFailedFields = [validationFailedFields copy];

      } else {
        HCLOG(@"wrong response validation_failed %@", response);
        self.validationFailedFields = @[];
      }
    }
  }
  
  return self;
}

@end
