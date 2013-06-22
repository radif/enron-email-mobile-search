//
//  Search.cpp
//  EmailSearch
//
//  Created by Radif Sharafullin on 6/21/13.
//  Copyright (c) 2013 MCB. All rights reserved.
//

#include "Search.h"
#import <Foundation/Foundation.h>

namespace EmailSearch{
    void callOnMainThread(std::function<void()>handle){
        if (handle) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handle();
            });
        }
    }
    
    std::string pathToRes(){
        return [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"res"] UTF8String];
    }
    
    std::string pathToIndex(){
        return [[[@(pathToRes().c_str()) stringByAppendingPathComponent:@"index"] stringByAppendingPathComponent:@"index.txt"] UTF8String];
    }
    std::string pathToData(){
    return [[[@(pathToRes().c_str()) stringByAppendingPathComponent:@"index"] stringByAppendingPathComponent:@"data.txt"] UTF8String];
    }
    std::string pathToPaths(){
    return [[[@(pathToRes().c_str()) stringByAppendingPathComponent:@"index"] stringByAppendingPathComponent:@"paths.txt"] UTF8String];
    }

    
    
}
