//
//  ProtocolLocator.h
//
//  Created by Tomer Shiri on 12/19/11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProtocolLocator : NSObject

+ (NSArray*) getAllClassesByProtocolType:(Protocol*) protocol;

@end
