//
//  resultViewController.h
//  infcor
//
//  Created by admin notte on 26/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface resultViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *resultTableView;
@property (strong,nonatomic) NSArray *risultati;
@property (strong, nonatomic) NSString *alangue;
@property (strong,nonatomic) NSString *searchText;
@property (strong, nonatomic) NSDictionary *params;
@property (strong,nonatomic) NSURL *searchURL;
@property (strong,nonatomic) UIFont *gio;

@end
