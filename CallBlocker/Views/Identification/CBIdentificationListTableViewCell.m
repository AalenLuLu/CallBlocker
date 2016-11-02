//
//  CBIdentificationListTableViewCell.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/28.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBIdentificationListTableViewCell.h"

@implementation CBIdentificationListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if(self = [super initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: reuseIdentifier])
	{
		self.detailTextLabel.textColor = [UIColor grayColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
