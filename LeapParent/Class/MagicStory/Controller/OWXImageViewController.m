//
//  OWXImageViewController.m
//  LeapParent
//
//  Created by 王史超 on 2018/6/20.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXImageViewController.h"

@interface OWXImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation OWXImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.image = _image;
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    
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
