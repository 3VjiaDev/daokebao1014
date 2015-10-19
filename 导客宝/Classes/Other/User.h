//
//  User.h
//  导客宝
//
//  Created by 3Vjia on 15/10/19.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic, strong)NSString *name;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *address;
@property(nonatomic, strong)NSString *mark;

@property(nonatomic,strong)NSMutableArray *styleAry;

@end
