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

@interface SearchResultViewController : UIViewController
//返回
{
    NSMutableArray *qjtIDArray;
    NSMutableArray *qjtNameArray;
    NSMutableArray *qjtImageArray;
    
    UIView *isNullView;
    
}
- (IBAction)return:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@end
