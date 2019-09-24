//
//  ZAlgoStringViewController.m
//  ZAlgoDemo
//
//  Created by zjixin on 2019/6/20.
//  Copyright © 2019 zjixin. All rights reserved.
//

#import "ZAlgoStringViewController.h"

@interface ZAlgoStringViewController()

@property (nonatomic, strong) NSArray<NSDictionary *> *dataSource;

@end

@implementation ZAlgoStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ZAlgoDemoCell"];
    
    self.dataSource = @[
                        @{@"title" : @"1. 字符串翻转",
                          @"subtitle": @"reverseString",
                          @"viewController" : @"",
                          @"action": @"reverseString"},
                        @{@"title" : @"2. 其他",
                          @"subtitle": @"",
                          @"viewController" : @"ZAlgoSortViewController",
                          @"action": @""},
                        ];
    [self.tableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZAlgoDemoCell" forIndexPath:indexPath];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    NSString *title = [dic valueForKey:@"title"];
    NSString *subtitle = [dic valueForKey:@"subtitle"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@--%@", title, subtitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = [self.dataSource objectAtIndex:indexPath.row];
    NSString *action = [item valueForKey:@"action"];
    if (action) {
        SEL sel = NSSelectorFromString(action);
        if ([self respondsToSelector:sel]) {
            [self performSelector:sel withObject:item];
        }
    }
}

#pragma mark -- Action

- (void)reverseString {
    NSString *string = @"the sky is blue";
    const char *stringChar = string.UTF8String;
    char *ch = reverse_str(stringChar);
//    NSString * str = [NSString stringWithUTF8String:ch];
//    NSLog(@"reversedString = %@", str);
    NSString *reversedString = [self reverseStringWith:string];
    NSLog(@"reversedString = %@", reversedString);
}

char * reverse_str(const char *s) {
    if (s == NULL) {
        return NULL;
    }
    
    char copyStr[strlen(s)];
    
    char temp;
    int length = 0;
    int i = 0, j = 0;
    while (s[i]) {
        copyStr[i] = s[i];
        i++;
        length++;
    }
    
    //先翻转单词
    
    
    //再翻转句子
    i = 0;
    j = length - 1;
    while (i < j) {
        temp = copyStr[i];
        copyStr[i] = copyStr[j];
        copyStr[j] = temp;
        i++;
        j--;
    }
    
    char *newStr[length];
    
    for (NSInteger index = 0; index < length; index++) {
        newStr[index] = copyStr[index];
    }
    return newStr;
}

- (NSString *)reverseStringWith:(NSString *)string {
    NSArray<NSString *> *strArray = [string componentsSeparatedByString:@" "];
    NSMutableArray *mutaArray = [NSMutableArray arrayWithCapacity:strArray.count];
    for (NSInteger index = strArray.count - 1; index >= 0; index--) {
        [mutaArray addObject:strArray[index]];
    }
    return [mutaArray componentsJoinedByString:@" "];

}

@end
