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
    //Ajout d'un spinner d'attente
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.frame = [[UIScreen mainScreen] bounds];
    self.spinner.center = CGPointMake( self.view.frame.size.width /2,(self.view.frame.size.height / 2) - 64);
    self.spinner.color = [UIColor blackColor];
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];}

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.afficheMotTableView=[[UITableView alloc] init];
    self.afficheMotTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.afficheMotTableView.delegate = self;
    self.afficheMotTableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    // id : traduction du mot en corse, toujours présent au retour de la requete. On fait le choix d'imposer la traduction du mot recherché. id ne dois pas etre present pour la requete mais apres
    if([self.alangue isEqualToString:@"mot_corse"]){
        [self.params[@"dbb_query"] insertObject:@"FRANCESE" atIndex:0];
        [self.params[@"mot_corse"] insertObject:@"FRANCESE" atIndex:0];
    }else{
        [self.params[@"mot_francais"] insertObject:@"CORSU : " atIndex:0];
    }
    NSString *cercaURL = [NSString stringWithFormat:@"http://adecec.net/infcor/try/traitement.php?mot=%@&langue=%@&param=%@", self.searchText, self.alangue,[self.params[@"dbb_query"] componentsJoinedByString:@" "] ];
    if([self.alangue isEqualToString:@"mot_francais"]){[self.params[@"dbb_query"] insertObject:@"id" atIndex:0 ];}
    cercaURL = [cercaURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *cerca = [NSURL URLWithString:cercaURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:cerca];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    // Requete synchrone
/*    NSData *theData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:nil
                                                        error:nil];
    
    self.risultati = [NSJSONSerialization JSONObjectWithData:theData
                                                     options:NSJSONReadingAllowFragments
                                                       error:nil];
    self.title = self.searchText;
    [self.afficheMotTableView reloadData];*/
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
    self.title = self.searchText;
    [self.tableView reloadData];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.afficheMotTableView reloadData];
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
    if (self.risultati.count > 0) {
        UIFont *fonte= [UIFont fontWithName:@"Klill" size:18];
        UIFont *fonte20 = [UIFont fontWithName:@"Klill" size:21];
        NSAttributedString *longDef=[[NSAttributedString alloc]initWithString:self.params[self.alangue][indexPath.row]  attributes:@{NSFontAttributeName:fonte20}];
        NSMutableAttributedString *leTexte = [[NSMutableAttributedString alloc] initWithAttributedString:longDef];
        NSString *mottu = [@"" stringByAppendingString:[self.risultati valueForKey:self.params[@"dbb_query"][indexPath.row]][0]];
        NSAttributedString *leMot = [[NSAttributedString alloc] initWithString:mottu attributes:@{NSFontAttributeName:fonte}];
        [leTexte appendAttributedString:leMot];
        cell.textLabel.attributedText = leTexte;
    }
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
    if(self.risultati.count > 0){
        UIFont *fonte= [UIFont fontWithName:@"Klill" size:18];
        UIFont *fonte20 = [UIFont fontWithName:@"Klill" size:21];
        NSAttributedString *longDef=[[NSAttributedString alloc]initWithString:self.params[self.alangue][indexPath.row]  attributes:@{NSFontAttributeName:fonte20}];
        NSMutableAttributedString *leTexte = [[NSMutableAttributedString alloc] initWithAttributedString:longDef];
        NSString *mottu = [@"" stringByAppendingString:[self.risultati valueForKey:self.params[@"dbb_query"][indexPath.row]][0]];
        NSAttributedString *leMot = [[NSAttributedString alloc] initWithString:mottu attributes:@{NSFontAttributeName:fonte}];
        [leTexte appendAttributedString:leMot];
        CGSize maxCell = CGSizeMake(self.view.frame.size.width - 20, 9999);
        CGRect tailleCell = [leTexte boundingRectWithSize:maxCell
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil];
            return MAX(20,tailleCell.size.height + tailleCell.size.height / 10);
    }
    else return 25;
}

-(void)viewWillDisappear:(BOOL)animated{
    if ([[self.params[@"dbb_query"] firstObject] isEqualToString:@"FRANCESE"]) {
            [self.params[@"dbb_query"] removeObject:@"FRANCESE"];
            [self.params[@"mot_corse"] removeObject:@"FRANCESE"];
    }
    else if ([[self.params[@"dbb_query"] firstObject] isEqualToString:@"id" ]) {
            [self.params[@"dbb_query"] removeObject:@"id"];
            [self.params[@"mot_francais"] removeObject:@"CORSU : "];}
}
@end
