//
//  ViewController.m
//  LJJAStar
//
//  Created by 刘俊杰 on 15/10/10.
//  Copyright © 2015年 LJ. All rights reserved.
//

#import "ViewController.h"
#import "LJJView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LJJView *aView = [[LJJView alloc] initWithFrame:CGRectMake(40, 100, 300, 300)];
    [self.view addSubview:aView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
