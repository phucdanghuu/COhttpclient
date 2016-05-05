//
//  COResponseObject.h
//  COHttpClient
//
//  Created by Tran Kien on 4/27/16.
//  Copyright © 2016 Cogini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COHttpClient.h"

typedef enum : NSUInteger {
  COHttpResponseObjectStatusTypeSuccess = 1,
  COHttpResponseObjectStatusTypeLoginFailed,
  COHttpResponseObjectStatusTypePermissionDenied,
  COHttpResponseObjectStatusTypeRequestInvalid,
  COHttpResponseObjectStatusTypeUpdateVersionRequired,
  COHttpResponseObjectStatusTypeUnAuthentication,
  COHttpResponseObjectStatusTypeError,
  COHttpResponseObjectStatusTypeDataNotFound,
  COHttpResponseObjectStatusTypeUnknown,
  COHttpResponseObjectStatusTypeValidationFailed
} COHttpResponseObjectStatusType;

@interface COValidationFailedField : NSObject
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *message;
@end


@interface COHttpResponseObject :NSObject

//@property (atomic, assign) BOOL isSuc;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSString *errorMessage;
@property (atomic, assign) COHttpResponseObjectStatusType status;
@property (nonatomic, strong) NSArray *validationFailedFields;
@property (nonatomic, strong, readonly) NSDictionary *rawData;

- (instancetype)initWithResponseDic:(id)response;
@end
