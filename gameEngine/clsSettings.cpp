/* 
 * File:   clsSettings.cpp
 * Author: matthew
 * 
 * Created on 21 January 2015, 21:45
 */

/*
 Read ini file and return all the settings
 */

#include <iostream>
#include <fstream>
#include <string>
//#include <regex>
#include <boost/algorithm/string.hpp>
#include <boost/xpressive/xpressive.hpp>
#include <boost/lexical_cast.hpp>

#include "clsSettings.h"

using namespace std;
using namespace boost::algorithm;
using namespace boost::xpressive;

string sHost;
string sDB;
string sUsername;
string sPassword;
int iServerId;
int iDbRequeryInterval;
int iDbRequeryErrorInterval;

clsSettings::clsSettings() {
    //clsSettings::readIni();
    this->readIni();
    //readIni();
}

clsSettings::clsSettings(const clsSettings& orig) {
}

std::string clsSettings::CONN_USERNAME() {
    return sUsername;
}

std::string clsSettings::CONN_PASSWORD() {
    return sPassword;
}

std::string clsSettings::CONN_HOST() {
    return sHost;
}

std::string clsSettings::CONN_DB() {
    return sDB;
}

int clsSettings::serverId() {
    return iServerId;
};

int clsSettings::DB_requeryErrorInterval(){
    return iDbRequeryErrorInterval;
};

int clsSettings::DB_requeryInterval(){
    return iDbRequeryInterval;
};

void clsSettings::readIni()
{
  string sLine;
  ifstream myfile ("settings.ini");
  bool bLineIsOK;
  std::string::size_type stEqualsPos;
  //sregex rgxDoubleQuote("[\"]*[\"]");
  //sregex rgxSingleQuote("[']*[']");
  sregex rgxDoubleQuote = sregex::compile("[\"]*[\"]");
  sregex rgxSingleQuote = sregex::compile("[']*[']");
    
  
  if (myfile.is_open())
  {
    while ( getline (myfile,sLine) )
    {
        //sLine = std::string::trim(sLine);
        
        if (sLine == "")
        { bLineIsOK = false; }
        else
        {
            if (sLine.at(0) == '#')
            { bLineIsOK = false; }
            else
            { bLineIsOK = true; }
        }
        
        if (bLineIsOK == true)
        {
            stEqualsPos = sLine.find('=');
            
            if (stEqualsPos == std::string::npos)
            {
                //no equals 
                bLineIsOK = false;
            }
            else
            {
                std::string sLeft = sLine.substr(0, stEqualsPos);
                std::string sRight = sLine.substr(stEqualsPos + 1, sLine.length() - stEqualsPos - 1);
                bool bLeftInQuotes = false;
                bool bRightInQuotes = false;
                
                boost::trim(sLeft);
                boost::trim(sRight);
                
                if (boost::xpressive::regex_search(sLeft, rgxDoubleQuote, boost::xpressive::regex_constants::match_continuous))
                    bLeftInQuotes = true;
                if (boost::xpressive::regex_search(sRight, rgxDoubleQuote, boost::xpressive::regex_constants::match_continuous))
                    bRightInQuotes = true;
                if (boost::xpressive::regex_search(sLeft, rgxSingleQuote, boost::xpressive::regex_constants::match_continuous))
                    bLeftInQuotes = true;
                if (boost::xpressive::regex_search(sRight, rgxSingleQuote, boost::xpressive::regex_constants::match_continuous))
                    bRightInQuotes = true;
                
                if (bLeftInQuotes)
                { sLeft = sLeft.substr(1, sLeft.length() - 2); }
                
                if (bRightInQuotes)
                { sRight = sRight.substr(1, sRight.length() - 2); }
                
                boost::algorithm::to_lower(sLeft);
                
                if (sLeft == "url")
                { sHost = sRight; }
                else if (sLeft == "database_name")
                { sDB = sRight; }
                else if (sLeft == "username")
                { sUsername = sRight; }
                else if (sLeft == "password")
                { sPassword = sRight; }
                else if (sLeft == "server id")
                { iServerId = boost::lexical_cast<int>(sRight); }
                else if (sLeft == "db requery interval")
                { iDbRequeryInterval = boost::lexical_cast<int>(sRight); }
                else if (sLeft == "db requery error interval")
                { iDbRequeryErrorInterval = boost::lexical_cast<int>(sRight); };
                
            }
        }
      //if line begins with # then ignore
      
      //split the line where the equals is
      //first value is the property that is being set e.g. "username"
      //second value is the value that is being set e.g. "root"
      //trim and strip any quotes or double quotes 
    }
    myfile.close();
  }
  else cout << "Unable to open setting.ini file" << endl << endl; 
}

clsSettings::~clsSettings() {
}

