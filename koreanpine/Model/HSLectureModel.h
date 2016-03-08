//
//  HSLectureModel.h
//  koreanpine
//
//  Created by Christ on 15/7/25.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "YH_Model.h"
#import "HSGraspProgress.h"

@interface HSLectureModel : YH_Model<NSCoding>

@property (copy, nonatomic) NSString *collectInfoID;

//@property (copy, nonatomic) NSString *collectionID;

@property (copy, nonatomic) NSString *collectID;

@property (copy, nonatomic) NSString *lectureID;


@property (copy, nonatomic) NSString *lectureName;

@property (copy, nonatomic) NSString *lectureDetail;

@property (copy, nonatomic) NSString *lectureImageUrl;

@property (assign, nonatomic) HSGraspState graspState;


@property(nonatomic,strong)NSString *collectSource;

@property(nonatomic,strong)NSString *hsCourseFlag;

@property(nonatomic,strong)NSString *collectCount;

@property(nonatomic,strong)NSString *updateTime;



@property(nonatomic,strong)NSString *viewed;

@property(nonatomic,assign)BOOL isCollect;

@property (assign, nonatomic) BOOL isNew;
@property(nonatomic,assign)BOOL isHot;
@property (nonatomic,assign) BOOL isHs;
@property(nonatomic,assign)BOOL isCollection;
@end
