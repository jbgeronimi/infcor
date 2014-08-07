//
//  resultViewController.m
//  infcor
//
//  Created by admin notte on 26/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "resultViewController.h"
#import "motViewController.h"
//#import "AFJSONRequestOperation.h"
//#import "AFNetworking.h"

@interface resultViewController ()

@end

@implementation resultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"INFCOR - ADECEC";
    }
    return self;
}

- (void)viewDidLoad
{

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.searchURL];
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
    NSLog(@" count : %lu", self.risultati.count);
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
    
    motViewController *motVC = [[motViewController alloc] init];
    // on garde notre fichier JSON et on affiche d'autres champs
//    motVC.detail = self.risultati[indexPath.row][@"detail"];
//    motVC.synonyme = self.risultati[indexPath.row][@"synonyme"];
    
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
