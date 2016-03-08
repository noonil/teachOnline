//
//  HSDownloadButton.h
//  
//
//  Created by Victor on 15/10/29.
//
//

#import <UIKit/UIKit.h>

@interface HSDownloadButton : UIButton

@property (nonatomic,assign) CGFloat progress;
@property (nonatomic,assign) CGFloat r;
@property (nonatomic,assign) CGFloat g;
@property (nonatomic,assign) CGFloat b;
@property (nonatomic,assign) CGFloat a;
@property (nonatomic,assign) CGRect outerCircleRect;
@property (nonatomic,assign) CGRect innerCircleRect;

-(void) setProgress:(CGFloat) newProgress;
@end
