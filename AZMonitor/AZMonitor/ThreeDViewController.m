//
//  ThreeDViewController.m
//  AZMonitor
//
//  Created by zhangjixin7 on 2020/9/28.
//  Copyright © 2020 app.jixin. All rights reserved.
//

#import "ThreeDViewController.h"

#define WIDTH 50
#define HEIGHT 10
#define DEPTH 10
#define SIZE 100
#define SPACING 150
#define CAMERA_DISTANCE 500

@interface ThreeDViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ThreeDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    [self.view addSubview:self.scrollView];
    //set content size
    self.scrollView.contentSize = CGSizeMake((WIDTH - 0)*SPACING, (HEIGHT - 0)*SPACING);
    //log
    NSLog(@"displayed: %i", DEPTH*HEIGHT*WIDTH);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //set up perspective transform
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = -1.0 / CAMERA_DISTANCE;
            self.scrollView.layer.sublayerTransform = transform;

            //create layers
            for (int z = DEPTH - 1; z >= 0; z--) {
                for (int y = 0; y < HEIGHT; y++) {
                    for (int x = 0; x < WIDTH; x++) {
                        //create layer
//                        CALayer *layer = [CALayer layer];
//                        layer.frame = CGRectMake(0, 0, SIZE, SIZE);
//                        layer.position = CGPointMake(x*SPACING, y*SPACING);
//                        layer.zPosition = -z*SPACING;
//                        //set background color
//                        layer.backgroundColor = [UIColor colorWithWhite:1-z*(1.0/DEPTH) alpha:1].CGColor;
//                        //attach to scroll view
//                        [self.scrollView.layer addSublayer:layer];
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x*SPACING, y*SPACING, SIZE, SIZE)];
                        label.text = [NSString stringWithFormat:@"(x = %d, y = %d)", x, y];
                        label.layer.zPosition = -z*SPACING;
                        label.layer.backgroundColor = [UIColor colorWithWhite:1-z*(1.0/DEPTH) alpha:1].CGColor;
                        [self.scrollView.layer addSublayer:label.layer];
                    }
                }
            }
        
        [self.scrollView setZoomScale:2 animated:YES];
    });
}

- (void)viewWillLayoutSubviews {
    self.scrollView.frame = self.view.bounds;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.maximumZoomScale = 3;
    }
    return _scrollView;
}

@end
