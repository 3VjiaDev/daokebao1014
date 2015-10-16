//
//  SearchResultViewController.m
//  导客宝
//
//  Created by apple1 on 15/10/8.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    indexPage = 1;
    qjtIDArray = [[NSMutableArray alloc]init];
    qjtNameArray = [[NSMutableArray alloc]init];
    qjtImageArray = [[NSMutableArray alloc]init];
    self.resultTableView.separatorStyle = NO;
    [self initYiRefreshHeader];
    [self initYiRefreshFooter];
    [self GetQJTList:indexPage];
    indexPage++;
}
#pragma mark 下拉刷新以及上拉加载

//下拉刷新
-(void)initYiRefreshHeader
{
    // YiRefreshHeader  头部刷新按钮的使用
    refreshHeader=[[YiRefreshHeader alloc] init];
    refreshHeader.scrollView=self.resultTableView;
    [refreshHeader header];
    
    refreshHeader.beginRefreshingBlock=^(){
        // 后台执行：
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self GetQJTList:indexPage];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 主线程刷新视图
                //[self analyseRequestData];
                [self.resultTableView reloadData];
                [refreshHeader endRefreshing];
            });
        });
    };
    // 是否在进入该界面的时候就开始进入刷新状态
    //[refreshHeader beginRefreshing];
}

//上拉刷新
-(void)initYiRefreshFooter
{
    // YiRefreshFooter  底部刷新按钮的使用
    refreshFooter=[[YiRefreshFooter alloc] init];
    refreshFooter.scrollView=self.resultTableView;
    [refreshFooter footer];
    
    refreshFooter.beginRefreshingBlock=^(){
        // 后台执行：
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //sleep(2);
            // [self analyseRequestData];
           [self GetQJTList:indexPage];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 主线程刷新视图
                [self.resultTableView reloadData];
                [refreshFooter endRefreshing];
            });
        });
    };
}

#pragma mark tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (qjtImageArray.count <= 0) {
        return 0;
    }
    else if (qjtImageArray.count%3 !=  0)
    {
        return (qjtImageArray.count/3)+1;
    }
    else
        return (qjtImageArray.count/3) ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        tableView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       

    }
    if (indexPath.row != (qjtImageArray.count/3)) {
        for (int i = 0; i < 3; i++) {
            
            UIView *view = [self qjtDraw:CGRectMake(10+340*i, 5, 325, 240) qjtImage:[qjtImageArray objectAtIndex:3*indexPath.row+i] title:[qjtNameArray objectAtIndex:3*indexPath.row+i] isCollect:YES tag:3*indexPath.row+i];
            [cell.contentView addSubview:view];
        }
    }
    else
    {
        for (int i = 0; i < qjtImageArray.count%3; i++) {
            
            UIView *view = [self qjtDraw:CGRectMake(10+340*i, 5, 325, 240) qjtImage:[qjtImageArray objectAtIndex:3*indexPath.row+i] title:[qjtNameArray objectAtIndex:3*indexPath.row+i] isCollect:YES tag:3*indexPath.row+i];
            [cell.contentView addSubview:view];
        }
    }

    return cell;
}

#pragma mark 全景图展示

-(UIView *)qjtDraw:(CGRect)rect qjtImage:(NSString*)qjtImage title:(NSString*)qjtTitle isCollect:(BOOL)isCollect tag:(int)tag
{
    UIView *qjtView = [[UIView alloc]initWithFrame:rect];
    qjtView.tag = tag;
    
    UIImageView *qjtImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    
    [qjtImageView sd_setImageWithURL:[NSURL URLWithString:qjtImage] placeholderImage:[UIImage imageNamed:@"jiazaipic"]];
    [qjtView addSubview:qjtImageView];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, (5*rect.size.height)/6, rect.size.width, rect.size.height/6)];
    titleView.backgroundColor = [UIColor whiteColor];
    [qjtView addSubview:titleView];
    
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, (titleView.frame.size.height - 20)/2, rect.size.width-130, 20)];
    titleLab.text = qjtTitle;
    titleLab.font = [UIFont systemFontOfSize:15.0f];
    [titleView addSubview:titleLab];
    
    UIImageView *isCollectionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(rect.size.width-30, (titleView.frame.size.height - 15)/2, 15, 15)];
    
    if (isCollect) {
        isCollectionImageView.image = [UIImage imageNamed:@"xiangqingbaocun-dianji" ];
    }
    else
    {
        isCollectionImageView.image = [UIImage imageNamed:@"xiangqingbaocun-dianji" ];
    }
    [titleView addSubview:isCollectionImageView];
    isCollectionImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *collectGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collent:)];
    
    [isCollectionImageView addGestureRecognizer:collectGestureTel];
    
    
    qjtView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touch:)];
    
    [qjtView addGestureRecognizer:tapGestureTel];
    
    return qjtView;
}


-(void)touch:(UIGestureRecognizer*)gestureRecognizer
{
    UIView *view  =(UIView*)gestureRecognizer.view;
    
    qjtSingleton *single = [qjtSingleton initQJTSingleton];
    single.qjtName = [qjtNameArray objectAtIndex:view.tag];
    single.qjtId = [qjtIDArray objectAtIndex:view.tag];
    [self performSegueWithIdentifier:@"info2" sender:self];
}
-(void)collent:(UIGestureRecognizer*)gestureRecognizer
{
    NSLog(@"11");
}

-(void)GetQJTList:(int)pageIndex
{
    [NSURLConnection sendAsynchronousRequest:[self GetQJTListRequest:pageIndex]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError) {
             [Tool showAlert:@"网络异常" message:@"连接超时"];
         }
         else
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             //将数据变成标准的json数据
             NSData *newData = [[Tool newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             
             NSArray *ReturnList = [[dic objectForKey:@"JSON"]objectForKey:@"ReturnList"];
             for (id list in ReturnList) {
                 NSString *SchemeId = [list objectForKey:@"SchemeId"];
                 NSString *SchemeName = [list objectForKey:@"SchemeName"];
                 NSString *ImagePath = [NSString stringWithFormat:@"%@%@",[Tool requestImageURL],[list objectForKey:@"ImagePath"]];
                 [qjtIDArray addObject:SchemeId];
                 [qjtNameArray addObject:SchemeName];
                 [qjtImageArray addObject:ImagePath];
             }
             if (qjtImageArray.count <= 0) {
                 float h = self.view.frame.size.height;
                 float w = self.view.frame.size.width;
                 isNullView = [[UIView alloc]initWithFrame:CGRectMake((w-108)/2, (h-130)/2, 108, 160)];
                 UIImageView *nullImage= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 108, 130)];
                 nullImage.image = [UIImage imageNamed:@"sousuotubiao"];
                 
                 UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 145, 108, 15)];
                 lab.text = @"搜索结果为空";
                 lab.textColor = [UIColor colorWithRed:0x9f/255.0 green:0xa0/255.0 blue:0xa0/255.0 alpha:1.0f];
                 lab.font = [UIFont systemFontOfSize:12.0f];
                 lab.textAlignment = NSTextAlignmentCenter;
                 [isNullView addSubview:lab];
                 
                 [isNullView addSubview:nullImage];
                 [self.view addSubview:isNullView];
             }
             else
             {
                 [isNullView removeFromSuperview];
             }
             [self.resultTableView reloadData];
         }
     }];
}

/*
 功能：获取全景图网络请求
 输入：DeptId：商家ID pageIndex：请求页数
 返回：网络请求
 */
- (NSMutableURLRequest*)GetQJTListRequest:(int)pageIndex
{
    NSURL *requestUrl = [NSURL URLWithString:[Tool requestURL]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:requestUrl];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    
    NSString *authCode =[Tool readAuthCodeString];
    NSString *keyWord = [keySingleton initKeySingleton].keyWord;
    NSString *page = [NSString stringWithFormat:@"%d",indexPage];
    NSArray *key = @[@"authCode",@"keyword",@"pageSize",@"pageIndex"];
    NSArray *object = @[authCode,keyWord,@"9",page];
    
    NSString *param=[NSString stringWithFormat:@"Params=%@&Command=DesignScheme/GetSchemeList",[Tool param:object forKey:key]];
    NSLog(@"http://passport.admin.3weijia.com/mnmnhwap.axd?%@",param);
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    return request;
}

- (IBAction)return:(UIButton *)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
