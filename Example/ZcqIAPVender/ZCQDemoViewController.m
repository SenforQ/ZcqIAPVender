//
//  ZCQDemoViewController.m
//  ZcqIAPVender_Example
//
//  Created by 郑创权 on 2022/10/19.
//  Copyright © 2022 Z cq. All rights reserved.
//

#import "ZCQDemoViewController.h"
#import <ZcqIAPVender/ZcqIAPVender.h>
@interface ZCQDemoViewController ()

@end

@implementation ZCQDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view, typically from a nib.

    [ZcqApiVenderManager inPurchase:@"com.demoweek.ceshi" withBuySuccessfulBlock:^{
        NSLog(@"购买成功.");
    }];
    self.view.backgroundColor = [UIColor purpleColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIViewController* vc = [[UIViewController alloc]init];
    vc.title = @"123";
    vc.view.backgroundColor = [UIColor yellowColor];
    [self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
