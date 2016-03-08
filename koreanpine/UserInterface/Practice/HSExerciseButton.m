//
//  HSExerciseButton.m
//  koreanpine
//
//  Created by Victor on 15/10/21.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSExerciseButton.h"
#import "UIView+WTXM.h"
@implementation HSExerciseButton


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.answerType) {
            
        case ExerciseAnswerTypeNUll:
            if (self.selected) {
                if (self.chooseAnswer) {
                    [[UIColor blackColor] setStroke];
                    CGContextAddArc(context, self.wid*0.5, self.hei*0.5, self.wid*0.5-1, 0, 2 * M_PI, 0);
                    CGContextStrokePath(context);
                    [[UIColor colorWithRed:(68/255.0) green:(100/255.0) blue:(193/255.0) alpha:1.0] setFill];
                    CGContextAddArc(context, self.wid*0.5, self.hei*0.5, self.wid*0.5-3, 0, 2 * M_PI, 0);
                    //    [[UIColor blackColor] setStroke];
                    // 3.渲染 (注意, 画线只能通过空心来画)
                    //    CGContextFillPath(ctx);
                    CGContextFillPath(context);

                }else {
                    [[UIColor blackColor] setStroke];
                    CGContextAddArc(context, self.wid*0.5, self.hei*0.5, self.wid*0.5-1, 0, 2 * M_PI, 0);
                    
                    CGContextStrokePath(context);
                    [[UIColor colorWithRed:(68/255.0) green:(100/255.0) blue:(193/255.0) alpha:1.0] setStroke];
                    CGContextAddArc(context, self.wid*0.5, self.hei*0.5, self.wid*0.5-3, 0, 2 * M_PI, 0);
                    //    [[UIColor blackColor] setStroke];
                    // 3.渲染 (注意, 画线只能通过空心来画)
                    //    CGContextFillPath(ctx);
                    CGContextStrokePath(context);
                }
            }else {
                if (self.chooseAnswer) {
                    [[UIColor colorWithRed:(68/255.0) green:(100/255.0) blue:(193/255.0) alpha:1.0] setFill];
                    CGContextAddArc(context, self.wid*0.5, self.hei*0.5, self.wid*0.5-1, 0, 2 * M_PI, 0);
                    
                    CGContextFillPath(context);
                    
                }else {
                    [[UIColor colorWithRed:(68/255.0) green:(100/255.0) blue:(193/255.0) alpha:1.0] setStroke];
                    CGContextAddArc(context, self.wid*0.5, self.hei*0.5, self.wid*0.5-1, 0, 2 * M_PI, 0);
                    
                    CGContextStrokePath(context);
                }
            }
            
            break;
        case ExerciseAnswerTypeRight:
            if (self.selected) {
                [[UIColor blackColor] setStroke];
                CGContextAddArc(context, self.wid*0.5, self.hei*0.5, self.wid*0.5-1, 0, 2 * M_PI, 0);
                
                CGContextStrokePath(context);
                
                [[UIColor colorWithRed:(117/255.0) green:(193/255.0) blue:(129/255.0) alpha:1.0] setFill];
                CGContextAddArc(context, self.wid*0.5, self.hei*0.5, self.wid*0.5-3, 0, 2 * M_PI, 0);
                //    [[UIColor blackColor] setStroke];
                // 3.渲染 (注意, 画线只能通过空心来画)
                //    CGContextFillPath(ctx);
                CGContextFillPath(context);
            }else {
                [[UIColor colorWithRed:(117/255.0) green:(193/255.0) blue:(129/255.0) alpha:1.0] setFill];
                CGContextAddArc(context, self.wid*0.5, self.hei*0.5, self.wid*0.5-1, 0, 2 * M_PI, 0);
                //    [[UIColor blackColor] setStroke];
                // 3.渲染 (注意, 画线只能通过空心来画)
                //    CGContextFillPath(ctx);
                CGContextFillPath(context);
            }

            break;
        case ExerciseAnswerTypeWrong:
            if (self.selected) {
                [[UIColor blackColor] setStroke];
                CGContextAddArc(context, self.wid*0.5, self.hei*0.5, self.wid*0.5-1, 0, 2 * M_PI, 0);
                
                CGContextStrokePath(context);
                [[UIColor colorWithRed:(220/255.0) green:(102/255.0) blue:(32/255.0) alpha:1.0] setFill];
                CGContextAddArc(context, self.wid*0.5, self.hei*0.5, self.wid*0.5-3, 0, 2 * M_PI, 0);
               
                CGContextFillPath(context);
            }else {
                [[UIColor colorWithRed:(220/255.0) green:(102/255.0) blue:(32/255.0) alpha:1.0] setFill];
                CGContextAddArc(context, self.wid*0.5, self.hei*0.5, self.wid*0.5-1, 0, 2 * M_PI, 0);
                //    [[UIColor blackColor] setStroke];
                // 3.渲染 (注意, 画线只能通过空心来画)
                //    CGContextFillPath(ctx);
                CGContextFillPath(context);
            }
            break;
            
        default:
            break;
    }
}


@end
