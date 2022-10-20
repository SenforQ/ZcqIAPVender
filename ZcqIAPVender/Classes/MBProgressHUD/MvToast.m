
#import "MvToast.h"
#import "MBProgressHUD.h"

@implementation MvToast

+ (void)config:(MBProgressHUD *)hud {
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.label.numberOfLines = 10;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 9.0) {
        hud.label.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    } else {
        hud.label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.0];
    }
    hud.margin = 16;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.layer.cornerRadius = 8;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0.000 alpha:0.700];
}

+ (void)showLoading {
    [self showLoadingInView:[UIApplication sharedApplication].keyWindow message:@"" interaction:NO];
}

+ (void)showLoadingWithMessage:(NSString *)message {
    [self showLoadingInView:[UIApplication sharedApplication].keyWindow message:message interaction:NO];
}

+ (void)showLoadingInView:(UIView *)view {
    [self showLoadingInView:view message:@"" interaction:NO];
}

+ (void)showLoadingInView:(UIView *)view message:(NSString *)message interaction:(BOOL)interaction {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
    if (interaction) {
        hud.userInteractionEnabled = NO;
    }
    [self config:hud];
}

+ (LcProgressBlock)showProgressWithMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = message;
    [self config:hud];
    return ^(CGFloat progress) {
        hud.progress = progress;
    };
}

+ (void)showInfoWithMessage:(NSString *)message {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:2];
    hud.userInteractionEnabled = NO;
    [self config:hud];
}

+ (void)showSuccessWithMessage:(NSString *)message {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:2];
    hud.userInteractionEnabled = NO;
    [self config:hud];
}
+ (void)showErrorWithMessage:(NSString *)message {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:2];
    hud.userInteractionEnabled = NO;
    [self config:hud];
}

+ (void)dismiss {
    [self dismissInView:[UIApplication sharedApplication].keyWindow animated:YES];
    
}

+ (void)dismissInView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)dismissInView:(UIView *)view animated:(BOOL)animated {
    [MBProgressHUD hideHUDForView:view animated:animated];
}

+ (void)dismissAniamted:(BOOL)aniamted {
    [self dismissInView:[UIApplication sharedApplication].keyWindow animated:aniamted];
}


+ (void)showInfoWithMessage:(NSString *)message inView:(UIView *)view {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:2];
    hud.userInteractionEnabled = NO;
    [self config:hud];
}

+ (void)dismissAniamted:(BOOL)aniamted inView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:aniamted];
}

+ (void)diggAnimationWith:(UIButton *)button {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@1.4, @1.0];
    animation.duration = 0.3;
    animation.calculationMode = kCAAnimationCubic;
    
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-18 / 180.0 * M_PI),@(18 /180.0 * M_PI),@(-18/ 180.0 * M_PI)];
    keyAnimaion.removedOnCompletion = YES;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.3f;
    keyAnimaion.repeatCount = 1;
    [button.layer addAnimation:keyAnimaion forKey:@"transform.rotation"];
    [button.layer addAnimation:animation forKey:@"transform.scale"];
}

@end
