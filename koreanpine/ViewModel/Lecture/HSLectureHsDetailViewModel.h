//
//  HSLectureHsDetailViewModel.h
//  koreanpine
//
//  Created by 陶山强 on 15/10/22.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkCenter.h"

@class HSLectureModel;

@protocol HSLectureHsDetailViewModelDelegate <NSObject>

- (void)lectureDetailViewModelDidupdate;

@end

@interface HSLectureHsDetailViewModel : NSObject


@property (strong, nonatomic) NSMutableDictionary *graspStateDict;

- (instancetype)initWithHSLectureModel:(HSLectureModel *)lectureModel;

@property (strong, nonatomic) HSLectureModel *lectureModel;

@property (strong, nonatomic) NSIndexPath *currentLectureIndexPath;

@property (strong, readonly, nonatomic) NSArray *stageList;

@property (weak, nonatomic) id<HSLectureHsDetailViewModelDelegate> delegate;

- (NSInteger)totalLectureCount;

- (void)addCourseStudyHistoryWithSucceededBlock:(void(^)(NSArray *stagItems))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock;

//获得对应课程章节信息
- (void)getCouserStageWithSucceededBlock:(void(^)(NSArray *stagItems))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock;

- (void)getLectureViewPathWithSucceededBlock:(void(^)(NSString *videoPath))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock;

- (BOOL)canSwithToPreLecture;

- (BOOL)canSwithToNextLecture;

- (void)switchToPreLecture;

- (void)switchToNextLecture;



@end
