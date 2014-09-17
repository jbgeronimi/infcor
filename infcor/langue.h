//
//  langue.h
//  infcor
//
//  Created by admin notte on 25/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import <Foundation/Foundation.h>
@class langue;
@protocol langueDelegate <NSObject>
@end

@interface langue : NSObject {
//    NSString *context;
//    id <langueDelegate> delegate;
}
@property (retain,nonatomic) NSString *context ;
@property (nonatomic,assign) id<langueDelegate> delegate;

@end
