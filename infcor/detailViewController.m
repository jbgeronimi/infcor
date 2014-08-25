//
//  detailViewController.m
//  INFCOR
//
//  Created by admin notte on 24/08/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//
#import "resultViewController.h"
#import "detailViewController.h"

@interface detailViewController ()

@end

@implementation detailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
 //       self.title = [self.detailRisultati[@"id"][0]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.detailTableView=[[UITableView alloc] init];
    self.detailTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    [self.detailTableView reloadData];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"le JSON seul %@", self.detailRisultati);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.params[self.alangue] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell_%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSLog(@"cell %@",cellIdentifier);
    UIFont *arial= [UIFont fontWithName:@"arial" size:15];
    cell.textLabel.font = arial;
    if ([self.detailRisultati valueForKey:self.params[@"dbb_query"][indexPath.row]]) {cell.textLabel.text = [self.params[self.alangue][indexPath.row] stringByAppendingString:[self.detailRisultati valueForKey:self.params[@"dbb_query"][indexPath.row]]];}
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize maximumLabelSize = CGSizeMake(300,9999);
    UIFont *arial= [UIFont fontWithName:@"arial" size:15];
    CGRect titleRect = [self rectForText:[self.params[self.alangue][indexPath.row] stringByAppendingString:[self.detailRisultati valueForKey:self.params[@"dbb_query"][indexPath.row]]]
                               usingFont:arial
                           boundedBySize:maximumLabelSize];
    return titleRect.size.height + 10;
}

-(CGRect)rectForText:(NSString *)text
           usingFont:(UIFont *)font
       boundedBySize:(CGSize)maxSize
{
    NSAttributedString *attrString =
    [[NSAttributedString alloc] initWithString:text
                                    attributes:@{ NSFontAttributeName:font}];
    return [attrString boundingRectWithSize:maxSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    if(([self.alangue isEqualToString:@"mot_corse"]) & ([self.params[@"dbb_query"] containsObject:@"FRANCESE"])) {
        [self.params[@"dbb_query"] removeObject:@"FRANCESE"];
        [self.params[@"mot_corse"] removeObject:@"FRANCESE"];
    }
    else{
        [self.params[@"dbb_query"] removeObject:@"id"];
        [self.params[@"mot_francais"] removeObject:@"CORSU : "];}
    NSLog(@"params a disappear %@",self.params);
    
}

@end
