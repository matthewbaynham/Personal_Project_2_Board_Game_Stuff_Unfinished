/* 
 * File:   clsCheckGame.h
 * Author: matthew
 *
 * Created on 22 January 2015, 17:40
 */

#ifndef CLSCHECKGAME_H
#define	CLSCHECKGAME_H
namespace nsCheckSpace
{
    //void overload(clsSettings* param1, int param2) {}
    void fnCheckGame(clsSettings* cSettings, int iProcessId, int iServerId, int iGameId);
    void fnCheckGame_old(clsSettings* cSettings, int iGameId);
};
#endif	/* CLSCHECKGAME_H */

