//
//  CommentCell.h
//  IDNRssReader
//
//  Created by photondragon on 15/6/14.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentInfo.h"

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelComment;

@property(nonatomic,strong) CommentInfo* comment;

@end
