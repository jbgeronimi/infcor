//
//  contactViewController.m
//  INFCOR
//
//  Created by admin notte on 31/08/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "contactViewController.h"
#import "ViewController.h"

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

-(void)viewWillAppear:(BOOL)animated{
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *chjode = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(chjodeFinestra:)];
    self.navigationItem.title = @"";
    self.navigationItem.leftBarButtonItem = chjode;

    UIWebView *contact = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [contact loadRequest:self.urlContact];
    [self.view addSubview:contact];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chjodeFinestra:(id)sender {
    ViewController *homeVC = [[ViewController alloc] init];
    [self.navigationController pushViewController:homeVC animated:YES];
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
