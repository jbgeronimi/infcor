//
//  afficheMotViewController.h
//  INFCOR
//
//  Created by admin notte on 16/08/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface afficheMotViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak,nonatomic) NSArray *risultati;
@property (weak, nonatomic) NSString *alangue;
@property (strong,nonatomic) UITableView *afficheMotTableView;
@property (strong, nonatomic) NSDictionary *params;
@property (assign,nonatomic) NSUInteger lindex;
@property (strong,nonatomic) NSString *searchText;
@property (strong, nonatomic) UIScrollView *motView;
@end
