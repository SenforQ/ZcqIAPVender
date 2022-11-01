//
//  ZcqIAPVenderConfig.m
//  Pods
//
//  Created by 郑创权 on 2022/10/18.
//

#import "ZcqIAPVenderConfig.h"

@interface ZcqIAPVenderConfig ()
//内购的
@property (nonatomic, copy)NSString* InternalPurchaseVoucherID;//订单凭证.
@property (nonatomic, assign)BOOL zcq_VipRepresentation;//是否开启会员

@end

@implementation ZcqIAPVenderConfig

static ZcqIAPVenderConfig * _defaultManager = nil;

+(instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[ZcqIAPVenderConfig alloc] init];
    });
    return _defaultManager;
}

-(instancetype)init{
    if (self = [super init]) {
        _InternalPurchaseVoucherID = [[NSUserDefaults standardUserDefaults] objectForKey:@"InternalPurchaseVoucherID"];
        _zcq_VipRepresentation = [[NSUserDefaults standardUserDefaults] boolForKey:@"MemberRepresentation"];
        _dingGouURL = @"https://shimo.im/docs/w6QwyJcDVrx66j3Q";
        _yinSiURL = @"https://shimo.im/docs/w6QwyJcDVrx66j3Q";
    }
    return self;
}

-(void)showConfigMessage{
    NSAssert([ZcqIAPVenderConfig shared].ipaIdArrays.count != 0, @"未主动填写ipaIdArrays，ipaIdArrays为空");
    NSAssert([ZcqIAPVenderConfig shared].ipaAppSecretkey.length != 0, @"未主动填写ipaAppSecretkey，ipaAppSecretkey为空");
#ifndef __OPTIMIZE__
    NSLog(@"----内购配置清单----");
    NSLog(@"IAPId数据配置（内购ID）：%@",_ipaIdArrays);
    NSLog(@"IAPAppSecretkey（密钥）：%@",_ipaAppSecretkey);
    NSLog(@"IAPInternalPurchaseVoucherID（订单凭证）：%@",_InternalPurchaseVoucherID);
    NSLog(@"IAP开通会员：%@",_zcq_VipRepresentation?@"YES":@"NO");
    NSLog(@"----内购配置完成----");
#else
#endif
}

-(NSString*)getIAPInternalPurchaseVoucherID{
    _defaultManager.InternalPurchaseVoucherID = [[NSUserDefaults standardUserDefaults] objectForKey:@"InternalPurchaseVoucherID"];
    return _defaultManager.InternalPurchaseVoucherID?_defaultManager.InternalPurchaseVoucherID:@"";
}
-(BOOL)getIsVIPStatus{
    _defaultManager.zcq_VipRepresentation = [[NSUserDefaults standardUserDefaults] boolForKey:@"MemberRepresentation"];
    return _defaultManager.zcq_VipRepresentation;
}
@end
