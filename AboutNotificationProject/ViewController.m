//
//  ViewController.m
//  AboutNotificationProject
//
//  Created by 周文春 on 16/5/26.
//  Copyright © 2016年 周文春. All rights reserved.
//

#import "ViewController.h"
#import "MegViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToMesgVC:) name:@"goToMesgVC" object:nil];

}
#pragma mark - goToMegVC
- (void)goToMesgVC:(NSNotification *)notification
{
    MegViewController * vc = [[MegViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
