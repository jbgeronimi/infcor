//
//  motDataSource.m
//  INFCOR
//
//  Created by admin notte on 02/08/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "motDataSource.h"
#import "ViewController.h"


@implementation motDataSource


-  (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField 
         possibleCompletionsForString:(NSString *)string {
    NSString *cercaString = (@"http://adecec.net/infcor/try/suggestion.php?mot=%@&langue=%@",textField, @"mot_corse");
    NSLog(@"cerca : %@", cercaString);
    NSURL *cercaURL = [[NSURL alloc] initWithString:cercaString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:cercaURL];
    NSData *theData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:nil
                                                        error:nil];
    
    NSMutableArray *risultati = [NSJSONSerialization JSONObjectWithData:theData
                                                     options:0
                                                       error:nil];
    

    return risultati;
    
}


@end
