//
//  ZcqIAPVenderConfig.h
//  Pods
//
//  Created by 郑创权 on 2022/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZcqIAPVenderConfig : NSObject

+(instancetype)shared;
//默认@[com.demoweek.ceshi,com.demomonth.ceshi,com.demoyear.ceshi]; BunldeId为com.bangong.wxy
@property (nonatomic, copy)NSArray* ipaIdArrays;
//默认ipaAppSecretkey = @"e0c5fafbe363427e8bc9d4165b907ff1"
@property (nonatomic, copy)NSString* ipaAppSecretkey;
//默认yinSiURL = @"https://shimo.im/docs/w6QwyJcDVrx66j3Q"
@property (nonatomic, copy)NSString* yinSiURL;
//默认dingGouURL = @"https://shimo.im/docs/w6QwyJcDVrx66j3Q"
@property (nonatomic, copy)NSString* dingGouURL;
//IAPInternalPurchaseVoucherID（订单凭证）
-(NSString*)getIAPInternalPurchaseVoucherID;
//是否为VIP
-(BOOL)getIsVIPStatus;
//展示配置信息.
-(void)showConfigMessage;
//是否为永久会员forever
@property (nonatomic, assign)BOOL isForeverVip;
@end

NS_ASSUME_NONNULL_END
