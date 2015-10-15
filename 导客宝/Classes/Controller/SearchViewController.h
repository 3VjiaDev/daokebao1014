//
//  SearchViewController.h
//  导客宝
//
//  Created by apple1 on 15/10/8.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "keySingleton.h"
@interface SearchViewController : UIViewController
{
    NSMutableArray *hotArray;
    NSMutableArray *hisArray;
    
}
@property (weak, nonatomic) IBOutlet UIView *hotView;
@property (weak, nonatomic) IBOutlet UIView *historyView;

//取消
- (IBAction)cancel:(id)sender;
//搜索
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end
