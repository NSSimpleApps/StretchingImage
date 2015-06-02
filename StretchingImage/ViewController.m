//
//  ViewController.m
//  StretchingImage
//
//  Created by NSSimpleApps on 01.12.14.
//  Copyright (c) 2014 NSSimpleApps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (assign, nonatomic) CGFloat angle;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
        
    if ([sender state] == UIGestureRecognizerStateBegan) {
            
        CGPoint firstPoint = [sender locationOfTouch:0 inView:sender.view];
        CGPoint secondPoint = [sender locationOfTouch:1 inView:sender.view];
        self.angle = atan2f(secondPoint.y - firstPoint.y, secondPoint.x - firstPoint.x);
            
    } else if ([sender state] == UIGestureRecognizerStateChanged) {
            
        CGFloat scale = sender.scale;
        sender.view.layer.transform = [self transformWithAngle:self.angle
                                                         scale:scale];
            
    } else if ([sender state] == UIGestureRecognizerStateEnded) {
            
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.delegate = self;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            
        CGFloat scale = sender.scale;
        
        CATransform3D t1 = [self transformWithAngle:self.angle scale:1.f + 1.f*(scale - 1.f)];
        CATransform3D t2 = [self transformWithAngle:self.angle scale:1.f/(1.f + 1.f*(scale - 1.f))];
        CATransform3D t3 = [self transformWithAngle:self.angle scale:1.f + 2.f*(scale - 1.f)/3.f];
        CATransform3D t4 = [self transformWithAngle:self.angle scale:1.f/(1.f + 2.f*(scale - 1.f)/3.f)];
        CATransform3D t5 = [self transformWithAngle:self.angle scale:1.f + 1.f*(scale - 1.f)/3.f];
        CATransform3D t6 = [self transformWithAngle:self.angle scale:1.f/(1.f + 1.f*(scale - 1.f)/3.f)];
        CATransform3D t7 = CATransform3DIdentity;//[self transformWithAngle:self.angle scale:1.f];
            
            
        NSArray *values = @[[NSValue valueWithCATransform3D:t1],
                            [NSValue valueWithCATransform3D:t2],
                            [NSValue valueWithCATransform3D:t3],
                            [NSValue valueWithCATransform3D:t4],
                            [NSValue valueWithCATransform3D:t5],
                            [NSValue valueWithCATransform3D:t6],
                            [NSValue valueWithCATransform3D:t7]];
            
        animation.values = values;
        animation.duration = 1;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
            
        [sender.view.layer addAnimation:animation forKey:@"bouncing"];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    self.imageView.layer.transform = CATransform3DIdentity;
}

- (CATransform3D)transformWithAngle:(CGFloat)angle scale:(CGFloat)scale {
    
    if (scale == 1.f) {
        
        return CATransform3DIdentity;
    }
    
    CATransform3D rotationTransform = CATransform3DMakeRotation(angle, 0.f, 0.f, 1.f);
    CATransform3D scaleTransform = CATransform3DScale(rotationTransform, scale, 1.f, 1.f);
    CATransform3D anotherRotationTransform = CATransform3DRotate(scaleTransform, -angle, 0.f, 0.f, 1.f);
    
    return anotherRotationTransform;
}

@end
