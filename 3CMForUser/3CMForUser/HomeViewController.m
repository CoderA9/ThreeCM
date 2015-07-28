//
//  ViewController.m
//  3CMForUser
//
//  Created by ANine on 7/27/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

#pragma mark - | ***** super methods ***** |


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)createContainersIfNeeded {
    
    [super createContainersIfNeeded];
    
}

- (void)createModelsIfNeeded {
    
    [super createModelsIfNeeded];
}
/* release some objects base UIView in this methods */
- (void)unloadView {
    
    [super unloadView];
}

/* release some objects base DataBase in this methods */
- (void)dealloc {
    
    CQT_SUPER_DEALLOC();
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)configVisualSubviews {
    
    // this method operate UIView initial replace viewDidLoad.
    
    [super configVisualSubviews];
    
    __unsafe_unretained CQTBaseTableViewController * weakSelf = self;
    
    [weakSelf createLeftNavBtnIfNeededWithTitle:@"" handle:^(id sender) {
        
        [weakSelf backToPreViewController];
        
    }];
    
    [self.customNavBarView addSubview:_leftNavBtn];
    
    [self createTitleLabelIfNeeded:self.title];
    [_customNavBarView addSubview:_titleLabel];
    
    [self createTableHeaderViewIfNeeded];
    _tableView.tableHeaderView = _tableHeaderView;
    
}

- (void)loadNeedData {
    
    [super loadNeedData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}
#pragma mark - | ***** Create Views ***** |

#pragma mark - | ***** private methods ***** |


#pragma mark - | ***** public methods ***** |
#pragma mark - | ***** UITableViewDataSource ***** |

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger sections = 1;
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = 10;
    
    switch (section) {
            
        case 0:
            
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = @"";
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 44.;
    
    switch (indexPath.section) {
            
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        CQT_AUTORELEASE(cell);
    }
    
    cell.textLabel.text = @"12132";
    return cell;
}

#pragma mark - | ***** UITableViewDelegate ***** |

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
