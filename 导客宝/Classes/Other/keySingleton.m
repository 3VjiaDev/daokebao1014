//
//  keySingleton.m
//  导客宝
//
//  Created by 3Vjia on 15/10/15.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "keySingleton.h"

@implementation keySingleton

static keySingleton *instance = nil;

+(keySingleton*)initKeySingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[keySingleton alloc]init];
    });
    return instance;
}

-(id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}
@end
