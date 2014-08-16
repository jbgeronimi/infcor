//
//  resultViewController.m
//  infcor
//
//  Created by admin notte on 26/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "resultViewController.h"
#import "afficheMotViewController.h"
//#import "AFJSONRequestOperation.h"
//#import "AFNetworking.h"

@interface resultViewController ()

@end

@implementation resultViewController

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = self.searchText;
    }
    return self;
}

- (void)viewDidLoad
{
    NSString *cercaURL = [NSString stringWithFormat:@"http://adecec.net/infcor/try/traitement.php?mot=%@&langue=%@&param=%@", self.searchText, self.alangue, self.params];
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
                                                            options:0
                                                              error:nil];
    
    NSLog(@"Sync JSON: %@", self.risultati);
// Requete ASynchrone
 /*   __block NSArray *json;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               json = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];
                               self.risultati = json;
                               NSLog(@"Async JSON: %@", self.risultati);
                           }];
-- Fin */
}
    
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.risultati.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
//a definir en fonction des resultats renvoyes par la base
    cell.textLabel.text = self.risultati[indexPath.row][@"id"];
    NSLog(@" cell : %@",cell.textLabel.text);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    afficheMotViewController *motVC = [[afficheMotViewController alloc] init];
    motVC.searchText = self.risultati[indexPath.row][@"id"];
    motVC.alangue = self.alangue;
    motVC.params = self.params;
    motVC.lindex = indexPath.row;
    
    [self.navigationController pushViewController:motVC animated:YES];
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
