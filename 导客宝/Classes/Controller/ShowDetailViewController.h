//
//  ShowDetailViewController.h
//  导客宝
//
//  Created by apple1 on 15/10/8.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "qjtSingleton.h"
#import "Tool.h"

@interface ShowDetailViewController : UIViewController

@property (strong, nonatomic)NSString* qjtID;
@property (strong, nonatomic)NSString* qjtName;
@property (assign, nonatomic)BOOL isCollenct;

//分享
- (IBAction)share:(id)sender;

//收藏
- (IBAction)collect:(id)sender;

//返回
- (IBAction)return:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
