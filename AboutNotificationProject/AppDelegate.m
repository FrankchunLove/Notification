//
//  AppDelegate.m
//  AboutNotificationProject
//
//  Created by 周文春 on 16/5/26.
//  Copyright © 2016年 周文春. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //首先进入程序时先移除所有通知,再接受新的通知,防止受到的通知累加
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self registerLocalNotification:3];
    return YES;
}
- (void)registerLocalNotification:(NSInteger)interval{
    
    //初始化本地通知
    UILocalNotification * notification = [[UILocalNotification alloc]init];
    
    //设置触发通知的时间
    NSDate * fireDate = [NSDate dateWithTimeIntervalSinceNow:interval];
    notification.fireDate = fireDate;
    
    //时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    //通知主体内容
    notification.alertBody = @"这是通知主体";
    //通知的动作(解锁时下面一行小字,滑动来...后面的字)
    notification.alertAction = @"学习通知";
    //应用程序角标(默认为0,不显示角标)
    notification.applicationIconBadgeNumber = 1;
    //通知被触发时播放的声音(可自定义)
    notification.soundName = UILocalNotificationDefaultSoundName;
    //通知的参数,通过key值来标识这个通知
    NSDictionary * userDict = [NSDictionary dictionaryWithObject:@"哈哈哈哈啊哈哈" forKey:@"key"];
    notification.userInfo = userDict;
    
    if([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]){
        //设置通知类型
        UIUserNotificationType type = UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound;
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        //通知重复的时间间隔,可以是天,周,月(实际最小单位是分钟)
        notification.repeatInterval = kCFCalendarUnitMinute;
    }else{
        //通知重复的时间间隔,可以是天,周,月(实际最小单位是分钟)
        notification.repeatInterval = NSCalendarUnitDay;
    }
    
    //执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}
// 本地通知回调函数，当应用程序收到本地通知时调用（应用在前台时调用，切换到后台则不调用此方法）
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //在通知栏时收到通知点击进去消息界面
    if (application.applicationState == UIApplicationStateInactive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToMesgVC" object:nil];
    }
    
    //程序在前台运行时收到通知,弹出提示框提醒之后进入消息界面
    //获取通知所带的数据
    NSString * details = [notification.userInfo objectForKey:@"key"];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"通知提醒" message:details preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToMesgVC" object:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    //跟新显示的角标个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}
//在需要移除某个通知时调用下面方法
//取消某个本地推送通知
- (void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray * localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification * notifiction in localNotifications) {
        NSDictionary * userInfo = notifiction.userInfo;
        if (userInfo) {
            //根据设置通知参数时指定的key来获取通知参数
            NSString * info = [userInfo objectForKey:key];
            //如果找到需要取消的通知,则取消掉
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notifiction];
                break;
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
