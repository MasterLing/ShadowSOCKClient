//
//  ViewController.m
//  ShadowSOCKClient
//
//  Created by linyu on 4/7/16.
//  Copyright © 2016 linyu. All rights reserved.
//

#import "ViewController.h"
#import "MyURLProtocol.h"
#import "ShadowsocksRunner.h"

@interface ViewController ()
{
    UIWebView *_webView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_webView];
    // Do any additional setup after loading the view, typically from a nib.
    [NSURLProtocol registerClass:[MyURLProtocol class]];
    
    dispatch_queue_t proxy = dispatch_queue_create("proxy", NULL);
    dispatch_async(proxy, ^{
        [self runProxy];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:@"http://www.google.com/"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)runProxy {
    [ShadowsocksRunner setDefaultConfig];
    [ShadowsocksRunner reloadConfig];
    for (; ;) {
        if ([ShadowsocksRunner runProxy]) {
            sleep(1);
        } else {
            sleep(2);
        }
    }
}

@end
