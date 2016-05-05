//
//  COResponseObject.m
//  COHttpClient
//
//  Created by Tran Kien on 4/27/16.
//  Copyright © 2016 Cogini. All rights reserved.
//

#import "COHttpResponseObject.h"

#define kErrorMapping  @{@"OK": @(COHttpResponseObjectStatusTypeSuccess), \
@"VALIDATION_FAILED" : @(COHttpResponseObjectStatusTypeValidationFailed), \
@"PERMISSION_DENIED" : @(COHttpResponseObjectStatusTypePermissionDenied), \
@"REQUEST_INVALID": @(COHttpResponseObjectStatusTypeRequestInvalid), \
@"VERSION_UPDATE_REQUIRED": @(COHttpResponseObjectStatusTypeUpdateVersionRequired), \
@"UNAUTHENTICATION": @(COHttpResponseObjectStatusTypeUnAuthentication), \
@"LOGIN_FAILED" : @(COHttpResponseObjectStatusTypeLoginFailed), \
@"ERROR" : @(COHttpResponseObjectStatusTypeError), \
@"DATA_NOT_FOUND" : @(COHttpResponseObjectStatusTypeDataNotFound) \
}

@implementation COValidationFailedField

@end


@interface COHttpResponseObject ()

@end

@implementation COHttpResponseObject
- (instancetype)initWithResponseDic:(id)response {

  if (self = [super init]) {


    _rawData = response;
    NSString *status = [response objectForKey:@"status"];

    if (status) {
      self.status = [kErrorMapping objectForKey:status] ?[[kErrorMapping objectForKey:status] integerValue]
      : COHttpResponseObjectStatusTypeUnknown;
    }
    else {
      self.status = COHttpResponseObjectStatusTypeUnknown;
    }

    if (self.status == COHttpResponseObjectStatusTypeSuccess) {
      self.data = [response objectForKey:@"data"];
    } else {
      id message = [response objectForKey:@"message"];
      self.errorMessage = [message isKindOfClass:[NSArray class]] ? [message componentsJoinedByString:@"\n"] : message;
    }

    if (self.status == COHttpResponseObjectStatusTypeValidationFailed) {
      id fields = [response objectForKey:@"fields"];

      if ([fields isKindOfClass:[NSArray class]]) {
        NSMutableArray *validationFailedFields = [NSMutableArray array];

        for (id dic  in fields) {
          COValidationFailedField *field = [[COValidationFailedField alloc] init];
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
