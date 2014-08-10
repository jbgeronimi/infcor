//
//  resultViewController.h
//  infcor
//
//  Created by admin notte on 26/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface resultViewController : UITableViewController
@property (weak,nonatomic) NSArray *risultati;
@property (weak, nonatomic) NSString *alangue;
@property (strong,nonatomic) NSString *searchText;
@property (strong,nonatomic) NSURL *searchURL;

@end
