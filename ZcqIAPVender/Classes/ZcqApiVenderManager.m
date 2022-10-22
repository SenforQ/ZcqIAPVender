//
//  ZcqApiVenderManager.m
//  ZcqIAPVender
//
//  Created by 郑创权 on 2022/10/18.
//

#import "ZcqApiVenderManager.h"
#import "IAPShare.h"
#import "ZcqIAPVenderConfig.h"
#import "MvToast.h"
#import <AFNetworking/AFNetworking.h>
//会员标识
#define zcq_VipRepresentation @"MemberRepresentation"
//内购凭证
#define InternalPurchaseVoucherID @"InternalPurchaseVoucherID"

@interface ZcqApiVenderManager()


@end

@implementation ZcqApiVenderManager

static ZcqApiVenderManager* _defaultManager = nil;
static BOOL _isInitComplete = NO;
+(instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[ZcqApiVenderManager alloc] init];
    });
    return _defaultManager;
}

-(instancetype)init{
    if (self = [super init]) {

    }
    return self;
}

-(BOOL)isGetProducts{
    if ([IAPShare sharedHelper].iap.products.count != 0) {
        return YES;
    }else{
        // 1.获得网络监控的管理者
        [MvToast showProgressWithMessage:@"正在获取价格"];
        AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
        if(mgr.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN || mgr.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi ){
            [self defaultManager];
            [MvToast dismiss];
        }else{
            [MvToast showProgressWithMessage:@"没有网络"];
        }
        return NO;
    }
}

//初始化配置.
-(void)defaultManager{
    //如果完成初始化
    if (_isInitComplete) {
        return;
    }
    NSAssert([ZcqIAPVenderConfig shared].ipaIdArrays.count != 0, @"未主动填写ipaIdArrays，ipaIdArrays为空");
    NSAssert([ZcqIAPVenderConfig shared].ipaAppSecretkey.length != 0, @"未主动填写ipaAppSecretkey，ipaAppSecretkey为空");
    if(![IAPShare sharedHelper].iap) {
        //查询ipaIdArrays的所有内购价格.
        NSSet* dataSet = [[NSSet alloc] initWithArray:[ZcqIAPVenderConfig shared].ipaIdArrays];
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    }
    //检查发票是否存在. 主要用于追查是否过期.
    [self checkTheInvoice];
    //为了保证在获取价格之前，用户不会提前进入到内购页面.设置信号量
    //创建计数为1的信号量
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
#ifndef __OPTIMIZE__
    [IAPShare sharedHelper].iap.production = NO;
    NSLog(@"debug");
#else
    NSLog(@"relase");
    [IAPShare sharedHelper].iap.production = YES;
#endif
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response){
        if (response.products.count > 0) {
            for (int i = 0; i < response.products.count; i ++) {
//                NSLog(@"response : %@",response);
            }
            //信号加1
//            NSLog(@"信号加1");
            NSLog(@"获取到数据");
            _isInitComplete = YES;
//            dispatch_semaphore_signal(semaphore);
        }else{
            NSLog(@"获取不到数据");
            //信号加1
//            dispatch_semaphore_signal(semaphore);
        }
    }];
    //等待，如果信号量大于0，那么继续往下执行并减少一个信号量
//    NSLog(@"等待，如果信号量大于0，那么继续往下执行并减少一个信号量");
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}
-(void)checkTheInvoice{
    // 校验发票
    if ([[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:InternalPurchaseVoucherID]]) {
        NSLog(@"当前拥有会员资格");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:zcq_VipRepresentation];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        NSLog(@"当前没有会员资格");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:zcq_VipRepresentation];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


//获取价格.
-(NSString*)getProductIDPrice:(NSString*)ProductID{
    if([IAPShare sharedHelper].iap.products.count == 0 && [ZcqIAPVenderConfig shared].ipaIdArrays.count != 0) {
        [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response){
        }];
    }else{
        for (int i = 0 ; i < [IAPShare sharedHelper].iap.products.count; i++) {
            SKProduct * product = [IAPShare sharedHelper].iap.products[i];
            if ([product.productIdentifier isEqualToString:ProductID]){
                NSString* priceStr = [[[IAPShare sharedHelper].iap getLocalePrice:product] componentsSeparatedByString:@"."].firstObject;
                return priceStr;
            }
        }
    }
    return @"";
}

// 购买项目 + 回调事件
+(void)inPurchase:(NSString *)identifier withBuySuccessfulBlock:(BuySuccessfulBlock)completed{
    [MvToast showLoading];
    SKProduct *inPurachesProduct;
    if ([IAPShare sharedHelper].iap.products.count > 0) {
        for (int i = 0; i < [IAPShare sharedHelper].iap.products.count; i ++) {
            SKProduct * kProduct = [IAPShare sharedHelper].iap.products[i];
            if ([identifier isEqualToString:kProduct.productIdentifier]) {
                inPurachesProduct = kProduct;
            }
        }
    }else{
        [MvToast showErrorWithMessage:@"暂时无法获取到产品，请稍后再试"];
        return;
    }
    
    
    
    [[IAPShare sharedHelper].iap buyProduct:inPurachesProduct onCompletion:^(SKPaymentTransaction *transcation) {
        if (transcation.error) {
            NSLog(@"订阅失败");
            [MvToast dismiss];
        }else if(transcation.transactionState == SKPaymentTransactionStatePurchased){
            [[IAPShare sharedHelper].iap checkReceipt:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] AndSharedSecret:[ZcqIAPVenderConfig shared].ipaAppSecretkey onCompletion:^(NSString *response, NSError *error) {
                NSDictionary* rec = [IAPShare toJSON:response];
                if([rec[@"status"] integerValue]==0){
                    [[IAPShare sharedHelper].iap provideContentWithTransaction:transcation];
                    [[NSUserDefaults standardUserDefaults] setValue:identifier forKey:InternalPurchaseVoucherID];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:zcq_VipRepresentation];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MvToast showInfoWithMessage:@"已是VIP"];
                    });
                    NSLog(@"VIP制定成功");
                    completed();
                }else {
                    NSLog(@"Fail");
                }
            }];
        }else if (transcation.transactionState == SKPaymentTransactionStateFailed){
            NSLog(@"订阅失败:SKPaymentTransactionStateFailed");
            [MvToast showErrorWithMessage:@"网络繁忙"];
        }
    }];
}
//正在恢复订阅
+(void)restorePurchase{
    [MvToast showLoadingWithMessage:@"正在恢复订阅"];
    [[IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
        for (SKPaymentTransaction *transaction in payment.transactions){
            NSString *purchased = transaction.payment.productIdentifier;
            for (NSString * idString in [ZcqIAPVenderConfig shared].ipaIdArrays) {
                if([purchased isEqualToString:idString])
                {
                    [[NSUserDefaults standardUserDefaults] setValue:purchased forKey:InternalPurchaseVoucherID];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:zcq_VipRepresentation];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [MvToast showSuccessWithMessage:@"恢复成功"];
                }
            }
        }
        [MvToast showSuccessWithMessage:@"未查询到订阅记录"];
    }];
    
}

-(BOOL)isInitComplete{
    return _isInitComplete;
}
@end
