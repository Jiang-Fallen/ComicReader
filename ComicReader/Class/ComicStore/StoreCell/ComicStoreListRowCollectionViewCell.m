//
//  ComocStoreListRowCollectionViewCell.m
//  ComicReader
//
//  Created by Jiang on 14/12/22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ComicStoreListRowCollectionViewCell.h"
//#import "ListRowContentModel.h"
#import "NewStoreContentListModel.h"
#import "UIImageView+WebCache.h"
#import "NSMutableAttributedString+TitleTreatment.h"

@interface ComicStoreListRowCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *bannerLabel;
@property (weak, nonatomic) IBOutlet UILabel *popularityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bookCoverImage;
@property (weak, nonatomic) IBOutlet UIImageView *backSpaceImage;

@property (assign, nonatomic, getter=isUnfinished) BOOL unfinished;
@property (nonatomic, copy) NSString *bookImageCoverURL;

@end

@implementation ComicStoreListRowCollectionViewCell

- (void)awakeFromNib {
    self.bannerLabel.transform = CGAffineTransformMakeRotation(-M_PI_4);
    UIImage *image = [UIImage imageNamed:@"download_space_normal.png"];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    image  = [image resizableImageWithCapInsets:edgeInsets];
    self.backSpaceImage.image = image;
    self.bookCoverImage.clipsToBounds = YES;
}
- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.opacity = 0.8;
    gradientLayer.startPoint = CGPointMake(0.5, 1);
    gradientLayer.endPoint = CGPointMake(0.5, 0);
    gradientLayer.colors = @[(id)[UIColor blackColor].CGColor, (id)[[UIColor blackColor] colorWithAlphaComponent:0.0].CGColor];
    gradientLayer.locations = @[@0.0, @0.2];
    gradientLayer.frame = self.bookCoverImage.bounds;
    self.bookCoverImage.layer.sublayers = @[gradientLayer];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:NO];
}

- (void)setListRowContentModel:(NewStoreContentListModel *)listRowContentModel{
    _listRowContentModel = listRowContentModel;
    
    self.unfinished = listRowContentModel.BookState.intValue == 1? YES: NO;
    self.popularityLabel.text = listRowContentModel.BookUpdateSection;
    self.bookNameLabel.text = listRowContentModel.BookName;
    self.bookImageCoverURL = listRowContentModel.BookIconOtherURL;
}

- (void)setBookImageCoverURL:(NSString *)bookImageCoverURL{
    [self.bookCoverImage sd_setImageWithURL:[NSURL URLWithString:bookImageCoverURL] placeholderImage:[UIImage imageNamed:@"community_cover_item.png"]];
}
- (NSString *)bookImageCoverURL{
    return self.listRowContentModel.BookIconOtherURL;
}

- (void)setUnfinished:(BOOL)unfinished{
    if (unfinished) {
        self.bannerLabel.text = @"连载中";
        self.bannerImage.image = [UIImage imageNamed:@"bc_corner_red.png"];
    }else{
        self.bannerLabel.text = @"已完结";
        self.bannerImage.image = [UIImage imageNamed:@"bc_corner_blue.png"];
    }
    _unfinished = unfinished;
}

@end
