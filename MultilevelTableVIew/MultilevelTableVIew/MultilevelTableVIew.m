//
//  MultilevelTableVIew.m
//  MultilevelTableVIew
//
//  Created by chenguangjiang on 15/12/28.
//  Copyright © 2015年 dengchenglin. All rights reserved.
//

#import "MultilevelTableVIew.h"
@interface MultilevelTableVIew ()
@property (nonatomic,strong) UITableView *tableView;
@end
@implementation MultilevelTableVIew
{
    NSMutableDictionary *_sectionStatus;
    NSMutableDictionary *_rowStatus;
    NSIndexPath *_currentIndexPath;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        _sectionStatus = [NSMutableDictionary dictionary];
        _rowStatus = [NSMutableDictionary dictionary];
        _expandStye = ExpandConflict;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame];
    if(self){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:style];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        _sectionStatus = [NSMutableDictionary dictionary];
        _rowStatus = [NSMutableDictionary dictionary];
      _expandStye = ExpandConflict;
    }
    return self;
}
-(UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    return [_tableView dequeueReusableCellWithIdentifier:identifier];
}
- (UITableViewCell *)dequeueReusableCellWithIdentifier:identifier forIndexPath:(NSIndexPath *)indexPath{
    return [_tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}
- (nullable __kindof UITableViewHeaderFooterView *)dequeueReusableHeaderFooterViewWithIdentifier:identifier{
    return [_tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_dataSoure && [_dataSoure respondsToSelector:@selector(mnumberOfSectionsInTableView:)]){
        return [_dataSoure mnumberOfSectionsInTableView:self];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(_dataSoure && [_dataSoure respondsToSelector:@selector(mtableView:heightForHeaderInSection:)]){
        return [_dataSoure mtableView:self heightForHeaderInSection:section];
    }
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(_dataSoure && [_dataSoure respondsToSelector:@selector(mtableView:viewForHeaderInSection:)]){
        UIView *view = [_dataSoure mtableView:self viewForHeaderInSection:section];
        view.tag = section;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(targetForHeader:)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:tap];
        return view;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BOOL selectedSection_isOpen = [[_sectionStatus objectForKey:@(section)] boolValue];
    if(selectedSection_isOpen){
        return [_dataSoure mtableView:self numberOfRowsInSection:section];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_dataSoure && [_dataSoure respondsToSelector:@selector(mtableView:heightForRowAtIndexPath:)]){
      return [_dataSoure mtableView:self heightForRowAtIndexPath:indexPath];
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_dataSoure mtableView:self cellForRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_delegate && [_delegate respondsToSelector:@selector(mtableView:didSelectRowAtIndexPath:)]){
        [_delegate mtableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (void)targetForHeader:(UITapGestureRecognizer *)tap{
    BOOL selectedSection_isOpen = [[_sectionStatus objectForKey:@(tap.view.tag)] boolValue];
    selectedSection_isOpen = !selectedSection_isOpen;
    [_sectionStatus setObject:@(selectedSection_isOpen) forKey:@(tap.view.tag)];
    if(_delegate && [_delegate respondsToSelector:@selector(mtableView:touchHeaderForSection:isOpen:)]){
        [_delegate mtableView:self touchHeaderForSection:tap.view.tag isOpen:selectedSection_isOpen];
    }
    NSInteger insertCount = 0;
    if(_dataSoure && [_dataSoure respondsToSelector:@selector(mtableView:numberOfRowsInSection:)]){
       insertCount = [_dataSoure mtableView:self numberOfRowsInSection:tap.view.tag];
    }
    //要展开的列表
    NSMutableArray *insertIndexPaths = [NSMutableArray array];
    for(int i = 0;i < insertCount;i++){
        [insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:tap.view.tag]];
    }
    
    //要删除的列表
    NSIndexPath *oldOpenIndexPath = _currentIndexPath;
    NSMutableArray *deletIndePath = [NSMutableArray array];
    if(oldOpenIndexPath && _expandStye == ExpandConflict){
        for(int i = 0;i < oldOpenIndexPath.row;i++){
            [deletIndePath addObject:[NSIndexPath indexPathForRow:i inSection:oldOpenIndexPath.section]];
        }
        [_sectionStatus setObject:@(NO) forKey:@(oldOpenIndexPath.section)];
    }
    [_tableView beginUpdates];
    if(selectedSection_isOpen){
        [_tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        _currentIndexPath = [NSIndexPath indexPathForRow:insertCount inSection:tap.view.tag];
    }
    else{
        [_tableView deleteRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        _currentIndexPath = nil;
    }
    
    if(deletIndePath.count != 0){
    
        [_tableView deleteRowsAtIndexPaths:deletIndePath withRowAnimation:UITableViewRowAnimationBottom];
    }
    [_tableView endUpdates];

}

@end
