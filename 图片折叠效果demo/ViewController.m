//
//  ViewController.m
//  图片折叠效果demo
//
//  Created by 孙安鹏 on 2017/5/4.
//  Copyright © 2017年 孙安鹏. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
// 上半部分图片
@property (nonatomic, strong) UIImageView *topHalfImg;

// 下半部分图片
@property (nonatomic, strong) UIImageView *bottomHalfImg;

//上半部分透明view
@property (nonatomic, strong) UIView *alphaUpView;

// 阴影layer
@property (nonatomic, strong) CAGradientLayer *shadowLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self loadSubViews];
}

- (void)loadSubViews {
    
    // 下半部分
    self.bottomHalfImg = [[UIImageView alloc] init];
    
    _bottomHalfImg.frame = CGRectMake((self.view.frame.size.width - 200)/2, 200, 200, 100);//frame放在 anchorPoint之前 坐标系统会变

    _bottomHalfImg.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);//Layer(图层)的一个属性contentsRect使图片显示下半图
    
    _bottomHalfImg.layer.anchorPoint = CGPointMake(0.5, 0);//由锚点决定，上部分的锚点为（0.5，1），下部分的锚点为（0.5，0）,就能快速重叠
    
    _bottomHalfImg.image = [UIImage imageNamed:@"testPicture.jpg"];
    
    [self.view addSubview:self.bottomHalfImg];

    
    
    // 上半部分
    self.topHalfImg = [[UIImageView alloc] init];
    
    _topHalfImg.frame = CGRectMake((self.view.frame.size.width - 200)/2, 200, 200, 100);//frame放在 anchorPoint之前 坐标系统会变
    
    _topHalfImg.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);//Layer(图层)的一个属性contentsRect使图片显示上半图
    
    _topHalfImg.layer.anchorPoint = CGPointMake(0.5, 1);//上部分绕着底部中心旋转，所以设置上部分的锚点anchorPoint为（0.5，1）
    
    _topHalfImg.image = [UIImage imageNamed:@"testPicture.jpg"];
    
    [self.view addSubview:self.topHalfImg];

    
    
    // 添加UIPanGestureRecognizer平移手势
    self.alphaUpView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200)/2, 150, 200, 200)];
    
    [self.view addSubview:self.alphaUpView];
    
    UIPanGestureRecognizer *panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    
    [self.alphaUpView addGestureRecognizer:panGestureRec];
    
    // 旋转时使下半部分有渐变阴影
    // 创建渐变图层
    CAGradientLayer *shadowLayer = [CAGradientLayer layer];
    
    // 设置渐变颜色
    shadowLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
    
    shadowLayer.frame = _bottomHalfImg.bounds;
    
    _shadowLayer = shadowLayer;
    
    // 设置不透明度 0
    shadowLayer.opacity = 0;
    
    [_bottomHalfImg.layer addSublayer:shadowLayer];

}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)sender {
    
    // 获取手指偏移量
    CGPoint transP = [sender translationInView:_alphaUpView];
    
    // 初始化形变
    CATransform3D transform3D = CATransform3DIdentity;
    
    // 设置立体效果
    transform3D.m34 = -1 / 1000.0;
    
    // 计算折叠角度，因为需要逆时针旋转，所以取反
    CGFloat angle = -transP.y * M_PI / 200.0;
    
    _topHalfImg.layer.transform = CATransform3DRotate(transform3D, angle, 1, 0, 0);

    
    // 设置阴影不透明度
    _shadowLayer.opacity = transP.y * 1 / 200.0;
    
    //在手指抬起的时候，需要把阴影设置隐藏，不透明度为0；折叠图片还原，其实就是把形变清空。
    if (sender.state == UIGestureRecognizerStateEnded) { // 手指抬起
        // 还原
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            _topHalfImg.layer.transform = CATransform3DIdentity;
            
            // 还原阴影
            _shadowLayer.opacity = 0;
            
        } completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
