

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^LcProgressBlock)(CGFloat progress);
@interface MvToast : NSObject
//拦截
+ (void)showLoading;
+ (void)showLoadingWithMessage:(NSString *)message;
+ (void)showLoadingInView:(UIView *)view;
+ (void)showLoadingInView:(UIView *)view message:(NSString *)message
              interaction:(BOOL)interaction;
+ (void)dismiss;
+ (void)dismissInView:(UIView *)view;
+ (void)dismissAniamted:(BOOL)aniamted;
+ (void)dismissInView:(UIView *)view animated:(BOOL)animated;
+ (LcProgressBlock)showProgressWithMessage:(NSString *)message;

//不拦截
+ (void)showInfoWithMessage:(NSString *)message;
+ (void)showSuccessWithMessage:(NSString *)message;
+ (void)showErrorWithMessage:(NSString *)message;

+ (void)showInfoWithMessage:(NSString *)message inView:(UIView *)view;
+ (void)dismissAniamted:(BOOL)aniamted inView:(UIView *)view;
+ (void)diggAnimationWith:(UIButton *)button;
@end

NS_ASSUME_NONNULL_END
