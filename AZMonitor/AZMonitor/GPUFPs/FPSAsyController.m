//
//  FPSAsyController.m
//  AZMonitor
//
//  Created by zhangjixin7 on 2020/9/21.
//  Copyright © 2020 app.jixin. All rights reserved.
//
//
#import "FPSAsyController.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/EAGL.h>


/// 参考文档：https://zsisme.gitbooks.io/ios-/content/chapter6/caeagllayer.html
@interface FPSAsyController ()<CALayerDelegate> {
    NSUInteger _count;
    NSTimeInterval _lastTime;
    NSTimeInterval _llll;
}

@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic, strong) CAEAGLLayer *glLayer;
@property (nonatomic, assign) GLuint framebuffer;
@property (nonatomic, assign) GLuint colorRenderbuffer;
@property (nonatomic, assign) GLint framebufferWidth;
@property (nonatomic, assign) GLint framebufferHeight;
@property (nonatomic, strong) GLKBaseEffect *effect;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) NSThread *subThread;
@property (nonatomic, assign) int totalFPS;
@property (nonatomic, assign) int maxFPS;
@property (nonatomic, assign) int minFPS;
@property (nonatomic, assign) int FPSRecordCount;
@property (nonatomic, strong) UILabel *fpsLabel;//测试代码

@end

@implementation FPSAsyController

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static FPSAsyController *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[FPSAsyController alloc] init];
    });
    return _instance;
}

- (void)openFPSMonitor
{
    [self performSelector:@selector(addGL) onThread:_subThread withObject:nil waitUntilDone:NO modes:[[NSSet setWithObject:NSRunLoopCommonModes] allObjects]];
}

- (void)closeFPSMonitor
{
    [self performSelector:@selector(clearGL) onThread:_subThread withObject:nil waitUntilDone:NO modes:[[NSSet setWithObject:NSRunLoopCommonModes] allObjects]];
    [self performSelector:@selector(invaildTimer) onThread:_subThread withObject:nil waitUntilDone:NO modes:[[NSSet setWithObject:NSRunLoopCommonModes] allObjects]];
}

- (void)clearGL
{
    [self tearDownBuffers];
    [EAGLContext setCurrentContext:nil];
}

- (void)addGL
{
    if (_glContext) {
        //set up context
        [EAGLContext setCurrentContext:_glContext];
    }
    //set up buffers
    [self setUpBuffers];
    [self setUpTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    self.view.frame = CGRectMake(100, 88, 10, 10);
    self.view.backgroundColor = [UIColor brownColor];
    //set up layer
    [self setUpLayer];;

    // set up base effect
    self.effect = [[GLKBaseEffect alloc] init];

    //set up thread
    [self setUpThread];
}

- (void)setUpLayer
{
    _glLayer = [CAEAGLLayer layer];
    _glLayer.frame = CGRectMake(0, 0, 10, 10);
    _glLayer.delegate = self;
    _glLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking:@NO, kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};
    GLKView *view = (GLKView *)self.view;
    [view.layer addSublayer:_glLayer];
}

- (void)setUpThread
{
    if (!_subThread) {
        _subThread = [[NSThread alloc] initWithTarget:self selector:@selector(startThread) object:nil];
        _subThread.name = @"JDSHFPSThread";
        [_subThread start];
    }
    [self performSelector:@selector(setUpTimer) onThread:_subThread withObject:nil waitUntilDone:NO modes:[[NSSet setWithObject:NSRunLoopCommonModes] allObjects]];
}

- (void)startThread
{
    if(_glContext == nil) {
        _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    if (!_glContext) {
        return;
    }
    //set up context
    [EAGLContext setCurrentContext:_glContext];
    //set up buffers
    [self setUpBuffers];
    [[NSRunLoop currentRunLoop] run];
}

- (void)setUpTimer
{
    if (!_link) {
        __weak typeof(self) weakSelf = self;
        _link = [CADisplayLink displayLinkWithTarget:weakSelf selector:@selector(tick:)];
        [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)invaildTimer
{
    if (_link) {
        [_link invalidate];
        _link = nil;
    }
}

- (void)tick:(CADisplayLink *)link
{
    [self drawFrame];//V8.4.4上线，暂不支持gpu统计
    if (_lastTime == 0) {
        _lastTime = _link.timestamp;
        return;
    }
    _count++;
    NSTimeInterval delta = _link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = _link.timestamp;
    float fps = _count / delta;
    _count = 0;
    if (_FPSDelegate && [_FPSDelegate respondsToSelector:@selector(FPSCountFinish:)]) {
        [_FPSDelegate FPSCountFinish:fps];
    }
    //测试代码
    __weak typeof (self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof (self)strongSelf = weakSelf;
        CGFloat progress = fps / 60.0;
        UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
        strongSelf.fpsLabel.textColor = color;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d GPU FPS",(int)round(fps)]];
        strongSelf.fpsLabel.attributedText = text;
    });
}

- (void)setUpBuffers
{
    //set up frame buffer
    glGenFramebuffers(1, &_framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);

    //set up color render buffer
    glGenRenderbuffers(1, &_colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderbuffer);
    [_glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_glLayer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_framebufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_framebufferHeight);

    //check success
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object: %i", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}

- (void)drawFrame {
    //bind framebuffer & set viewport
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    glViewport(0, 0, _framebufferWidth, _framebufferHeight);

    [self.effect prepareToDraw];
    //clear the screen
    glClear(GL_COLOR_BUFFER_BIT); glClearColor(0.0, 0.0, 0.0, 1.0);

    //set up vertices
    GLfloat vertices[] = {
        -0.5f, -0.5f, -1.0f, 0.0f, 0.5f, -1.0f, 0.5f, -0.5f, -1.0f,
    };

    //set up colors
    GLfloat colors[] = {
        0.0f, 0.0f, 1.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f,
    };


    //draw triangle
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, colors);
    glDrawArrays(GL_TRIANGLES, 0, 3);

    //present render buffer
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)tearDownBuffers
{
    if (_framebuffer) {
        //delete framebuffer
        glDeleteFramebuffers(1, &_framebuffer);
        _framebuffer = 0;
    }

    if (_colorRenderbuffer) {
        //delete color render buffer
        glDeleteRenderbuffers(1, &_colorRenderbuffer);
        _colorRenderbuffer = 0;
    }
}

- (void)didEnterBackground:(NSNotification *)noti
{
    [self performSelector:@selector(invaildTimer) onThread:_subThread withObject:nil waitUntilDone:NO modes:[[NSSet setWithObject:NSRunLoopCommonModes] allObjects]];
}

//测试代码
- (UILabel *)fpsLabel
{
    if (!_fpsLabel) {
        _fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 150, 50)];
        _fpsLabel.backgroundColor = [UIColor blackColor];
        _fpsLabel.textColor = [UIColor whiteColor];

        [[UIApplication sharedApplication].keyWindow addSubview:_fpsLabel];
    }
    return _fpsLabel;
}

@end
