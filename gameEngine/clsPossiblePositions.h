/* 
 * File:   clsPossiblePositions.h
 * Author: matthew
 *
 * Created on 21 January 2015, 16:29
 */

#ifndef CLSPOSSIBLEPOSITIONS_H
#define	CLSPOSSIBLEPOSITIONS_H

namespace nsCheckSpace
{
    class clsPossiblePositions {
    public:
        clsPossiblePositions();
        virtual ~clsPossiblePositions();
        void readGameDetails(clsSettings* cSettings);
        void readGameTypeDetails(clsSettings* cSettings);
        void readGameRules_game(clsSettings* cSettings);
        void readGameRules_pieces(clsSettings* cSettings);
        void coutRules();
        void readCurrentPositions(clsSettings* cSettings);
        void calculateAllPossibleMoves();
        //std::vector<strctMove> calculateAllPossibleMoves();
        void updatePossibleMovesToDB(clsSettings* cSettings);

        bool gameHasRule(int iRuleId);
        bool pieceHasRule(int iPieceTypeId, int iRuleId);
        void cout_allPossibleMoves();
        void setProcessId(int iValue);
        void setGameId(int iValue);
        void setGameTypeId(int iValue);
        void pp_piece_moveFirst();
        void pp_piece_moveLast();
        void pp_piece_moveNext();
        void pp_piece_movePrevious();
        bool pp_piece_Eof();
        bool pp_piece_Bof();
        bool pp_piece_Empty();
        int pp_pieceCurrent_TypeId();
        int pp_pieceCurrent_Id();
        int pp_pieceCurrent_CurrentSquareNo();

        void pp_pieceMove_moveFirst();
        void pp_pieceMove_moveLast();
        void pp_pieceMove_moveNext();
        void pp_pieceMove_movePrevious();
        bool pp_pieceMove_Eof();
        bool pp_pieceMove_Bof();
        bool pp_pieceMove_Empty();
        int pp_pieceMove_moveCurr_squareNo();
        bool pp_pieceMove_moveCurr_taking();
        bool pp_pieceMove_moveCurr_multiMove();
        void pp_pieceMove_moveCurr_resetVaribles();
        
    private:
            /*
	7	startedAt_date	date
	8	startedAt_time	time	
	9	endedAt_date	date	
	10	endedAt_time	time	
	11	description	varchar(256)	             
             */
        int iProcessId;
        int iGameId;
        int iGameTypeId;

        int iPlayerId_White;
        int iPlayerId_Black;
        int iPlayerId_WhosTurnNext;
        int iGameStatusId;

        int iBoardWidth;
        int iBoardHeight;
        int iBoardType;
        
        //date dteStartedAt;
        //time tmStartedAt;

        int iPieceCurrent;
        //int iPieceMax;
        
        int iPieceCurr_MoveCurrent;
        int iPieceCurr_MoveMax;

        struct strctPiece {
            int iCurrentSquare;
            int iPieceId;
            int iPieceTypeId;
            int iPreviousMoveType;
            enumPieceColour eColour;
            std::vector<strctMove> vctrAllMoves;
        };
        
        struct strctPieceType {
            int iPieceTypeId;
            std::vector<int> vctrRules;
        };
        
        std::vector<strctPieceType> vctrPieceTypes;
        std::vector<strctPiece> vctrAllPieces;
        std::vector<int> vctrGamesRules;

        bool calculateAllPossibleMoves_checkSquare(int iSquareNo);
        std::vector<strctMove> calculateAllPossibleMoves_diagonallyForwardOneSquare(strctPiece* objPiece);
        void updatePossibleMovesToDB(int iProcessId, std::vector<strctMove>* vctrAllPossibleMoves);
    };
};
#endif	/* CLSPOSSIBLEPOSITIONS_H */

