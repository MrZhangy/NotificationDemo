//
//  ViewController.m
//  NotificationDemo
//
//  Created by zhangyafeng on 15/5/20.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    /**
     *  notificationObserver: 注册一个观察着对象，这个值不能为nil
        notificationSelector: notification posing发送指定的消息通知Observer.指定的方法必须有且仅有一个参       数（an instance of NSNotification).
     *  notificationName:     只有具有该名字的notification才能发送信息给Observer,
        object :             通知观察者观察的对象（notification）
     *  注意在viewController释放前，需要注销Observer
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertView:) name:@"kShowAlertView" object:nil];
}



-(void)showAlertView:(NSNotification *)notification
{
    //传输的数据
    NSLog(@"%@",notification.userInfo);
    //发送数据的对象
    NSLog(@"%@",notification.object);

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showSecondViewController:(id)sender {
    SecondViewController *secVc  = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secVc animated:YES];
}

@end
