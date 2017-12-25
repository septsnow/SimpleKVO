//
//  NSObject+KVO.h
//  SimpleKVO
//
//  Created by lucky on 2017/12/24.
//  Copyright © 2017年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVO)

- (void)ls_addObserver:(NSObject *)observer forKey:(NSString *)key;

- (void)ls_removeObserver:(NSObject *)observer forKey:(NSString *)key;

@end

@interface NSObject (Observering)

- (void)observeNewValue:(NSObject *)newValue;

@end
