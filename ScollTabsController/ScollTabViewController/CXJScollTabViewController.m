//
//  ViewController.m
//  ScollTabsController
//
//  Created by pro on 2018/5/22.
//  Copyright © 2018年 ChenXiaoJun. All rights reserved.
//  适配iphoneX

#pragma mark - 宏定义开始

#define kTopSafeHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kBottomSafeHeight kStatusBarHeight > 20 ? 34 : 0
#define kNavBarHeight 44.0
#define kTabbarHeight 49.0
#define ScreenW [[UIScreen mainScreen] bounds].size.width
#define ScreenH [[UIScreen mainScreen] bounds].size.height

#pragma mark - 宏定义结束


#import "CXJScollTabViewController.h"

@interface CXJScollTabViewController ()<UIScrollViewDelegate>

/** 标题滚动视图 */
@property (nonatomic,weak) UIScrollView *tabScrollView;

/** 内容滚动视图 */
@property (nonatomic,weak) UIScrollView *contentScrollView;

/** 标题视图内所有按钮 */
@property (nonatomic,strong) NSMutableArray *tabBtns;

/** 当前选中标题按钮 */
@property (nonatomic,weak) UIButton *selectedBtn;

/** 控制器是否第一次加载 */
@property (nonatomic,assign,getter=isVcLoaded) BOOL vcLoaded;


@end

@implementation CXJScollTabViewController
#pragma mark - 懒加载开始
-(NSMutableArray *)tabBtns
{
    if (!_tabBtns) {
        _tabBtns = [NSMutableArray array];
    }
    return _tabBtns;
}

#pragma mark - 懒加载结束
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isVcLoaded == NO) {
        [self setUp];
        self.vcLoaded = YES;
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];

    
}


-(void)setUp
{
    //*********获取数据
    ({
        //获取个数
        NSInteger rows = 0;
        if ([self.dataDelegate respondsToSelector:@selector(numberOfRowsInScollTabVC:)]) {
            rows = [self.dataDelegate numberOfRowsInScollTabVC:self];
        }
        //获取子控制器及标题
        if ([self.dataDelegate respondsToSelector:@selector(scollTabVC:viewControllerForRowAtIndex:)] && [self.dataDelegate respondsToSelector:@selector(scollTabVC:titleForRowAtIndex:)]) {
            for (int i=0; i<rows; i++) {
                UIViewController *vc = [self.dataDelegate scollTabVC:self viewControllerForRowAtIndex:i];
                NSString *title = [self.dataDelegate scollTabVC:self titleForRowAtIndex:i];
                if (!vc || !title || !title.length) continue;
                
                vc.title = title;
                [self addChildViewController:vc];
            }
        }
        
    });
    
    //*********如果没有设置任何数据则什么也不显示
    if (!self.childViewControllers.count) return;
    
    
    
    //*********添加tabScrollView
    UIScrollView *tabScrollView = ({
        UIScrollView *tabScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopSafeHeight+kNavBarHeight, ScreenW, 50.0)];
        tabScrollView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        tabScrollView.showsHorizontalScrollIndicator = NO;
        tabScrollView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            tabScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        tabScrollView;
    });
    
    [self.view addSubview:self.tabScrollView = tabScrollView];
    
    
    
    //*********添加contentScrollView
    UIScrollView *contentScrollView = ({
        CGFloat maxTabY = CGRectGetMaxY(tabScrollView.frame);
        UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, maxTabY, ScreenW, ScreenH - maxTabY)];
        contentScrollView.backgroundColor = [UIColor greenColor];
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.bounces = NO;
        contentScrollView.pagingEnabled = YES;
        contentScrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * ScreenW, contentScrollView.bounds.size.height);
        contentScrollView;
    });
    
    [self.view addSubview:self.contentScrollView = contentScrollView];
    
    
    
    
    
    //*********根据子控件创建tabs按钮集合并添加到tabScrollView,并设置滚动范围
    ({
        CGFloat tabBtnW = 90.0;
        CGFloat tabBtnX = 0;
        for (int i=0; i<self.childViewControllers.count; i++) {
            NSString *title = [self.childViewControllers[i] title];
            if (title.length <= 0) continue;
            UIButton *tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tabBtnX = tabBtnW * i;
            tabBtn.frame = CGRectMake(tabBtnX, 0, tabBtnW, self.tabScrollView.bounds.size.height);
            [tabBtn setTitle:title forState:UIControlStateNormal];
            [tabBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [tabBtn addTarget:self action:@selector(didTapTabsBtn:) forControlEvents:UIControlEventTouchDown];
            tabBtn.tag = i;
            [self.tabScrollView addSubview:tabBtn];
            [self.tabBtns addObject:tabBtn];
        }
        //设置tab滚动范围
        self.tabScrollView.contentSize = CGSizeMake(self.tabBtns.count * tabBtnW, self.tabScrollView.bounds.size.height);
    });
    
    
    //*********设置默认选中
    ({
        if (self.tabBtns.count) {
            [self didTapTabsBtn:self.tabBtns[self.selectedIndex]];
        }
    });
}

#pragma mark - 设置当前选中时赋值给选中索引
-(void)setSelectedBtn:(UIButton *)selectedBtn
{
    _selectedBtn = selectedBtn;
    _selectedIndex = selectedBtn.tag;
}


#pragma mark - 当前控制器相关方法
/**
 点击tabScrollView上的标题按钮
 
 @param button 按钮
 */
-(void)didTapTabsBtn:(UIButton *)button
{
    //*********添加子控制器view到滚动时图,并滚动到对应的控制器
    ({
        UIViewController *childVC = self.childViewControllers[button.tag];
        CGFloat offsetX = button.tag * ScreenW;
        
        if (!childVC.view.superview) {
            childVC.view.frame = CGRectMake(offsetX, 0, ScreenW, self.contentScrollView.bounds.size.height);
            [self.contentScrollView addSubview:childVC.view];
        }
        
        [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    });
    
    
    //*********标题缩放
    ({
        if (self.selectedBtn) {
            self.selectedBtn.transform = CGAffineTransformIdentity;
        }
        button.transform = CGAffineTransformMakeScale(1.2, 1.2);
    });
    
    
    
    //*********设置记录当前选中按钮
    ({
        if (self.selectedBtn) self.selectedBtn.selected = NO;
        button.selected = YES;
        self.selectedBtn = button;
    });
    
    //*********回调代理点击tab事件
    ({
        if ([self.delegate respondsToSelector:@selector(scollTabVC:didSelectRowAtIndex:)]) {
            [self.delegate scollTabVC:self didSelectRowAtIndex:self.selectedIndex];
        }
    });
    
}



#pragma mark - contentScrollView代理
//滚动停止时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger idx = scrollView.contentOffset.x / ScreenW;
    UIButton *curBtn = self.tabBtns[idx];
    
    //*********滚动到对应的控制器
    ({
        if (self.tabBtns.count > idx && idx != self.selectedIndex) {
            [self didTapTabsBtn:curBtn];
        }
    });
    
    
    
    //*********滚动标题到中间
    ({
        CGFloat offsetX = curBtn.center.x - (ScreenW * 0.5);
        if (offsetX < 0) {
            offsetX = 0;
        }
        CGFloat maxScrollW = self.tabScrollView.contentSize.width - ScreenW;
        if (offsetX > maxScrollW) {
            offsetX = maxScrollW;
        }
        [self.tabScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    });
    
}

//滚动时调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x / ScreenW;
    NSInteger leftIdx = (NSInteger)offsetX;
    NSInteger rightIdx = leftIdx + 1;
    
    UIButton *leftBtn = self.tabBtns[leftIdx];
    UIButton *rightBtn;
    if (rightIdx < self.tabBtns.count) {
        rightBtn = self.tabBtns[rightIdx];
    }
    
    CGFloat changeR = offsetX - leftIdx;
    CGFloat changeL = 1 - changeR;
    
    //*********标题文字缩放
    ({
        leftBtn.transform = CGAffineTransformMakeScale(changeL * 0.2 + 1, changeL * 0.2 + 1);
        rightBtn.transform = CGAffineTransformMakeScale(changeR * 0.2 + 1, changeR * 0.2 + 1);
    });
    
    //*********标题文字渐变
    ({
        [leftBtn setTitleColor:[UIColor colorWithRed:changeL green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor colorWithRed:changeR green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
    });
}




@end
