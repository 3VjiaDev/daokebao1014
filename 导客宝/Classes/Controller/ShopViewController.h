//
//  ShopViewController.h
//  导客宝
//
//  Created by apple1 on 15/10/8.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "Tool.h"
#import "qjtSingleton.h"
#import "Popover.h"
#import "singleton.h"

@interface ShopViewController : UIViewController
{
    UIView *examineView;
    UITableView *qjtTableView;
    BOOL isCloud;
    
    NSMutableArray *qjtIDArray;
    NSMutableArray *qjtNameArray;
    NSMutableArray *qjtImageArray;
    
    BOOL isSelect;
    UIView *seleceView;
    
    UIView *styleView;
    NSMutableArray *styleArray;
    NSMutableArray *styleIDArray;
    
    UIView *areaView;
    NSMutableArray *areaArray;
    NSMutableArray *areaIDArray;
    
    UIView *spaceView;
    NSMutableArray *spaceArray;
    NSMutableArray *spaceIDArray;
    
    
    UIPopoverController *popover;
    
     UIView *isNullView;
    
}
//改变类型
- (IBAction)changeStyle:(id)sender;
//客户信息
- (IBAction)userInformation:(id)sender;
//搜索
- (IBAction)search:(id)sender;
//筛选
- (IBAction)select:(id)sender;

//筛选按钮
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *typebutton;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *faceImage;

@end
