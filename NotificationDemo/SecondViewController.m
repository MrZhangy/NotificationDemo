//
//  SecondViewController.m
//  NotificationDemo
//
//  Created by zhangyafeng on 15/5/20.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 74, CGRectGetWidth(self.view.frame), 30)];
    [button setTitle:@"发送通知" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor grayColor];
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)onClick:(UIButton*)button
{
    NSDictionary *datadict = @{@"username":@"MiMi"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kShowAlertView" object:self userInfo:datadict];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
