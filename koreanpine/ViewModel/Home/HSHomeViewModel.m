//
//  HSHomeViewModel.m
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSHomeViewModel.h"
#import "HSLoginMgr.h"
#import "NetworkCenter.h"
#import "HSRuntimeMgr.h"
#import "HSLectureModel.h"

@interface HSHomeViewModel ()

@property (strong, nonatomic) NSMutableArray *headerSections;

@property (strong, nonatomic) NSMutableArray *cellInfos;

@end

@implementation HSHomeViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViewModel];
    }
    return self;
}

- (void)dealloc
{
    [self unInitNotifi];
}

- (void)initNotifi
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvUpdateHomeNotifi:) name:kNotifiHomeInfoDidUpdate object:nil];
}

- (void)unInitNotifi
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)recvUpdateHomeNotifi:(NSNotification *)notifi
{
    if ([self.delegate respondsToSelector:@selector(homeViewModelDidUpdateCellInfo:)]) {
        [self.delegate homeViewModelDidUpdateCellInfo:self];
    }
}

- (void)initViewModel
{
    [self initNotifi];
    
    self.headerSections = [NSMutableArray array];
    
    NSArray *sectionImageNames = @[@"label1",@"label2"];
    NSArray *sectionTitleNames = @[@"通知公告",@"成长统计"];
    for (int row = 0; row < [sectionImageNames count]; row ++) {
        HSHomeSectionTitle *sectionTitleItem = [[HSHomeSectionTitle alloc] init];
        sectionTitleItem.title = sectionTitleNames[row];
        sectionTitleItem.imageName = sectionImageNames[row];
        [self.headerSections addObject:sectionTitleItem];
    }
    
    self.cellInfos = [NSMutableArray array];
}

- (NSArray *)bannerImageNames
{
    return @[@"banner1",@"banner2",@"banner3"];
}

- (NSUInteger)tableViewSectionCount
{
    return self.headerSections.count;
}

- (NSUInteger)tableViewNumberOfRowsInSection:(NSUInteger)section
{
    return 2;
}

- (HSHomeSectionTitle *)tableViewHomeSectionTitleAtSection:(NSUInteger)section
{
    HSHomeSectionTitle *homeSectionTitle = nil;
    if (section < self.headerSections.count) {
        homeSectionTitle = self.headerSections[section];
    }
    return homeSectionTitle;
}

- (HSHomeCellInfo *)tableViewHomeCellInfoAtIndexPath:(NSIndexPath *)indexPath
{
    HSHomeCellInfo *cellInfo = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                cellInfo = [[HSHomeCellInfo alloc] init];
                [cellInfo setImageName:@"examination_f"];
                [cellInfo setHighlightImageName:@"examination_n"];
                [cellInfo setTitle:@"全力打造中，敬请期待"];
                
            } else if (indexPath.row == 1) {
                //新课程提示项
                cellInfo = [[HSHomeCellInfo alloc] init];
                [cellInfo setImageName:@"course-f"];
                [cellInfo setHighlightImageName:@"course"];
                NSPredicate *beginWithPredicate = [NSPredicate predicateWithFormat:@"isNew == YES"];
                NSArray *searchedResultArr = [[HSRuntimeMgr runtimeMgr].latestLectureArr filteredArrayUsingPredicate:beginWithPredicate];
                
                NSString *titleText = @"";
                if (searchedResultArr.count == 0) {
                    titleText = @"您目前无新的课程";
                    cellInfo.shouldHighlight = NO;
                } else if (searchedResultArr.count == 1) {
                    HSLectureModel *lectureItem = (HSLectureModel *)searchedResultArr[0];
                    titleText = [NSString stringWithFormat:@"您有新的课程《%@》,请学习吧!",lectureItem.lectureName];
                    cellInfo.shouldHighlight = YES;
                } else if (searchedResultArr.count > 1) {
                    titleText = @"您有很多新的课程，请前往学习吧！";
                    cellInfo.shouldHighlight = YES;
                }
                [cellInfo setTitle:titleText];
            }
            break;
        }
        case 1:
        {
            HSLectureExamGraspState *graspState = [HSRuntimeMgr runtimeMgr].lectureExamGraspState;
            
            if (indexPath.row == 0) {
                cellInfo = [[HSHomeCellInfo alloc] init];
                [cellInfo setImageName:@"statistics_f"];
                [cellInfo setHighlightImageName:@"statistics"];
                [cellInfo setTitle:@"全力打造中，敬请期待"];
                
            } else if (indexPath.row == 1) {
                cellInfo = [[HSHomeCellInfo alloc] init];
                [cellInfo setImageName:@"degree_f"];
                [cellInfo setHighlightImageName:@"degree"];
                
                NSString *titleText = @"";
                if (graspState.lectureTotalCount == 0) {
                    titleText = @"尚无可学习的课程";
                    cellInfo.shouldHighlight = NO;
                } else {
                    titleText = [NSString stringWithFormat:@"您可以学习%lu节课，知识掌握度为%.0f%%",(unsigned long)graspState.lectureTotalCount,graspState.lectureGraspRate];
                    cellInfo.shouldHighlight = YES;
                }
                [cellInfo setTitle:titleText];
            }
            break;
        }
            
        default:
            break;
    }
    return cellInfo;
}


@end

@implementation HSHomeSectionTitle


@end

@implementation HSHomeCellInfo

//- (NSString *)imageName
//{
//    return nil;
//}

//- (NSString *)title
//{
//    return @"aaaa";
//}

@end


