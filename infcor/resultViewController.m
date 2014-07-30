//
//  resultViewController.m
//  infcor
//
//  Created by admin notte on 26/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "resultViewController.h"
#import "motViewController.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworking.h"

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
    NSString *UUID = [[NSUUID UUID] UUIDString];
    NSString *res = [NSString stringWithFormat:@"http://adecec.net/infcor/results/%@.json", UUID];
    NSURL *url = [[NSURL alloc] initWithString:res];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.risultati = JSON;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"NSError: %@",[error localizedDescription]);
    }];
    
    [operation start];
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
    cell.textLabel.text = self.risultati[indexPath.row][@"title"];
//    cell.detailTextLabel.text = self.images[indexPath.row][@"detail"];
//    [cell.imageView setImageWithURL:[NSURL URLWithString:self.images[indexPath.row][@"thumbnail"]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    
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
