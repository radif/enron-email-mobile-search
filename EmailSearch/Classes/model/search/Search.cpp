//
//  Search.cpp
//  EmailSearch
//
//  Created by Radif Sharafullin on 6/21/13.
//  Copyright (c) 2013 MCB. All rights reserved.
//

#include "Search.h"
#include <future>
#include <chrono>
#include <map>
#include <fstream>
#include <sstream>

namespace EmailSearch{
    
    static std::map<std::string, long long> _index;
    
    void initializeIndex(){
    
        std::string filePath(pathToIndex());
        std::ifstream mapStream(filePath);
        std::string line;
        while(std::getline(mapStream, line)) {
            size_t loc(line.find(","));
            if (loc != line.npos) {
                std::string prefix(line.substr(0,loc));
                std::string lineNum(line.substr(loc+1));
                _index.insert({prefix, atoll(lineNum.c_str())});
            }
            
        }
    }
    
    void testLineForMatchingKeyAndQuery(const std::string & line,const std::string & key, const std::string & query, bool & mathesKey, bool & mathesQuery){
        mathesKey=false;
        mathesQuery=false;
        size_t loc(line.find(","));
        if (loc != line.npos) {
            std::string word(line.substr(0,loc));
            
            if (word.size()<key.size())
                return;
            
            std::string keySubWord(word.substr(0,key.size()));
            mathesKey=keySubWord==key;
            
            if (word.size()<query.size())
                return;
            std::string querySubWord(word.substr(0,query.size()));
            mathesQuery=querySubWord==query;
        }
    }
    
    std::vector<std::string> linesForCharIndex(long long index, const std::string & key, const std::string & query){
        std::string filePath(pathToData());
        std::vector<std::string> retVal;
        std::ifstream dataStream(filePath, std::ifstream::binary);
        std::string line;
        if (dataStream) {
            dataStream.seekg(index);
            bool mathesQuery(false);
            bool mathesKey(false);
            while(std::getline(dataStream, line)) {
                testLineForMatchingKeyAndQuery(line, key, query, mathesKey, mathesQuery);
                
                if (mathesKey) {
                    if (mathesQuery)
                        retVal.push_back(line);
                }else
                    break;
            }
            
        }
        
        return retVal;
        
    }
    
    struct FutureHolder {std::future<void> future;};
    
    long currentTimeMilliseconds() {
        return (long) std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
    }
    
    Search::Search(const std::string & m_query, completion_t completion)
    {
        static std::once_flag onceFlag;
        std::call_once(onceFlag,[](){
            initializeIndex();
        });
        search(m_query, completion);
    }
    
    void Search::search(const std::string query, const completion_t completion){
        
        //find the query match
        
        std::string q(query);
        std::transform(q.begin(), q.end(), q.begin(), ::tolower);
        const long kSearchBeganTime=currentTimeMilliseconds();
        
        
        
        FutureHolder *futureHolder(new FutureHolder());
        futureHolder->future = std::async(std::launch::async, [=] () {
            results_t results;

            std::string key(q);
            if (key.size()>3)
                key=key.substr(0,3);
            

            auto it(_index.find(key));
            
            if (it!=_index.end()) {
                key=(*it).first;
                long long index((*it).second);
                auto lines(linesForCharIndex(index, key, q));
                
                for (auto & line : lines) {
                    //adding a result
                    size_t loc(line.find(","));
                    if (loc != line.npos) {
                        std::string word(line.substr(0,loc));
                        std::string data(line.substr(loc+1));
                        
                        std::stringstream ss(data);
                        std::vector<int> values;
                        
                        int i;
                        while (ss >> i)
                        {
                            values.push_back(i);
                            
                            if (ss.peek() == ',')
                                ss.ignore();
                        }
                        
                        for (int i (0); i<values.size(); i=i+2) {
                            results.push_back(SearchResult(word, values[i], values.at(i+1), currentTimeMilliseconds()-kSearchBeganTime));
                        }
                        
                        
                        
                    }else{
                        //malformed string exception!
                    }
                    
                }

            }else{
                //math not found code path
            }

            //search done
            if (completion)
                callOnMainThread([=](){
                    completion(query, results, currentTimeMilliseconds()-kSearchBeganTime);
                    delete futureHolder;
                });
            
            
            
        });
    }
    
    
    
}
