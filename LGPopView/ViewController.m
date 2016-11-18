//
//  ViewController.m
//  LGPopView
//
//  Created by lingo on 16/11/17.
//  Copyright © 2016年 lingo. All rights reserved.
//

#import "ViewController.h"
#import "LGPopBgView.h"
#import "LGPopView.h"
#import "UIViewController+LGPopViewController.h"
#import "LGPopSpring.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    testBtn.backgroundColor = [UIColor redColor];
    [testBtn setTitle:@"测试" forState:UIControlStateNormal];
    [self.view addSubview:testBtn];
    testBtn.frame = CGRectMake(10, 100, self.view.frame.size.width - 20, 40);
    
    [testBtn addTarget:self action:@selector(testBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    LGPopBgView *bgView = [[LGPopBgView alloc] init];
//    [self.view addSubview:bgView];
//    bgView.frame = self.view.bounds;
//    
//    
//    LGPopView *popView = [[LGPopView alloc] init];
//    [self.view addSubview:popView];
//    popView.frame = CGRectMake(50, 200, 200, 200);
}

- (void)testBtn:(UIButton *)sender{
    //我想怎么用
    LGPopView *popView = [[LGPopView alloc] init];
    LGPopBgView *bgView = [[LGPopBgView alloc] init];
    
    [self showPopView:popView bgView:bgView inView:nil animation:[LGPopSpring new] dismissed:^{
        
    }];
}



@end
