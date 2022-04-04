/* 
 * File:   clsCheckGame.cpp
 * Author: matthew
 * 
 * Created on 22 January 2015, 17:40
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

#include "clsPossiblePositions.h"

using namespace std;
using namespace sql::mysql;
using namespace boost;

#include "clsCheckGame.h"

namespace nsCheckSpace
{
    void fnCheckGame(clsSettings* cSettings, int iProcessId, int iServerId, int iGameId)
    {
        try {
            int iGameTypeId = -1;
            bool bIsOk = false;
            
            cout << "one" << endl;
            
            /************************
             *   Get game details   *
             ************************/

            sql::Driver * driver = get_driver_instance();

            std::auto_ptr< sql::Connection > con(driver->connect(cSettings->CONN_HOST(), cSettings->CONN_USERNAME(), cSettings->CONN_PASSWORD()));
            con->setSchema(cSettings->CONN_DB());
            std::auto_ptr< sql::Statement > stmt(con->createStatement());
            std::auto_ptr< sql::PreparedStatement >  pstmt;
            std::auto_ptr< sql::ResultSet > res;

            pstmt.reset(con->prepareStatement("CALL assign_process( ? , ? , ? , @bIsOk )"));
            pstmt->setInt(1, iProcessId);
            pstmt->setInt(2, cSettings->serverId());
            pstmt->setInt(3, iGameId);
            pstmt->execute();

            pstmt.reset(con->prepareStatement("SELECT @bIsOk AS _isOk"));
            res.reset(pstmt->executeQuery());
            while (res->next()) {
                if (res->getInt("_isOk") == 1)
                { bIsOk = true; }
                else
                { bIsOk = false; }
            }

            if (bIsOk)
            {
                /******************************
                 *   Get possible positions   *
                 ******************************/

                clsPossiblePositions* cPossiblePositions = new clsPossiblePositions();
                //cPossiblePositions->readCurrentPositions(cSettings, iGameId);
                
                cPossiblePositions->setProcessId(iProcessId);
                cPossiblePositions->setGameId(iGameId);
                cPossiblePositions->readGameDetails(cSettings);
                cPossiblePositions->readGameTypeDetails(cSettings);
                //cPossiblePositions->setGameTypeId(iGameTypeId);
                cPossiblePositions->readCurrentPositions(cSettings);
                cPossiblePositions->readGameRules_game(cSettings);
                cPossiblePositions->readGameRules_pieces(cSettings);
                cPossiblePositions->coutRules();
 
                //std::vector<strctMove> vctrTempMoves = cPossiblePositions->calculateAllPossibleMoves();
                cPossiblePositions->calculateAllPossibleMoves();
                //cPossiblePositions->cout_allPossibleMoves();
                cPossiblePositions->updatePossibleMovesToDB(cSettings);
            }
            else
            {
                cout << endl;
                cout << "********************************************" << endl;
                cout << "*   WARNING!!! Process failed to assign.   *" << endl;
                cout << "********************************************" << endl;
                cout << endl;
            };
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


    void fnCheckGame_old(clsSettings* cSettings, int iGameId)
    {
        try {
            int iGameTypeId = -1;
            
            /************************
             *   Get game details   *
             ************************/
/*            
            sql::Driver * driver = get_driver_instance();

            std::auto_ptr< sql::Connection > con(driver->connect(cSettings->CONN_HOST(), cSettings->CONN_USERNAME(), cSettings->CONN_PASSWORD()));
            con->setSchema(cSettings->CONN_DB());
            
            std::auto_ptr< sql::PreparedStatement > stmt(con->prepareStatement("CALL get_game_details ( ? );"));
            stmt->setInt(1, iGameId);
            std::auto_ptr< sql::ResultSet > res(stmt->executeQuery());
*/            
            

            /******************************
             *   Get possible positions   *
             ******************************/

            clsPossiblePositions* cPossiblePositions = new clsPossiblePositions();
            //cPossiblePositions->readCurrentPositions(cSettings, iGameId);
            cPossiblePositions->setGameId(iGameId);
            cPossiblePositions->readGameDetails(cSettings);
            cPossiblePositions->readGameTypeDetails(cSettings);
            //cPossiblePositions->setGameTypeId(iGameTypeId);
            cPossiblePositions->readCurrentPositions(cSettings);
            cPossiblePositions->readGameRules_game(cSettings);
            cPossiblePositions->readGameRules_pieces(cSettings);
            cPossiblePositions->coutRules();
            cPossiblePositions->cout_allPossibleMoves();

            //            sql::Driver * driver = get_driver_instance();
//
//            std::auto_ptr< sql::Connection > con(driver->connect(cSettings->CONN_HOST(), cSettings->CONN_USERNAME(), cSettings->CONN_PASSWORD()));
//            con->setSchema(cSettings->CONN_DB());
//
//            std::auto_ptr< sql::PreparedStatement > stmt(con->prepareStatement("CALL get_game_current_positions ( ? );"));
//            stmt->setInt(1, iGameId);
//            std::auto_ptr< sql::ResultSet > res(stmt->executeQuery());
//
//            int iPieceId = -1;  
//            int iSquareNo = -1;
//            int iMoveType = -1;
//            int iPieceTypeId = -1;
//
//            while (res->next()) {
//                iPieceId = res->getInt("piece_id");  
//                iSquareNo = res->getInt("square_no");
//                iMoveType = res->getInt("move_type");
//                iPieceTypeId = res->getInt("piece_type_id");
//
//                cout << "piece_id: " << iPieceId
//                     << " square_no: " << iSquareNo
//                     << " move_type: " << iMoveType
//                     << " piece_type_id: " << iPieceTypeId
//                     << endl;
//            }        
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
}