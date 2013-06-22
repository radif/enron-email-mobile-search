//
//  SearchResult.h
//  EmailSearch
//
//  Created by Radif Sharafullin on 6/21/13.
//  Copyright (c) 2013 MCB. All rights reserved.
//

#ifndef __EmailSearch__SearchResult__
#define __EmailSearch__SearchResult__

#include <iostream>
namespace EmailSearch {
    class SearchResult {
        const unsigned _emailPathID;
        const unsigned _lineNumber;
        const long _elapsedTime;
    public:
        const std::string word;
        std::string emailPath() const;
        std::string emailBody() const;
        std::string emailLine() const;
        SearchResult(const std::string m_word, const unsigned emailPathID, const unsigned lineNumber, const long elapsedTime);
        SearchResult(const SearchResult& other);
    };
}

#endif /* defined(__EmailSearch__SearchResult__) */
