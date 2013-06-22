//
//  SearchResult.cpp
//  EmailSearch
//
//  Created by Radif Sharafullin on 6/21/13.
//  Copyright (c) 2013 MCB. All rights reserved.
//

#include "SearchResult.h"
#include "Search.h"
#include <fstream>

namespace EmailSearch {
    static std::vector<std::string> _paths;
    
    void initializePathsLookup(){
        static std::once_flag onceFlag;
        std::call_once(onceFlag,[](){
            std::string filePath(pathToPaths());
            std::ifstream mapStream(filePath);
            std::string line;
            while(std::getline(mapStream, line))
                _paths.push_back(line);
        });
    }
    
    SearchResult::SearchResult(const std::string m_word, const unsigned emailPathID, const unsigned lineNumber, const long elapsedTime)
    : word(m_word), _emailPathID(emailPathID), _lineNumber(lineNumber), _elapsedTime(elapsedTime)
    {
        initializePathsLookup();
    }
    
    SearchResult::SearchResult(const SearchResult& other)
    : word(other.word), _emailPathID(other._emailPathID), _lineNumber(other._lineNumber), _elapsedTime(other._elapsedTime)
    {
        initializePathsLookup();
    }
    
    std::string SearchResult::emailPath() const{return _paths.at(_emailPathID);}
    
    std::string SearchResult::emailBody() const{
        std::string retVal;
        
        std::string filePath(pathToRes()+emailPath());
        std::ifstream stream(filePath);
        std::string line;
        while(std::getline(stream, line))
            retVal+=(line+"\n");
        
        return retVal;
    }
    
    std::string SearchResult::emailLine() const{
        std::string retVal;
        
        std::string filePath(pathToRes()+emailPath());
        std::ifstream stream(filePath);
        std::string line;
        int lineCounter(0);
        while(std::getline(stream, line)){
            if (lineCounter==_lineNumber)
                retVal=line;
            lineCounter++;
        }
        return retVal;
    }
    
}

