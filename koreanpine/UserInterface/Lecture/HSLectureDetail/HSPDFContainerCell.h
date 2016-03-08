//
//  HSPDFContainerCell.h
//  koreanpine
//
//  Created by Victor on 15/10/14.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSPDFVC.h"
@class HSLectureModel,HSLecturePDFModel;
@interface HSPDFContainerCell : UICollectionViewCell

@property (strong, nonatomic) HSPDFVC *pdfContainerVC;

- (void)updateCellWithLecutreModel:(HSLectureModel *)lectureModel  pdfModel:(HSLecturePDFModel *)pdfModel;

- (void)willDisplayCell;

- (void)endDisplayCell;

@end
