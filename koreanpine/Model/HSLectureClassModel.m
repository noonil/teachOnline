//
//  HSLectureClassModel.m
//  koreanpine
//
//  Created by Christ on 15/7/28.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLectureClassModel.h"
#import "HSLoginMgr.h"

@implementation HSLectureClassModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.lectureClassType = HSLectureClassTypeClass;
        self.classId = [dict stringForKey:@"id"];
        self.isNew = ![[dict stringForKey:@"isNew"] isEqualToString:@"0"];
        self.createTime = [dict stringForKey:@"createTime"];
        self.classify = [dict stringForKey:@"classify"];
        self.sequence = [dict stringForKey:@"sequence"];
        self.name = [dict stringForKey:@"name"];
        self.stageDictOrderId = [dict stringForKey:@"stageDictOrderId"];
        self.modifyTime = [dict stringForKey:@"modifyTime"];
        self.isVideo = [dict boolForKey:@"isVideo"];
        self.url = [dict stringForKey:@"url"];
        self.lecturerName = [dict stringForKey:@"lecturerName"];
        self.lecturer = [dict stringForKey:@"lecturer"];
        self.cloudId = [dict stringForKey:@"cloudId"];
        self.fileSize = [[dict stringForKey:@"fileSize"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.classId forKey:@"id"];
    [coder encodeObject:self.cloudId forKey:@"cloudId"];
    [coder encodeObject:self.classify forKey:@"classify"];
    [coder encodeObject:self.sequence forKey:@"sequence"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.stageDictOrderId forKey:@"stageDictOrderId"];
    [coder encodeObject:self.modifyTime forKey:@"modifyTime"];
    [coder encodeObject:self.videoPath forKey:@"videoPath"];
    [coder encodeObject:self.lecturerName forKey:@"lecturerName"];
    [coder encodeBool:self.isHs forKey:@"isHs"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.classId = [aDecoder decodeObjectForKey:@"id"];
        self.cloudId = [aDecoder decodeObjectForKey:@"cloudId"];
        self.classify = [aDecoder decodeObjectForKey:@"classify"];
        self.sequence = [aDecoder decodeObjectForKey:@"sequence"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.stageDictOrderId = [aDecoder decodeObjectForKey:@"stageDictOrderId"];
        self.modifyTime = [aDecoder decodeObjectForKey:@"modifyTime"];
        self.videoPath = [aDecoder decodeObjectForKey:@"videoPath"];
        self.lecturerName = [aDecoder decodeObjectForKey:@"lecturerName"];
        self.isHs = [aDecoder decodeBoolForKey:@"isHs"];
    }
    return self;
}

- (void)getLectureViewPathWithSucceededBlock:(void(^)(NSString *videoPath))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock
{
    if (self.url.length == 0) { return; }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];

    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
    if (companyModel.companyUUID.length > 0) {
        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    [parameter setObject:self.url forKey:@"url"];
    
    __weak typeof(self) weakSelf = self;
    //获取视频播放百度云路径
    [[EPHttpClient sharedClient] POST:@"com/courseware/getVedioUrl" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *videoPath = responseObject[@"data"];
        if (!IsStrEmpty(videoPath)) {
            weakSelf.videoPath = videoPath;
            if (succeededBlock) {
                succeededBlock(videoPath);
            }
        } else {
            NSError *error = [NSError errorWithDomain:@"错误的数据" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"数据格式错误"}];
            if (failedBlock) {
                failedBlock(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]]) { return NO; }
    HSLectureClassModel *classModel = (HSLectureClassModel *)object;
    return [self.classId isEqualToString:classModel.classId];
}

@end

@implementation HSLectureHomeworkModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        
        self.lectureClassType = HSLectureClassTypePractice;
        
        self.homeworkId = [dict stringForKey:@"id"];
        
        self.isNew = [dict boolForKey:@"isNew"];
        
        self.name = [dict stringForKey:@"name"];
        
        self.totalCount = [dict integerForPath:@"total"];
        
        self.practiceId = [dict stringForKey:@"practiceId"];
        
        self.modifyTime = [dict stringForKey:@"modifyTime"];
        
        
        [self getHomeworkInfoWithFinish:nil];
    }
    return self;
}

- (void)getHomeworkInfoWithFinish:(void (^)())finishBlock
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject: kVERSIONCODE forKey:@"versionCode"];
    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
    if (companyModel.companyUUID.length > 0) {
        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    
    [parameter setObject:self.homeworkId forKey:@"homeworkId"];
    //获取作业信息
    [[EPHttpClient sharedClient] POST:@"com/courseware/getHomeworkInfo" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        NSDictionary *dataDict = resultDic[@"data"];
        if (dataDict) {
            self.masterDegree = [dataDict floatForPath:@"masterDegree"];
            self.rightNum = [dataDict integerForPath:@"rightNum"];
        }
        if (finishBlock) {
            finishBlock();
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end

@implementation HSLecturePDFModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.lectureClassType = HSLectureClassTypePDF;
        
        self.classId = [dict stringForKey:@"id"];
        self.isNew = ![[dict stringForKey:@"isNew"] isEqualToString:@"0"];
        self.createTime = [dict stringForKey:@"createTime"];
//        self.classify = [dict stringForKey:@"classify"];
//        self.sequence = [dict stringForKey:@"sequence"];
        self.name = [dict stringForKey:@"name"];
        self.cloudId = [dict stringForKey:@"cloudId"];
        self.pdfFileSize = [dict stringForKey:@"pdfFileSize"];
//        self.isVideo = [dict boolForKey:@"isVideo"];
        self.url = [dict stringForKey:@"url"];
        self.lecturerName = [dict stringForKey:@"lecturerName"];
//        self.lecturer = [dict stringForKey:@"lecturer"];
//        self.resType = [dict stringForKey:@"resType"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.classId forKey:@"id"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.cloudId forKey:@"cloudId"];
    [coder encodeObject:self.pdfFileSize forKey:@"pdfFileSize"];
    [coder encodeObject:self.videoPath forKey:@"pdfPath"];
    [coder encodeObject:self.lecturerName forKey:@"lecturerName"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.classId = [aDecoder decodeObjectForKey:@"id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.cloudId = [aDecoder decodeObjectForKey:@"cloudId"];
        self.pdfFileSize = [aDecoder decodeObjectForKey:@"pdfFileSize"];
        self.videoPath = [aDecoder decodeObjectForKey:@"pdfPath"];
        self.lecturerName = [aDecoder decodeObjectForKey:@"lecturerName"];
    }
    return self;
}
- (void)getLectureViewPathWithSucceededBlock:(void (^)(NSString *))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:kVERSIONCODE forKey:@"versionCode"];
    [parameters setObject:self.cloudId forKey:@"cloudId"];
    ///HsMobile/com/ctrl/course/courseware/getVedioUrlByCloudId
    ///com/courseware/getVedioUrl 旧的
//    NSLog(@"%@",self.cloudId);
    if (self.isHs) {
        __weak typeof(self) weakSelf = self;
        [[EPHttpClient sharedClient] POST:@"com/ctrl/course/courseware/getHsVedioUrlByCloudId" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            NSDictionary *dictUrl = responseObject[@"data"];
            NSInteger resCode = [responseObject integerForPath:@"res"];
            if (resCode == 1) {
                weakSelf.videoPath = dictUrl[@"url"];
                if (succeededBlock) {
                    succeededBlock(dictUrl[@"url"]);
                }
                //            NSLog(@"%@",pdfUrl);
                //http://dldir1.qq.com/qqfile/qq/QQ7.6/15742/QQ7.6.exe 示范
                
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"失败");
        }];

    }else {
        __weak typeof(self) weakSelf = self;
        [[EPHttpClient sharedClient] POST:@"com/ctrl/course/courseware/getVedioUrlByCloudId" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"%@",responseObject);
            NSDictionary *dictUrl = responseObject[@"data"];
            NSInteger resCode = [responseObject integerForPath:@"res"];
            if (resCode == 1) {
                weakSelf.videoPath = dictUrl[@"url"];
                if (succeededBlock) {
                    succeededBlock(dictUrl[@"url"]);
                }
                //            NSLog(@"%@",pdfUrl);
                //http://dldir1.qq.com/qqfile/qq/QQ7.6/15742/QQ7.6.exe 示范
                
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"失败");
        }];
  
    }
    
}
/**
 *  id = 3787;
	classify = PDF教程;
	lecturer = ;
	masterStatus = 0;
	cloudId = C19927747BA04E2EB3AE17D6022CC4AE;
	pdfFileSize = 0;
	url = C19927747BA04E2EB3AE17D6022CC4AE;
	resType = 2;
	isVideo = 1;
	stageDictOrderId = 577;
	createTime = 1442555238000;
	isNew = 0;
	fileType = 1;
	modifyTime = 1442555238000;
	sequence = 2;
	status = 1;
	name = PDF001;
 */

@end