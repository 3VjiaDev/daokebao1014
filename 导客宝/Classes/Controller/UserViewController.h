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
#import "QCheckBox.h"
#import "User.h"
#import "YiRefreshHeader.h"
#import "YiRefreshFooter.h"
@interface UserViewController : UIViewController<QCheckBoxDelegate>
{
    NSMutableArray *nameAry;
    NSMutableArray *IDAry;
    NSMutableArray *phoneAry;
    NSMutableArray *addrAry;
    
    NSMutableArray *markAry;
    
    NSMutableArray *styleAry;
    NSMutableArray *unUpdataUserArray;
    
    UIView *addView;
    UIButton *addButton;
    
    UITextField *addName;
    NSString *addSex;
    UITextField *addPhone;
    UITextView *addr;
    UITextView *addMark;
    NSMutableArray *addStyleAry;
    
    YiRefreshHeader *refreshHeader;//下拉刷新
    YiRefreshFooter *refreshFooter;//上拉加载
    int indexPage;//页码
}
@property (weak, nonatomic) IBOutlet UIButton *addCustomerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cloudImageView;

@property (strong, nonatomic)  UITableView *customerTable;
@property (weak, nonatomic) IBOutlet UIView *titleView;

//添加客户
- (IBAction)addClient:(id)sender;
@end
