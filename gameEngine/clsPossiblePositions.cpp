/* 
 * File:   clsPossiblePositions.cpp
 * Author: matthew
 * 
 * Created on 21 January 2015, 16:29
 */
#include <stdlib.h>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <vector>
#include <string>
#include <ctime>

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

#include "clsPossiblePositions.h"

using namespace std;
using namespace sql::mysql;
using namespace boost;

nsCheckSpace::clsPossiblePositions::clsPossiblePositions() {
}

//std::vector<nsCheckSpace::strctMove> nsCheckSpace::clsPossiblePositions::calculateAllPossibleMoves()
void nsCheckSpace::clsPossiblePositions::calculateAllPossibleMoves()
{
    cout << "std::vector<nsCheckSpace::strctMove> nsCheckSpace::clsPossiblePositions::calculateAllPossibleMoves()" << endl;
    
    bool bIsError = false;
    std::string sErrorMessage = "";
    enumPieceColour ePieceColour = unknown;
    
    //switch(this->vctrGamesRules)
    /*
     * check the rules for movement find out which direction each piece can move in
     * loop through each possible square checking if it has a piece already in it.
     */        
    /*
RULE_MOVE_ONE_SPACE_DIAGONALLY_FORWARD 
RULE_END_OF_BOARD_CONVERT_TO_KING_TAKE_MOVE 
RULE_END_OF_BOARD_CONVERT_TO_KING_DOES_TAKE_MOVE 
RULE_MOVE_DIAGINALLY_FORWARD_ANY_DISTANCE 
RULE_MOVE_DIAGINALLY_ANY_DIRECTION_ANY_DISTANCE 
RULE_TAKE_PIECE_BY_JUMPING_OVER 
RULE_IF_CAN_TAKE_MUST_TAKE
RULE_CANT_MOVE_MEANS_LOOSE 
RULE_PIECE_CANNOT_JUMP_OVER_OTHER_PIECE
RULE_PIECE_CAN_JUMP_OVER_OTHER_PIECES
     */
    
    
    
    //std::vector<strctMove> vctrTempMoves;
        
    if (this->iPlayerId_White == this->iPlayerId_WhosTurnNext)
    { ePieceColour = white; }
    else if (this->iPlayerId_Black == this->iPlayerId_WhosTurnNext)
    { ePieceColour = black; }
    else
    {
        //error
        bIsError = true;
        sErrorMessage = "Error: Next player is neither of the current players";
        ePieceColour = unknown;
    };

    for(std::vector<strctPiece>::iterator it = this->vctrAllPieces.begin(); it != this->vctrAllPieces.end();++it)
    {
        bool bIsOk = true;
        
        if (it->eColour != ePieceColour)
        { bIsOk = false; }
        
        if (bIsOk)
        {
            if (this->pieceHasRule(it->iPieceTypeId, RULE_MOVE_ONE_SPACE_DIAGONALLY_FORWARD))
            {
                strctMove objMove;
                /*
                 * Position after move is position before move plus and minus one.
                 * 
                 * However if we divide position before and after move by the width 
                 * that will tell us what row they are on, and we don't want to move
                 * through the wall at the side of the board.
                 * Is white = 1 with small square numbers and 0 with bigger square numbers
                 */

                std::vector<strctMove> vTemp = this->calculateAllPossibleMoves_diagonallyForwardOneSquare(&*it);                
                cout << "it->vctrAllMoves size: " << it->vctrAllMoves.size() << endl;
                cout << "vTemp size: " << vTemp.size() << endl;
                
                it->vctrAllMoves.insert(it->vctrAllMoves.end(), vTemp.begin(), vTemp.end());
                //vctrTempMoves.insert(vctrTempMoves.end(), vTemp.begin(), vTemp.end());

                cout << "it->vctrAllMoves size: " << it->vctrAllMoves.size() << endl;
            }

            if (this->pieceHasRule(it->iPieceTypeId, RULE_MOVE_DIAGINALLY_FORWARD_ANY_DISTANCE))
            {}

            if (this->pieceHasRule(it->iPieceTypeId, RULE_MOVE_DIAGINALLY_ANY_DIRECTION_ANY_DISTANCE))
            {}

            if (this->pieceHasRule(it->iPieceTypeId, RULE_MOVE_ONE_SPACE_DIAGONALLY_ANY_DIRECTION))
            {}

        }
    }
    
    
    
    if (this->gameHasRule(RULE_END_OF_BOARD_CONVERT_TO_KING_TAKE_MOVE))
    {
    
    }
    
    if (this->gameHasRule(RULE_END_OF_BOARD_CONVERT_TO_KING_DOES_TAKE_MOVE))
    {
    
    }
    
//    return vctrTempMoves;
    
};

void nsCheckSpace::clsPossiblePositions::updatePossibleMovesToDB(clsSettings* cSettings)
{
/*
 * CREATE PROCEDURE insert_possible_move(
 *      in p_process_id int, 
 *      in p_multi_move bool, 
 *      in p_square_no int, 
 *      in p_piece_id int, 
 *      in p_move_order int, 
 *      in p_is_compulsary bool, 
 *      in p_is_next_move bool, 
 *      in p_player_id int)
 */
    try {
        sql::Driver * driver = get_driver_instance();

        std::auto_ptr< sql::Connection > con(driver->connect(cSettings->CONN_HOST(), cSettings->CONN_USERNAME(), cSettings->CONN_PASSWORD()));
        con->setSchema(cSettings->CONN_DB());
        std::string* sMessageOut;

        /******************
         *   Game Rules   *
         ******************/
        std::auto_ptr< sql::PreparedStatement > stmt(con->prepareStatement("call insert_possible_move( ? , ? , ? , ? , ? , ? , ? , ? )"));

        cout << "outputting all possible moves" << endl;
        this->pp_piece_moveFirst();

        cout << "Count of pieces: " << this->vctrAllPieces.size() << endl;

        while (!this->pp_piece_Eof())
        {
            cout << "Current = " << this->iPieceCurrent
                 << "piece_id: " << this->pp_pieceCurrent_Id()
                 << " square_no: " << this->pp_pieceCurrent_CurrentSquareNo()
                 << " piece_type_id: " << this->pp_pieceCurrent_TypeId();

            this->pp_pieceMove_moveFirst();

            if (this->pp_pieceMove_Empty())
            { cout << " No moves can be done."; }
            else
            {
                while (!this->pp_pieceMove_Eof())
                {
                    bool bIsCompulsory = false;

                    cout << "Move Current " << this->iPieceCurr_MoveCurrent << " ";

                    cout << " " << this->pp_pieceMove_moveCurr_squareNo();
                    if (this->pp_pieceMove_moveCurr_taking())
                    { cout << "t"; }

                    if (this->pp_pieceMove_moveCurr_multiMove())
                    { cout << "m"; }

                    stmt->setInt(1, this->iProcessId); //p_process_id
                    stmt->setBoolean(2, this->pp_pieceMove_moveCurr_multiMove()); //p_multi_move
                    stmt->setInt(3, this->pp_pieceMove_moveCurr_squareNo()); //p_square_no
                    stmt->setInt(4, this->pp_pieceCurrent_Id()); //p_piece_id
                    stmt->setInt(5, 0); //p_move_order
                    stmt->setBoolean(6, bIsCompulsory); //p_is_compulsary
                    stmt->setBoolean(7, true); //p_is_next_move
                    stmt->setInt(8, this->iPlayerId_WhosTurnNext); //p_player_id
                        /*
                         * CREATE PROCEDURE insert_possible_move(
                         *      in p_process_id int, 
                         *      in p_multi_move bool, 
                         *      in p_square_no int, 
                         *      in p_piece_id int, 
                         *      in p_move_order int, 
                         *      in p_is_compulsary bool, 
                         *      in p_is_next_move bool, 
                         *      in p_player_id int)
                         */
                    stmt->executeQuery();

                    this->pp_pieceMove_moveNext();
                }
            };
            cout << endl;
            this->pp_piece_moveNext();
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
};

std::vector<nsCheckSpace::strctMove> nsCheckSpace::clsPossiblePositions::calculateAllPossibleMoves_diagonallyForwardOneSquare(strctPiece* objPiece)
{
    cout << "std::vector<nsCheckSpace::strctMove> nsCheckSpace::clsPossiblePositions::calculateAllPossibleMoves_diagonallyForwardOneSquare(strctPiece* objPiece)" << endl;
    
    bool bIsOk = true;
    int iDirection;
    std::vector<strctMove> vResult;
    
    if (objPiece->eColour == white)
    { 
        iDirection = 1; 
        if (objPiece->iCurrentSquare < this->iBoardWidth)
        {
            //Can't move forward from end row.
            bIsOk = false;
        }
    }
    else if (objPiece->eColour == black)
    { 
        iDirection = -1; 
        if (objPiece->iCurrentSquare > (this->iBoardHeight - 1) * this->iBoardWidth)
        {
            //Can't move forward from end row.
            bIsOk = false;
        }
    }
    else
    { bIsOk = false; };
        
    if (this->iBoardWidth == 0)
    { bIsOk = false; };
    
    if (this->iBoardHeight == 0)
    { bIsOk = false; };
    
    if (bIsOk) 
    {
        int iNext_1 = objPiece->iCurrentSquare + iDirection * (this->iBoardWidth + 1);

        if (iNext_1 / this->iBoardWidth  == (objPiece->iCurrentSquare/this->iBoardWidth) + iDirection)
        {
            /*****************************************************************************
             *    calculate the row by dividing square number by width and if we don't   *  
             *    go off the edge of the board then it's only one row a head.            *  
             *****************************************************************************/
            if (calculateAllPossibleMoves_checkSquare(iNext_1))
            {
                cout << "Add possible move in direction: " << iDirection << endl;
                strctMove objMove_1;
                objMove_1.iSquare = iNext_1;

                objMove_1.bTaking = false;
                objMove_1.bMultiMove = false;
                objMove_1.bMultiPieceMove = false; //Castling in chess

                vResult.push_back(objMove_1);
            }
        }

        int iNext_2 = objPiece->iCurrentSquare + iDirection * (this->iBoardWidth - 1);

        if (iNext_2 / this->iBoardWidth  == (objPiece->iCurrentSquare/this->iBoardWidth) - iDirection)
        {
            /*****************************************************************************
             *    calculate the row by dividing square number by width and if we don't   *  
             *    go off the edge of the board then it's only one row a head.            *  
             *****************************************************************************/
            if (calculateAllPossibleMoves_checkSquare(iNext_1))
            {
                cout << "Add possible move in direction: -1 * " << iDirection << endl;
                strctMove objMove_2;
                objMove_2.iSquare = iNext_2;

                objMove_2.bTaking = false;
                objMove_2.bMultiMove = false;
                objMove_2.bMultiPieceMove = false; //Castling in chess

                vResult.push_back(objMove_2);
            }

        }
    }
    
    cout << "END!!! std::vector<nsCheckSpace::strctMove> nsCheckSpace::clsPossiblePositions::calculateAllPossibleMoves_diagonallyForwardOneSquare(strctPiece* objPiece)" << endl;

    return vResult;
}

bool nsCheckSpace::clsPossiblePositions::calculateAllPossibleMoves_checkSquare(int iSquareNo)
{
/*
 * Check if square is  
 * 
 * if square is empty then ...
 * if occupied by own piece then ...
 * if occupied by opponents piece then ...
 * 
 * 
 */
    
    std::vector<strctPiece>::iterator it = std::find_if( this->vctrAllPieces.begin(), this->vctrAllPieces.end(), boost::bind( &strctPiece::iCurrentSquare, _1 ) == iSquareNo );
    
    if(it == this->vctrAllPieces.end() )
    {
    //square is empty
    }
    else if (it->eColour == white)
    {
    
    }
    else if (it->eColour == black)
    {
    
    }
    
    
    
}

bool nsCheckSpace::clsPossiblePositions::gameHasRule(int iRuleId)
{
    bool bResult;
    
    if(std::find(this->vctrGamesRules.begin(), this->vctrGamesRules.end(), iRuleId) != this->vctrGamesRules.end()) {
        bResult = true; /* contains rule */
    } else {
        bResult = false; /* does not contain rule */
    }
    
    return bResult;
};

bool nsCheckSpace::clsPossiblePositions::pieceHasRule(int iPieceTypeId, int iRuleId)
{
    bool bResult;
    
    std::vector<strctPieceType>::iterator it = std::find_if(this->vctrPieceTypes.begin(), this->vctrPieceTypes.end(), boost::bind(&strctPieceType::iPieceTypeId, _1) == iPieceTypeId);
    //std::vector<strctPieceType>::iterator it = std::find_if(this->vctrPieceTypes.begin(), this->vctrPieceTypes.end(), boost::bind(&strctPieceType::iPieceTypeId, iPieceTypeId));

    if (it != this->vctrPieceTypes.end())
    {
        if(std::find(it->vctrRules.begin(), it->vctrRules.end(), iRuleId) != it->vctrRules.end()) 
        { bResult = true; }
        else
        { bResult = false; }
    }
    else
    { bResult = false; }
    
    return bResult;
};


void nsCheckSpace::clsPossiblePositions::readGameDetails(clsSettings* cSettings)
{
    try {
        sql::Driver * driver = get_driver_instance();

        std::auto_ptr< sql::Connection > con(driver->connect(cSettings->CONN_HOST(), cSettings->CONN_USERNAME(), cSettings->CONN_PASSWORD()));
        con->setSchema(cSettings->CONN_DB());
        std::string* sMessageOut;

        /******************
         *   Game Rules   *
         ******************/
        std::auto_ptr< sql::PreparedStatement > stmt(con->prepareStatement("CALL get_game_details( ? );"));
        stmt->setInt(1, this->iGameId);
        std::auto_ptr< sql::ResultSet > res(stmt->executeQuery());

        while (res->next()) {
            this->iGameTypeId = res->getInt("game_type"); 
            
            this->iPlayerId_White = res->getInt("player_white_id");
            this->iPlayerId_Black = res->getInt("player_black_id");
            this->iPlayerId_WhosTurnNext = res->getInt("whos_turn_next_id");
            this->iGameStatusId = res->getInt("status_id");
            /*
	2	player_white_id	int(11)
	3	player_black_id	int(11)	
	4	whos_turn_next_id	int(11)
	5	game_type	int(11)	
	6	status_id	int(11)	
	7	startedAt_date	date
	8	startedAt_time	time	
	9	endedAt_date	date	
	10	endedAt_time	time	
	11	description	varchar(256)	             
             */
            
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
}

void nsCheckSpace::clsPossiblePositions::readGameTypeDetails(clsSettings* cSettings)
{
    try {
        sql::Driver * driver = get_driver_instance();

        std::auto_ptr< sql::Connection > con(driver->connect(cSettings->CONN_HOST(), cSettings->CONN_USERNAME(), cSettings->CONN_PASSWORD()));
        con->setSchema(cSettings->CONN_DB());
        std::string* sMessageOut;

        /******************
         *   Game Rules   *
         ******************/
        std::auto_ptr< sql::PreparedStatement > stmt(con->prepareStatement("CALL get_game_type_details( ? , ? )"));
        stmt->setInt(1, -1); //if the language equals -1 then all text is blank but figures come out OK
        stmt->setInt(2, this->iGameTypeId);
        std::auto_ptr< sql::ResultSet > res(stmt->executeQuery());

        while (res->next()) {
            this->iBoardWidth = res->getInt("board_width");
            this->iBoardHeight = res->getInt("board_height");
            this->iBoardType = res->getInt("board_type_id");

            /*
	4	board_width	int(11)			No 	None		Change Change	Drop Drop	
	5	board_height	int(11)		
             *              */
            
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
}


void nsCheckSpace::clsPossiblePositions::readGameRules_game(clsSettings* cSettings)
{
    try {
        sql::Driver * driver = get_driver_instance();

        std::auto_ptr< sql::Connection > con(driver->connect(cSettings->CONN_HOST(), cSettings->CONN_USERNAME(), cSettings->CONN_PASSWORD()));
        con->setSchema(cSettings->CONN_DB());
        std::string* sMessageOut;

        /******************
         *   Game Rules   *
         ******************/
        std::auto_ptr< sql::PreparedStatement > stmt(con->prepareStatement("CALL get_game_details_rules_game( ? );"));
        stmt->setInt(1, this->iGameTypeId);
        std::auto_ptr< sql::ResultSet > res(stmt->executeQuery());

        while (res->next()) {
            if(std::find(vctrGamesRules.begin(), vctrGamesRules.end(), res->getInt("rule_id")) == vctrGamesRules.end())
            { vctrGamesRules.push_back(res->getInt("rule_id")); };
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
};


void nsCheckSpace::clsPossiblePositions::readGameRules_pieces(clsSettings* cSettings)
{
    try {
        sql::Driver * driver = get_driver_instance();

        std::auto_ptr< sql::Connection > con(driver->connect(cSettings->CONN_HOST(), cSettings->CONN_USERNAME(), cSettings->CONN_PASSWORD()));
        con->setSchema(cSettings->CONN_DB());
        std::string* sMessageOut;
        
        /********************
         *   Pieces Rules   *
         ********************/

        std::auto_ptr< sql::PreparedStatement > stmt(con->prepareStatement("CALL get_game_details_rules_pieces( ? );"));
        stmt->setInt(1, this->iGameTypeId);
        //stmtPiece->setString(2, sMessageOut.c_str());
        std::auto_ptr< sql::ResultSet > res(stmt->executeQuery());

        while (res->next()) {
            int iPieceTypeId =  res->getInt("piecetype_id");
            int iRuleId =  res->getInt("rule_id");
            
            std::vector<strctPieceType>::iterator it = std::find_if(this->vctrPieceTypes.begin(), this->vctrPieceTypes.end(), boost::bind(&strctPieceType::iPieceTypeId, _1) == iPieceTypeId);

            strctPieceType objPieceType;
            if (it == this->vctrPieceTypes.end())
            {
                //Add new piece type
                objPieceType.iPieceTypeId = iPieceTypeId;
                objPieceType.vctrRules.push_back(iRuleId);
                this->vctrPieceTypes.push_back(objPieceType);
            }
            else
            { 
                std::vector<strctPieceType>::difference_type pos;
                pos = std::distance(this->vctrPieceTypes.begin(), it);
                
                //change existing value
                this->vctrPieceTypes.at(pos).iPieceTypeId = iPieceTypeId;
                this->vctrPieceTypes.at(pos).vctrRules.push_back(iRuleId);
            };
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
};

void nsCheckSpace::clsPossiblePositions::coutRules()
{
    cout << "Game Rules" << endl;
    for(vector<int>::iterator it = this->vctrGamesRules.begin(); it != this->vctrGamesRules.end(); ++it)
    {
        cout << "    " << *it << endl;
    };

    cout << endl << "Piece Rules" << endl;
    for(vector<strctPieceType>::iterator itPieceType = this->vctrPieceTypes.begin(); itPieceType != this->vctrPieceTypes.end(); ++itPieceType)
    {
        cout << "Piece ID: " << itPieceType->iPieceTypeId << endl;
        for(vector<int>::iterator itPieceRule = itPieceType->vctrRules.begin(); itPieceRule != itPieceType->vctrRules.end(); ++itPieceRule)
        { cout << "    " << *itPieceRule << endl; };
    };
};

void nsCheckSpace::clsPossiblePositions::readCurrentPositions(clsSettings* cSettings) {
    try {
        sql::Driver * driver = get_driver_instance();

        std::auto_ptr< sql::Connection > con(driver->connect(cSettings->CONN_HOST(), cSettings->CONN_USERNAME(), cSettings->CONN_PASSWORD()));
        con->setSchema(cSettings->CONN_DB());

        std::auto_ptr< sql::PreparedStatement > stmt(con->prepareStatement("CALL get_game_current_positions ( ? );"));
        stmt->setInt(1, this->iGameId);
        std::auto_ptr< sql::ResultSet > res(stmt->executeQuery());

        //iPieceMax = 0;

        while (res->next()) {
            strctPiece objPiece;

            objPiece.iPieceId = res->getInt("piece_id");
            objPiece.iCurrentSquare = res->getInt("square_no");
            objPiece.iPieceTypeId = res->getInt("piece_type_id");
            objPiece.iPreviousMoveType = res->getInt("move_type");
            if (res->getInt("colour_id") == PIECE_COLOUR_ID_WHITE)
            { objPiece.eColour = white; }
            else if (res->getInt("colour_id") == PIECE_COLOUR_ID_BLACK)
            { objPiece.eColour = black; }
            else
            { objPiece.eColour = unknown; }
                    

                    //objPiece.vctrAllMoves = res->getInt("piece_id");

            vctrAllPieces.push_back(objPiece);
            //iPieceMax++;
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
}

void nsCheckSpace::clsPossiblePositions::cout_allPossibleMoves()
{
    cout << "outputting all possible moves" << endl;
    this->pp_piece_moveFirst();
    
    cout << "Count of pieces: " << this->vctrAllPieces.size() << endl;

    while (!this->pp_piece_Eof())
    {
        cout << "Current = " << this->iPieceCurrent
             << "piece_id: " << this->pp_pieceCurrent_Id()
             << " square_no: " << this->pp_pieceCurrent_CurrentSquareNo()
             << " piece_type_id: " << this->pp_pieceCurrent_TypeId();
        
        this->pp_pieceMove_moveFirst();

        if (this->pp_pieceMove_Empty())
        { cout << " No moves can be done."; }
        else
        {
            while (!this->pp_pieceMove_Eof())
            {
                cout << "Move Current " << this->iPieceCurr_MoveCurrent << " ";

                cout << " " << this->pp_pieceMove_moveCurr_squareNo();
                if (this->pp_pieceMove_moveCurr_taking())
                { cout << "t"; }

                if (this->pp_pieceMove_moveCurr_multiMove())
                { cout << "m"; }

                this->pp_pieceMove_moveNext();
            }
        };
        cout << endl;
        this->pp_piece_moveNext();
    }
}

nsCheckSpace::clsPossiblePositions::~clsPossiblePositions() {
}

void nsCheckSpace::clsPossiblePositions::setProcessId(int iValue)
{ this->iProcessId = iValue; }

void nsCheckSpace::clsPossiblePositions::setGameId(int iValue)
{ this->iGameId = iValue; }

void nsCheckSpace::clsPossiblePositions::setGameTypeId(int iValue)
{ this->iGameTypeId = iValue; }


/*********************
*   Current Piece   *
*********************/

int nsCheckSpace::clsPossiblePositions::pp_pieceCurrent_TypeId()
{ return this->vctrAllPieces.at(this->iPieceCurrent).iPieceTypeId; }

int nsCheckSpace::clsPossiblePositions::pp_pieceCurrent_Id()
{ 
    return this->vctrAllPieces.at(this->iPieceCurrent).iPieceId;
}

int nsCheckSpace::clsPossiblePositions::pp_pieceCurrent_CurrentSquareNo()
{ return this->vctrAllPieces.at(this->iPieceCurrent).iCurrentSquare; }

void nsCheckSpace::clsPossiblePositions::pp_piece_moveFirst()
{
    this->iPieceCurrent = 0;
    this->pp_pieceMove_moveCurr_resetVaribles();
}

void nsCheckSpace::clsPossiblePositions::pp_piece_moveLast()
{ 
    this->iPieceCurrent = this->vctrAllPieces.size() - 1; 
    this->pp_pieceMove_moveCurr_resetVaribles();
}

void nsCheckSpace::clsPossiblePositions::pp_piece_moveNext()
{
    //if (!this->pp_piece_Eof())
    //{ 
        this->iPieceCurrent++; 
        this->pp_pieceMove_moveCurr_resetVaribles();
    //}
}

void nsCheckSpace::clsPossiblePositions::pp_piece_movePrevious()
{
    //if (!this->pp_piece_Bof())
    //{ 
        this->iPieceCurrent--; 
        this->pp_pieceMove_moveCurr_resetVaribles();
    //}
}

bool nsCheckSpace::clsPossiblePositions::pp_piece_Eof()
{ return (this->iPieceCurrent >= this->vctrAllPieces.size()); }

bool nsCheckSpace::clsPossiblePositions::pp_piece_Bof()
{ return (this->iPieceCurrent <= 0); }

bool nsCheckSpace::clsPossiblePositions::pp_piece_Empty()
{ return (this->vctrAllPieces.size() == 0); }


/*************************** 
*   Current Piece Moves   *
***************************/

void nsCheckSpace::clsPossiblePositions::pp_pieceMove_moveFirst()
{ this->iPieceCurr_MoveCurrent = 0; }

void nsCheckSpace::clsPossiblePositions::pp_pieceMove_moveLast()
{ this->iPieceCurr_MoveCurrent = this->iPieceCurr_MoveMax;}

void nsCheckSpace::clsPossiblePositions::pp_pieceMove_moveNext()
{
    //if (!this->pp_pieceMove_Eof())
    //{ 
        this->iPieceCurr_MoveCurrent++; 
    //}
}

void nsCheckSpace::clsPossiblePositions::pp_pieceMove_movePrevious()
{
    //if (!this->pp_pieceMove_Bof())
    //{ 
        this->iPieceCurr_MoveCurrent--; 
    //}
}

bool nsCheckSpace::clsPossiblePositions::pp_pieceMove_Eof()
{ return (this->iPieceCurr_MoveCurrent >= this->vctrAllPieces.at(this->iPieceCurrent).vctrAllMoves.size());}

bool nsCheckSpace::clsPossiblePositions::pp_pieceMove_Bof()
{ return (this->iPieceCurr_MoveCurrent <= 0); }

bool nsCheckSpace::clsPossiblePositions::pp_pieceMove_Empty()
{ return (this->vctrAllPieces.at(this->iPieceCurrent).vctrAllMoves.size() == 0);}

int nsCheckSpace::clsPossiblePositions::pp_pieceMove_moveCurr_squareNo()
{ return this->vctrAllPieces.at(this->iPieceCurrent).vctrAllMoves.at(this->iPieceCurr_MoveCurrent).iSquare; }

bool nsCheckSpace::clsPossiblePositions::pp_pieceMove_moveCurr_taking()
{ return this->vctrAllPieces.at(this->iPieceCurrent).vctrAllMoves.at(this->iPieceCurr_MoveCurrent).bTaking; }

bool nsCheckSpace::clsPossiblePositions::pp_pieceMove_moveCurr_multiMove()
{ return this->vctrAllPieces.at(this->iPieceCurrent).vctrAllMoves.at(this->iPieceCurr_MoveCurrent).bMultiMove; }

void nsCheckSpace::clsPossiblePositions::pp_pieceMove_moveCurr_resetVaribles()
{
    this->iPieceCurr_MoveCurrent = 0;
    if (this->iPieceCurrent < this->vctrAllPieces.size())
    { this->iPieceCurr_MoveMax = this->vctrAllPieces.at(this->iPieceCurrent).vctrAllMoves.size(); }
    else
    { this->iPieceCurr_MoveMax = 0; }
}

//}