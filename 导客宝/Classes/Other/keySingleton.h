//
//  keySingleton.h
//  导客宝
//
//  Created by 3Vjia on 15/10/15.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface keySingleton : NSObject

@property (strong,nonatomic) NSString *keyWord;

+(keySingleton*)initKeySingleton;

@end
