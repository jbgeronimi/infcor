//
//  ViewController.h
//  infcor
//
//  Created by admin notte on 24/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "langue.h"

@interface ViewController : UIViewController <UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource>/*{
    UITableView *suggestTableView;
}*/
@property (strong,nonatomic) UIButton *primu;
@property (strong,nonatomic) NSString *alangue;
@property (strong,nonatomic) UITextField *searchText;
@property (strong,nonatomic) NSURL *searchURL;
@property (strong,nonatomic) NSMutableArray *suggest;
@property (retain,nonatomic) UITableView *suggestTableView;
@property  NSDictionary *params;
@property (assign,nonatomic) NSUInteger lindex;
@end
