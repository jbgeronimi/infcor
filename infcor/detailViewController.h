//
//  detailViewController.h
//  INFCOR
//
//  Created by admin notte on 24/08/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak,nonatomic) NSDictionary *detailRisultati;
@property (weak, nonatomic) NSString *alangue;
@property (strong,nonatomic) UITableView *detailTableView;
@property (strong, nonatomic) NSDictionary *params;
@property (strong,nonatomic) UIFont *gio;

@end
