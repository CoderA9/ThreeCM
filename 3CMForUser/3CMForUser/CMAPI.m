//
//  CMAPI.m
//  3CMForUser
//
//  Created by ANine on 7/27/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CMAPI.h"
#import "CMUser.h"

@implementation CMAPI

+ (instancetype)sharedAPI {
    
    static CMAPI *_sharedAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAPI = [[self alloc] initWithBaseURL:[NSURL URLWithString:kCMBaseUrlString]];
    });
    
    return _sharedAPI;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self)
        return nil;
    
    [self registerHTTPOperationClass:[LXJSONRequestOperation class]];
    
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    [self setDefaultHeader:@"X-UDID" value:DB_APP_UUID()];
    
    self.registeredLXErrorParser = @"DBResponseErrorParser";
    
    self.enableViewControllerTracking = YES;
    
    self.viewControllerRegexPattern = @"(CM[a-zA-Z]+ViewController|DBPostsBackgroundUploader|IM[a-zA-Z]+ViewControl|OB[a-zA-Z]+ViewController|Nyx[a-zA-Z]+ViewController|MU[a-zA-Z]+ViewController|DBK[a-zA-Z]+ViewControl)";
    
    _compatiblePOSTParameters = YES;
    
    return self;
}


#pragma mark - | ***** private methods ***** |

/**
 负责发送API请求
 */
- (void)sendRequest:(CQTHTTPRequestMethodType)method
               path:(NSString *)path
         parameters:(NSDictionary *)parameters
            success:(CMAPIClientSuccessBlock)successBlock
            failure:(CMAPIClientFailureBlock)failureBlock {
    
    [self sendRequest:method path:path parameters:parameters filesForUpload:nil upload:nil success:successBlock failure:failureBlock];
}

- (void)sendRequest:(CQTHTTPRequestMethodType)method
               path:(NSString *)path
         parameters:(NSDictionary *)parameters
     filesForUpload:(NSArray *)files
             upload:(CMAPIClientUploaderBlock)uploadBlock
            success:(CMAPIClientSuccessBlock)successBlock
            failure:(CMAPIClientFailureBlock)failureBlock {
    
    
    // 请求成功的block
    void (^requestSuccessBlock)(LXHTTPRequestOperation *operation, id JSON);
    requestSuccessBlock = ^(LXHTTPRequestOperation *operation, id JSON) {
        
        
        NSString *requestUrlString = operation.request.URL.absoluteString;
        CQTDebugLog(@"*****请求成功,%@",safelyStr(requestUrlString));
        
        
        NSError *error = nil;
        // 处理返回的JSON数据，判断是否有错误代码的返回
        [self parseResponseDataForError:&error withData:JSON];
        
        if (!error) {
            
            [self parseObjectWithError:&error Data:JSON requestUrlString:requestUrlString];
        }
        
        if (error) {
            
            CQTDebugLog(@"error JSON!!! = %@", JSON);
            CQTDebugLog(@"error!!! = %@", error);
            
            NSDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:JSON];
            if (!infoDic) {
                
                infoDic = @{};
            }
            
            NSDictionary *dic = @{
                                  @"infoDic":[NSMutableDictionary dictionaryWithDictionary:JSON],
                                  @"error":error
                                  };
            
            if (failureBlock) {
                
                failureBlock(dic);
                
                [self performSelector:@selector(parseNetworkError:) withObject:error afterDelay:0.5];
            }
            
        } else if (successBlock) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:JSON];
            
            [self finishProcess];
            
            successBlock(dic);
        }
    };
    // 请求失败的block
    void (^requestFailureBlock)(LXHTTPRequestOperation *operation, NSError *error);
    requestFailureBlock = ^(LXHTTPRequestOperation *operation, NSError *error) {
        
        CQTDebugLog(@"*****请求失败  %@",error);
        
        [self performSelector:@selector(parseNetworkError:) withObject:error afterDelay:0.5];
        
        if (failureBlock) {
            NSDictionary *dic = @{
                                  @"error":error
                                  };
            failureBlock(dic);
        }
    };
    
    NSMutableDictionary *dic = [self parameterDictionary];
    
    [dic addEntriesFromDictionary:parameters];
    
    if (!validStr(dic[kPhoneNumKey])) {
        
        [dic setObject:safelyStr([CMUser sharedUser].defaultAccount.phoneNum)  forKey:kPhoneNumKey];
    }
    
    switch (method) {
            
        case CQTHTTPRequestGETMethod:
            [self getPath:path parameters:dic success:requestSuccessBlock failure:requestFailureBlock];
            break;
            
        case CQTHTTPRequestPOSTMethod:
            if (!files) {
                
                [self postPath:path parameters:dic success:requestSuccessBlock failure:requestFailureBlock];
            } else {
                
                [self uploadPath:path parameters:dic files:files uploadProgressBlock:uploadBlock success:requestSuccessBlock failure:requestFailureBlock];
            }
            break;
            
        case CQTHTTPRequestPutMethod:
            break;
            
        case CQTHTTPRequestDELETEMethod:
            break;
            
        default:
            break;
    }
    
}

- (NSMutableDictionary *)parameterDictionary {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [self appendRequestParameters:dic];
    
    return dic;
}

/**
 附加基本的请求参数，每个请求都会带
 */
- (void)appendRequestParameters:(NSMutableDictionary *)parameters {

    //用户的UserId.
    [parameters setObject:[CMUser sharedUser].userId forKey:@"uid"];
    
    //是否是调试模式,如果是调试模式则忽略TokenKey
    [parameters setObject:NSStringFromInt(APP_IS_DEBUG) forKey:@"debug"];
    
    //token安全信息
    [parameters setObject:@"" forKey:@"TokenKey"];
    
    //App名称
    [parameters setObject:@"ida" forKey:kAppNameKey];
    
    //版本号
    [parameters setObject:APP_SHORT_VERSION forKey:kVersionKey];
    
    //平台
    [parameters setObject:kiPhone forKey:kPlatformKey];
    
    //设备号
    [parameters setObject:[CMDataManager getUUIDString] forKey:kDeviceIdKey];
    
    //平台ID 爱达1 订餐2
    [parameters setObject:@"1" forKey:@"serverID"];
    
    /* 这个session供大数据用 */
    [parameters setObject:[CQTResourceBrige sharedBrige].pseudoSessionId forKey:kSESSIONKey];
    
    //使用者的手机版本
    [parameters setObject:NSStringFormat(@"%@|%@",[CMDataManager sharedManager].platformStr,[[UIDevice currentDevice] systemVersion]) forKey:kSystemVersionKey];
    
}

- (void)parseObjectWithError:(NSError **)outError Data:(id)data requestUrlString:(NSString *)urlString {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data];
    
    int resultcode = [dic[@"resultcode"] intValue];
    NSString *info = dic[@"info"];
    
    NSString *LocalMsg = _ERROR_MESSAGE(resultcode);
    if ([LocalMsg isEqualToString:__TEXT(error_info_not_found)]) {
        LocalMsg = info;
    }
    
    if (resultcode > 100) {
        
        *outError = [NSError errorWithDomain:info
                                        code:resultcode
                                    userInfo:@{
                                               
                                               @"errorcode":NSStringFromInt(resultcode),
                                               @"info":safelyStr(LocalMsg),
                                               @"NSErrorFailingURLKey":safelyStr(urlString),
                                               }];
    }
}

- (void)parseNetworkError:(NSError *)error {
    
    NSInteger code = error.code;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *string = _ERROR_MESSAGE((int)code);
        
        if ([string isEqualToString:__TEXT(error_info_not_found)]) {
            
            string = error.domain;
        }
        
        NSDictionary *userInfo = error.userInfo;
        if (validDic(userInfo)) {
            
            NSString *url = userInfo[@"NSErrorFailingURLKey"];
            
            CQTDebugLog("\n\n\n******************************* ErrorUrl  *************************\n\n");
            CQTDebugLog(@"%@ \n\n",safelyStr(url));
        }
        
        CQTDebugLog(@"error messsage: =======  %@ =======\n\n\n",string);
        
        if (!validStr(string) || [string isEqualToString:@"NSURLErrorDomain"]) {
            
            return ;
        }
        [self startProcessWithTitle:string];
        [self finishProcessWithTitle:string timeLength:3.f];
    });
}

@end
