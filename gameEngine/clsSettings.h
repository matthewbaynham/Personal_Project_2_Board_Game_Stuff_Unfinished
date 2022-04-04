/* 
 * File:   clsSettings.h
 * Author: matthew
 *
 * Created on 21 January 2015, 21:45
 */

#ifndef CLSSETTINGS_H
#define	CLSSETTINGS_H

class clsSettings {
public:
    clsSettings();
    clsSettings(const clsSettings& orig);
    std::string CONN_USERNAME();
    std::string CONN_PASSWORD();
    std::string CONN_HOST();
    std::string CONN_DB();
    int serverId();
    int DB_requeryInterval();
    int DB_requeryErrorInterval();
    virtual ~clsSettings();
private:
    void readIni();
};

#endif	/* CLSSETTINGS_H */

