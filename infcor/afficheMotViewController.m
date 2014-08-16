//
//  afficheMotViewController.m
//  INFCOR
//
//  Created by admin notte on 16/08/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "afficheMotViewController.h"

@interface afficheMotViewController ()

@end

@implementation afficheMotViewController

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = self.searchText;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"params %@", self.params[self.alangue]);
    NSString *cercaURL = [NSString stringWithFormat:@"http://adecec.net/infcor/try/traitement.php?mot=%@&langue=%@&param=%@", self.searchText, self.alangue, [self.params[@"mot_corse"] componentsJoinedByString:@" "]];
    cercaURL = [cercaURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    [risultatiVC setSearchURL:[NSURL URLWithString:cercaURL]];
    NSURL *cerca = [NSURL URLWithString:cercaURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:cerca];
    NSLog(@"cerca : %@",cercaURL);
    // Requete synchrone
    NSData *theData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:nil
                                                        error:nil];
    
    self.risultati = [NSJSONSerialization JSONObjectWithData:theData
                                                     options:NSJSONReadingAllowFragments
                                                       error:nil];
    
    self.title = self.searchText;
    NSLog(@"Sync JSON: %@", self.risultati);
    NSLog(@"JSON ligne 0 : %@",[self.risultati valueForKey:@"DEFINIZIONE"]);
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.afficheMotTableView=[[UITableView alloc] init];
    self.afficheMotTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.afficheMotTableView.delegate = self;
    self.afficheMotTableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;

//    [self afficheMot:self.alangue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.params[@"mot_corse"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    UIFont *arial= [UIFont fontWithName:@"arial" size:15];
    cell.textLabel.font = arial;
    cell.textLabel.text = [self.params[self.alangue][indexPath.row] stringByAppendingString:[self.risultati valueForKey:self.params[@"mot_corse"][indexPath.row]][0]];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    NSLog(@"pour la clef %@",[self.risultati valueForKey:self.params[@"mot_corse"][indexPath.row]][0]);
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize maximumLabelSize = CGSizeMake(300,9999);
    UIFont *arial= [UIFont fontWithName:@"arial" size:15];
    CGRect titleRect = [self rectForText:[self.params[self.alangue][indexPath.row] stringByAppendingString:[self.risultati valueForKey:self.params[@"mot_corse"][indexPath.row]][0]]
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

@end
