//
//  OWXMagicStoryViewController.m
//  LeapParent
//
//  Created by 王史超 on 2018/6/20.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXMagicStoryViewController.h"
#import "OWXImageViewController.h"

@interface OWXMagicStoryViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, strong) NSMutableArray<OWXImageViewController *> *imageArray;

@end

@implementation OWXMagicStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建数据源
    for (int i = 1; i <= 12; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        OWXImageViewController *imageVC = [[OWXImageViewController alloc] init];
        imageVC.image = image;
        [self.imageArray addObject:imageVC];
    }
    
    //设置第三个参数
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    
    //初始化UIPageViewController
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageViewController = pageViewController;
    //指定代理
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    //设置frame
    pageViewController.view.frame = self.view.bounds;
    //是否双面显示，默认为NO
    pageViewController.doubleSided = NO;
    //设置首页显示数据
    OWXImageViewController *imageViewController = [self createImage:0];
    [pageViewController setViewControllers:@[imageViewController]
                                 direction:UIPageViewControllerNavigationDirectionReverse
                                  animated:YES
                                completion:nil];
    
    //添加pageViewController到Controller
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    
    [self.view addSubview:self.backButton];
    
}

//获取指定显示controller
- (OWXImageViewController *)createImage:(NSInteger)integer {
    return [self.imageArray objectAtIndex:integer];
}

//获取显示controller元素下标
- (NSInteger)indexWithController:(OWXImageViewController *)vc {
    return [self.imageArray indexOfObject:vc];
}

#pragma mark - UIPageViewControllerDataSource
//显示前一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger index = [self indexWithController:(OWXImageViewController *)viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index--;
    
    return [self createImage:index];
}

//显示下一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexWithController:(OWXImageViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == self.imageArray.count) {
        return nil;
    }
    
    return [self createImage:index];
    
}

//// 来展示页指示器控件
////返回页控制器中页的数量
//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
//    return self.imageArray.count;
//}
//
////返回页控制器中当前页的索引
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
//    return 0;
//}

#pragma mark - UIPageViewControllerDelegate
//翻页视图控制器将要翻页时执行的方法
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    NSLog(@"将要翻页也就是手势触发时调用方法");
    pageViewController.view.userInteractionEnabled = NO;
}

//可以通过返回值重设书轴类型枚举
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return UIPageViewControllerSpineLocationMin;
}

//防止上一个动画还没有结束,下一个动画就开始了
//当用户从一个页面转向下一个或者前一个页面,或者当用户开始从一个页面转向另一个页面的途中后悔了,并撤销返回到了之前的页面时,将会调用这个方法。假如成功跳转到另一个页面时,transitionCompleted 会被置成 YES,假如在跳转途中取消了跳转这个动作将会被置成 NO。
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if(finished) {
        // 无论有无翻页，只要动画结束就恢复交互。
        pageViewController.view.userInteractionEnabled = YES;
    }
    else {
        NSLog(@"finished----%d,completed-----%d",finished,completed);
    }
}

- (NSMutableArray<OWXImageViewController *> *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
