//
//  CQTPopOverView.m
//  CQTIda
//
//  Created by ANine on 7/10/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTPopOverView.h"
#import "CQTViewConstants.h"

@interface CQTPopOverView(Private) {

}

@property (nonatomic,readwrite)BOOL isShow;

@end


@implementation CQTPopOverView


#pragma mark - | ***** super Methods ***** |

- (instancetype)initWithTarget:(id <UITableViewDataSource,UITableViewDelegate>)target {
    
    if (self = [super init]) {
        
        [self createHeadViewIfNeeded];
        [self addSubview:_headView];
        
        [self createTableViewIfNeeded];
        [self addSubview:_tableView];
        
        _tableView.delegate = target;
        _tableView.dataSource = target;
        
        setClearColor(self);
        
        self.isShow = NO;
        self.hidden = YES;
        self.needGuide = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    if (CGSizeEqualToSize(frame.size,CGSizeZero)) {
        return;
    }

    [self updateSubviewsGUI];
    
    //do something.
}

- (void)updateSubviewsGUI {
    
    _headView.frame = ViewRect((ViewWidth(self) - 20) /2, 0, 20, 10);
    
    _tableView.frame = ViewRect(0, ViewBottom(_headView), ViewWidth(self), ViewHeight(self) - ViewHeight(_headView));
}

- (void)dealloc {
    
    A9_ViewReleaseSafely(_tableView);
    A9_ViewReleaseSafely(_headView);
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
    
    
}

#pragma mark - | ***** public methods ***** |
- (void)setMainColor:(UIColor *)mainColor {
    
    if (_mainColor) {
        
        A9_ObjectReleaseSafely(_mainColor);
    }
    _mainColor = [mainColor copy];
    setClearColor(self);
    _headView.backgroundColor = kClearColor;
    _tableView.backgroundColor = mainColor;
}

- (void)setNeedGuide:(BOOL)needGuide {
    
    [self createHeadViewIfNeeded];
    
    if (_needGuide != needGuide) {
        
        if (needGuide) {
           
            [self addSubview:_headView];
        }else {
            
            A9_ViewReleaseSafely(_headView);
        }
        
        _needGuide = needGuide;
        
        [self updateSubviewsGUI];
    }
}

#pragma mark - | *****  private methods ***** |
- (void)createHeadViewIfNeeded {
    
    if (!_headView) {
        
        _headView = [[CQTImgView alloc] init];
        _headView.image = Image(grayArrow.png);
    }else {
        
        CQTRemoveFromSuperViewSafely(_headView);
    }
}

- (void)createTableViewIfNeeded {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = HEX_RGB(0xF2F2F2);;
        _tableView.layer.cornerRadius = 6.;
        _tableView.clipsToBounds = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = YES;
    }else {
        
        CQTRemoveFromSuperViewSafely(_tableView);
    }
}

@end
