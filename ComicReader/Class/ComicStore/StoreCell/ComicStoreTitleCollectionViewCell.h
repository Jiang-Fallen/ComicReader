//
//  ComicStoreTitleCollectionViewCell.h
//  ComicReader
//
//  Created by Jiang on 3/26/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cellIdentifier = @"ComicStoreTitleCollectionViewCellIdentifier";
@interface ComicStoreTitleCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
