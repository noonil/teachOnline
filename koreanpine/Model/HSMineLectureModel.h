//
//  HSMineLectureModel.h
//  koreanpine
//
//  Created by Christ on 15/7/26.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "YH_Model.h"
#import "HSLectureModel.h"

@interface HSMineLectureModel : HSLectureModel

@property (copy, nonatomic) NSString *lectureLinkUrl;

@property (copy, nonatomic) NSString *lectureModifyTime;

@property (assign, nonatomic) NSUInteger lectureCount;


@end
