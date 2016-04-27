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
  COHttpResponseObjectErrorTypeSuccess = 1,
  COHttpResponseObjectErrorTypeRequestValid,
  COHttpResponseObjectErrorTypeUpdateVersionRequired,
  COHttpResponseObjectErrorTypeUnAuthentication,
  COHttpResponseObjectErrorTypeError,
  COHttpResponseObjectErrorTypeDataNotFound,
  COHttpResponseObjectErrorTypeUnknown,
  COHttpResponseObjectErrorTypeUnLoginFailed,
  COHttpResponseObjectErrorTypeValidationFailed
} COHttpResponseObjectErrorType;

@interface CCValidationFailedField : NSObject
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *message;
@end


@interface COHttpResponseObject :NSObject

//@property (atomic, assign) BOOL isSuc;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSString *errorMessage;
@property (atomic, assign) COHttpResponseObjectErrorType status;
@property (nonatomic, strong) NSArray *validationFailedFields;


- (instancetype)initWithResponseDic:(id)response;
@end
