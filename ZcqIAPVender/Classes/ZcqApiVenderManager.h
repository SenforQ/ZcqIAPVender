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

@end

NS_ASSUME_NONNULL_END
