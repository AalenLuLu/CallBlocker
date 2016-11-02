//
//  CBSettingSwitchTableViewCell.h
//  CallBlocker
//
//  Created by Aalen on 2016/10/31.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBSettingSwitchTableViewCellDelegate <NSObject>

@required
- (void)onSwitchChangedAtIndexPath: (NSIndexPath *)indexPath enable: (BOOL)enable;

@end

@interface CBSettingSwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) id<CBSettingSwitchTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;

- (void)setTitle: (NSString *)title;
- (void)setEnable: (BOOL)enable;

@end
