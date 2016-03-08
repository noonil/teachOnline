//
//  HSPracticePKButton.m
//  koreanpine
//
//  Created by Victor on 15/11/5.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSPracticePKButton.h"
#import "UIView+WTXM.h"
#import "HSUserHeroModel.h"
@interface HSPracticePKButton ()
@property (nonatomic,strong) UILabel *sortTypeLabel;
@property (nonatomic,strong) UILabel *resultLabel;
@property (nonatomic,strong) UILabel *rankLabel;
@property (nonatomic,strong) NSTimer *timer;
@end



@implementation HSPracticePKButton




#pragma mark -共有方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
        self.userInteractionEnabled = YES;
        self.progressView.thicknessRatio = 0.15;
        self.progressView.progressTintColor = RGBACOLOR(194,215,249,1);
        self.progressView.roundedCorners = YES;
        self.progressView.trackTintColor = RGBACOLOR(117, 155, 215, 1);
        self.singleTap = [[UITapGestureRecognizer alloc] init];
        [self.singleTap addTarget:self action:@selector(singleTapActived:)];
        [self.singleTap setNumberOfTapsRequired:1];
        [self.singleTap setNumberOfTouchesRequired:1];
        [self.progressView addGestureRecognizer:self.singleTap];
        [self addSubview:self.progressView];
       
        self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.hei*0.4,  frame.size.width, frame.size.height*0.2)];
        self.resultLabel.textColor = RGBACOLOR(255, 255, 255, 1);
        self.resultLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.resultLabel];
        
        self.sortTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.hei*0.2, self.wid, self.hei*0.2)];
        self.sortTypeLabel.textAlignment = NSTextAlignmentCenter;
        self.sortTypeLabel.textColor = RGBACOLOR(217, 226, 243, 1);
        [self addSubview:self.sortTypeLabel];
        
       
        
        self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.hei*0.6, self.wid, self.hei*0.2)];
        self.rankLabel.textColor = RGBACOLOR(217, 226, 243, 1);

        self.rankLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.rankLabel];
        self.resultLabel.font = [UIFont systemFontOfSize:31];
        self.sortTypeLabel.font = [UIFont systemFontOfSize:12];
        self.rankLabel.font = [UIFont systemFontOfSize:12];
        [self setNeedsDisplay];
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
   
    CGContextRef contextLast = UIGraphicsGetCurrentContext();
    [RGBACOLOR(127, 163, 220, 0.3) setStroke];
    CGContextAddArc(contextLast, CGRectGetWidth(self.frame)*0.5, CGRectGetHeight(self.frame)*0.5, CGRectGetHeight(self.frame)*0.5-0.5, 0, 2 * M_PI, 0);
    CGContextStrokePath(contextLast);

}

- (void)setUserHeroModel:(HSUserHeroModel *)userHeroModel {
    _userHeroModel = userHeroModel;
    
   
    if ([self.sortType isEqualToString:@"rightRate"]) {
      self.sortTypeLabel.text = @"正确率";
        [self.progressView setProgress:0];
        CGFloat result = 0.0;
         if (userHeroModel.rightCount.length*[userHeroModel.totalCount integerValue]) {
             CGFloat right = [userHeroModel.rightCount floatValue];
             CGFloat total = [userHeroModel.totalCount floatValue];
             result = right/total;
         }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(progressChange:) userInfo:[NSNumber numberWithFloat:result] repeats:YES];
        NSString *totalNum = [NSString stringWithFormat:@"%.1f%%",result*100.0];
        if ([userHeroModel.ranking4RightRate isEqualToString:@"-1"]) {
            self.rankLabel.hidden = YES;
            totalNum = [NSString stringWithFormat:@"---%%"];
        }else {
            self.rankLabel.hidden = NO;
            self.rankLabel.text = [NSString stringWithFormat:@"第%@名",userHeroModel.ranking4RightRate];
        }

           NSRange range = [totalNum rangeOfString:@"%"];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:totalNum];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
        self.resultLabel.attributedText = attrStr;
        
    }else if ([self.sortType isEqualToString:@"totalNum"]) {
      self.sortTypeLabel.text = @"答题量";
        [self.progressView setProgress:0];
        self.resultLabel.text = userHeroModel.totalCount;
        NSString *totalNum = nil;
        NSRange range;
        if ([userHeroModel.totalCount integerValue]/10000 > 0) {
            totalNum = [NSString stringWithFormat:@"%.1f万题",(CGFloat)[userHeroModel.totalCount integerValue]/10000.0];
            range = [totalNum rangeOfString:@"万题"];
        } else {
            totalNum = [NSString stringWithFormat:@"%@题",userHeroModel.totalCount];
            if ([userHeroModel.ranking4TotalNum isEqualToString:@"-1"]) {
                self.rankLabel.hidden = YES;
                totalNum = [NSString stringWithFormat:@"---题"];
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(progressChange:) userInfo:[NSNumber numberWithFloat:0] repeats:YES];
            }else {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(progressChange:) userInfo:[NSNumber numberWithFloat:1] repeats:YES];
                self.rankLabel.hidden = NO;
                self.rankLabel.text = [NSString stringWithFormat:@"第%@名",userHeroModel.ranking4TotalNum];
            }
            range = [totalNum rangeOfString:@"题"];
        }
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:totalNum];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
        self.resultLabel.attributedText = attrStr;
           }
    [[NSRunLoop currentRunLoop ]addTimer:self.timer forMode:NSRunLoopCommonModes];
//    [[NSRunLoop currentRunLoop] run];
}

- (void) progressChange:(NSTimer *)timer {
    CGFloat result = [timer.userInfo floatValue];
    if (result == 0) {
        [self.progressView setProgress:result animated:NO];
        return;
    }
    CGFloat progress = ![self.timer isValid] ? result : self.progressView.progress + 0.01f;
    [self.progressView setProgress:progress];
    if (self.progressView.progress >= result) {
        [self.timer invalidate];
    }
}

- (void)dealloc {
    [self.progressView removeGestureRecognizer:self.singleTap];
}
#pragma mark -代理方法||数据源方法

#pragma mark -私有方法
- (void) singleTapActived:(UITapGestureRecognizer *)GestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(practicePKBtnTapped:)]) {
        [self.delegate practicePKBtnTapped:self];
    }
}

#pragma  mark -懒加载

@end
