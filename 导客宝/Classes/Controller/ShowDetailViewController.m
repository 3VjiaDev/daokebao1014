//
//  ShowDetailViewController.m
//  导客宝
//
//  Created by apple1 on 15/10/8.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "ShowDetailViewController.h"
#import "UMSocial.h"

@interface ShowDetailViewController ()<UMSocialUIDelegate>

@end

@implementation ShowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view.
    self.qjtID = [qjtSingleton initQJTSingleton].qjtId;
    self.qjtName = [qjtSingleton initQJTSingleton].qjtName;
    self.isCollenct = [qjtSingleton initQJTSingleton].isCollent;
    
    NSString *UrlString = [NSString stringWithFormat:@"%@%@",[Tool qjtRequestUrl],self.qjtID];
    NSLog(@"%@",UrlString);
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:UrlString]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)share:(id)sender {


    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"55fa8188e0f55ae5bb000b6a"
                                      shareText:@"分享"
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];
    //[UMSocialData defaultData].extConfig.wechatSessionData.url = shareLink;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"111";
   // [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareLink;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"111";
    //[UMSocialData defaultData].extConfig.qqData.url = shareLink;
    [UMSocialData defaultData].extConfig.qqData.title =  @"111";
    //[self addShareCount];
}

- (IBAction)collect:(id)sender {
}

- (IBAction)return:(id)sender {
}


@end
