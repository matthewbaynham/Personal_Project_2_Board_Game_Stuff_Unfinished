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

#define EXAMPLE_HOST "localhost"
#define EXAMPLE_USER "usrboardgames"
#define EXAMPLE_PASS "yK6Fz5SfYA4c5XSj"
#define EXAMPLE_DB "dbBoardGames"

using namespace std;
using namespace sql::mysql;
//using namespace std::thread;
using namespace boost;

void fnCheckGame(int iGameId)
{
    try {
        sql::Driver * driver = get_driver_instance();

        std::auto_ptr< sql::Connection > con(driver->connect(EXAMPLE_HOST, EXAMPLE_USER, EXAMPLE_PASS));
        con->setSchema(EXAMPLE_DB);
        
        std::auto_ptr< sql::PreparedStatement > stmt(con->prepareStatement("CALL get_game_current_positions ( ? );"));
        stmt->setInt(1, 7);
        std::auto_ptr< sql::ResultSet > res(stmt->executeQuery());

        int iPieceId = -1;  
        int iSquareNo = -1;
        int iMoveType = -1;
        int iPieceTypeId = -1;

        while (res->next()) {
            iPieceId = res->getInt("piece_id");  
            iSquareNo = res->getInt("square_no");
            iMoveType = res->getInt("move_type");
            iPieceTypeId = res->getInt("piece_type_id");

            cout << "piece_id: " << iPieceId
                 << " square_no: " << iSquareNo
                 << " move_type: " << iMoveType
                 << " piece_type_id: " << iPieceTypeId
                 << endl;
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

