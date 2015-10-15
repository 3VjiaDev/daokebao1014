//
//  LoginViewController.h
//  导客宝
//
//  Created by apple1 on 15/10/7.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"
#import "singleton.h"

@interface LoginViewController : UIViewController
{
    BOOL isLogin;//防止登录按钮多次点击
}

//登录
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
