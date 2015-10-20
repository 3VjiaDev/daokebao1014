
//
//  UserViewController.m
//  导客宝
//
//  Created by apple1 on 15/10/5.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "UserViewController.h"


@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,QRadioButtonDelegate>

@end

@implementation UserViewController

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
 
    
    [super viewDidLoad];
    self.customerTable = [[UITableView alloc]initWithFrame:CGRectMake(15, 144, self.view.frame.size.width-30, self.view.frame.size.height-170)];
    self.customerTable.delegate = self;
    self.customerTable.dataSource = self;
    [self.view addSubview:self.customerTable];
    
    addSex = @"女";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.cloudImageView.hidden = YES;
    [self initData];
    indexPage = 1;
     [self initYiRefreshFooter];
    [self getCustomerList:indexPage];
    [self cellFristRow:self.titleView];
    styleAry = [[NSMutableArray alloc]init];
    unUpdataUserArray = [self readplistData1:@"updataUser.plist"];
    
    if (unUpdataUserArray.count > 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"上传离线用户信息" message:@"是否上传离线的用户信息至服务器?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"上传", nil];
        alert.tag = 1000;
        [alert show];
    }
    else
    {
        unUpdataUserArray = [[NSMutableArray alloc]init];
    }
}
//上拉刷新
-(void)initYiRefreshFooter
{
    // YiRefreshFooter  底部刷新按钮的使用
    refreshFooter=[[YiRefreshFooter alloc] init];
    refreshFooter.scrollView=self.customerTable;
    [refreshFooter footer];
    
    refreshFooter.beginRefreshingBlock=^(){
        // 后台执行：
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self getCustomerList:indexPage++];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 主线程刷新视图
                [self.customerTable reloadData];
                [refreshFooter endRefreshing];
            });
        });
    };
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            self.cloudImageView.hidden = NO;
            for (int i = unUpdataUserArray.count-1; i >= 0; i--) {
                User *user = [[User alloc]init];
                user.name = [[unUpdataUserArray objectAtIndex:i]objectForKey:@"name"];
                user.phone = [[unUpdataUserArray objectAtIndex:i]objectForKey:@"phone"];
                user.sex = [[unUpdataUserArray objectAtIndex:i]objectForKey:@"sex"];
                user.address = [[unUpdataUserArray objectAtIndex:i]objectForKey:@"address"];
                user.mark = [[unUpdataUserArray objectAtIndex:i]objectForKey:@"mark"];
                user.styleAry = [[unUpdataUserArray objectAtIndex:i]objectForKey:@"style"];
                
                [self addCustomer:user];
                [unUpdataUserArray removeObjectAtIndex:i];
                [self writeToPlist:@"updataUser.plist" data:unUpdataUserArray];
            }
        }
    }
}
#pragma mark 键盘响应函数

//键盘消失
- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    addView.frame =CGRectMake(0, 0, addView.frame.size.width, addView.frame.size.height);
    [UIView commitAnimations];
}

//键盘显示
-(void)keyboardWillShow:(NSNotification *)notification
{
    
    int pointY = 336;
    int offset = pointY + 100 - (addView.frame.size.height - 450);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        addView.frame = CGRectMake(0.0f, -offset, addView.frame.size.width, addView.frame.size.height);
    
    [UIView commitAnimations];

    
}

-(NSMutableArray*)array:(User*)user
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:user.name forKey:@"name"];
    [dic setValue:user.sex forKey:@"sex"];
    [dic setValue:user.phone forKey:@"phone"];
    [dic setValue:user.address forKey:@"address"];
    [dic setValue:user.mark forKey:@"mark"];
    [dic setValue:user.styleAry forKey:@"style"];
    [unUpdataUserArray addObject:dic];
    
    return unUpdataUserArray;
}

#pragma mark 初始化数据
-(void)initData
{
    nameAry = [[NSMutableArray alloc]init];
    IDAry = [[NSMutableArray alloc]init];
    phoneAry = [[NSMutableArray alloc]init];
    addrAry = [[NSMutableArray alloc]init];
    markAry = [[NSMutableArray alloc]init];
}

- (IBAction)addClient:(id)sender {
    [self.addCustomerBtn setImage:[[UIImage imageNamed:@"tianjiakehu-dianji"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self addUserView];
}

#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nameAry.count+unUpdataUserArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil) {
       
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    if (indexPath.row < unUpdataUserArray.count) {
        
        [self cellRow:cell.contentView
                 name:[[unUpdataUserArray objectAtIndex:indexPath.row]objectForKey:@"name"]
                phone:[[unUpdataUserArray objectAtIndex:indexPath.row]objectForKey:@"phone"]
              address:[[unUpdataUserArray objectAtIndex:indexPath.row]objectForKey:@"address"]
                style:[[unUpdataUserArray objectAtIndex:indexPath.row]objectForKey:@"name"]
                state:@"未上传"
                  tag:(indexPath.row)];
    }
    else
    {
        [self cellRow:cell.contentView
                 name:[nameAry objectAtIndex:(indexPath.row-unUpdataUserArray.count)]
                phone:[phoneAry objectAtIndex:(indexPath.row-unUpdataUserArray.count)]
              address:[addrAry objectAtIndex:(indexPath.row-unUpdataUserArray.count)]
                style:[nameAry objectAtIndex:(indexPath.row-unUpdataUserArray.count)]
                state:@"查看"
                  tag:(indexPath.row-unUpdataUserArray.count)];
    }
   
    return cell;
}

-(void)cellFristRow:(UIView*)view
{
    NSArray *infoAry = @[@"客户姓名",@"手机号",@"地址",@"风格",@"备注"];
    NSArray *xAry = @[@0,@150,@300,@610,@870];
    NSArray *widthAry = @[@149,@149,@309,@259,@134];
    float h = view.frame.size.height;
    for (int i = 0; i < infoAry.count; i++) {
        id xPoint = [xAry objectAtIndex:i];
        id width = [widthAry objectAtIndex:i];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake([xPoint floatValue], 12, [width floatValue], 20)];
        lab.text = [infoAry objectAtIndex:i];
        lab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab];
        
        if (i != 0) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake([xPoint floatValue], 0, 1, h)];
            lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [view addSubview:lineView];
        }
    }
}

-(void)cellRow:(UIView*)view name:(NSString *)name phone:(NSString*)phone address:(NSString*)address style:(NSString*)style state:(NSString*)state tag:(NSInteger)tag
{
    NSArray *infoAry = @[name,phone,address,style,state];
    NSArray *xAry = @[@0,@150,@300,@610,@870];
    NSArray *widthAry = @[@149,@149,@309,@259,@134];
    float h = view.frame.size.height;
    for (int i = 0; i < infoAry.count; i++) {
        id xPoint = [xAry objectAtIndex:i];
        id width = [widthAry objectAtIndex:i];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake([xPoint floatValue], 0, [width floatValue], h)];
        lab.text = [infoAry objectAtIndex:i];
        if (i == 4) {
            lab.textColor = [UIColor colorWithRed:239/255.0 green:142/255.0 blue:61/255.0 alpha:1.0f];
            lab.tag = tag;
            lab.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouch:)];
            
            [lab addGestureRecognizer:tapGestureTel];

        }
        lab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab];
        if (i != 0) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake([xPoint floatValue], 0, 1, h)];
            lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [view addSubview:lineView];
        }
    }
}
-(void)labelTouch:(UIGestureRecognizer*)gestureRecognizer
{
    UILabel *lab=(UILabel*)gestureRecognizer.view;
    if ([lab.text isEqualToString:@"查看"]) {
        NSLog(@"%@",[IDAry objectAtIndex:lab.tag]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"查看" message:@"查看用户备注" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"%@",[unUpdataUserArray objectAtIndex:lab.tag]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"上传" message:@"上传用户信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark 绘制添加用户界面
-(UIView*)drawView:(CGRect)frame colorRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return view;
}

-(UILabel*)labelWithFrame:(CGRect)frame string:(NSString*)string color:(UIColor*)color font:(float)font
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:font];
    label.text = string;
    label.textColor = color;
    return label;
}
-(void)addUserView
{
    addView = [self drawView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                    colorRed:0.0f green:0.0f blue:0.0f alpha:0.2f];
    [self.view addSubview:addView];
    
    float xpoint = (self.view.frame.size.width - 400)/2;
    float ypoint = (self.view.frame.size.height - 520)/2;
    
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(xpoint, ypoint, 400, 520)];
    infoView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0f];
    [addView addSubview:infoView];
    
    UIView *titleView = [self drawView:CGRectMake(0, 0, infoView.frame.size.width, 35)
                              colorRed:239/255.0 green:142/255.0 blue:61/255.0 alpha:1.0f];
    [infoView addSubview:titleView];
    
    UIImageView *titleIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7.5, 20, 20)];
    titleIV.image = [UIImage imageNamed:@"baitianjia"];
    [titleView addSubview:titleIV];
    
    [titleView addSubview:[self labelWithFrame:CGRectMake(40, 7.5, 100, 20)
                                        string:@"添加客户"
                                         color:[UIColor whiteColor]
                                          font:15.0]];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(titleView.frame.size.width - 30, 5, 25, 25);
    
    [closeBtn setImage:[[UIImage imageNamed:@"baicha"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:closeBtn];
    
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(15, 50, infoView.frame.size.width-30, 109)];
    baseView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [infoView addSubview:baseView];
    
    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(1, 1, infoView.frame.size.width-32, 35)];
    nameView.backgroundColor =[UIColor whiteColor];
    [baseView addSubview:nameView];
    
    [nameView addSubview:[self labelWithFrame:CGRectMake(10, 7.5, 50, 20)
                                       string:@"姓名"
                                        color:[UIColor blackColor]
                                         font:15.0f]];
    
    addName = [[UITextField alloc]initWithFrame:CGRectMake(50, 7.5, 250, 20)];
    addName.borderStyle = UITextBorderStyleNone;
    addName.font = [UIFont systemFontOfSize:15.0f];
    addName.delegate = self;
    [nameView addSubview:addName];
    
    UIView *sexView = [[UIView alloc]initWithFrame:CGRectMake(1, 37, infoView.frame.size.width-32, 35)];
    sexView.backgroundColor =[UIColor whiteColor];
    [baseView addSubview:sexView];
    
    [sexView addSubview:[self labelWithFrame:CGRectMake(10, 7.5, 50, 20)
                                      string:@"性别"
                                       color:[UIColor blackColor]
                                        font:15.0f]];
    for(int i = 0;i< 2;i++)
    {
        QRadioButton *radio = [[QRadioButton alloc]initWithDelegate:self groupId:@"remaind"];
        radio.frame = CGRectMake(60+50*i, 7.5, 50, 20);
        [radio setTitle:(i == 0)?@"男":@"女" forState:UIControlStateNormal];
        [radio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [radio.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [sexView addSubview:radio];
        [radio setChecked:YES];
    }
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(1, 73, infoView.frame.size.width-32, 35)];
    phoneView.backgroundColor =[UIColor whiteColor];
    [baseView addSubview:phoneView];
    
    [phoneView addSubview:[self labelWithFrame:CGRectMake(10, 7.5, 50, 20)
                                        string:@"号码"
                                         color:[UIColor blackColor]
                                          font:15.0f]];
    
    addPhone = [[UITextField alloc]initWithFrame:CGRectMake(50, 7.5, 250, 20)];
    addPhone.borderStyle = UITextBorderStyleNone;
    addPhone.keyboardType = UIKeyboardTypeNumberPad;
    addPhone.delegate = self;
    addPhone.font = [UIFont systemFontOfSize:15.0f];
    [phoneView addSubview:addPhone];

    
    UIView *base1View = [[UIView alloc]initWithFrame:CGRectMake(15, 185, infoView.frame.size.width-30, 90)];
    base1View.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [infoView addSubview:base1View];
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(1, 1, infoView.frame.size.width-32, 88)];
    addressView.backgroundColor = [UIColor whiteColor];
    [base1View addSubview:addressView];

    [addressView addSubview:[self labelWithFrame:CGRectMake(10, 7.5, 50, 20)
                                          string:@"地址"
                                           color:[UIColor blackColor]
                                            font:15.0f]];
    
    addr = [[UITextView alloc]initWithFrame:CGRectMake(50, 2.5, addressView.frame.size.width-60, 60)];
    addr.font = [UIFont systemFontOfSize:15.0f];
    addr.delegate = self;
    [addressView addSubview:addr];
    
    UIView *base2View = [[UIView alloc]initWithFrame:CGRectMake(15, 290, infoView.frame.size.width-30, 90)];
    base2View.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [infoView addSubview:base2View];
    UIView *markView = [[UIView alloc]initWithFrame:CGRectMake(1, 1, infoView.frame.size.width-32, 88)];
    markView.backgroundColor = [UIColor whiteColor];
    [base2View addSubview:markView];
    
    [markView addSubview:[self labelWithFrame:CGRectMake(10, 7.5, 50, 20)
                                       string:@"备注"
                                        color:[UIColor blackColor]
                                         font:15.0f]];
    
    addMark  = [[UITextView alloc]initWithFrame:CGRectMake(50, 2.5, addressView.frame.size.width-60, 60)];
    addMark.font = [UIFont systemFontOfSize:15.0f];
    addMark.delegate = self;
    [markView addSubview:addMark];
    
    [infoView addSubview:[self labelWithFrame:CGRectMake(20, 385, 200, 20)
                                       string: @"喜欢装修风格（可多选）"
                                        color:[UIColor blackColor]
                                         font:15.0f]];
    
    UIView *base3View = [[UIView alloc]initWithFrame:CGRectMake(10, 410, infoView.frame.size.width-20, 60)];
    base3View.backgroundColor = [UIColor whiteColor];
    [infoView addSubview:base3View];
    NSArray *checkAry = @[@"欧式",@"田园",@"中式",@"地中海",@"简约",@"现代"];
    for (int i = 0; i < checkAry.count; i++) {
        QCheckBox *_check1 = [[QCheckBox alloc] initWithDelegate:self];
        int row = i/3;
        int col = i%3;
        _check1.frame = CGRectMake(10+100*col, 30*row, 100, 30);
        [_check1 setTitle:[checkAry objectAtIndex:i] forState:UIControlStateNormal];
        [_check1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_check1.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [base3View addSubview:_check1];
        
    }

    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(15, 475, 370, 30);

    [addButton setTitle:@"完成保存" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor colorWithRed:239/255.0 green:142/255.0 blue:61/255.0 alpha:1.0f];
    [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:addButton];
    [addButton.layer setMasksToBounds:YES];
    [addButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [addButton.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 239/255.0, 142/255.0, 61/255.0, 1 });
    [addButton.layer setBorderColor:colorref];//边框颜色

}

-(void)close:(id)sender
{
    [self.addCustomerBtn setImage:[[UIImage imageNamed:@"tianjiakehu-weidianji"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3
                     animations:^{
                         addView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [addView removeFromSuperview];
                         styleAry = [[NSMutableArray alloc]init];
                     }];

}
#pragma mark 单选复选
-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if([radio.titleLabel.text isEqualToString:@"男"])
    {
        addSex = @"男";
    }
    else
    {
        addSex = @"女";
    }
}
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked
{
    if(checked)
    {
        [styleAry addObject:checkbox.titleLabel.text];
    }
    else
    {
        [styleAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if ([obj isEqualToString:checkbox.titleLabel.text]) {
                *stop = YES;
                if (*stop == YES) {
                    [styleAry removeObject:obj];
                }
            }
        }];
    }
}
-(void)addButtonAction:(id)sender
{
   
    UIButton *button = (UIButton*)sender;
    NSLog(@"%@",button.titleLabel.text);
    if ([button.titleLabel.text isEqualToString:@"正在保存..."]) {
        return;
    }
    NSLog(@"name = %@",addName.text);
    if((addName.text.length<=0)||(addPhone.text.length<=0)||(addr.text.length<=0)||(addMark.text.length<=0))
    {
        [Tool showAlert:@"用户信息不完整" message:@"请完善用户信息"];
        return;
    }
    [button setTitle:@"正在保存..." forState:UIControlStateNormal];
    User *user =[[User alloc]init];
    user.name = addName.text;
    user.sex = addSex;
    user.phone = addPhone.text;
    user.mark = addMark.text;
    user.address = addr.text;
    user.styleAry = styleAry;
    [self addCustomer:user];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    int pointY = 336;
    int offset = pointY + 100 - (addView.frame.size.height - 450);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        addView.frame = CGRectMake(0.0f, -offset, addView.frame.size.width, addView.frame.size.height);
    
    [UIView commitAnimations];
}
#pragma mark 获取客户列表
/*
 功能：获取客户列表
 输入：null
 返回：null
 */
-(void)getCustomerList:(int)page
{
    NSString *deptid = [singleton initSingleton].deptid;
    
    [NSURLConnection sendAsynchronousRequest:[self GetCustomerListRequest:deptid pageIndex:page]
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
                 NSString *CustomerName = [list objectForKey:@"CustomerName"];
                 NSString *CustomerId = [list objectForKey:@"CustomerId"];
                 NSString *Mobile = [list objectForKey:@"Mobile"];
                 NSString *Address = [list objectForKey:@"Address"];
                 
                 [nameAry addObject:CustomerName];
                 [IDAry addObject:CustomerId];
                 [phoneAry addObject:Mobile];
                 [addrAry addObject:Address];
             }
             [self.customerTable reloadData];
         }
     }];
}

/*
 功能：用户登录网络请求
 输入：DeptId：商家ID pageIndex：请求页数
 返回：网络请求
 */

- (NSMutableURLRequest*)GetCustomerListRequest:(NSString*)DeptId pageIndex:(int)pageIndex
{
    NSURL *requestUrl = [NSURL URLWithString:[Tool requestURL]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:requestUrl];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    
    NSString *authCode =[Tool readAuthCodeString];
    
    NSArray *key = @[@"authCode",@"DeptId",@"pageSize",@"pageIndex"];
    NSString *page = [NSString stringWithFormat:@"%d",indexPage];
    NSArray *object = @[authCode,DeptId,@"12",page];
    
    NSString *param=[NSString stringWithFormat:@"Params=%@&Command=ShopManager/GetCustomerList",[Tool param:object forKey:key]];
    NSLog(@"http://passport.admin.3weijia.com/mnmnhwap.axd?%@",param);
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    return request;
}
#pragma mark 添加客户信息
/*
 功能：添加客户信息
 输入：null
 返回：null
 */

-(void)addCustomer:(User*)user
{
    [NSURLConnection sendAsynchronousRequest:[self addCustomer:user.name sex:user.sex phone:user.phone address:user.address mark:user.mark style:user.styleAry]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         [self.addCustomerBtn setImage:[[UIImage imageNamed:@"tianjiakehu-weidianji"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
         [UIView animateWithDuration:0.3
                          animations:^{
                              addView.alpha = 0.0f;
                          }
                          completion:^(BOOL finished){
                              [addView removeFromSuperview];
                              styleAry = [[NSMutableArray alloc]init];
                          }];

         if (connectionError) {
             [Tool showAlert:@"网络异常" message:@"连接超时"];
             [self writeToPlist:@"updataUser.plist" data:[self array:user]];
             styleAry = [[NSMutableArray alloc]init];
             unUpdataUserArray = [self readplistData1:@"updataUser.plist"];
             [self.customerTable reloadData];
             self.cloudImageView.hidden = YES;
             
         }
         else
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             //将数据变成标准的json数据
             NSData *newData = [[Tool newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             NSString *Json = [dic objectForKey:@"JSON"];
             if (Json != nil) {
                 //添加客户成功
                                nameAry = [[NSMutableArray alloc]init];
                 IDAry = [[NSMutableArray alloc]init];
                 phoneAry = [[NSMutableArray alloc]init];
                 addrAry = [[NSMutableArray alloc]init];
                 markAry = [[NSMutableArray alloc]init];
                 self.cloudImageView.hidden = YES;
                 [self getCustomerList:indexPage++];
             }
             else
             {
                 //添加客户失败
                 [UIView animateWithDuration:0.3
                                  animations:^{
                                      addView.alpha = 0.0f;
                                  }
                                  completion:^(BOOL finished){
                                      [addView removeFromSuperview];
                                  }];
                 [self writeToPlist:@"updataUser.plist" data:[self array:user]];
                  styleAry = [[NSMutableArray alloc]init];
                 [Tool showAlert:@"添加失败" message:@"添加客户失败"];
                 unUpdataUserArray = [self readplistData1:@"updataUser.plist"];
                 self.cloudImageView.hidden = YES;
                 [self.customerTable reloadData];
             }
         }
     }];
}

/*
 功能：添加客户信息网络请求
 输入：name：客户姓名 sex：性别 phone： address mark style
 返回：网络请求
 */
- (NSMutableURLRequest*)addCustomer:(NSString*)name sex:(NSString *)sex phone:(NSString*)phone address:(NSString *)address
                               mark:(NSString *)mark style:(NSArray*)styAry
{
    NSURL *requestUrl = [NSURL URLWithString:[Tool requestURL]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:requestUrl];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    
    NSString *authCode =[Tool readAuthCodeString];
    
    //生成上传数据
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:authCode forKey:@"authCode"];
    
    NSMutableDictionary *jsonInfoDic = [[NSMutableDictionary alloc]init];
    
    [jsonInfoDic setValue:name forKey:@"name"];
    [jsonInfoDic setValue:sex forKey:@"sex"];
    [jsonInfoDic setValue:phone forKey:@"mobile"];
    [jsonInfoDic setValue:address forKey:@"address"];
    [jsonInfoDic setValue:mark forKey:@"remark"];
    [jsonInfoDic setValue:styAry forKey:@"categoryIds"];
    
    [dic setValue:jsonInfoDic forKey:@"JsonInfo"];
    
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *param=[NSString stringWithFormat:@"Params=%@&Command=ShopManager/EditCustomerInfo",string];
    NSLog(@"http://passport.admin.3weijia.com/mnmnhwap.axd?%@",param);
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    return request;
}
#pragma mark 文件操作
/*
 功能：向plist文件中写入数据
 输入：name：文件名
 输出：null
 */
-(void)writeToPlist:(NSString*)plistName data:(id)data
{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSLog(@"%@",plistPath);
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:plistName];
    
    //写入数据
    [data writeToFile:filename atomically:YES];
}

/*
 功能：读取plist文件数据
 输入：name：plist文件名
 输出：plist数据
 */
-(NSMutableArray *)readplistData1:(NSString*)plistName
{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSLog(@"%@",plistPath);
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:plistName];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:filename];
    return array;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
