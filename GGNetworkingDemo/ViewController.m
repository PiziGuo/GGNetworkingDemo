//
//  ViewController.m
//  GGNetworkingDemo
//
//  Created by David on 2017/1/17.
//  Copyright © 2017年 GangZi. All rights reserved.
//

#import "ViewController.h"
#import "TwoController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)push:(id)sender {
    
    TwoController *twoC = [[TwoController alloc] init];
    
    
    [self.navigationController pushViewController:twoC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
