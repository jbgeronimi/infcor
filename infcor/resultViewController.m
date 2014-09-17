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
    self.spinner.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];
    /*
     //Modification des matrices affiche_mot et affiche_liste pour respecter le contexte de langue
     if(([self.alangue isEqualToString:@"mot_francais"]) && !([self.params[@"affiche_mot"] containsObject:@"id"])){
     [self.params[@"affiche_mot"] insertObject:@"id" atIndex:0];
     [self.params[@"affiche_liste"] insertObject:@"FRANCESE" atIndex:0];}
     else if (([self.alangue isEqualToString:@"mot_corse"]) && !([self.params[@"affiche_mot"] containsObject:@"FRANCESE"])){
     [self.params[@"affiche_mot"] insertObject:@"FRANCESE" atIndex:0];
     [self.params[@"affiche_liste"] insertObject:@"id" atIndex:0];}*/
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
    self.resultTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
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
    //Un message d'alerte si pas de résultat
    if (self.risultati.count == 0){
        NSDictionary *erreur =@{@"mot_corse":@"PRUBLEMA",
                                @"mot_francais":@"ERREUR"};
        NSDictionary *textAlert = @{@"mot_corse":@"Nisun Risultatu pè a vostra ricerca. Forse ùn avete micca srittu a vostra parolla curettamente. Pudete cuntattà l'ADECEC pè prupone una soluzione",
                                    @"mot_francais":@"La banque INFCOR n'a pas de résultat à afficher. Il s'agit peut être d'une faute de frappe. Vous pouvez contacter l'ADECEC pour proposer une solution"};
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[erreur valueForKey:self.alangue]
                                                        message:[textAlert valueForKey:self.alangue]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"contact", nil];
        [alert show];
        
    }
    NSLog(@"risultati %@",self.risultati);
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.risultati[indexPath.row][[[self.params valueForKey:@"affiche_liste"] valueForKey:self.alangue][0]];
    //le mot contient " : " il faut les enlever pour l'esthetique
    cell.textLabel.text = [cell.textLabel.text substringFromIndex:2];
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
    detVC.title = self.risultati[indexPath.row][[[self.params valueForKey:@"affiche_liste"] valueForKey:self.alangue][0]];
    detVC.title = [detVC.title substringFromIndex:2];
    detVC.gio = self.gio;
    
    [self.navigationController pushViewController:detVC animated:YES];
}

-(void) viewDidAppear:(BOOL)animated{
    [self.resultTableView reloadData];
    if(self.risultati){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.spinner stopAnimating];}
    //    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    //   [self.params[@"affiche_liste"] removeObjectAtIndex:0];
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
