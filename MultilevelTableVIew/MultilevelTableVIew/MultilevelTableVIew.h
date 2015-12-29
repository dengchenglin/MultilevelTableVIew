//
//  MultilevelTableVIew.h
//  MultilevelTableVIew
//
//  Created by chenguangjiang on 15/12/28.
//  Copyright © 2015年 dengchenglin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ExpandStye) {
    ExpandConflict,          //默认只允许展开一段
    ExpandUnConflict         //允许展开多段
};
@protocol MultilevelTableViewDelegate,MultilevelTableViewDataSoure;
@interface MultilevelTableVIew : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) id<MultilevelTableViewDelegate>delegate;
@property (nonatomic,weak) id<MultilevelTableViewDataSoure>dataSoure;
@property (nonatomic,assign) ExpandStye expandStye;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (UITableViewCell *)dequeueReusableCellWithIdentifier:identifier forIndexPath:(NSIndexPath *)indexPath;
- (UITableViewHeaderFooterView *)dequeueReusableHeaderFooterViewWithIdentifier:identifier ;
@end

@protocol MultilevelTableViewDelegate <NSObject>
@optional
- (void)mtableView:(MultilevelTableVIew *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)mtableView:(MultilevelTableVIew *)tableView touchHeaderForSection:(NSInteger)section isOpen:(BOOL)isOpen;
@end
@protocol MultilevelTableViewDataSoure <NSObject>
@required
- (NSInteger)mtableView:(MultilevelTableVIew *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)mtableView:(MultilevelTableVIew *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (CGFloat)mtableView:(MultilevelTableVIew *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)mnumberOfSectionsInTableView:(MultilevelTableVIew *)tableView;
- (CGFloat)mtableView:(MultilevelTableVIew *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)mtableView:(MultilevelTableVIew *)tableView viewForHeaderInSection:(NSInteger)section;
@end