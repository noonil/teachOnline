//
//  HSLectureClassModel.h
//  koreanpine
//
//  Created by Christ on 15/7/28.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "YH_Model.h"
#import "NetworkCenter.h"
#import "HSGraspProgress.h"

typedef NS_ENUM(NSUInteger, HSLectureClassType) {
    HSLectureClassTypeClass = 0,
    HSLectureClassTypePractice,
    HSLectureClassTypePDF
};

@protocol HSLectureDetails <NSObject>

@property (assign, nonatomic) HSLectureClassType lectureClassType;

@property (copy, nonatomic) NSString *name;

@end

@interface HSLectureClassModel : YH_Model<HSLectureDetails,NSCoding>

@property (assign, nonatomic) HSLectureClassType lectureClassType;

@property (copy, nonatomic) NSString *classId;

@property (assign, nonatomic) BOOL isNew;

@property (copy, nonatomic) NSString *createTime;

@property (copy, nonatomic) NSString *classify;

@property (copy, nonatomic) NSString *sequence;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *stageDictOrderId;

@property (copy, nonatomic) NSString *modifyTime;

@property (nonatomic,copy) NSString *cloudId;

@property (assign, nonatomic) BOOL isVideo;

@property (copy, nonatomic) NSString *url;

@property (copy, nonatomic) NSString *lecturerName;

@property (copy, nonatomic) NSString *lecturer;

@property (copy, nonatomic) NSString *videoPath;

@property (assign,nonatomic)NSInteger fileSize;

@property(nonatomic,copy)NSString *homeworkCount;

@property(nonatomic,copy)NSString *classhourCount;

@property (nonatomic,assign) BOOL isHs;

- (void)getLectureViewPathWithSucceededBlock:(void(^)(NSString *videoPath))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock;


@end

@interface HSLectureHomeworkModel : YH_Model<HSLectureDetails>

@property (assign, nonatomic) HSLectureClassType lectureClassType;

@property (copy, nonatomic) NSString *homeworkId;

@property (assign, nonatomic) BOOL isNew;

@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) NSUInteger totalCount;

@property (assign, nonatomic) HSGraspState graspState;

@property (assign, nonatomic) NSInteger rightNum;

@property (assign, nonatomic) CGFloat masterDegree;

@property (copy, nonatomic) NSString *modifyTime;

@property (nonatomic,copy) NSString *practiceId;

@property (nonatomic,assign) BOOL isHs;

@property(nonatomic,copy)NSString *homeworkCount;

@property(nonatomic,copy)NSString *classhourCount;
- (void)getHomeworkInfoWithFinish:(void (^)())finishBlock;

@end

@interface HSLecturePDFModel : HSLectureClassModel<HSLectureDetails,NSCopying>
//@property (assign, nonatomic) HSLectureClassType lectureClassType;

//@property (copy, nonatomic) NSString *pdfId;

//@property (assign, nonatomic) BOOL isNew;

//@property (copy, nonatomic) NSString *name;

//@property (copy, nonatomic) NSString *createTime;

//@property (copy, nonatomic) NSString *cloudId;

@property (copy, nonatomic) NSString *pdfFileSize;

//@property (copy, nonatomic) NSString *url;

//@property (copy, nonatomic) NSString *lecturerName;

@property (copy, nonatomic) NSString *resType;

//@property (copy, nonatomic) NSString *pdfPath;

@property(nonatomic,copy)NSString *homeworkCount;

@property(nonatomic,copy)NSString *classhourCount;

@end