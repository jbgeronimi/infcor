//
//  contactViewController.m
//  INFCOR
//
//  Created by admin notte on 31/08/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "contactViewController.h"

@interface contactViewController ()

@end

@implementation contactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIWebView *contact = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 800)];
    [contact loadRequest:self.urlContact];
    [self.view addSubview:contact];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
