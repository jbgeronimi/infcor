//
//  prefsViewController.h
//  infcor
//
//  Created by admin notte on 24/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "langue.h"


@interface prefsViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *afficheParams;
@property NSIndexPath *lindex;
@property (strong, nonatomic) NSString  *alangue;
@property (copy)  NSDictionary *params;
@property (strong,nonatomic) NSDictionary *allParams;
@end
