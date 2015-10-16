//
//  UserViewController.h
//  导客宝
//
//  Created by apple1 on 15/10/5.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"
#import "singleton.h"
#import "QRadioButton.h"
@interface UserViewController : UIViewController
{
    NSMutableArray *nameAry;
    NSMutableArray *IDAry;
    NSMutableArray *phoneAry;
    NSMutableArray *addrAry;
    NSMutableArray *styleAry;
    NSMutableArray *markAry;
    
    
    UIView *addView;
    UIButton *addButton;
    
    UITextField *addName;
    NSString *addSex;
    UITextField *addPhone;
    UITextView *addr;
    UITextView *addMark;
    NSMutableArray *addStyleAry;
}
@property (weak, nonatomic) IBOutlet UIButton *addCustomerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cloudImageView;

@property (weak, nonatomic) IBOutlet UITableView *customerTable;
@property (weak, nonatomic) IBOutlet UIView *titleView;

//添加客户
- (IBAction)addClient:(id)sender;
@end
