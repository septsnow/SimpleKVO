//
//  ViewController.m
//  SimpleKVO
//
//  Created by lucky on 2017/12/24.
//  Copyright © 2017年 lucky. All rights reserved.
//

#import "ViewController.h"
#import "Patient.h"
#import "Nursy.h"
#import "NSObject+KVO.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Patient* patient = [[Patient alloc] init];
    [patient setTemperature:@40];
    
    Nursy* nursy = [[Nursy alloc] init];
    
    [patient ls_addObserver:nursy forKey:@"temperature"];
    
    [patient setTemperature:@35];
    
}

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
