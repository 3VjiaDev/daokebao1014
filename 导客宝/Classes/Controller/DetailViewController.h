//
//  DetailViewController.h
//  导客宝
//
//  Created by apple1 on 15/10/12.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "qjtSingleton.h"
#import "Tool.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic)NSString* qjtID;
@property (strong, nonatomic)NSString* qjtName;
@property (assign, nonatomic)BOOL isCollenct;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
