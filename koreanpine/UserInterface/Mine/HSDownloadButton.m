//
//  HSDownloadButton.m
//  
//
//  Created by Victor on 15/10/29.
//
//
#define SIDE_WEITH 3
#define _R 105.0/256
#define _G 146.0/256
#define _B 212.0/256
#define _A 1.0

#import "HSDownloadButton.h"

@implementation HSDownloadButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.progress = 0.0;
        self.r = _R;
        self.g = _G;
        self.b = _B;
        self.a = _A;
        }
    return self;
}
- (instancetype)init {
    if (self = [super init]) {
        self.progress = 0.0;
        self.r = _R;
        self.g = _G;
        self.b = _B;
        self.a = _A;
    }
    return self;
}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.r = _R;
//    self.g = _G;
//    self.b = _B;
//    self.a = _A;
//}
-(void) setProgress:(CGFloat) newProgress
{
    _progress = newProgress;
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.progress == 1.0) {
        return;
    }
    
    int radius, x, y;
    int offset = SIDE_WEITH;
    CGRect frame = self.frame;
    frame.size.width -= 2;
    frame.size.height -= 2;
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    if (frame.size.width > frame.size.height) {
        radius = frame.size.height;
        int delta = frame.size.width - radius;
        x = delta/2+1;
        y = 1;
        [[UIColor lightGrayColor] setFill];
        CGContextAddArc(context1, CGRectGetWidth(self.frame)*0.5, CGRectGetHeight(self.frame)*0.5, 16, 0, 2 * M_PI, 0);
        CGContextFillPath(context1);
        [[UIColor whiteColor] setFill];
        CGContextAddArc(context1, CGRectGetWidth(self.frame)*0.5, CGRectGetHeight(self.frame)*0.5, 13.5, 0, 2 * M_PI, 0);
        //    [[UIColor blackColor] setStroke];
        // 3.渲染 (注意, 画线只能通过空心来画)
        //    CGContextFillPath(ctx);
        CGContextFillPath(context1);
    } else {
        radius = frame.size.width;
        int delta = frame.size.height - radius;
        y = delta/2+1;
        x = 1;
        [[UIColor lightGrayColor] setFill];
        CGContextAddArc(context1, CGRectGetWidth(self.frame)*0.5, CGRectGetHeight(self.frame)*0.5, 16, 0, 2 * M_PI, 0);
        CGContextFillPath(context1);
        [[UIColor whiteColor] setFill];
        CGContextAddArc(context1, CGRectGetWidth(self.frame)*0.5, CGRectGetHeight(self.frame)*0.5, 13.5, 0, 2 * M_PI, 0);
        //    [[UIColor blackColor] setStroke];
        // 3.渲染 (注意, 画线只能通过空心来画)
        //    CGContextFillPath(ctx);
        CGContextFillPath(context1);
    }

    self.outerCircleRect = CGRectMake(x, y, radius, radius);
    self.innerCircleRect = CGRectMake(x+offset, y+offset, radius-2*offset , radius-2*offset);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGGradientRef myGradient;

    CGColorSpaceRef myColorspace;
  
    size_t num_locations = 3;
    
    CGFloat locations[3] = { 1.0, 1.0 ,1.0 };
    
    CGFloat components[12] = {
        1.0, 1.0 ,1.0, 1.0, 1.0 ,1.0, 1.0, 1.0 ,1.0, 1.0, 1.0 ,1.0
    }; // End colour
    
    myColorspace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components,locations, num_locations);
 
    CGPoint myStartPoint, myEndPoint;
    CGFloat myStartRadius, myEndRadius;
    myStartPoint.x = self.innerCircleRect.origin.x + self.innerCircleRect.size.width/2;
    myStartPoint.y = self.innerCircleRect.origin.y + self.innerCircleRect.size.width/2;
    myEndPoint.x = self.innerCircleRect.origin.x + self.innerCircleRect.size.width/2;
    myEndPoint.y = self.innerCircleRect.origin.y + self.innerCircleRect.size.width/2;
    myStartRadius = self.innerCircleRect.size.width/2 ;
    myEndRadius = self.outerCircleRect.size.width/2;
     CGContextSaveGState(context);
    CGContextMoveToPoint(context,
                         self.outerCircleRect.origin.x + self.outerCircleRect.size.width/2, // move to the top center of the outer circle
                         self.outerCircleRect.origin.y +1); // the Y is one more because we want to draw inside the bigger circles.
    // add an arc relative to _progress
    CGContextAddArc(context,
                   self.outerCircleRect.origin.x + self.outerCircleRect.size.width/2,
                    self.outerCircleRect.origin.y + self.outerCircleRect.size.width/2,
                    self.outerCircleRect.size.width/2-1,
                    -M_PI/2,
                    (-M_PI/2 + self.progress*2*M_PI), 0);
    CGContextAddArc(context,
                    self.outerCircleRect.origin.x + self.outerCircleRect.size.width/2,
                    self.outerCircleRect.origin.y + self.outerCircleRect.size.width/2,
                    self.outerCircleRect.size.width/2 - 9,
                    (-M_PI/2 + self.progress*2*M_PI),
                    -M_PI/2, 1);
   
    CGContextClosePath(context);
    // clip to the path stored in context
    CGContextClip(context);
       CGFloat components2[12] = {  self.r, self.g, self.b, self.a, // Start color
        self.r , self.g, self.b, self.a,
        self.r, self.g, self.b, self.a }; // End color
    
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components2,locations, num_locations);
    
    myStartPoint.x = self.innerCircleRect.origin.x + self.innerCircleRect.size.width/2;
    myStartPoint.y = self.innerCircleRect.origin.y + self.innerCircleRect.size.width/2;
    myEndPoint.x = self.innerCircleRect.origin.x + self.innerCircleRect.size.width/2;
    myEndPoint.y = self.innerCircleRect.origin.y + self.innerCircleRect.size.width/2;
   
    myStartRadius = self.innerCircleRect.size.width/2;
    myEndRadius = self.outerCircleRect.size.width/2;
    
    CGContextDrawRadialGradient(context,
                                myGradient,
                                myStartPoint, myStartRadius, myEndPoint, myEndRadius, 0);
    
     CGGradientRelease(myGradient);
    CGColorSpaceRelease(myColorspace);
    CGContextSetRGBStrokeColor(context, self.r,self.g,self.b,self.a);
     CGContextAddEllipseInRect(context, self.outerCircleRect);
    CGContextStrokePath(context);
    
    CGContextAddEllipseInRect(context, self.innerCircleRect);
    CGContextStrokePath(context);
 
    CGContextRestoreGState(context);
     CGContextRestoreGState(context);
 }
- (CGFloat)r {
    if (!_r) {
        _r = _R;
    }
    return _r;
}
- (CGFloat)g {
    if (!_g) {
        _g = _G;
    }
    return _g;
}
- (CGFloat)b {
    if (!_b) {
        _b = _B;
    }
    return _b;
}
- (CGFloat)a {
    if (!_a) {
        _a = _A;
    }
    return _a;
}
@end
