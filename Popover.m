//
//  Popover.m
//  导客宝
//
//  Created by 3Vjia on 15/10/14.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "Popover.h"
#import "ShopViewController.h"
#import "AppDelegate.h"

@interface Popover ()
{
    ShopViewController *oceanaViewController;
    NSString *selectStr;
}
@property(nonatomic,strong)NSMutableArray *menus;

@end

@implementation Popover


- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (delegate.isMain) {
        self.menus = [[NSMutableArray alloc]initWithObjects:@"云库",@"曲美装饰", nil];
    }
   else
   {
       self.menus = [[NSMutableArray alloc]initWithObjects:@"曲美装饰",@"云库", nil];
   }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
     return self.menus.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = NO;
    tableView.scrollEnabled = NO;
    static NSString *ID=@"ID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:239/255.0 green:142/255.0 blue:61/255.0 alpha:1.0f];
        }
    }
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 100, 20)];
    lab.text = self.menus[indexPath.row];
    lab.font = [UIFont systemFontOfSize:15.0f];
    lab.textAlignment = NSTextAlignmentCenter;
    if (indexPath.row == 0) {
        lab.textColor = [UIColor whiteColor];
    }
    [cell.contentView addSubview:lab];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectStr =[[NSString alloc] initWithFormat:@"%@",[self.menus objectAtIndex:indexPath.row]];
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:selectStr,@"type", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    
    //通过通知中心发送通知
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
