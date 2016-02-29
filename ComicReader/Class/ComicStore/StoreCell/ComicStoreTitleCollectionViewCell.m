//
//  ComicStoreTitleCollectionViewCell.m
//  ComicReader
//
//  Created by Jiang on 3/26/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ComicStoreTitleCollectionViewCell.h"

@implementation ComicStoreTitleCollectionViewCell

- (void)awakeFromNib {
    self.titleLabel.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.7];
}

- (void)setSelected:(BOOL)selected{
    self.titleLabel.textColor = selected?[[UIColor whiteColor]colorWithAlphaComponent:1]
                                        :[[UIColor whiteColor]colorWithAlphaComponent:0.7];
}

@end
