//
//  CBSettingSwitchTableViewCell.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/31.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBSettingSwitchTableViewCell.h"

@interface CBSettingSwitchTableViewCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UISwitch *statusSwitch;

@end

@implementation CBSettingSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		_titleLabel = [[UILabel alloc] init];
		_titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview: _titleLabel];
		NSLayoutConstraint *labelLeftContraint = [NSLayoutConstraint constraintWithItem: _titleLabel attribute: NSLayoutAttributeLeft relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeLeft multiplier: 1 constant: 16.0];
		NSLayoutConstraint *labelVerticalContraint = [NSLayoutConstraint constraintWithItem: _titleLabel attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeCenterY multiplier: 1 constant: 0];
		
		_statusSwitch = [[UISwitch alloc] init];
//		_statusSwitch.enabled = NO;
		_statusSwitch.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview: _statusSwitch];
		NSLayoutConstraint *switchRightConstraint = [NSLayoutConstraint constraintWithItem: _statusSwitch attribute: NSLayoutAttributeRight relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeRight multiplier: 1 constant: -16.0];
		NSLayoutConstraint *switchVerticalContraint = [NSLayoutConstraint constraintWithItem: _statusSwitch attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeCenterY multiplier: 1 constant: 0];
		
		NSLayoutConstraint *labelSwitchContraint = [NSLayoutConstraint constraintWithItem: _titleLabel attribute: NSLayoutAttributeRight relatedBy: NSLayoutRelationLessThanOrEqual toItem: _statusSwitch attribute: NSLayoutAttributeLeft multiplier: 1 constant: -8.0];
		
		[self.contentView addConstraints: @[labelLeftContraint, labelVerticalContraint, switchRightConstraint, switchVerticalContraint, labelSwitchContraint]];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		[_statusSwitch addTarget: self action: @selector(onSwitchChanged:) forControlEvents: UIControlEventValueChanged];
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

- (void)setTitle:(NSString *)title
{
	_titleLabel.text = title;
	[_titleLabel sizeToFit];
}

- (void)setEnable:(BOOL)enable
{
	_statusSwitch.on = enable;
}

#pragma mark - UI handle

- (void)onSwitchChanged: (UISwitch *)sender
{
	if(_delegate && [_delegate respondsToSelector: @selector(onSwitchChangedAtIndexPath:enable:)])
	{
		[_delegate onSwitchChangedAtIndexPath: _indexPath enable: sender.on];
	}
}

@end
