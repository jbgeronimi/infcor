 //
//  resultViewController.m
//  infcor
//
//  Created by admin notte on 26/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "resultViewController.h"
#import "detailViewController.h"
#import "contactViewController.h"


@interface resultViewController ()

@end

@implementation resultViewController

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
//Ajout d'un spinner d'attente
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.frame = [[UIScreen mainScreen] bounds];
    self.spinner.center = CGPointMake( self.view.frame.size.width /2,(self.view.frame.size.height / 2) - 64);
    self.spinner.color = [UIColor blackColor];
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];
    
    // id : traduction du mot en corse, toujours présent au retour de la requete. On fait le choix d'imposer la traduction du mot recherché. id ne dois pas etre present pour la requete mot_francais mais apres
    if(([self.alangue isEqualToString:@"mot_corse"]) && !([self.params[@"dbb_query"] containsObject:@"FRANCESE"])){
        [self.params[@"dbb_query"] insertObject:@"FRANCESE" atIndex:0];
        [self.params[@"mot_corse"] insertObject:@"FRANCESE" atIndex:0];
    }else if(([self.alangue isEqualToString:@"mot_francais"]) & !([self.params[@"dbb_query"] containsObject:@"id"])){
        [self.params[@"dbb_query"] insertObject:@"id" atIndex:0 ];
        [self.params[@"mot_francais"] insertObject:@"CORSU : " atIndex:0];
    }
 
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //       self.title = [self.detailRisultati valueForKey:self.params[@"dbb_query"][0]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.resultTableView=[[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.resultTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.separatorStyle = UITableViewCellSelectionStyleNone;

    if(([self.alangue isEqualToString:@"mot_corse"]) && !([self.params[@"dbb_query"] containsObject:@"FRANCESE"])){
        [self.params[@"dbb_query"] insertObject:@"FRANCESE" atIndex:0];
        [self.params[@"mot_corse"] insertObject:@"FRANCESE" atIndex:0];
    }
    //cas du mot_francais : id(CORSU) est ajouté apres, dans view did appear
    NSString *cercaURL = [NSString stringWithFormat:@"http://adecec.net/infcor/try/debut.php?mot=%@&langue=%@&param=%@", self.searchText, self.alangue,[self.params[@"dbb_query"] componentsJoinedByString:@" "] ];
    cercaURL = [cercaURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//Connection à la base en mode asynchrone : utilisation de didReceiveresponse,didReceiveData,willCacheResponse,connectionDidFinishLoading
    self.searchURL = [NSURL URLWithString:cercaURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.searchURL];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
 }

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc]init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:_responseData
                                                           options:0
                                                             error:nil];
    self.risultati = json;
    [self.tableView reloadData];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.spinner stopAnimating];
}

-(void)alertView:(UIAlertView *)alarm clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if(buttonIndex == 1){
        contactViewController *contact = [[contactViewController alloc]init];
        NSString *txtContact = @"http://adecec.net/infcor/contact.php?mot=";
        txtContact = [txtContact stringByAppendingString:self.searchText];
        NSURLRequest *urlContact = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:txtContact]];
        contact.urlContact = urlContact;
        [self.navigationController pushViewController:contact animated:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.risultati.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell_%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//a definir en fonction des resultats renvoyes par la base
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.risultati[indexPath.row][@"id"];
    cell.textLabel.font = self.gio;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    detailViewController *detVC = [[detailViewController alloc] init];
    detVC.detailRisultati = self.risultati[indexPath.row];
    detVC.alangue = self.alangue;
    detVC.params = self.params;
    detVC.title = self.searchText;
    detVC.gio = self.gio;

    [self.navigationController pushViewController:detVC animated:YES];
}

-(void) viewDidAppear:(BOOL)animated{
    [self.resultTableView reloadData];

//    [super viewDidAppear:animated];
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
