//
//  DetailViewController.m
//  导客宝
//
//  Created by apple1 on 15/10/12.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.qjtID = [qjtSingleton initQJTSingleton].qjtId;
    self.qjtName = [qjtSingleton initQJTSingleton].qjtName;
    self.isCollenct = [qjtSingleton initQJTSingleton].isCollent;
    
    NSString *UrlString = [NSString stringWithFormat:@"%@%@",[Tool qjtRequestUrl],self.qjtID];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:UrlString]];
    [self.webView loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
