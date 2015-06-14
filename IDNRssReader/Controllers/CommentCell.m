//
//  CommentCell.m
//  IDNRssReader
//
//  Created by photondragon on 15/6/14.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell()

@end

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(CommentInfo *)comment
{
	_comment = comment;

	self.labelComment.text = comment.content;
}

@end
