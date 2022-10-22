//
//  ZcqApiVenderManager.h
//  ZcqIAPVender
//
//  Created by 郑创权 on 2022/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BuySuccessfulBlock)(void);

@interface ZcqApiVenderManager : NSObject

// 初始化
+(instancetype)shared;
-(void)defaultManager;
// 购买项目 + 回调事件
+(void)inPurchase:(NSString *)identifier withBuySuccessfulBlock:(BuySuccessfulBlock)completed;
//获取价格.
-(NSString*)getProductIDPrice:(NSString*)ProductID;
//判断是否获取到价格列表.
-(BOOL)isGetProducts;
//是否获取到所有价格.
-(BOOL)isInitComplete;
//恢复购买
+(void)restorePurchase;
//是否获取到网络.
@property (nonatomic, assign)BOOL isNetWorking;
@end

NS_ASSUME_NONNULL_END
