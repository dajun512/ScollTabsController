//
//  CXJScollTabViewController.h
//  ScollTabsController
//
//  Created by pro on 2018/5/23.
//  Copyright © 2018年 ChenXiaoJun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXJScollTabViewController;

#pragma mark ---------------- 代理开始 ------------------

@protocol CXJScollTabDataDelegate <NSObject>


@required
/**
 栏目总数

 @param scrollTabVC self
 @return 栏目数
 */
-(NSInteger)numberOfRowsInScollTabVC:(CXJScollTabViewController *)scrollTabVC;

/**
 返回栏目控制器

 @param scrollTabVC self
 @param index 索引
 @return 控制器
 */
-(nonnull __kindof UIViewController *)scollTabVC:(CXJScollTabViewController *)scrollTabVC viewControllerForRowAtIndex:(NSInteger)index;


/**
 返回栏目标题

 @param scrollTabVC self
 @param index 索引
 @return 标题
 */
-(nonnull NSString *)scollTabVC:(CXJScollTabViewController *)scrollTabVC titleForRowAtIndex:(NSInteger)index;

@end


@protocol CXJScollTabDelegate <NSObject>


/**
 选中某个栏目

 @param scrollTabVC self
 @param index 索引
 */
-(void)scollTabVC:(CXJScollTabViewController *)scrollTabVC didSelectRowAtIndex:(NSInteger)index;

@end

#pragma mark ---------------- 代理结束 ------------------

#pragma mark - 使用方法:1.继承该类,实现数据源代理即可

@interface CXJScollTabViewController : UIViewController

/** 获取当前选中索引 */
@property (nonatomic,assign) NSInteger selectedIndex;

/** 数据源代理 */
@property (nonatomic,weak) id<CXJScollTabDataDelegate> dataDelegate;

/** 事件代理 */
@property (nonatomic,weak) id<CXJScollTabDelegate> delegate;


@end
