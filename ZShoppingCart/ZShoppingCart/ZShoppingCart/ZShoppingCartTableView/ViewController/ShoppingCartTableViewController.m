//
//  ShoppingCartTableViewController.m
//  ZShoppingCart
//
//  Created by AlexZhang on 11/12/2017.
//  Copyright © 2017 Jixin. All rights reserved.
//

#import "ShoppingCartTableViewController.h"
#import "CommodityTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "ADTableHeaderView.h"

#define kHeaderWidth [UIScreen mainScreen].bounds.size.width
#define kHeaderHeight 50

#define kCommodityWidth [UIScreen mainScreen].bounds.size.width
#define kCommodityHeight 110

typedef NS_ENUM(NSInteger, ShoppingCartCellType) {
    ShoppingCartCellTypeCommodity = 0,
    ShoppingCartCellTypeRecommend
};

@interface ShoppingCartTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat cellNumerPerRow;

@end

@implementation ShoppingCartTableViewController

static NSString *headerIdentifier = @"ADHeaderView";
static NSString *commodityIdentifier = @"Commodity";
static NSString *recommendIdentifier = @"Recommend";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setContent];
    self.title = @"ShoppingCart TableView";
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[CommodityTableViewCell class] forCellReuseIdentifier:commodityIdentifier];
        [_tableView registerClass:[ADTableHeaderView class] forHeaderFooterViewReuseIdentifier:headerIdentifier];
    }
    return _tableView;
}

- (void)setContent {
    if (KScreenWidth <768) {
        self.cellNumerPerRow = 3.0;
    } else if (KScreenWidth < 1024) {
        self.cellNumerPerRow = 5.0;
    } else {
        self.cellNumerPerRow = 6.0;
    }
    
    self.dataArray = [NSMutableArray array];
    NSMutableArray *commodityArray = [NSMutableArray array];
    NSMutableArray *recommendArray = [NSMutableArray array];
    NSInteger rand = random() % 5;
    for (NSInteger index = 0; index < 17; index++) {
        if (index < rand) {
            [commodityArray addObject:@{@"type" : @(ShoppingCartCellTypeCommodity)}];
        } else {
            [recommendArray addObject:@{@"type" : @(ShoppingCartCellTypeRecommend)}];
        }
    }
    NSMutableArray *finalRecommendArray = [NSMutableArray array];
    NSMutableArray *mutaArray = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger idx = 0; idx < recommendArray.count; idx++) {
        [mutaArray addObject:recommendArray[idx]];
        if (mutaArray.count == self.cellNumerPerRow ||
            idx == recommendArray.count - 1) {
            [finalRecommendArray addObject:[mutaArray copy]];
            [mutaArray removeAllObjects];
        }
    }
    
    [self.dataArray addObject:commodityArray];
    [self.dataArray addObject:finalRecommendArray];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ADTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!headerView) {
        headerView = [[ADTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kHeaderWidth, kHeaderHeight)];
    }
    UIView *backgroundView = [[UIView alloc] initWithFrame:headerView.bounds];
    backgroundView.backgroundColor = [UIColor orangeColor];
    
    headerView.backgroundView = backgroundView;
    return headerView;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kCommodityHeight;
    } else if (indexPath.section == 1) {
        return kRecommendHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.dataArray[indexPath.section];
    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:commodityIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor greenColor];
        UILabel *label = [cell viewWithTag:1000];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
            label.tag = 1000;
        }
        label.text = [NSString stringWithFormat:@"(%ld, %ld)", indexPath.section, indexPath.row];
        [cell addSubview:label];
    } else if (indexPath.section == 1) {
        NSArray *recommendCellArray = array[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:recommendIdentifier];
        if (!cell) {
            cell = [[RecommendTableViewCell alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kRecommendHeight)];
        }
        [(RecommendTableViewCell *)cell setContentWithModel:recommendCellArray row:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
