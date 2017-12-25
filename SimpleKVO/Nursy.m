//
//  Nursy.m
//  SimpleKVO
//
//  Created by lucky on 2017/12/25.
//  Copyright © 2017年 lucky. All rights reserved.
//

#import "Nursy.h"

#import "NSObject+KVO.h"

@implementation Nursy

- (void)observeNewValue:(NSObject *)newValue {
    NSLog(@"%@ 是什么..", newValue);
}

@end
