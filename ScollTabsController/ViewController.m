//
//  ViewController.m
//  ScollTabsController
//
//  Created by pro on 2018/5/22.
//  Copyright © 2018年 ChenXiaoJun. All rights reserved.
//  适配iphoneX




#import "ViewController.h"
#import "RecommentViewController.h"
#import "VideoViewController.h"
#import "LocalViewController.h"
#import "PictureViewController.h"
#import "CarViewController.h"
#import "NBAViewController.h"
#import "HouseViewController.h"
@interface ViewController ()<CXJScollTabDataDelegate,CXJScollTabDelegate>

/** viewControllers */
@property (nonatomic,strong) NSArray<UIViewController *> *viewControllers;

/** titles */
@property (nonatomic,strong) NSArray<NSString *> *titles;
@end

@implementation ViewController
#pragma mark - lazy
-(NSArray<NSString *> *)titles
{
    if (!_titles) {
        _titles = @[
                    @"推荐",
                    @"视频",
                    @"本地",
                    @"图库",
                    @"汽车",
                    @"NBA",
                    @"房产"
                    ];
    }
    return _titles;
}
-(NSArray<UIViewController *> *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = @[
                        [[RecommentViewController alloc] init],
                        [[VideoViewController alloc] init],
                        [[LocalViewController alloc] init],
                        [[PictureViewController alloc] init],
                        [[CarViewController alloc] init],
                        [[NBAViewController alloc] init],
                        [[HouseViewController alloc] init]
                        ];
    }
    return _viewControllers;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"网易标题";
    
    //设置代理数据源
    self.dataDelegate = self;
    self.delegate = self;
    
    
    //默认选中
    self.selectedIndex = 2;

}


#pragma mark - 数据源代理
/**
 栏目总数
 
 @param scrollTabVC self
 @return 栏目数
 */
-(NSInteger)numberOfRowsInScollTabVC:(CXJScollTabViewController *)scrollTabVC
{
    return 7;
}

/**
 返回栏目控制器
 
 @param scrollTabVC self
 @param index 索引
 @return 控制器
 */
-(nonnull __kindof UIViewController *)scollTabVC:(CXJScollTabViewController *)scrollTabVC viewControllerForRowAtIndex:(NSInteger)index
{
    return self.viewControllers[index];
}


/**
 返回栏目标题
 
 @param scrollTabVC self
 @param index 索引 
 @return 标题
 */
-(nonnull NSString *)scollTabVC:(CXJScollTabViewController *)scrollTabVC titleForRowAtIndex:(NSInteger)index
{
    return self.titles[index];
}

#pragma mark - 事件代理
-(void)scollTabVC:(CXJScollTabViewController *)scrollTabVC didSelectRowAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld个标题",index);
}


@end
