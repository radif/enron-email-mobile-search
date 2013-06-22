//
//  Search.h
//  EmailSearch
//
//  Created by Radif Sharafullin on 6/21/13.
//  Copyright (c) 2013 MCB. All rights reserved.
//

#ifndef __EmailSearch__Search__
#define __EmailSearch__Search__

#include <iostream>
#include <vector>
#include <functional>
#include "SearchResult.h"

namespace EmailSearch {
    typedef std::vector<SearchResult> results_t;
    typedef std::shared_ptr<results_t> p_results_t;
    typedef std::function<void(std::string query, p_results_t results, long timeMillis)> completion_t;
    
    //platform specific helpers
    
    std::string pathToRes();

    std::string pathToIndex();
    std::string pathToData();
    std::string pathToPaths();
    
    void callOnMainThread(std::function<void()>handle);
    
    class Search{
        void search(const std::string query, const completion_t completion);
    public:
        Search(const std::string & m_query, completion_t completion);
        
    };    
}


#endif /* defined(__EmailSearch__Search__) */
