//
//  ViewController.m
//  NSArrayPropertyDemo
//
//  Created by zzg on 2018/5/7.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, copy) NSArray *arrayProperty;
@property (nonatomic, strong) NSArray *strongArrayProperty;

@property (nonatomic, copy) NSMutableArray *mutableArrayProperty;
@property (nonatomic, strong) NSMutableArray *strongMutableArrayProperty;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //可变数组
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [mutableArray addObject:@"1"];
    [mutableArray addObject:@"2"];
    [mutableArray addObject:@"3"];
    
    //使用可变数组给不可变数组赋值
    {
        self.arrayProperty = mutableArray;//拷贝一份对象
        self.strongArrayProperty = mutableArray;//指针指向新的对象
        
        [mutableArray removeLastObject];
        
        //不可变数组，使用copy关键字：没问题
        NSLog(@"class Of arrayProperty:%@", NSStringFromClass([self.arrayProperty class]));//__NSArrayI
        NSLog(@"arrayProperty:%@", self.arrayProperty);//1,2,3
        
        //不可变数组，使用strong关键字：赋值时，指针指向了可变数组对象，其值会被无意中改变
        NSLog(@"class Of strongArrayProperty:%@", NSStringFromClass([self.strongArrayProperty class]));//__NSArrayM（使用strong关键字）
        NSLog(@"strongArrayProperty:%@", self.strongArrayProperty);//1,2（值被无意中改变）
    }
    
    //不可变数组给可变数组赋值
    {
        //不可变数组直接赋值给可变数组会报警告
        NSArray *array = [NSArray arrayWithObjects:@"a", @"b", @"c", nil];
//        self.mutableArray = array;//报警告：Incompatible pointer types assigning to 'NSMutableArray *' from 'NSArray *'
//        self.strongMutableArray = array;//报警告：Incompatible pointer types assigning to 'NSMutableArray *' from 'NSArray *'
        
        //不可变数组，调用copy方法，返回的还是不可变数组
        //下面相当于是直接给可变数组赋值不可变数组，只是copy方法的返回值是id，编译器不会报警告
        self.mutableArrayProperty = [array copy];
        self.strongMutableArrayProperty = [array copy];
        NSLog(@"class Of mutableArrayProperty:%@", NSStringFromClass([self.mutableArrayProperty class]));//__NSArrayI（使用copy关键字）
        NSLog(@"class Of strongMutableArrayProperty:%@", NSStringFromClass([self.strongMutableArrayProperty class]));//__NSArrayI（使用strong关键字）
        //这里如果两个属性调用增删改查数组的方法，会崩溃

        //不可变数组，调用mutableCopy方法，返回的是可变数组
        self.mutableArrayProperty = [array mutableCopy];//mutableCopy虽然返回了一个可变数组，但是setter方法中对传入的参数执行了{_mutableArrayProperty = [[array mutableCopy] copy];}，所以self.mutableArrayProperty类型被改变
        self.strongMutableArrayProperty = [array mutableCopy];
        NSLog(@"class Of mutableArrayProperty:%@", NSStringFromClass([self.mutableArrayProperty class]));//__NSArrayI（使用copy关键字）
        NSLog(@"class Of strongMutableArrayProperty:%@", NSStringFromClass([self.strongMutableArrayProperty class]));//__NSArrayM（使用strong关键字）
    }
    
    //可变数组
    {
        self.mutableArrayProperty = mutableArray;//setter方法中执行了{_mutableArrayProperty = [mutableArray copy];}，所以self.mutableArrayProperty类型被改变
        self.strongMutableArrayProperty = mutableArray;
        
        NSLog(@"class Of mutableArrayProperty:%@", NSStringFromClass([self.mutableArrayProperty class]));//__NSArrayI（类型被改变，失去了可变属性，调用修改数组的方法会崩溃）
        //[self.mutableArray removeLastObject];//崩溃

        NSLog(@"class Of strongMutableArrayProperty:%@", NSStringFromClass([self.strongMutableArrayProperty class]));//__NSArrayM
        [mutableArray removeLastObject];
        
        NSLog(@"mutableArrayProperty:%@", self.mutableArrayProperty);//1,2
        NSLog(@"strongMutableArrayProperty:%@", self.strongMutableArrayProperty);//1
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
