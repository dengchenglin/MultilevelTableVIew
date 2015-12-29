//
//  ViewController.m
//  MultilevelTableVIew
//
//  Created by chenguangjiang on 15/12/28.
//  Copyright © 2015年 dengchenglin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<MultilevelTableViewDelegate,MultilevelTableViewDataSoure>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[MultilevelTableVIew alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _tableView.delegate = self;
    _tableView.dataSoure = self;
    _tableView.expandStye = ExpandUnConflict;//允许展开多段
    [self.view addSubview:_tableView];
}

- (NSInteger)mnumberOfSectionsInTableView:(MultilevelTableVIew *)tableView{
    return 10;
}
- (CGFloat)mtableView:(MultilevelTableVIew *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView *)mtableView:(MultilevelTableVIew *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    label.text = [NSString stringWithFormat:@"一级%d段",(int)section];
    [view addSubview:label];
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, label.bounds.size.height - 1, self.view.bounds.size.width, 1)];
    line.backgroundColor = [UIColor grayColor];
    [label addSubview:line];
    return view;
}

-(void)mtableView:(MultilevelTableVIew *)tableView touchHeaderForSection:(NSInteger)section isOpen:(BOOL)isOpen{
    if(isOpen){
        NSLog(@"第%ld段展开",(long)section);
    }
    else{
        NSLog(@"第%ld段关闭",(long)section);
    }
}

- (NSInteger)mtableView:(MultilevelTableVIew *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)mtableView:(MultilevelTableVIew *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(UITableViewCell *)mtableView:(MultilevelTableVIew *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"indentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"二级%ld",(long)indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)mtableView:(MultilevelTableVIew *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击第%ld段第%ld行",(long)indexPath.section,(long)indexPath.row);
}
@end
