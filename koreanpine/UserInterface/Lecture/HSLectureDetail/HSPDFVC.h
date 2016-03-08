//
//  HSPDFVC.h
//  koreanpine
//
//  Created by Victor on 15/10/14.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"
#import "HSClassVC.h"
@class HSLectureModel,HSLecturePDFModel,HSLectureDetailVC;
@interface HSPDFVC : HSBaseVC
<HSContainerVCInterface>
@property (weak ,nonatomic) HSLectureDetailVC *mainVC;
- (void)updateVCWithLecutreModel:(HSLectureModel *)lectureModel  pdfModel:(HSLecturePDFModel *)lecturePDFModel;
- (void)willDisplayContainerView;

- (void)endDisplayContainerView;

@end
