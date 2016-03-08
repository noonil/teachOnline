//
//  HSMyUILabel.h
//  koreanpine
//
//  Created by 陶山强 on 15/11/3.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface HSMyUILabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;
@end
