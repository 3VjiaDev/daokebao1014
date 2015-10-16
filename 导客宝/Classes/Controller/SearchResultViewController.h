//
//  SearchResultViewController.h
//  导客宝
//
//  Created by apple1 on 15/10/8.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "Tool.h"
#import "keySingleton.h"
#import "qjtSingleton.h"
#import "YiRefreshHeader.h"
#import "YiRefreshFooter.h"

@interface SearchResultViewController : UIViewController
//返回
{
    NSMutableArray *qjtIDArray;
    NSMutableArray *qjtNameArray;
    NSMutableArray *qjtImageArray;
    YiRefreshHeader *refreshHeader;//下拉刷新
    YiRefreshFooter *refreshFooter;//上拉加载
    int indexPage;//页码

    UIView *isNullView;
    
}
- (IBAction)return:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@end
