/* 
 * File:   modConstants.h
 * Author: matthew
 *
 * Created on 28 January 2015, 16:12
 */

#ifndef MODCONSTANTS_H
#define	MODCONSTANTS_H

#define PIECE_COLOUR_ID_WHITE 1
#define PIECE_COLOUR_ID_BLACK 2

#define RULE_MOVE_ONE_SPACE_DIAGONALLY_FORWARD 1
#define RULE_END_OF_BOARD_CONVERT_TO_KING_TAKE_MOVE 2
#define RULE_END_OF_BOARD_CONVERT_TO_KING_DOES_TAKE_MOVE 3
#define RULE_MOVE_DIAGINALLY_FORWARD_ANY_DISTANCE 4
#define RULE_MOVE_DIAGINALLY_ANY_DIRECTION_ANY_DISTANCE 5
#define RULE_TAKE_PIECE_BY_JUMPING_OVER 7
#define RULE_IF_CAN_TAKE_MUST_TAKE 8
#define RULE_CANT_MOVE_MEANS_LOOSE 9
#define RULE_PIECE_CANNOT_JUMP_OVER_OTHER_PIECE 10
#define RULE_PIECE_CAN_JUMP_OVER_OTHER_PIECES 11
#define RULE_MOVE_ONE_SPACE_DIAGONALLY_ANY_DIRECTION 12

namespace nsCheckSpace
{
    enum enumPieceColour { black, white, unknown};
    struct strctMove {
        int iSquare;
        bool bTaking;
        bool bMultiMove;
        bool bMultiPieceMove; //Castling in chess
    };


}


#endif	/* MODCONSTANTS_H */

