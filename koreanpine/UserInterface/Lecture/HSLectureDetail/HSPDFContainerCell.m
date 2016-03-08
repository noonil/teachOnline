//
//  HSPDFContainerCell.m
//  koreanpine
//
//  Created by Victor on 15/10/14.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSPDFContainerCell.h"
#import "HSLectureModel.h"
#import "HSLectureClassModel.h"
@implementation HSPDFContainerCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCell];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initCell];
    }
    return self;
}

- (void)initCell
{
    self.pdfContainerVC = [[HSPDFVC alloc] initWithNibName:@"HSPDFVC" bundle:nil];
    
        [self.pdfContainerVC.view setFrame:self.contentView.bounds];
    
    
    [self.pdfContainerVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.contentView addSubview:self.pdfContainerVC.view];
    
}

- (void)updateCellWithLecutreModel:(HSLectureModel *)lectureModel  pdfModel:(HSLecturePDFModel *)pdfModel
{
    [self.pdfContainerVC updateVCWithLecutreModel:lectureModel pdfModel:pdfModel];
}

- (void)willDisplayCell
{
    [self.pdfContainerVC willDisplayContainerView];
}

- (void)endDisplayCell
{
    [self.pdfContainerVC endDisplayContainerView];
}


@end
