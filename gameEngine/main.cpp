/* 
 * File:   main.cpp
 * Author: matthew
 *
 * Created on 21 January 2015, 15:48
 */

#include <stdlib.h>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <vector>
#include <string>

#include <boost/thread.hpp>   
#include <boost/date_time.hpp> 

#include "mysql_connection.h"

#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <cppconn/prepared_statement.h>

#include "modConstants.h"
#include "clsSettings.h"
#include "clsCheckGame.h"

using namespace nsCheckSpace;
using namespace std;
using namespace sql::mysql;
using namespace boost;

void fnListGamesWaiting(clsSettings* cSettings)
{
    try {
        sql::Driver * driver = get_driver_instance();

        std::auto_ptr< sql::Connection > con(driver->connect(cSettings->CONN_HOST(), cSettings->CONN_USERNAME(), cSettings->CONN_PASSWORD()));
        con->setSchema(cSettings->CONN_DB());
        
        std::auto_ptr< sql::PreparedStatement > stmt(con->prepareStatement("CALL get_unassigned_processes_list();"));
        std::auto_ptr< sql::ResultSet > res(stmt->executeQuery());

        int iProcessId = -1;
        int iServerId = -1;
        int iGameId = -1;

        while (res->next()) {
            iProcessId = res->getInt("id");
            iServerId = res->getInt("server_id");
            iGameId = res->getInt("game_id");
            
            cout << "Starting thread for game ID: " << iGameId << endl;
            boost::thread thdCheckOneGame(boost::bind(nsCheckSpace::fnCheckGame, boost::ref(cSettings), iProcessId, iServerId, iGameId));
        }
  } catch (sql::SQLException &e) {
    /*
      MySQL Connector/C++ throws three different exceptions:

      - sql::MethodNotImplementedException (derived from sql::SQLException)
      - sql::InvalidArgumentException (derived from sql::SQLException)
      - sql::SQLException (derived from std::runtime_error)
    */
    cout << "# ERR: SQLException in " << __FILE__;
    cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << endl;
    /* what() (derived from std::runtime_error) fetches error message */
    cout << "# ERR: " << e.what();
    cout << " (MySQL error code: " << e.getErrorCode();
    cout << ", SQLState: " << e.getSQLState() << " )" << endl;
  }

  cout << "Done." << endl;
}

void fnEmailStatus_Set_Sent(clsSettings* cSettings, int iEmailId)
{
    try {
        sql::Driver * driver = get_driver_instance();

        std::auto_ptr< sql::Connection > con(driver->connect(cSettings->CONN_HOST(), cSettings->CONN_USERNAME(), cSettings->CONN_PASSWORD()));
        con->setSchema(cSettings->CONN_DB());

        std::auto_ptr< sql::PreparedStatement > pstmt;
        pstmt.reset(con->prepareStatement("CALL set_emailStatus_sent( ? )"));

        pstmt->setInt(1, iEmailId);
        pstmt->execute();
            
  } catch (sql::SQLException &e) {
    /*
      MySQL Connector/C++ throws three different exceptions:

      - sql::MethodNotImplementedException (derived from sql::SQLException)
      - sql::InvalidArgumentException (derived from sql::SQLException)
      - sql::SQLException (derived from std::runtime_error)
    */
    cout << "# ERR: SQLException in " << __FILE__;
    cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << endl;
    /* what() (derived from std::runtime_error) fetches error message */
    cout << "# ERR: " << e.what();
    cout << " (MySQL error code: " << e.getErrorCode();
    cout << ", SQLState: " << e.getSQLState() << " )" << endl;
  }

  cout << "Done." << endl;
}


void fnListEmailsWaiting(clsSettings* cSettings)
{
    try {
        sql::Driver * driver = get_driver_instance();

        std::auto_ptr< sql::Connection > con(driver->connect(cSettings->CONN_HOST(), cSettings->CONN_USERNAME(), cSettings->CONN_PASSWORD()));
        con->setSchema(cSettings->CONN_DB());
        
        std::auto_ptr< sql::PreparedStatement > stmt(con->prepareStatement("CALL get_emailQueue();"));
        std::auto_ptr< sql::ResultSet > res(stmt->executeQuery());

//        std::auto_ptr< sql::PreparedStatement > pstmt(con->prepareStatement("CALL set_emailStatus_sent( ? )"));
//        pstmt.reset(con->prepareStatement("CALL set_emailStatus_sent( ? )"));

        int iEmailId = -1;
        int iUserId = -1;
        std::string sAddressTo = "";
        std::string sAddressCc = "";
        std::string sTitle = "";
        std::string sMessage = "";

        while (res->next()) {
            /*
             SELECT id, 
             *      user_id, 
             *      createdAt_date, 
             *      createdAt_time, 
             *      language_id, 
             *      email_type, 
             *      address_to, 
             *      address_cc, 
             *      title, 
             *      message 
             */
           
            iEmailId = res->getInt("id");
            iUserId = res->getInt("user_id");
            sAddressTo = res->getString("address_to");
            sAddressCc = res->getString("address_cc");
            sTitle = res->getString("title");
            sMessage = res->getString("message");
            
            cout << "Starting thread for email ID: " << iEmailId << endl;
            cout << "Address " << sAddressTo << endl;
            
            std::string sCommandLine = "echo \"" + sMessage + "\" | mail -s \"$(echo -e \"" + sTitle + "\\nContent-Type: text/html\")\" " + sAddressTo;
            
            cout << sCommandLine << endl;
            
            std::system(sCommandLine.c_str());
            
            boost::thread thdEmailStatus_Set_Sent(boost::bind(fnEmailStatus_Set_Sent, boost::ref(cSettings), iEmailId));

            /*void fnEmailStatus_Set_Sent(clsSettings* cSettings, int iEmailId)*/

            //std::auto_ptr< sql::PreparedStatement > pstmt;
            //pstmt.reset(con->prepareStatement("CALL set_emailStatus_sent( ? )"));
            //pstmt->setInt(1, iEmailId);
            //pstmt->execute();
            

            /*CREATE PROCEDURE set_emailStatus_sent(in p_email_id int)*/
            /*echo "<b>HTML Message goes here</b>" | mail -s "$(echo -e "This is the subject\nContent-Type: text/html")" matthew.baynham@gmail.com*/
        }
  } catch (sql::SQLException &e) {
    /*
      MySQL Connector/C++ throws three different exceptions:

      - sql::MethodNotImplementedException (derived from sql::SQLException)
      - sql::InvalidArgumentException (derived from sql::SQLException)
      - sql::SQLException (derived from std::runtime_error)
    */
    cout << "# ERR: SQLException in " << __FILE__;
    cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << endl;
    /* what() (derived from std::runtime_error) fetches error message */
    cout << "# ERR: " << e.what();
    cout << " (MySQL error code: " << e.getErrorCode();
    cout << ", SQLState: " << e.getSQLState() << " )" << endl;
  }

  cout << "Done." << endl;
}


int main(int argc, char** argv) {
    clsSettings* cSettings = new clsSettings();
    
    while (true)
    {
        try{
            cout << "Starting thread to check all current games." << endl;
            boost::thread thdGameCheck(boost::bind(fnListGamesWaiting, boost::ref(cSettings)));
            boost::thread thdEmailCheck(boost::bind(fnListEmailsWaiting, boost::ref(cSettings)));
            thdGameCheck.join();
            thdEmailCheck.join();
        }
        catch (int e)
        {
        //if thread goes wrong the server might just be busy with the last thread wait along time before we go again
        sleep(cSettings->DB_requeryErrorInterval());
        }
    sleep(cSettings->DB_requeryInterval());
    }
}

