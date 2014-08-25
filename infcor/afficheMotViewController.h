//
//  afficheMotViewController.h
//  INFCOR
//
//  Created by admin notte on 16/08/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface afficheMotViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSArray *risultati;
@property (strong, nonatomic) NSString *alangue;
@property (strong,nonatomic) UITableView *afficheMotTableView;
@property (strong, nonatomic) NSDictionary *params;
@property (strong,nonatomic) NSString *searchText;
@property (strong, nonatomic) UIScrollView *motView;
@end
