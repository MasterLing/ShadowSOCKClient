//
//  MyURLProtocol.m
//  LyUtilities
//
//  Created by linyu on 3/31/16.
//  Copyright © 2016 linyu. All rights reserved.
//

#import "MyURLProtocol.h"

//static NSString * kURLProxyKey = @"URLProxyKey";

@interface MyURLProtocol() <NSURLSessionDataDelegate,NSURLSessionTaskDelegate,NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *connection;

@end


@implementation MyURLProtocol
{
    NSURLSession *_urlSession;
}

+(BOOL)canInitWithRequest:(NSURLRequest*)request
{
    return YES;
}
- (void) startLoading {
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    config.connectionProxyDictionary = @
    {
        @"SOCKSEnable":@YES,
        @"SOCKSProxy":@"127.0.0.1",
        @"SOCKSPort":@1090
    };
    
    NSURLSession*session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    self.connection = [session dataTaskWithRequest:newRequest];
    [self.connection resume];
}


+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)reques
{
    return reques;
}

- (void) stopLoading {
    [self.connection cancel];
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if( error ) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

@end
