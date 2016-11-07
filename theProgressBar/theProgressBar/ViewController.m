//
//  ViewController.m
//  theProgressBar
//
//  Created by 曾绍鹏 on 2016/11/7.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "ViewController.h"
#import "SProgressView.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

CGFloat const SGProgressBarHeight = 2.5;
@interface ViewController ()
{
    
    __block int timeout;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)showSGProgressWithDuration:(float)duration remainSecond:(float)remainSecond
{
    SProgressView *progressView = [self progressView];
    progressView.progress = 1-(remainSecond/duration);
    timeout=remainSecond; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                progressView.progress = 1;
                if (progressView.progress >= 1) {
                    NSLog(@"over!");
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                progressView.progress = 1-(timeout/duration);
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (SProgressView *)progressView
{
    SProgressView *_progressView;
    for (UIView *subview in [self.view subviews])
    {
        if ([subview isKindOfClass:[SProgressView class]])
        {
            _progressView = (SProgressView *)subview;
        }
    }
    
    if (!_progressView)
    {
        _progressView = [[SProgressView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SGProgressBarHeight)];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:_progressView];
    }
    
    return _progressView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
