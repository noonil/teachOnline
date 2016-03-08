//
//  HSLectureDetailVC.h
//  koreanpine
//
//  Created by Christ on 15/7/26.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"

@class HSLectureModel;

@interface HSLectureDetailVC : HSBaseVC
@property (strong, nonatomic) UICollectionView *yhCollectionView;
@property(assign,nonatomic)BOOL isHs;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lectureModel:(HSLectureModel *)lectureModel isHs:(bool)isHs ClassID:(NSString *)classId;

- (void)chapterDidChanged;

- (BOOL)hasShownLeftView;

//增加浏览量
- (void)addViewedCourse:(NSString *)lectureID isHs:(BOOL)isHs;

@end
