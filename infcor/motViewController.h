//
//  motViewController.h
//  infcor
//
//  Created by admin notte on 30/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface motViewController : UIViewController
@property (weak,nonatomic) NSArray *risultati;
@property (weak, nonatomic) NSString *alangue;
@property (strong, nonatomic) NSDictionary *params;
@property (assign,nonatomic) NSUInteger lindex;
@property (strong,nonatomic) NSString *searchText;
@property (strong, nonatomic) UIScrollView *motView;

@end
