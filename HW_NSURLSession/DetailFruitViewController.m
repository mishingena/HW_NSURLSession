//
//  DetailFruitViewController.m
//  HW_NSURLSession
//
//  Created by Гена on 15.12.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "DetailFruitViewController.h"

@interface DetailFruitViewController () {
    NSURLSession *backgroundSession;
    NSURLSessionDownloadTask *getImage;
//    UIActivityIndicatorView *indicator;
//    NSMutableDictionary *dictImg;
}

@property (nonatomic, weak) IBOutlet UIImageView *detailImage;

@end

@implementation DetailFruitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.progressView setProgress:0 animated:NO];
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
//                                                          delegate:self
//                                                     delegateQueue:nil];
//    
////    dictImg  = [[NSMutableDictionary alloc] init];
////    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
////    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
////    indicator.center = self.view.center;
//    
//    NSURLSessionDownloadTask *getImage = [session downloadTaskWithURL:self.detailImageURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//        UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
//        dispatch_async (dispatch_get_main_queue(), ^{
//            self.detailImage.image = downloadedImage;
//        });
//    }];
//    [getImage resume];
    // Do any additional setup after loading the view.
    [self loadImage];
}

- (void)loadImage {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    backgroundSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    getImage = [backgroundSession downloadTaskWithURL:self.detailImageURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        dispatch_async (dispatch_get_main_queue(), ^{
            self.detailImage.image = downloadedImage;
        });
    }];
    [getImage resume];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
//    if (self.fruit.cachedLargeImage) {
//        self.detailImage.image = self.fruit.cachedLargeImage;
//    } else {
//        [indicator startAnimating];
//        [indicator setHidesWhenStopped:YES];
//        [self.view addSubview:indicator];
//        [[session dataTaskWithURL:self.detailImageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            UIImage *img = [UIImage imageWithData:data];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [indicator stopAnimating];
//                self.fruit.cachedLargeImage = img;
//                self.detailImage.image = img;
//            });
//        }] resume];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    [self.progressView setProgress:1 animated:YES];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    NSLog(@"download: %@ progress: %f", downloadTask, progress);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:progress animated:YES];
    });
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
