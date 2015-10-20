//
//  DetailViewController.m
//  导客宝
//
//  Created by apple1 on 15/10/12.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "DetailViewController.h"
#import "UMSocial.h"

@interface DetailViewController ()<UMSocialUIDelegate>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.qjtID = [qjtSingleton initQJTSingleton].qjtId;
    self.qjtName = [qjtSingleton initQJTSingleton].qjtName;
    self.isCollenct = [qjtSingleton initQJTSingleton].isCollent;
    
    NSString *UrlString = [NSString stringWithFormat:@"%@%@",[Tool qjtRequestUrl],self.qjtID];
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

@end
