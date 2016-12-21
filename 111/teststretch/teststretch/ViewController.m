//
//  ViewController.m
//  teststretch
//
//  Created by ios on 16/8/31.
//  Copyright © 2016年 KyleWong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;//数据
@property (nonatomic, strong)NSMutableArray<NSNumber *> *isExpland;//是否展开

@property (nonatomic, strong) NSMutableArray<NSNumber *> *subTitleArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadData {
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    if (!self.isExpland) {
        self.isExpland = [NSMutableArray array];
    }
    
    if (!self.subTitleArray) {
        self.subTitleArray = [NSMutableArray array];
    }
    
    //这里用一个二维数组来模拟数据。
    self.dataArray = [NSArray arrayWithObjects:@[@"a",@"b",@"c",@"d"],@[@"d",@"e",@"f"],@[@"h",@"i",@"j",@"m",@"n"],nil].mutableCopy;
    
    //用0代表收起，非0（不一定是1）代表展开，默认都是收起的
    for (int i = 0; i < self.dataArray.count; i++) {
        [self.isExpland addObject:@0];
        
        [self.subTitleArray addObject:@0];
    }
    
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这里是关键，如果选中
    NSArray *array = self.dataArray[section];
    if ([self.isExpland[section] boolValue]) {
        if([self.subTitleArray[section] boolValue])
        {
            return 0;
        }
        return array.count;
    }
    else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }

    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(![self.isExpland[section] boolValue])
    {
        UIButton *headerSection = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 600, 44)];
        headerSection.tag = 666+section;
        headerSection.backgroundColor = [UIColor redColor];
        //标题
        [headerSection setTitle:[NSString stringWithFormat:@"第%@组",@(section)] forState:UIControlStateNormal];
        
        [headerSection addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        return headerSection;

    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 88)];
        UIButton *headerSection = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 600, 44)];
        headerSection.tag = 666+section;
        headerSection.backgroundColor = [UIColor redColor];
        //标题
        [headerSection setTitle:[NSString stringWithFormat:@"第%@组",@(section)] forState:UIControlStateNormal];
        
        [headerSection addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:headerSection];
        
        UIButton *headerSubSection = [[UIButton alloc] initWithFrame:CGRectMake(0, 44, 600, 44)];
        headerSubSection.tag = 888+section;
        headerSubSection.backgroundColor = [UIColor purpleColor];
        //标题
        [headerSubSection setTitle:[NSString stringWithFormat:@"第%@组subtitle",@(section)] forState:UIControlStateNormal];
        
        [headerSubSection addTarget:self action:@selector(buttonSubtitleAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:headerSubSection];
        
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if([self.isExpland[section] boolValue])
    {
        return 88;
    }
    else
    {
        return 44;
    }
}

- (void)buttonAction:(UIButton *)button {
    NSInteger section = button.tag - 666;
    self.isExpland[section] = [self.isExpland[section] isEqual:@0]?@1:@0;
    self.subTitleArray[section] = @0;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

- (void)buttonSubtitleAction:(UIButton *)button {
    NSInteger section = button.tag - 888;
    self.subTitleArray[section] = [self.subTitleArray[section] isEqual:@0]?@1:@0;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

@end
