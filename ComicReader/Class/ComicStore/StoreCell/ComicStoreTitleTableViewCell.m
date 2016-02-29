//
//  ComicStoreTitleTableViewCell.m
//  ComicReader
//
//  Created by Jiang on 1/14/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ComicStoreTitleTableViewCell.h"

@interface ComicStoreTitleTableViewCell ()

@end

@implementation ComicStoreTitleTableViewCell

- (void)awakeFromNib {
//    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"titleCell"]];
    self.contentView.layer.masksToBounds = NO;
    CGRect rect = self.contentTitleLabel.frame;
    CGFloat x = arc4random()%15 + 30;
    rect.origin.x = x;
    self.contentTitleLabel.frame = rect;
    rect = self.backImageView.frame;
    rect.origin.x = x - 20.0;
    self.backImageView.frame = rect;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backImageView.layer.zPosition = 1;
    self.contentTitleLabel.layer.zPosition = 2;
    
//    self.contentTitleLabel.textColor = [self randomColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
    self.contentView.backgroundColor = selected?[UIColor colorWithWhite:1 alpha:1]:[UIColor clearColor];
//    self.contentTitleLabel.textColor = selected?[UIColor grayColor]:[UIColor blackColor];
}

- (UIColor *)randomColor{
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
