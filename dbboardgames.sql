-- phpMyAdmin SQL Dump
-- version 4.3.8
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Apr 22, 2015 at 12:37 AM
-- Server version: 5.5.42
-- PHP Version: 5.4.38

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `dbboardgames`
--
CREATE DATABASE IF NOT EXISTS `dbboardgames` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `dbboardgames`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `ad_add`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ad_add`(in p_user_id int, in p_description varchar(256), out p_id int)
BEGIN
declare ciAdStatus_active int default 1;

insert into tbl_ads (
  user_id,
  description,
  posted_date,
  posted_time,
  status_id)
values (p_user_id, p_description, curdate(), curtime(), ciAdStatus_active);  
  
set p_id = LAST_INSERT_ID();

end$$

DROP PROCEDURE IF EXISTS `ad_gameType_add`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ad_gameType_add`(in p_add_id int, in p_game_type_id int)
BEGIN

if p_game_type_id = 0 or p_game_type_id = -1 then
    insert into tbl_ads_game_types (
        ads_id, game_type_id)
    select distinct p_add_id, id 
    from tblgametype;
else
    insert into tbl_ads_game_types (ads_id, game_type_id)
    values (p_add_id, p_game_type_id);
end if;

end$$

DROP PROCEDURE IF EXISTS `ad_house_add`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ad_house_add`(in p_add_id int, in p_user_id int, in p_house_id int)
BEGIN

if p_house_id = 0 or p_house_id = -1 then
    insert into tbl_ads_houses (ads_id, house_id)
    SELECT distinct p_add_id, houseid 
    FROM tblcrossref_userhouse
    WHERE userid = p_user_id;
else
    insert into tbl_ads_houses (ads_id, house_id)
    values (p_add_id, p_house_id);
end if;

end$$

DROP PROCEDURE IF EXISTS `all_Possible_Moves`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `all_Possible_Moves`(IN p_game_type_id INT, IN p_current_positions varchar(4000))
BEGIN
/*
test data = "1:2:3~4:5:6~7:8:9~10:11:12~13:14:15~16:17:18~19:20:21~22:23:24~25:26:27~28:29:30~31:32:33~34:35:36~37:38:39~40:41:42~43:44:45~46:47:48~49:50:51~52:53:54~55:56:57~58:59:60~61:62:63~64:65:66"
test data2 = "1:2:3~4:5:6~7:8:9~10:11:12~13:14:15~16:17:18~19:20:21~22:23:24~25:26:27~28:29:30~31:32:33~34:35:36~37:38:39~40:41:42~43:44:45~46:47:48~49:50:51~52:53:54~55:56:57~58:59:60~61:62:63~64:65:66~67:68:69~70:71:72~73:74:75~76:77:78~79:80:81~82:83:84~85:86:87~88:89:90~91:92:93~94:95:96~97:98:99~100:101:102~103:104:105~106:107:108~109:110:111~112:113:114~115:116:117~118:119:120~121:122:123~124:125:126~127:128:129~130:131:132~133:134:135~136:137:138~139:140:141~142:143:144~145:146:147~148:149:150~151:152:153~154:155:156~157:158:159~160:161:162~163:164:165~166:167:168~169:170:171~172:173:174~175:176:177~178:179:180~181:182:183~184:185:186~187:188:189~190:191:192~193:194:195~196:197:198~199:200:201~202:203:204~205:206:207~208:209:210~211:212:213~214:215:216~217:218:219~220:221:222~223:224:225~226:227:228~229:230:231~232:233:234~235:236:237~238:239:240~241:242:243~244:245:246~247:248:249~250:251:252~253:254:255~256:257:258~259:260:261~262:263:264~265:266:267~268:269:270~271:272:273~274:275:276~277:278:279~280:281:282~283:284:285~286:287:288~289:290:291~292:293:294~295:296:297~298:299:300~301:302:303~304:305:306~307:308:309~310:311:312~313:314:315~316:317:318~319:320:321~322:323:324~325:326:327~328:329:330~331:332:333~334:335:336~337:338:339~340:341:342~343:344:345~346:347:348~349:350:351~352:353:354~355:356:357~358:359:360~361:362:363~364:365:366~367:368:369~370:371:372~373:374:375~376:377:378~379:380:381~382:383:384~385:386:387~388:389:390~391:392:393~394:395:396~397:398:399~400:401:402~403:404:405~406:407:408~409:410:411~412:413:414~415:416:417~418:419:420~421:422:423~424:425:426~427:428:429~430:431:432~433:434:435~436:437:438~439:440:441~442:443:444~445:446:447~448:449:450~451:452:453~454:455:456~457:458:459~460:461:462~463:464:465~466:467:468~469:470:471~472:473:474~475:476:477~478:479:480~481:482:483~484:485:486~487:488:489~490:491:492~493:494:495~496:497:498~499:500:501~502:503:504~505:506:507~508:509:510~511:512:513~514:515:516~517:518:519~520:521:522~523:524:525~526:527:528~529:530:531~532:533:534~535:536:537~538:539:540~541:542:543~544:545:546~547:548:549~550:551:552~553:554:555~556:557:558~559:560:561~562:563:564~565:566:567~568:569:570~571:572:573~574:575:576~577:578:579~580:581:582~583:584:585~586:587:588~589:590:591~592:593:594~595:596:597~598:599:600"
*/

declare sCurrentPos varchar(4000);
declare sTemp varchar(4000);
declare bIsFinished boolean;
declare sTempPieceTypeId varchar(4000);
declare sTempPieceId varchar(4000);
declare sTempPositionId varchar(4000);
/*
declare iTempPieceId int;
declare iTempPieceTypeId int;
declare iTempPositionId int;
*/

declare iRecordStart int;
declare iRecordEnd int;
declare iDelimiterA int;
declare iDelimiterB int;
declare iCounter int;

set iRecordStart = 1;

create TEMPORARY table tblTempPositions (piece_id int, piece_type_id int, position_id int);

set bIsFinished = false;
set iCounter = 0;

while (bIsFinished = false) do
    set iDelimiterA = LOCATE(':', p_current_positions, iRecordStart + 1);
    set iDelimiterB = LOCATE(':', p_current_positions, iDelimiterA + 1);
    set iRecordEnd = LOCATE('~', p_current_positions, iDelimiterB + 1);

    if (iRecordStart = 1) then
        set sTempPieceId = left(p_current_positions, iDelimiterA - 1);
    else
        set sTempPieceId = substring(p_current_positions, iRecordStart + 1, iDelimiterA - iRecordStart - 1);
    end if;

    set sTempPieceTypeId = substring(p_current_positions, iDelimiterA + 1, iDelimiterB - iDelimiterA - 1);

    if iRecordEnd = 0 then
        set sTempPositionId = right(p_current_positions, length(p_current_positions) - iDelimiterB);
    else
        set sTempPositionId = substring(p_current_positions, iDelimiterB + 1, iRecordEnd - iDelimiterB - 1);
    end if;

    if (iRecordEnd = 0) then
        set bIsFinished = true;
    end if;

    insert into tblTempPositions (piece_id, piece_type_id, position_id)
    values (CAST(sTempPieceId AS SIGNED), CAST(sTempPieceTypeId AS SIGNED), CAST(sTempPositionId AS SIGNED));

    set iRecordStart = iRecordEnd;
    set iCounter = iCounter + 1;
    if (iCounter > 1000) then
        set bIsFinished = true;
    end if;
end while;





/***************************
 *   Get rules for Pieces  *
 ***************************/
/*
Loop through all pieces
Loop through all rules that apply to the piece and calculate what positions can be moved to.

Think about compulsary moves
think about moves with more than one piece (Castling with rook and king in chess)
*/






/********************
 *   Output stuff   *
 ********************/
select piece_id, piece_type_id, position_id from tblTempPositions;

/*select xxx from tblTempStrings;*/

end$$

DROP PROCEDURE IF EXISTS `assign_process`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `assign_process`(in p_process_id int, in p_server_id int, in p_game_id int, out p_is_ok int)
BEGIN
declare ciProcessStatus_unassigned int default 1;
declare ciProcessStatus_processing int default 2;
declare ciIsOk_True int default 1;
declare ciIsOk_False int default 0;

if exists(select * from tblServerProcesses_main where id = p_process_id and game_id = p_game_id and status_id = ciProcessStatus_unassigned) then
    update tblServerProcesses_main
    set status_id = ciProcessStatus_processing, server_id = p_server_id
    where id = p_process_id and game_id = p_game_id;
    
    set p_is_ok = ciIsOk_True;
else
    /*process might have been already assigned whilst other stuff is going on*/
    set p_is_ok = ciIsOk_False;
end if;

end$$

DROP PROCEDURE IF EXISTS `email_createForgottenPwd`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `email_createForgottenPwd`(in p_user varchar(256), out p_messsage varchar(256))
BEGIN
declare sAuthenticationString varchar(1024);
declare sTitle varchar(256) default '';
declare sMessage varchar(4000) default '';
declare sMessageLine varchar(256) default '';
declare iTextCounter int default 0;
declare iTextMax int default 0;
declare ciTextElement_ResetPwd int default 29; 
declare ciTextElement_ResetPwdTitle int default 30;
declare iLanguageId int default 0;
declare sEmail varchar(256);
declare sUsername varchar(256);
declare ciEmailStatus_sEmail int default 1;
declare ciEmailType_changePwd int default 1;
declare ciSettingId_webAddress int default 1;
declare sWebAddress varchar(1024) default '';
declare iUserId int default -1;
declare bIsOk bit default 0;

/*
 * 1) get user details from tbl_user.  
 * 2) get the text from tbl_text (incorrect language).
 *    (note: each email has one element id but different txt_id values and uses txt_id as sort order.) 
 * 3) replace strings like %1% with data fields e.g. user name.
 * 4) create authentication string
 */

delete from tbl_authentication_strings where not (createdAt_date = CURDATE() or createdAt_date = DATE_SUB(CURDATE(),INTERVAL 1 DAY));
 
set p_messsage = ''; 
 
if exists(select * from tbluser where trim(lower(username)) = trim(lower(p_user)) or trim(lower(email)) = trim(lower(p_user))) then
    set iUserId = (select id from tbluser where trim(lower(username)) = trim(lower(p_user)) or trim(lower(email)) = trim(lower(p_user)));
else
    set bIsOk = 1;
    set p_messsage = 'Cant find user'; 
end if;

 
/********************
 *   Get settings   *
 ********************/
if bIsOk = 0 then
    set sWebAddress = (select txt from tbl_settings where id = ciSettingId_webAddress);
else
    set bIsOk = 1;
    set p_messsage = 'Cant find settings'; 
end if;

/****************************
 *   Authorisation String   *
 ****************************/ 
if bIsOk = 0 then
    set sAuthenticationString = '';

    call generate_randText(100, sAuthenticationString);
 
    insert into tbl_authentication_strings (
      user_id,
      createdAt_date,
      createdAt_time,
      txt)
    values ( 
      iUserId,
      CURDATE(),
      CURTIME(),
      sAuthenticationString);
end if;

/************************
 *   Get USer details   *
 ************************/  

if bIsOk = 0 then
    if exists(select * FROM tbluser WHERE id = iUserId) then
        set iLanguageId = (select language_id FROM tbluser WHERE id = iUserId);
        set sEmail = (select email FROM tbluser WHERE id = iUserId);
        set sUsername = (select username FROM tbluser WHERE id = iUserId);
    end if;  
  
    set iTextCounter = (select min(id_text) from tbltext where id_html_element = ciTextElement_ResetPwd and id_language = iLanguageId);
    set iTextMax = (select max(id_text) from tbltext where id_html_element = ciTextElement_ResetPwd and id_language = iLanguageId);

    while iTextCounter <= iTextMax do
        set sMessageLine = (select text from tbltext where id_html_element = ciTextElement_ResetPwd and id_language = iLanguageId and id_text = iTextCounter);
        set sMessage = CONCAT(sMessage, sMessageLine);
        set iTextCounter = iTextCounter + 1;
    end while;
  
    set sTitle = (select text from tbltext where id_html_element = ciTextElement_ResetPwdTitle and id_language = iLanguageId and id_text = 1);
end if;

/***********************************
 *   Substitute %1%, %2% and %3%   *
 ***********************************/

if bIsOk = 0 then
    set sMessage = replace(sMessage, '%1%', sUsername);  
    set sMessage = replace(sMessage, '%2%', sWebAddress);  
    set sMessage = replace(sMessage, '%3%', sAuthenticationString);  
end if;  
  
/***************************
 *   Save email in table   *
 ***************************/  
if bIsOk = 0 then
    insert into tbl_email (
      user_id,
      createdAt_date,
      createdAt_time,
      status_id,
      language_id,
      email_type,
      address_to,
      address_cc,
      title,
      message)
    values (
      iUserId,
      CURDATE(),
      CURTIME(),
      ciEmailStatus_sEmail,
      iLanguageId,
      ciEmailType_changePwd,
      sEmail,
      '',
      sTitle,
      sMessage);
end if;

end$$

DROP PROCEDURE IF EXISTS `gameRequest_accept`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `gameRequest_accept`(in p_request_id int, in p_is_white int, out p_game_id int, out p_message varchar(1024))
BEGIN
declare iWhiteUserId int;
declare iBlackUserId int;
declare iGameTypeId int;
declare bIsOK boolean default true;
declare ciRequestStatus_accept int default 3;

if exists (select * from tbl_game_request where id = p_request_id) then
    if p_is_white = 1 then
        set  iWhiteUserId = (select receiver_id from tbl_game_request where id = p_request_id);
        set  iBlackUserId = (select sender_id from tbl_game_request where id = p_request_id);
    else
        set  iWhiteUserId = (select sender_id from tbl_game_request where id = p_request_id);
        set  iBlackUserId = (select receiver_id from tbl_game_request where id = p_request_id);
    end if;

    set  iGameTypeId = (select game_type_id from tbl_game_request where id = p_request_id);
else
    set bIsOK = false;
    set p_message = 'Unknown request ID';
end if;

if bIsOk = true then
    Call startGame( iWhiteUserId , iBlackUserId , iGameTypeId , p_game_id , p_message );
    update tbl_game_request 
    set status_id = ciRequestStatus_accept
    where id = p_request_id;
end if;

end$$

DROP PROCEDURE IF EXISTS `game_request_accept`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `game_request_accept`(in p_request_id int, in p_sender_id int, in p_receiver_id int)
BEGIN
declare ciGameStatus_accept int default 3;

update tbl_game_request
set status_id = ciGameStatus_accept,
    lastStatusChangeAt_date = CURDATE(), 
    lastStatusChangeAt_time = CURTIME()
where id = p_request_id 
and sender_id = p_request_id 
and receiver_id = p_sender_id;

end$$

DROP PROCEDURE IF EXISTS `game_request_details`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `game_request_details`(in p_resquest_id int, in p_language_id int)
BEGIN

CREATE TEMPORARY TABLE IF NOT EXISTS temp_requests (
    sender_id int, 
    sender_text varchar(256), 
    receiver_id int, 
    receiver_text varchar(256), 
    game_type_id int, 
    game_type_text varchar(256), 
    status_id int,
    status_text varchar(256));

insert into temp_requests (
    sender_id, 
    receiver_id, 
    game_type_id, 
    status_id)
SELECT sender_id, receiver_id, game_type_id, status_id 
FROM tbl_game_request 
WHERE id = p_resquest_id;

update temp_requests r
join tbluser u on u.id = r.sender_id
set r.sender_text = u.username; 

update temp_requests r
join tbluser u on u.id = r.receiver_id
set r.receiver_text = u.username; 

update temp_requests r
join (SELECT gt.id, t.text 
    FROM tblgametype as gt 
    inner join tbltext as t 
    on gt.language_element_id = t.id_html_element and gt.name_txt_id = t.id_text
    where t.id_language = p_language_id) as sub_qry 
on sub_qry.id = r.game_type_id
set r.game_type_text = sub_qry.text; 


update temp_requests r
join (SELECT gr.id, t.text 
    FROM tbl_lookup_gamerequest_status as gr 
    inner join tbltext as t 
    on gr.language_element_id = t.id_html_element and gr.txt_id = t.id_text
    where t.id_language = p_language_id) as sub_qry 
on sub_qry.id = r.status_id
set r.status_text = sub_qry.text; 

select
    sender_id, 
    sender_text, 
    receiver_id, 
    receiver_text, 
    game_type_id, 
    game_type_text, 
    status_id,
    status_text 
from temp_requests;

end$$

DROP PROCEDURE IF EXISTS `game_request_make`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `game_request_make`(in p_sender_id int, in p_receiver_id int, in p_game_type_id int, out p_resquest_id int)
BEGIN
declare ciGameStatus_requested int default 1;
declare iSeed int;
declare iTemp int;
declare iCounter int default 0;
declare bIsFinished boolean default false;
declare iMaxGameTypeId int;
declare iGameTypeId int;

if exists(select * from tblgametype where id = p_game_type_id) then
    set iGameTypeId = p_game_type_id;
else
    set iSeed = SECOND(curtime()) + minute(curtime()) + hour(curtime()) + 2 * p_sender_id + 7 * p_receiver_id + 17 * p_game_type_id;
    set iMaxGameTypeId = (select max(id) from tblgametype);
    
    while not bIsFinished do
        set iTemp = (RAND(iSeed) * (iMaxGameTypeId * 2 + 10));
        set iSeed = iSeed + SECOND(curtime()) + 1;
        set iCounter = iCounter + 1;
        
        if exists(select * from tblgametype where id = iTemp) then
            set bIsFinished = true;
            set iGameTypeId = iTemp;
        end if;
        
        if iCounter > 10000 then
            set bIsFinished = true;
            set iGameTypeId = iMaxGameTypeId;
        end if;
    end while;
end if;

insert into tbl_game_request (status_id, lastStatusChangeAt_date, lastStatusChangeAt_time, sender_id, receiver_id, game_type_id)
values (ciGameStatus_requested, CURDATE(), CURTIME(), p_sender_id, p_receiver_id, iGameTypeId);

set p_resquest_id = LAST_INSERT_ID();

end$$

DROP PROCEDURE IF EXISTS `game_request_reject`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `game_request_reject`(in p_request_id int, in p_sender_id int, in p_receiver_id int)
BEGIN
declare ciGameStatus_reject int default 2;

update tbl_game_request
set status_id = ciGameStatus_accept,
    lastStatusChangeAt_date = CURDATE(), 
    lastStatusChangeAt_time = CURTIME()

where id = p_request_id 
and sender_id = p_request_id 
and receiver_id = p_sender_id;

end$$

DROP PROCEDURE IF EXISTS `generate_randText`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_randText`(in p_length int, out p_result varchar(4000))
begin
declare iCounter int default 0;
declare iCounter2 int default 0;

declare iSeed int default 0;
declare iAscii int default 0;

set p_result = '';
set iSeed = p_length + SECOND(curtime()) + 60 * minute(curtime()) + 3600 * hour(curtime());
set iAscii = RAND(iSeed)*26+65;

while iCounter < p_length do
    set iCounter2 = iCounter;

    while iCounter = iCounter2 or (iAscii < 65 or iAscii > 90) do
        set iCounter2 = iCounter2 * iCounter2 - iCounter2 * 7 + 10;
        set iSeed = iAscii + iCounter2 + iCounter + (1000 * RAND(iCounter));
        set iAscii = RAND(iSeed)*28+64;
    end while;
            
    set p_result = CONCAT(p_result, CHAR(iAscii using utf8));
    set iCounter = iCounter + 1;
end while;

end$$

DROP PROCEDURE IF EXISTS `get_botList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_botList`(IN `p_GameTypeId` INT)
BEGIN

SELECT u.id, u.username
    FROM tbluser as u
    inner join tblcrossref_userplaysgametype as cr
    on u.id = cr.userId
    WHERE u.isBot = true
    and cr.gameTypeId = p_GameTypeId;

END$$

DROP PROCEDURE IF EXISTS `get_competition_template_list`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_competition_template_list`(in p_house_id int, in p_language_id int)
BEGIN

CREATE TABLE IF NOT EXISTS temp_competitionTemplate (
  id INT NOT NULL,
  type_id int not null,
  type_text varchar(256),
  period_type_id int not null,
  period_type_text varchar(256),
  competitor_type_id int not null,
  competitor_type_text varchar(256),
  signup_type_id int not null,
  signup_type_text varchar(256),
  game_type_id int not null,
  game_type_text varchar(256),
  name varchar(256) NOT NULL,
  description varchar(1024) NOT NULL);


drop table if exists temp_text_compType;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_text_compType (id int, txt varchar(256));

drop table if exists temp_text_competitorType;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_text_competitorType (id int, txt varchar(256));

drop table if exists temp_text_period;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_text_period (id int, txt varchar(256));

drop table if exists temp_text_signupType;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_text_signupType (id int, txt varchar(256));

drop table if exists temp_text_gameType;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_text_gameType (id int, txt varchar(256));

/****************
 *   Get text   *
 ****************/
insert into temp_text_compType (id, txt)
select l.id, t.text
from tbl_lookup_competitionType as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id;

insert into temp_text_competitorType (id, txt)
select l.id, t.text
from tbl_lookup_competitionCompetitor as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id;

insert into temp_text_period (id, txt)
select l.id, t.text
from tbl_lookup_competitionPeriod as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id;

insert into temp_text_signupType (id, txt)
select l.id, t.text
from tbl_lookup_competitionSignupType as l
inner join tbltext as t

on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id;

insert into temp_text_gameType (id, txt)
select l.id, t.text
from tblgametype as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.name_txt_id
where t.id_language = p_language_id;

/*********************
 *   Get templates   *
 *********************/

insert into temp_competitionTemplate (
  id,
  type_id,
  period_type_id,
  competitor_type_id,
  signup_type_id,
  game_type_id,
  name,
  description)
select
  id,
  type_id,
  period_type_id,
  competitor_type_id,
  signup_type_id,
  game_type_id,
  name,
  description
from tbl_competitionTemplate;


/********************
 *   Fill in text   *
 ********************/

update temp_competitionTemplate c
join temp_text_compType t
on t.id = c.type_id
set c.type_text = t.txt;

update temp_competitionTemplate c
join temp_text_competitorType t
on t.id = c.competitor_type_id
set c.competitor_type_text = t.txt;

update temp_competitionTemplate c
join temp_text_period t
on t.id = c.period_type_id
set c.period_type_text = t.txt;

update temp_competitionTemplate c
join temp_text_signupType t
on t.id = c.signup_type_id
set c.signup_type_text = t.txt;

update temp_competitionTemplate c
join temp_text_gameType t
on t.id = c.game_type_id
set c.game_type_text = t.txt;

/*******************
 *   Return data   *
 *******************/ 

select
  id,
  type_id,
  type_text,
  period_type_id,
  period_type_text,
  competitor_type_id,
  competitor_type_text,
  signup_type_id,
  signup_type_text,
  game_type_id,
  game_type_text,
  name,
  description 
from temp_competitionTemplate;

end$$

DROP PROCEDURE IF EXISTS `get_competition_template_list_from_user`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_competition_template_list_from_user`(in p_user_id int, in p_language_id int)
BEGIN

drop table if exists temp_houses;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_houses (id int);

drop table if exists temp_competitionTemplate;
CREATE TABLE IF NOT EXISTS temp_competitionTemplate (
  id INT NOT NULL,
  house_id int,
  house_name varchar(256),
  participant_type_id int,
  participant_type_text varchar(256),
  type_id int not null,
  type_text varchar(256),
  period_type_id int not null,
  period_type_text varchar(256),
  competitor_type_id int not null,
  competitor_type_text varchar(256),
  signup_type_id int not null,
  signup_type_text varchar(256),
  game_type_id int not null,
  game_type_text varchar(256),
  name varchar(256) NOT NULL,
  description varchar(1024) NOT NULL);  
  
drop table if exists temp_text_compType;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_text_compType (id int, txt varchar(256));

drop table if exists temp_text_competitorType;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_text_competitorType (id int, txt varchar(256));

drop table if exists temp_text_period;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_text_period (id int, txt varchar(256));

drop table if exists temp_text_signupType;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_text_signupType (id int, txt varchar(256));

drop table if exists temp_text_gameType;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_text_gameType (id int, txt varchar(256));

drop table if exists temp_text_participantType;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_text_participantType (id int, txt varchar(256));

/******************
 *   Get houses   *
 ******************/

insert into temp_houses (id)
select distinct houseid
from tblcrossref_userhouse
where userid = p_user_id;

/****************
 *   Get text   *
 ****************/
insert into temp_text_compType (id, txt)
select l.id, t.text
from tbl_lookup_competitionType as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id;

insert into temp_text_competitorType (id, txt)
select l.id, t.text
from tbl_lookup_competitionCompetitor as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id;

insert into temp_text_period (id, txt)
select l.id, t.text
from tbl_lookup_competitionPeriod as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id;

insert into temp_text_signupType (id, txt)
select l.id, t.text
from tbl_lookup_competitionSignupType as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id;

insert into temp_text_gameType (id, txt)
select l.id, t.text
from tblgametype as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.name_txt_id
where t.id_language = p_language_id;

insert into temp_text_participantType (id, txt)
select l.id, t.text
from tbl_lookup_competition_participantType as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id;


/*********************
 *   Get templates   *
 *********************/

insert into temp_competitionTemplate (
  id,
  house_id,
  type_id,
  period_type_id,
  competitor_type_id,
  signup_type_id,
  game_type_id,
  name,
  description)
select distinct
  c.id,
  c.house_id,
  c.type_id,
  c.period_type_id,
  c.competitor_type_id,
  c.signup_type_id,
  c.game_type_id,
  c.name,
  c.description
from tbl_competitionTemplate as c
inner join temp_houses as h
on h.id = c.house_id;

update temp_competitionTemplate c
join tblcrossref_competitionuser t
on c.id = t.competition_id 
set c.participant_type_id = t.participant_type_id
where t.user_id = p_user_id;



/********************
 *   Fill in text   *
 ********************/

update temp_competitionTemplate c
join temp_text_compType t
on t.id = c.type_id
set c.type_text = t.txt;

update temp_competitionTemplate c
join temp_text_competitorType t
on t.id = c.competitor_type_id
set c.competitor_type_text = t.txt;

update temp_competitionTemplate c
join temp_text_period t
on t.id = c.period_type_id
set c.period_type_text = t.txt;

update temp_competitionTemplate c
join temp_text_signupType t
on t.id = c.signup_type_id
set c.signup_type_text = t.txt;

update temp_competitionTemplate c
join temp_text_gameType t
on t.id = c.game_type_id
set c.game_type_text = t.txt;

update temp_competitionTemplate c
join tblhouse t
on t.id = c.house_id
set c.house_name = t.housename;

update temp_competitionTemplate c
join temp_text_participantType t
on t.participant_type_id = c.id
set c.participant_type_text = t.txt;

/*******************
 *   Return data   *
 *******************/ 

select
  id,
  house_id, 
  house_name,
  type_id,
  type_text,
  participant_type_id,
  participant_type_text,
  period_type_id,
  period_type_text,
  competitor_type_id,
  competitor_type_text,
  signup_type_id,
  signup_type_text,
  game_type_id,
  game_type_text,
  name,
  description 
from temp_competitionTemplate;

end$$

DROP PROCEDURE IF EXISTS `get_current_games`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_current_games`(in p_user_id int, in p_language_id int)
BEGIN
declare ciGameStatus_over int default 2;
declare iCounter int default 0;

DROP TABLE IF EXISTS temp_games;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_games (
  id int NOT NULL,
  last_move_id int NOT NULL DEFAULT '0',
  player_white_id int NOT NULL,
  player_white_text varchar(256) NULL,
  player_black_id int NOT NULL,
  player_black_text varchar(256) NULL,
  whos_turn_next_id int NOT NULL,
  game_type int NOT NULL,
  game_type_text varchar(256) NULL,
  status_id int NOT NULL,
  status_text varchar(256) NULL,
  startedAt_date date NOT NULL,
  startedAt_time time NOT NULL,
  other_person_id int,
  other_person_text varchar(256),
  menu_text varchar(256));

DROP TABLE IF EXISTS temp_id;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_id (id int);
  
insert into temp_games (id, last_move_id, player_white_id, player_black_id, whos_turn_next_id, game_type, status_id, startedAt_date, startedAt_time)
SELECT id, last_move_id, player_white_id, player_black_id, whos_turn_next_id, game_type, status_id, startedAt_date, startedAt_time 
FROM tbl_games 
WHERE (player_white_id = p_user_id or player_black_id = p_user_id)
and status_id != ciGameStatus_over;

update temp_games g
join tbluser u on u.id = g.player_white_id
set g.player_white_text = u.username; 

update temp_games g
join tbluser u on u.id = g.player_black_id
set g.player_black_text = u.username; 

update temp_games g
set other_person_id = player_black_id
where player_white_id = p_user_id;

update temp_games g

set other_person_id = player_white_id
where player_black_id = p_user_id;

update temp_games g
join tbluser u on u.id = g.other_person_id
set g.other_person_text = u.username; 

update temp_games g
join (SELECT gt.id, t.text 
    FROM tblgametype as gt 
    inner join tbltext as t 
    on gt.language_element_id = t.id_html_element and gt.name_txt_id = t.id_text
    where t.id_language = p_language_id) as sub_qry 
on sub_qry.id = g.game_type
set g.game_type_text = sub_qry.text; 


update temp_games g
join (SELECT gs.id, t.text 

    FROM tbl_lookup_gamestatus as gs 
    inner join tbltext as t 
    on gs.language_element_id = t.id_html_element and gs.txt_id = t.id_text
    where t.id_language = p_language_id) as sub_qry 
on sub_qry.id = g.status_id
set g.status_text = sub_qry.text; 


/*
update temp_games g
join (select other_person_id from temp_games group by other_person_id having count(*) = 1) as sub_qry 
on sub_qry.other_person_id = g.other_person_id
set g.menu_text = g.other_person_text;
*/

delete from temp_id;
insert into temp_id (id) 
select g2.other_person_id from temp_games as g2 group by g2.other_person_id having count(g2.id) = 1;

update temp_games as g1
set g1.menu_text = g1.other_person_text
where g1.other_person_id in (select id from temp_id);

while exists(select * from temp_games where menu_text is null) and iCounter < 1000 do
    set iCounter = iCounter + 1;

    delete from temp_id;
    insert into temp_id (id) 
    select min(g2.id) from temp_games as g2 where menu_text is null group by g2.other_person_id;

    update temp_games
    set menu_text = concat(other_person_text, ' (', cast(iCounter as char), ')')
    where id in (select id from temp_id);
end while;


select
  id,
  last_move_id,
  player_white_id,
  player_white_text,
  player_black_id,
  player_black_text,
  whos_turn_next_id,
  game_type,
  game_type_text,
  status_id,
  status_text,
  startedAt_date,
  startedAt_time,
  other_person_id,
  other_person_text,
  menu_text
from temp_games
order by other_person_text, id;

end$$

DROP PROCEDURE IF EXISTS `get_emailQueue`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_emailQueue`()
BEGIN
declare ciEmailStatus_sEmail int default 1;

SELECT id, user_id, createdAt_date, createdAt_time, language_id, email_type, address_to, address_cc, title, message 
FROM tbl_email 
WHERE status_id = ciEmailStatus_sEmail;

end$$

DROP PROCEDURE IF EXISTS `get_gameStatus_overview`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_gameStatus_overview`(in p_game_id int, out p_last_move_id int, out p_game_status int, out p_whos_turn_next_id int)
BEGIN

if exists(select * FROM tbl_games where id = p_game_id) then
    set p_last_move_id = (select last_move_id FROM tbl_games where id = p_game_id);
    set p_game_status = (select status_id FROM tbl_games where id = p_game_id);
    set p_whos_turn_next_id = (select whos_turn_next_id FROM tbl_games where id = p_game_id);
else
    set p_last_move_id = -1;
    set p_game_status = -1;
    set p_whos_turn_next_id = -1;
end if;

end$$

DROP PROCEDURE IF EXISTS `get_games_list_description`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_games_list_description`(IN `p_language_id` INT)
BEGIN
    SELECT gt.id, t.text
    FROM tblgametype as gt
    inner join tbltext as t
    on gt.language_element_id = t.id_html_element
    and gt.name_txt_id = t.id_text    
    where t.id_language = p_language_id;

end$$

DROP PROCEDURE IF EXISTS `get_game_currentPositions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_game_currentPositions`(IN p_language_id INT, IN p_game_id int, OUT p_message VARCHAR(1024))
BEGIN
declare iGameTypeId int default -1;
declare ciPieceColour_white int default 1;

if exists(SELECT * FROM tbl_games where id = p_game_id) then
    set iGameTypeId = (SELECT game_type FROM tbl_games where id = p_game_id);
end if;

SELECT id, if(colour_id=ciPieceColour_white, 1, 0) as isWhite, piece_type_id, piece_id as piece_no, iGameTypeId as gameType_id, square_no as squareNumber  
FROM tbl_game_current_positions 
WHERE game_id = p_game_id;

end$$

DROP PROCEDURE IF EXISTS `get_game_current_positions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_game_current_positions`(IN `p_game_id` INT)
BEGIN


    SELECT piece_id, colour_id, square_no, move_type, piece_type_id
    FROM tbl_game_current_positions
    where game_id = p_game_id;

end$$

DROP PROCEDURE IF EXISTS `get_game_details`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_game_details`(IN `p_game_id` INT)
BEGIN

SELECT player_white_id, player_black_id, whos_turn_next_id, game_type, status_id, startedAt_date, startedAt_time, endedAt_date, endedAt_time, description 
FROM tbl_games 
WHERE id = p_game_id;

end$$

DROP PROCEDURE IF EXISTS `get_game_details_rules_game`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_game_details_rules_game`(IN `p_game_type_id` INT)
BEGIN

SELECT rule_id FROM tblcrossref_gametyperulegame 
WHERE gametype_id = p_game_type_id;

end$$

DROP PROCEDURE IF EXISTS `get_game_details_rules_pieces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_game_details_rules_pieces`(IN `p_game_type_id` INT)
BEGIN

SELECT piecetype_id, rule_id 
FROM tblcrossref_gametyperulepiece 
WHERE gametype_id = p_game_type_id;

end$$

DROP PROCEDURE IF EXISTS `get_game_type_details`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_game_type_details`(IN `p_language_id` INT, IN `p_game_name_id` INT)
    DETERMINISTIC
BEGIN


if p_language_id = -1 then
    SELECT gt.id, "" as name, gt.language_element_id, gt.name_txt_id, gt.board_width, gt.board_height, gt.board_type_id 
    FROM tblgametype as gt
    WHERE gt.id = p_game_name_id;
ELSE
    SELECT gt.id, t.text as name, gt.language_element_id, gt.name_txt_id, gt.board_width, gt.board_height, gt.board_type_id 
    FROM tblgametype as gt
    inner join tbltext as t
    on gt.language_element_id = t.id_html_element
    and gt.name_txt_id = t.id_text
    WHERE gt.id = p_game_name_id
    and t.id_language = p_language_id;
end if;

end$$

DROP PROCEDURE IF EXISTS `get_game_type_id`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_game_type_id`(IN `p_language_id` INT, IN `p_game_name` VARCHAR(256), OUT `p_gametype_id` INT, OUT `p_message` VARCHAR(1024))
BEGIN
declare iGameTypeId int;

set iGameTypeId  = -1;
set p_message  = "";

if exists(select g.id
          from tblGameType as g
          inner join tbltext as t
          on g.language_element_id = t.id_html_element
          and g.name_txt_id = t.id_text
          where t.id_language = p_language_id
          and t.text = p_game_name) then
    set iGameTypeId  = (select g.id
                        from tblGameType as g
                        inner join tbltext as t
                        on g.language_element_id = t.id_html_element
                        and g.name_txt_id = t.id_text
                        where t.id_language = p_language_id
                        and t.text = p_game_name);
end if;

set p_gametype_id = iGameTypeId;

end$$

DROP PROCEDURE IF EXISTS `get_game_type_pieces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_game_type_pieces`(IN `p_language_id` INT, IN `p_game_name_id` INT, OUT `p_message` VARCHAR(1024))
BEGIN

SELECT p.piece_type_id, t.text as name, p.language_element_id, p.name_txt_id, p.white_file_name, p.black_file_name
FROM (tblpiecetype as p
inner join tblcrossref_gametypepiecetype as cr
on p.id = cr.piecetype_id)
inner join tbltext as t
on t.id_html_element = p.language_element_id
and t.id_text = p.name_txt_id
where gametype_id = p_game_name_id
and t.id_language = p_language_id;

end$$

DROP PROCEDURE IF EXISTS `get_game_type_startpositions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_game_type_startpositions`(IN p_language_id INT, IN p_game_name_id int, OUT p_message VARCHAR(1024))
BEGIN

SELECT p.id, p.isWhite, p.piece_type_id, p.piece_no, p.gameType_id, p.squareNumber FROM tblpiecestartposition as p
WHERE p.gameType_id = p_game_name_id;

end$$

DROP PROCEDURE IF EXISTS `get_houses`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_houses`(IN p_userid INT, in p_language_id int)
BEGIN

    drop table if exists temp_houseStatus;
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_houseStatus(id int, txt varchar(1024));

    drop table if exists temp_membership;
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_membership (id int, txt varchar(1024));
    
    insert into temp_houseStatus (id, txt)
    SELECT h.id, t.text
    FROM tbl_lookup_housestatus as h
    inner join tblText as t
    on h.language_element_id = t.id_html_element
    and h.txt_id = t.id_text
    where t.id_language = p_language_id;

    insert into temp_membership (id, txt)
    SELECT m.id, t.text
    FROM tbl_lookup_membership_type as m
    inner join tblText as t

    on m.language_element_id = t.id_html_element
    and m.txt_id = t.id_text
    where t.id_language = p_language_id;

     select distinct 
         h.id,
         h.housename,
         h.createdAt,
         h.status as house_status_id,
         hs.txt as house_status,
         uh.membership_type_id,
         m.txt as membership_type
     from (tblHouse as h
     inner join tblCrossRef_UserHouse as uh
     on h.id = uh.houseid)
     inner join temp_membership as m
     on uh.membership_type_id = m.id
     inner join temp_houseStatus as hs
     on h.status = hs.id
     where uh.userid = p_userid;

END$$

DROP PROCEDURE IF EXISTS `get_Housesusers`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_Housesusers`(IN p_house_id INT, in p_language_id int)
BEGIN

drop table if exists temp_status;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_status (id int, txt varchar(1024));

drop table if exists temp_membership;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_membership (id int, txt varchar(1024));

insert into temp_status (id, txt)
SELECT u.id, t.text
FROM tbl_lookup_userstatus as u
inner join tblText as t
on u.language_element_id = t.id_html_element
and u.txt_id = t.id_text
where t.id_language = p_language_id;

insert into temp_membership (id, txt)
SELECT m.id, t.text
FROM tbl_lookup_membership_type as m
inner join tblText as t
on m.language_element_id = t.id_html_element
and m.txt_id = t.id_text
where t.id_language = p_language_id;

SELECT DISTINCT cr.houseid, h.housename, cr.userid, u.username, u.status, ts.txt as User_status, cr.membership_type_id, tm.txt as membership_type_description
FROM tblcrossref_userhouse as cr
inner join tbluser u
on cr.userid = u.id
inner join tblhouse h
on cr.houseid = h.id
inner join temp_status as ts
on u.status = ts.id
inner join temp_membership as tm
on tm.id = cr.membership_type_id
where cr.houseid = p_house_id;

END$$

DROP PROCEDURE IF EXISTS `get_languages`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_languages`()
BEGIN
     select id, description, displayOrder
     from tbl_lookup_language
     order by displayOrder;

END$$

DROP PROCEDURE IF EXISTS `get_language_id`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_language_id`(IN `p_language_text` VARCHAR(256), OUT `p_language_id` INT, OUT `p_message` VARCHAR(1024))
BEGIN
     declare iResult int;

     set p_message = "";
     set iResult = -1;

     if exists(select id from tbl_lookup_language where upper(description) = upper(p_language_text)) then
         set iResult = (select id from tbl_lookup_language where upper(description) = upper(p_language_text));
     else
         set p_message = "Language ID not found.";
         set iResult = -1;
     end if;

     set p_language_id = iResult;
END$$

DROP PROCEDURE IF EXISTS `get_lookup_competitionCompetitor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_lookup_competitionCompetitor`(in p_language_id int)
BEGIN


select l.id, t.text
from tbl_lookup_competitionCompetitor as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id;


end$$

DROP PROCEDURE IF EXISTS `get_lookup_competitionPeriod`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_lookup_competitionPeriod`(in p_language_id int)
BEGIN

select l.id, t.text
from tbl_lookup_competitionPeriod as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id;

end$$

DROP PROCEDURE IF EXISTS `get_lookup_competitionSignupType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_lookup_competitionSignupType`(in p_language_id int)
BEGIN

select l.id, t.text
from tbl_lookup_competitionSignupType as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id;

end$$

DROP PROCEDURE IF EXISTS `get_lookup_competitionType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_lookup_competitionType`(in p_language_id int)
BEGIN

select l.id, t.text
from tbl_lookup_competitionType as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id;

end$$

DROP PROCEDURE IF EXISTS `get_lookup_competition_participantType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_lookup_competition_participantType`(in p_language_id int)
BEGIN

select l.id, t.text
from tbl_lookup_competition_participantType as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id;

end$$

DROP PROCEDURE IF EXISTS `get_lookup_housestatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_lookup_housestatus`(in p_language_id int)
BEGIN

SELECT l.id, t.text, l.description 
FROM tbl_lookup_housestatus as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id
ORDER BY t.text;

end$$

DROP PROCEDURE IF EXISTS `get_lookup_membership_type`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_lookup_membership_type`(in p_language_id int)
BEGIN

SELECT l.id, t.text, l.description 
FROM tbl_lookup_membership_type as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id
ORDER BY t.text;

end$$

DROP PROCEDURE IF EXISTS `get_lookup_userstatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_lookup_userstatus`(in p_language_id int)
BEGIN

SELECT l.id, t.text, l.description 
FROM tbl_lookup_userstatus as l
inner join tbltext as t
on t.id_html_element = l.language_element_id
and t.id_text = l.txt_id
where t.id_language = p_language_id
ORDER BY t.text;

end$$

DROP PROCEDURE IF EXISTS `get_news`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_news`(in p_date int, in p_user_id int, in p_option int, in p_misc_id int)
BEGIN
declare iItemCount int;
declare dDayCounter date;
declare bFinished boolean;
declare iTempUserId int;
declare ciNewsType_gameRequest int default 1;
declare ciNewsType_gamestart int default 2;
declare ciNewsType_gameresult int default 3;
declare ciNewsType_ad int default 4;
declare ciOption_thisUser int default 1;
declare ciOption_allUsers int default 2;
declare ciOption_UsersInHouse int default 3;
declare dDate date;
declare iYear int;
declare iMonth int;
declare iDay int;
declare ciRequestStatus_requested int default 1;
declare ciAdStatus_active int default 1;

set iYear = floor(p_date / 10000);
set p_date = p_date - (iYear * 10000);
set iMonth = floor(p_date / 100);
set p_date = p_date - (iMonth * 100);
set iDay = p_date;

set dDate = DATE_ADD(DATE_ADD(MAKEDATE(iYear, 1), INTERVAL (iMonth)-1 MONTH), INTERVAL (iDay)-1 DAY);

drop table if exists temp_user_filter;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_user_filter (user_id int);

if p_option = ciOption_thisUser then
    insert into temp_user_filter (user_id)
    values (p_user_id);
elseif p_option = ciOption_allUsers or p_misc_id = -1 then
    insert into temp_user_filter (user_id)
    select distinct u.userid 
    FROM tblcrossref_userhouse h
    inner join tblcrossref_userhouse u
    on h.houseid = u.houseid
    where h.userid = p_user_id;
elseif p_option = ciOption_UsersInHouse then
    insert into temp_user_filter (user_id)
    select distinct userid 
    FROM tblcrossref_userhouse
    where houseid = p_misc_id;
end if;

create index idx_usr_filter on temp_user_filter (user_id);

set bFinished = false;

drop table if exists temp_game_results;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_game_results (
     at_date date not null,
     at_time time not null,
     news_type int not null,
     game_request_id int,
     game_request_sender_id int,
     game_request_sender_name varchar(256),
     game_request_receiver_id int,
     game_request_receiver_name varchar(256),
     game_request_status_id int,
     game_result_white_player_id int,
     game_result_white_player_name varchar(256),
     game_result_black_player_id int,
     game_result_black_player_name varchar(256),
     game_result_winner_player_id int,
     game_result_winner_player_name varchar(256),
     game_start_white_player_id int,
     game_start_white_player_name varchar(256),
     game_start_black_player_id int,
     game_start_black_player_name varchar(256),
     ad_id int,
     ad_description varchar(256),
     ad_user_id int, 
     ad_user_name varchar(256),
     ad_game_types varchar(1024));

drop table if exists temp_user;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_user (
     user_id int,
     user_name varchar(256),
     user_isbot boolean,
     unique idx_temp_user_id (user_id));

/*************************************************
 *   Get game requests for the day dDayCounter   *
 *************************************************/
insert into temp_game_results (
    game_request_id,
    game_request_sender_id,
    game_request_receiver_id,
    game_request_status_id,
    at_date,
    at_time,
    news_type)
select distinct 
    r.id, 
    r.sender_id,
    r.receiver_id,
    r.status_id,
    r.lastStatusChangeAt_date,
    r.lastStatusChangeAt_time,

    ciNewsType_gameRequest
from tbl_game_request as r
inner join temp_user_filter as f 
on f.user_id = r.sender_id
or f.user_id = r.receiver_id
where r.lastStatusChangeAt_date = dDate
and status_id = ciRequestStatus_requested;

/************************************************
 *   Get game results for the day dDayCounter   *
 ************************************************/
insert into temp_game_results (
    at_date,
    at_time,
    news_type,
    game_result_white_player_id,
    game_result_black_player_id,
    game_result_winner_player_id)
SELECT distinct
    g.endedAt_date, 
    g.endedAt_time, 
    ciNewsType_gameresult, 
    g.player_white_id, 
    g.player_black_id, 
    if(g.whos_turn_next_id = g.player_black_id, g.player_white_id, g.player_black_id) as winner
FROM tbl_games as g
inner join temp_user_filter as f 
on f.user_id = g.player_white_id
or f.user_id = g.player_black_id
WHERE g.endedAt_date = dDate
order by g.endedAt_date, g.endedAt_time;    
     
    
/***********************************************
  *   Get game Starts for the day dDayCounter   *
  ***********************************************/
insert into temp_game_results (
    at_date,
    at_time,
    news_type,
    game_start_white_player_id,
    game_start_black_player_id)
SELECT distinct
    g.startedAt_date, 
    g.startedAt_time, 
    ciNewsType_gamestart, 
    g.player_white_id, 
    g.player_black_id 
FROM tbl_games as g
inner join temp_user_filter as f 
on f.user_id = g.player_white_id
or f.user_id = g.player_black_id
WHERE g.startedAt_date = dDate
order by g.startedAt_date, g.startedAt_time;    

/***************
 *   Adverts   *
 ***************/
insert into temp_game_results (
    at_date,
    at_time,
    news_type,
    ad_id,
    ad_description,
    ad_user_id) 
select 
    a.posted_date,
    a.posted_time,
    ciNewsType_ad,
    a.id,
    a.description,
    a.user_id
from tbl_ads as a
inner join temp_user_filter as f
on f.user_id = a.user_id
where a.posted_date = dDate
and a.status_id = ciAdStatus_active;


/*
CREATE TABLE IF NOT EXISTS tbl_ads (
  id INT NOT NULL AUTO_INCREMENT,
  user_id int not null,
  description varchar(256),
  posted_date date not null,
  posted_time date not null,
  status_id int not null,
  PRIMARY KEY (id)) ENGINE=MyISAM;

*/

insert into temp_user (user_id)
select distinct u.userid 
FROM tblcrossref_userhouse h
inner join tblcrossref_userhouse u
on h.houseid = u.houseid
where h.userid = p_user_id;


update temp_user t
join tbluser u on u.id = t.user_id
set t.user_name = u.username;

create index idx_temp_game_result_rqust_sndr on temp_game_results (game_request_sender_id);
create index idx_temp_game_result_rqust_rcvr on temp_game_results (game_request_receiver_id);
create index idx_temp_game_result_rqust_sts_id on temp_game_results (game_request_status_id);
create index idx_temp_game_result_rslt_wht_plyr on temp_game_results (game_result_white_player_id);
create index idx_temp_game_result_rslt_blck_plyr on temp_game_results (game_result_black_player_id);
create index idx_temp_game_result_rslt_wnnr_plyr on temp_game_results (game_result_winner_player_id);
create index idx_temp_game_result_str_wht_plyr on temp_game_results (game_start_white_player_id);
create index idx_temp_game_result_str_blck_plyr on temp_game_results (game_start_black_player_id);
create index idx_temp_game_result_ad_usr on temp_game_results (ad_user_id);


update temp_game_results r
join temp_user u on r.game_request_sender_id = u.user_id
set r.game_request_sender_name = u.user_name;

update temp_game_results r
join temp_user u on r.game_request_receiver_id = u.user_id
set r.game_request_receiver_name = u.user_name;

update temp_game_results r
join temp_user u on r.game_result_white_player_id = u.user_id
set r.game_result_white_player_name = u.user_name;

update temp_game_results r
join temp_user u on r.game_result_black_player_id = u.user_id
set r.game_result_black_player_name = u.user_name;

update temp_game_results r
join temp_user u on r.game_result_winner_player_id = u.user_id
set r.game_result_winner_player_name = u.user_name;

update temp_game_results r
join temp_user u on r.game_start_white_player_id = u.user_id
set r.game_start_white_player_name = u.user_name;

update temp_game_results r
join temp_user u on r.game_start_black_player_id = u.user_id
set r.game_start_black_player_name = u.user_name;

update temp_game_results r
join temp_user u on r.ad_user_id = u.user_id
set r.ad_user_name = u.user_name;

select distinct
     at_date,
     at_time,
     news_type,
     game_request_id,
     game_request_sender_id,
     game_request_sender_name,
     game_request_receiver_id,
     game_request_receiver_name,
     game_request_status_id,
     game_result_white_player_id,
     game_result_white_player_name,
     game_result_black_player_id,
     game_result_black_player_name,
     game_result_winner_player_id,
     game_result_winner_player_name,
     game_start_white_player_id,
     game_start_white_player_name,
     game_start_black_player_id,
     game_start_black_player_name
     ad_id,
     ad_description,
     ad_user_id, 
     ad_user_name,
     ad_game_types 
     
from temp_game_results
order by at_date desc, at_time desc;

end$$

DROP PROCEDURE IF EXISTS `get_queue_games_waiting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_queue_games_waiting`()
BEGIN
DECLARE ic_waiting_for_computer INT DEFAULT 3;
DECLARE ic_processing INT DEFAULT 4;

create TEMPORARY table tblTemp (id int);

insert into tblTemp (id)
SELECT id 
FROM tbl_games 
WHERE status_id = ic_waiting_for_computer;

update tbl_games
set status_id = ic_processing

where id in (select id from tblTemp);

select id from tblTemp;

end$$

DROP PROCEDURE IF EXISTS `get_rules_game`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_rules_game`(IN p_language_id INT, IN p_game_type_id int, OUT `p_message` VARCHAR(1024))
BEGIN

DROP TEMPORARY TABLE IF EXISTS performance;
CREATE TEMPORARY TABLE tblTemp AS
select r.id as rule_id, r.language_element_id, r.name_txt_id, r.description_txt_id, "" as name, "" as description
from tblCrossref_GameTypeRuleGame as cr
inner join tblRule_Game as r
on cr.rule_id = r.id
where cr.gametype_id = p_game_type_id;

UPDATE tblTemp AS tmp
INNER JOIN tbltext AS txt
ON tmp.name_txt_id = txt.id_text
AND tmp.language_element_id = txt.id_html_element
SET tmp.name = txt.name
WHERE  txt.id_language = p_language_id;

UPDATE tblTemp AS tmp
INNER JOIN tbltext AS txt
ON tmp.description_txt_id = txt.id_text
AND tmp.language_element_id = txt.id_html_element
SET tmp.description = txt.name
WHERE  txt.id_language = p_language_id;

select t.rule_id, t.name, t.description
from tblTemp as t;

end$$

DROP PROCEDURE IF EXISTS `get_someone_elses_user_id`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_someone_elses_user_id`(IN `p_user_name` VARCHAR(256), OUT `p_user_id` INT, OUT `p_message` VARCHAR(1024))
BEGIN
     declare iUserId int;

     set p_message = "";


     if exists(select id from tblUser where username = p_user_name) then
         set iUserId = (select id from tblUser where username = p_user_name);
     else
         set p_message = "Can't find UserName";
         set iUserId = -1;
     end if;

     set p_user_id = iUserId;
END$$

DROP PROCEDURE IF EXISTS `get_text`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_text`(IN `p_language_id` INT, IN `p_html_element_text` VARCHAR(256), OUT `p_message` VARCHAR(256))
BEGIN
     declare iHtmlElementId int;

     set p_message = "x";
     set iHtmlElementId = -1;

     if exists(select id from tbl_lookup_html_element where upper(description) = upper(p_html_element_text)) then
         set iHtmlElementId = (select id from tbl_lookup_html_element where upper(description) = upper(p_html_element_text));
     else
         set p_message = "HTML Element ID not found";

         set iHtmlElementId = -1;
     end if;

     SELECT id_text, text
     FROM tbltext


     WHERE id_language = p_language_id
     and id_html_element = iHtmlElementId;
END$$

DROP PROCEDURE IF EXISTS `get_unassigned_processes_list`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_unassigned_processes_list`()
BEGIN
declare ciProcessStatus_unassigned int default 1;

select
     id,
     server_id,
     game_id,
     process_type_id,
     start_time
from tblServerProcesses_main
where status_id = ciProcessStatus_unassigned
order by start_time;

end$$

DROP PROCEDURE IF EXISTS `get_userId_from_authenticationString`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_userId_from_authenticationString`(in p_code varchar(1024), out p_user_id int, out p_messsage varchar(256))
BEGIN
declare dAuthTime time;

delete from tbl_authentication_strings where not (createdAt_date = CURDATE() or createdAt_date = DATE_SUB(CURDATE(),INTERVAL 1 DAY));

if exists(select * from tbl_authentication_strings where txt = p_code and createdAt_date = CURDATE()) then
    set p_user_id = (select user_id from tbl_authentication_strings where txt = p_code);
elseif exists(select * from tbl_authentication_strings where txt = p_code and createdAt_date = DATE_SUB(CURDATE(),INTERVAL 1 DAY)) then
    set dAuthTime = (select createdAt_time from tbl_authentication_strings where txt = p_code); 
    if CURTIME() < dAuthTime then
        set p_user_id = -1;
        set p_messsage = 'Authentication code has expired';
    else
        set p_user_id = (select user_id from tbl_authentication_strings where txt = p_code);
    end if;
else
    set p_user_id = -1;
    set p_messsage = 'Invalid authentication code';
end if;

end$$

DROP PROCEDURE IF EXISTS `get_userList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_userList`(in p_house_id int, in p_user_id int)
BEGIN
/*
if house id = -1 then return everyone in all the houses
*/


if p_house_id = -1 then
    SELECT distinct u.id, u.username
    FROM tbluser as u
    inner join tblcrossref_userhouse as h1
    on u.id = h1.userId
    inner join tblcrossref_userhouse as h2
    on h1.houseid = h2.houseid
    WHERE u.isBot = false
    and h2.userid = p_user_id
    and not u.id = p_user_id
    order by u.username;
else
    if exists(select * from tblcrossref_userhouse where houseid = p_house_id and userid = p_user_id) then
	SELECT distinct u.id, u.username

	FROM tbluser as u
	inner join tblcrossref_userhouse as h
	on u.id = h.userId
	WHERE u.isBot = false
	and h.houseid = p_house_id
        and not u.id = p_user_id
	order by u.username;
    else
	select -1 as id, '' as username;
    end if;
end if;


END$$

DROP PROCEDURE IF EXISTS `get_usersHouses`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_usersHouses`(IN `p_user_id` INT)
BEGIN
     declare iHouseStatus_Active int;
     declare iUserStatus_Active int;


     set iHouseStatus_Active = (SELECT id FROM tbl_lookup_housestatus WHERE upper(description) = upper('active'));
     set iUserStatus_Active = (SELECT id FROM tbl_lookup_userstatus where upper(description) = upper('Active'));

     SELECT DISTINCT t1.houseid, h.housename, t2.userid, u.username
     FROM tblcrossref_userhouse as t1
     inner join tblcrossref_userhouse as t2
     on t1.houseid = t2.houseid
     inner join tblhouse h
     on t1.houseid = h.id
     inner join tbluser u
     on t2.userid = u.id
     where t1.userid = p_user_id
     and h.status = iHouseStatus_Active
     and u.status = iUserStatus_Active;

END$$

DROP PROCEDURE IF EXISTS `get_users_in_all_my_houses`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_users_in_all_my_houses`(IN `p_user_id` INT, OUT `p_message` VARCHAR(1024))
BEGIN
    SELECT distinct u.username
    FROM tbluser as u
    inner join (tblcrossref_userhouse as mh
    inner join tblcrossref_userhouse as oh
    on oh.houseid = mh.houseid)
    on oh.userid = u.id
    where mh.userid = p_user_id and not oh.userid = p_user_id
    order by u.username;
end$$

DROP PROCEDURE IF EXISTS `get_user_id`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_id`(IN `p_username` VARCHAR(256), IN `p_pwd` VARCHAR(256), OUT `p_message` VARCHAR(256), OUT `p_id` INT)
BEGIN
    DECLARE sOutMessage VARCHAR(256);
    DECLARE iOutId INT;

    IF EXISTS (SELECT * FROM tbluser WHERE upper(username)=upper(p_username)) THEN
        IF EXISTS (SELECT * FROM tbluser WHERE upper(username)=upper(p_username) and upper(pwd)=upper(p_pwd)) THEN
            SET sOutMessage = "OK";
            SET iOutId = (SELECT id FROM tblUser WHERE upper(username)=upper(p_username) and upper(pwd)=upper(p_pwd));
        ELSE
            SET sOutMessage = "Wrong Password.";
            SET iOutId = -1;
        END IF;
    ELSE
        SET sOutMessage = "User does not exist.";
        SET iOutId = -1;
    END IF;

    SET p_message = sOutMessage;
    SET p_id = iOutId;
END$$

DROP PROCEDURE IF EXISTS `get_user_notifications`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_notifications`(in p_user_id int)
BEGIN

SELECT notifications_regularNews, notifications_newCompetitionInHouse, notifications_competitionResults, notifications_adsPosted 
FROM tbluser 
WHERE id = p_user_id;

end$$

DROP PROCEDURE IF EXISTS `house_createNew`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `house_createNew`(IN `p_house_name` VARCHAR(256), IN `p_house_description` VARCHAR(1000), IN `p_user_id` INT)
BEGIN
declare iHouse_id int;
declare ciStatus_active int default 1;
declare ciMembershipType_owner int default 1;

INSERT INTO tblhouse(housename, description, createdAt, status) 
VALUES (p_house_name, p_house_description, Now(), ciStatus_active);


set iHouse_id = LAST_INSERT_ID();

INSERT INTO tblcrossref_userhouse(houseid, userid, membership_type_id)
values (iHouse_id, p_user_id, ciMembershipType_owner);

end$$

DROP PROCEDURE IF EXISTS `house_edit`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `house_edit`(in p_house_id int, in p_house_name varchar(256), in p_house_description varchar(1000), in p_house_status int, in p_user_id int)
BEGIN
declare ciMembershipType_owner int default 1;

if exists(select * from tblcrossref_userhouse where houseid = p_house_id and userid = p_user_id and membership_type_id = ciMembershipType_owner) then
    UPDATE tblhouse 
    SET 
	housename = p_house_name,
	description = p_house_description,
	status = p_house_status 
    WHERE id = p_house_id;
end if;

end$$

DROP PROCEDURE IF EXISTS `house_view_details`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `house_view_details`(IN p_user_id INT, IN p_house_id INT)
BEGIN
     select distinct 
         h.id,
         h.housename,
         h.description,
         h.createdAt,
         h.status as house_status_id,
         hs.description as house_status,
         uh.membership_type_id,
         m.description as membership_type
     from (tblHouse as h
     inner join tblCrossRef_UserHouse as uh
     on h.id = uh.houseid)
     inner join tbl_lookup_membership_type as m
     on uh.membership_type_id = m.id
     inner join tbl_lookup_housestatus as hs
     on h.status = hs.id
     where uh.userid = p_user_id
     and h.id = p_house_id;

END$$

DROP PROCEDURE IF EXISTS `insert_possible_move`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_possible_move`(in p_process_id int, in p_multi_move bool, in p_square_no int, in p_piece_id int, in p_move_order int, in p_is_compulsary bool, in p_is_next_move bool, in p_player_id int)
BEGIN

INSERT INTO tblserverprocesses_possiblemoves(process_id, multi_move, square_no, piece_id, move_order, is_compulsary, is_next_move, player_id) 
VALUES (p_process_id, p_multi_move, p_square_no, p_piece_id, p_move_order, p_is_compulsary, p_is_next_move, p_player_id);

end$$

DROP PROCEDURE IF EXISTS `login_captcha_check`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_captcha_check`( in p_session_id varchar(256), in p_code varchar(256), out p_result int)
BEGIN

delete from tbl_captchaRequests 

where not (createdAt_date = CURDATE() or createdAt_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY));

drop table if exists temp_codes;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_codes (code varchar(256));

insert into temp_codes (code)
select distinct captcha_txt
from tbl_captchaRequests
where session_id = p_session_id;

if exists(select * from temp_codes where trim(lower(code)) = trim(lower(p_code))) then
    set p_result = 0;
else
    set p_result = 1;
end if;

end$$

DROP PROCEDURE IF EXISTS `login_captcha_request`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_captcha_request`( in p_session_id varchar(256), out p_path varchar(256))
BEGIN
declare bIsFinished boolean default false;
declare iSeed int;
declare iTemp int default 0;
declare iMaxId int;
declare sCaptchaCode varchar(256) default '';

set p_path = '';

set iSeed = 3600 * SECOND(curtime()) + 60 * minute(curtime()) + hour(curtime());
set iMaxId = (select max(id) from tbl_captcha);

while not bIsFinished do
    set iSeed = iSeed - iTemp + SECOND(curtime()) + minute(curtime()) + hour(curtime());
    set iTemp = (RAND(iSeed) * (iMaxId * 2 + 10));
    
    if exists(select * from tbl_captcha where id = iTemp) then
        set bIsFinished = true;
        set p_path = (select file from tbl_captcha where id = iTemp);
        set sCaptchaCode = (select code from tbl_captcha where id = iTemp);
    end if;
end while;

insert into tbl_captchaRequests (createdAt_date, session_id, captcha_txt) values (CURDATE(), p_session_id, sCaptchaCode);

delete from tbl_captchaRequests where not (createdAt_date = CURDATE() or createdAt_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY));

end$$

DROP PROCEDURE IF EXISTS `login_changeUserName`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_changeUserName`(IN p_userid int, IN p_username VARCHAR(256), IN p_session_id VARCHAR(256), IN p_ip varchar(256), IN p_token varchar(1024), OUT p_result VARCHAR(256))
BEGIN
declare sTitle varchar(256) default '';
declare sMessage varchar(4000) default '';
declare sMessageLine varchar(256) default '';
declare iTextCounter int default 0;
declare iTextMax int default 0;
declare iLanguageId int default 0;
declare sEmail varchar(256);
declare sOldUserName varchar(256);
declare ciEmailStatus_sEmail int default 1;
declare ciEmailType_changeUsrName int default 5;
declare ciTextElement_changeUsrName int default 31; 
declare ciTextElement_changeUsrNameTitle int default 32;
declare bIsOk boolean default true;

set p_result = '';

if exists(SELECT * FROM tbl_sessions WHERE user_id = p_userid) then
    DROP TABLE IF EXISTS temp_sessions;
    CREATE TEMPORARY TABLE temp_sessions (
        sessions_id varchar(1024),
        ip varchar(256),
        token varchar(1024),
        user_id int,
        now_day date,
        now_time time,
        now_datetime datetime);

    insert into temp_sessions (sessions_id, ip, token, user_id, now_day, now_time)
    select                     sessions_id, ip, token, user_id, now_day, now_time 
    from tbl_sessions 
    where user_id = p_userid 
    and (now_day = curdate() or now_day = DATE_SUB( curdate(), INTERVAL 1 DAY ));
    
    delete from temp_sessions where now_day = DATE_SUB( curdate(), INTERVAL 1 DAY ) and now_time < curtime();
    
    if (not exists(select * from temp_sessions where sessions_id = p_session_id and ip = p_ip and token = p_token)) then
        set p_result = 'no current session';
        set bIsOk = false;
    end if;
else
    set p_result = 'no current session';
    set bIsOk = false;
end if;

if bIsOk = true then
    set sOldUserName = (select username from tbluser where id = p_userid);
    
    update tbluser set username = p_username where id = p_userid;

    if exists(select * from tbluser where username = p_username and id = p_userid) then
        set p_result = 'ok';
    else
        set p_result = 'update failed';
        set bIsOk = false;
    end if;
end if;

/***********************************************************************
 *   Insert new email to remind user that user name has been changed   *
 ***********************************************************************/

 
/************************
 *   Get USer details   *
 ************************/  

if bIsOk = true then
    if exists(select * FROM tbluser WHERE id = p_userid) then
        set iLanguageId = (select language_id FROM tbluser WHERE id = p_userid);
        set sEmail = (select email FROM tbluser WHERE id = p_userid);
    end if;  
  
    set iTextCounter = (select min(id_text) from tbltext where id_html_element = ciTextElement_changeUsrName and id_language = iLanguageId);
    set iTextMax = (select max(id_text) from tbltext where id_html_element = ciTextElement_changeUsrName and id_language = iLanguageId);

    while iTextCounter <= iTextMax do
        set sMessageLine = (select text from tbltext where id_html_element = ciTextElement_changeUsrName and id_language = iLanguageId and id_text = iTextCounter);
        set sMessage = CONCAT(sMessage, sMessageLine);
        set iTextCounter = iTextCounter + 1;
    end while;
  
    set sTitle = (select text from tbltext where id_html_element = ciTextElement_changeUsrNameTitle and id_language = iLanguageId and id_text = 1);
end if;

/***********************************
 *   Substitute %1%, %2% and %3%   *
 ***********************************/

if bIsOk = true then
    set sMessage = replace(sMessage, '%1%', p_username);  
    set sMessage = replace(sMessage, '%2%', sOldUserName);  
    set sMessage = replace(sMessage, '%3%', p_username);  
end if;  

/***************************
 *   Save email in table   *
 ***************************/  
if bIsOk = true then
    insert into tbl_email (
      user_id,
      createdAt_date,
      createdAt_time,
      status_id,
      language_id,
      email_type,
      address_to,
      address_cc,
      title,
      message)
    values (
      p_userid,
      CURDATE(),
      CURTIME(),
      ciEmailStatus_sEmail,
      iLanguageId,
      ciEmailType_changeUsrName,
      sEmail,
      '',
      sTitle,
      sMessage);
end if; 

end$$

DROP PROCEDURE IF EXISTS `login_check`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_check`(in p_user_id int, in p_username varchar(256), in p_session_id varchar(1024), in p_ip varchar(256), in p_token varchar(1024), out p_result varchar(256))
BEGIN
declare sUserName varchar(256);
declare bIsOk boolean default true;

DROP TABLE IF EXISTS temp_sessions;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_sessions (
  id INT NOT NULL,
  sessions_id varchar(1024) not null,
  ip varchar(256) not null,
  token varchar(1024) not null,
  user_id int not null,
  now_day date not null,
  now_time time not null,
  now_datetime datetime);

if exists(select * from tbluser where id = p_user_id) then
    set sUserName = (select username from tbluser where id = p_user_id);
else
    set p_result = 'user doesnt exist';
    set bIsOk = false;
end if;

if bIsOk = true then
    if exists(select * from tbl_sessions where user_id = p_user_id) then
        insert into temp_sessions (id, sessions_id, ip, token, user_id, now_day, now_time)
        select id, sessions_id, ip, token, user_id, now_day, now_time 
        from tbl_sessions 
        where user_id = p_user_id 
        and (now_day = curdate() or now_day = DATE_SUB( curdate(), INTERVAL 1 DAY ));
        
        delete from temp_sessions where now_day = DATE_SUB( curdate(), INTERVAL 1 DAY ) and now_time < curtime();
        
        if exists(select * from temp_sessions where sessions_id = p_session_id and ip = p_ip and token = p_token) then
            set p_result = 'OK';
            set bIsOk = true;
        else
            set p_result = 'no current session';
            set bIsOk = false;
        end if;
    end if;
end if;

delete from tbl_sessions where not (now_day = curdate() or now_day = DATE_SUB( curdate(), INTERVAL 1 DAY ));

end$$

DROP PROCEDURE IF EXISTS `login_findUserName`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_findUserName`(IN p_username VARCHAR(256), OUT p_result VARCHAR(256))
BEGIN

if exists(SELECT * FROM tbluser WHERE username = p_username) then
    set p_result = 'exists';
else
    if exists(SELECT * FROM tbluser WHERE trim(lower(username)) = trim(lower(p_username))) then
        set p_result = 'exists';
    else
        set p_result = 'not found';
    end if;
end if;

end$$

DROP PROCEDURE IF EXISTS `login_get_captcha`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_get_captcha`( out p_id int, out p_path varchar(256))
BEGIN
declare bIsFinished boolean default false;
declare iSeed int;
declare iTemp int default 0;
declare iMaxId int;

set p_id = -1;
set p_path = '';

set iSeed = 3600 * SECOND(curtime()) + 60 * minute(curtime()) + hour(curtime());
set iMaxId = (select max(id) from tbl_captcha);

while not bIsFinished do
    set iSeed = iSeed - iTemp + SECOND(curtime()) + minute(curtime()) + hour(curtime());
    set iTemp = (RAND(iSeed) * (iMaxId * 2 + 10));
    
    if exists(select * from tbl_captcha where id = iTemp) then
        set bIsFinished = true;
        set p_id = iTemp;
        set p_path = (select file from tbl_captcha where id = iTemp);
    end if;
end while;

end$$

DROP PROCEDURE IF EXISTS `login_get_salt`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_get_salt`(in p_username varchar(256), out p_salt varchar(1024))
BEGIN
declare sSalt varchar(1024);

if exists(SELECT * from tbluser where username = p_username) then
    set p_salt = (SELECT salt from tbluser where username = p_username);
else
    set p_salt = '';
end if;

end$$

DROP PROCEDURE IF EXISTS `login_logout`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_logout`(in p_session_id varchar(1024), in p_ip varchar(256), in p_token varchar(1024))
BEGIN

delete from tbl_sessions 
where sessions_id = p_session_id 
or ip = p_ip 
or token = p_token;

end$$

DROP PROCEDURE IF EXISTS `login_resetPwd`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_resetPwd`( in p_user_id int, in p_salt varchar(256), in p_pwd varchar(256), out p_message varchar(256))
BEGIN

set p_message = '';


if exists(select * from tbluser where id = p_user_id) then
    UPDATE tbluser 
    SET pwd = p_pwd, salt = p_salt
    WHERE id = p_user_id;
else
    set p_message = 'Cant find user';
end if;


end$$

DROP PROCEDURE IF EXISTS `login_stuff`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_stuff`(IN `p_username` VARCHAR(256), IN `p_password` VARCHAR(1024), IN `p_session_id` VARCHAR(256), IN `p_ip` VARCHAR(256), IN `p_captcha_id` INT, IN `p_captcha_code` VARCHAR(256), OUT `p_user_id` INT, OUT `p_token` VARCHAR(1024), OUT `p_result` VARCHAR(256))
BEGIN
declare sToken varchar(1024);
declare iUserId int;
declare iSeed int;
declare iAscii int;
declare iAscii_new int;
declare bLoggedIn boolean default false;
declare sPwd varchar(1024);
declare iCounter int default 0;
declare iCounter2 int default 1;
declare sCaptcha_code varchar(256);
declare bIsOk boolean default true;

set p_user_id = -1; 
set p_token = '';
set p_result = 'failed';

if bIsOk then
    if exists(select * from tbl_captcha where id = p_captcha_id) then
        set sCaptcha_code = (select code from tbl_captcha where id = p_captcha_id);
        if (trim(upper(p_captcha_code)) != trim(upper(sCaptcha_code))) then
            set p_result = 'failed captcha';
            set bIsOk = false;
        end if;
    end if;
end if;

if bIsOk then
    if exists(SELECT * from tbluser where username = p_username) then
        set iUserId = (SELECT id from tbluser where username = p_username);
    
        set sPwd = (SELECT pwd from tbluser where username = p_username);

        if sPwd = p_password then
            set bLoggedIn = true;
        else
            set p_result = 'wrong password';
            set bIsOk = false;
        end if;
    else
        set p_result = 'user does not exist';
        set bIsOk = false;
    end if;
end if;

if bIsOk then
    if bLoggedIn = true then
        set sToken = '';
        set iSeed = iUserId + SECOND(curtime()) + 60 * minute(curtime()) + 3600 * hour(curtime());
        set iAscii = RAND(iSeed)*26+65;

        while iCounter < 99 do
            set iCounter2 = iCounter;
            while iCounter = iCounter2 or (iAscii < 65 or iAscii > 90) do
                set iCounter2 = iCounter2 * iCounter2 - iCounter2 * 7 + 10;
                set iSeed = iAscii + iCounter2 + iCounter + (1000 * RAND(iCounter));
                set iAscii = RAND(iSeed)*28+64;
            end while;

            set sToken = CONCAT(sToken, CHAR(iAscii using utf8));
            set iCounter = iCounter + 1;
        end while;

        set p_result = 'OK';

        INSERT INTO tbl_sessions(sessions_id, ip, token, user_id, now_day, now_time) 
        VALUES (p_session_id,p_ip,sToken,iUserId,CURDATE(),curtime());

        set p_user_id = iUserId;
        set p_token = sToken;
    end if;
end if;

end$$

DROP PROCEDURE IF EXISTS `rules_allPieces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `rules_allPieces`(IN `p_game_type_id` INT, IN `p_language_id` INT)
BEGIN

CREATE TEMPORARY TABLE IF NOT EXISTS tempTblPieces (id int(11), name varchar(1024));

insert into tempTblPieces (id, name)
select p.id, t.text
from tblpiecetype as p
inner join tbltext as t
on t.id_text = p.name_txt_id
and t.id_html_element = p.language_element_id
where t.id_language = p_language_id;

CREATE TEMPORARY TABLE IF NOT EXISTS tempTblRules (id int(11), name varchar(1024), description varchar(1024));

insert into tempTblRules (id, name, description)
SELECT r.id, t1.text, t2.text
FROM tblrule_game as r
inner join tbltext as t1
on r.language_element_id = t1.id_html_element and r.name_txt_id = t1.id_text
inner join tbltext as t2

on r.language_element_id = t2.id_html_element and r.description_txt_id = t2.id_text
where t1.id_language = p_language_id
and t2.id_language = p_language_id;

SELECT p.name as piece_name, r.name as rule_short_desc, r.description as rule_long_desc
FROM tblcrossref_gametyperulepiece as cr
inner join tempTblPieces as p
on cr.piecetype_id = p.id
inner join tempTblRules r
on cr.rule_id = r.id

where cr.gametype_id = p_game_type_id
order by p.name;

drop TABLE IF EXISTS tempTblPieces;
drop TABLE IF EXISTS tempTblRules;

END$$

DROP PROCEDURE IF EXISTS `rules_game`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `rules_game`(IN p_game_type_id INT, IN p_language_id INT)
BEGIN

CREATE TEMPORARY TABLE IF NOT EXISTS tempTblRules (id int(11), name varchar(1024), description varchar(1024));

insert into tempTblRules (id, name, description)
SELECT r.id, t1.text, t2.text
FROM tblrule_game as r
inner join tbltext as t1
on r.language_element_id = t1.id_html_element and r.name_txt_id = t1.id_text
inner join tbltext as t2
on r.language_element_id = t2.id_html_element and r.description_txt_id = t2.id_text
where t1.id_language = p_language_id
and t2.id_language = p_language_id;

SELECT r.name as rule_short_desc, r.description as rule_long_desc
FROM tblcrossref_gametyperulegame cr
inner join tempTblRules as r
on r.id = cr.rule_id
where cr.gametype_id = p_game_type_id
order by r.name;

END$$

DROP PROCEDURE IF EXISTS `set_emailStatus_sent`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `set_emailStatus_sent`(in p_email_id int)
BEGIN
declare ciEmailStatus_sent int default 2;

update tbl_email
set status_id = ciEmailStatus_sent
where id = p_email_id;

end$$

DROP PROCEDURE IF EXISTS `set_user_notifications`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `set_user_notifications`(in p_user_id int, IN p_session_id varchar(256), IN p_token varchar(1024), IN p_ip varchar(256), IN p_regular_news INT, IN p_new_competition_in_house INT, IN p_competition_results INT, IN p_ads_posted INT, OUT p_result varchar(256))
BEGIN
declare bIsOk boolean default true;

DROP TABLE IF EXISTS temp_sessions;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_sessions (
  id INT NOT NULL,
  sessions_id varchar(1024) not null,
  ip varchar(256) not null,
  token varchar(1024) not null,
  user_id int not null,
  now_day date not null,
  now_time time not null,
  now_datetime datetime);

if not exists(select * from tbluser where id = p_user_id) then
    set p_result = 'user doesnt exist';
    set bIsOk = false;
end if;

if bIsOk = true then
    if exists(select * from tbl_sessions where user_id = p_user_id) then
        insert into temp_sessions (id, sessions_id, ip, token, user_id, now_day, now_time)
        select id, sessions_id, ip, token, user_id, now_day, now_time 
        from tbl_sessions 
        where user_id = p_user_id 
        and (now_day = curdate() or now_day = DATE_SUB( curdate(), INTERVAL 1 DAY ));
        
        delete from temp_sessions where now_day = DATE_SUB( curdate(), INTERVAL 1 DAY ) and now_time < curtime();
        
        if not exists(select * from temp_sessions where sessions_id = p_session_id and ip = p_ip and token = p_token) then
            set p_result = 'no current session';
            set bIsOk = false;
        end if;
    end if;
end if;

delete from tbl_sessions where not (now_day = curdate() or now_day = DATE_SUB( curdate(), INTERVAL 1 DAY ));

if bIsOk = true then
    update tbluser
    set notifications_regularNews = p_regular_news, 
        notifications_newCompetitionInHouse = p_new_competition_in_house, 
        notifications_competitionResults = p_competition_results, 
        notifications_adsPosted = p_ads_posted 
    WHERE id = p_user_id;
    set p_result = 'ok';
end if;

end$$

DROP PROCEDURE IF EXISTS `startGame`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `startGame`(IN `p_white_user_id` INT, IN `p_black_user_id` INT, IN `p_game_type_id` INT, OUT `p_gameid` INT, OUT `p_message` VARCHAR(1024))
BEGIN
     DECLARE ic_waiting_for_human INT DEFAULT 1;
     declare iGameType int;
     /*declare iStatusId int;*/

     /*set iStatusId = -1;*/
     set p_gameid = -1;
     set p_message = "";


/*
if exists(select id from tbl_lookup_gameStatus where description = 'current') then
         set iStatusId = (select id from tbl_lookup_gameStatus where description = 'current');
     else
          set p_message = "Can't find Status ID Value";
     end if;
*/

     if p_message = "" then
         insert into tbl_games (
             player_white_id,
             player_black_id,
             whos_turn_next_id,
             game_type,
             status_id,
             startedAt_date,
             startedAt_time,
             endedAt_date,
             endedAt_time,
             description)
         values (
             p_white_user_id,
             p_black_user_id,
             p_white_user_id,
             p_game_type_id,
             ic_waiting_for_human,
             CURDATE(),
             CURTIME(),
             null,
             null,
             '');

         set p_gameid = LAST_INSERT_ID();

         insert into tbl_game_current_positions (
             game_id,
             piece_id,
             colour_id,
             square_no,
             move_type, 
         piece_type_id)
         select p_gameid, piece_no, colour_id, squareNumber, 4, piece_type_id
         from tblpiecestartposition
         where gameType_id = p_game_type_id;

         if ROW_COUNT() = 0 then
              set p_message = "Game not added.";
         end if;
     end if;
END$$

DROP PROCEDURE IF EXISTS `underConstruction_check_isRead`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `underConstruction_check_isRead`(IN `p_session_id` VARCHAR(256), OUT `p_result` TINYINT(1))
BEGIN

if exists(select * from tbl_sessions where sessions_id = p_session_id and under_construction_read = true) then
    set p_result = true;
else
    set p_result = false;
end if;

end$$

DROP PROCEDURE IF EXISTS `underConstruction_set_isRead`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `underConstruction_set_isRead`(IN `p_session_id` VARCHAR(256))
BEGIN

update tbl_sessions
set under_construction_read = true
where sessions_id = p_session_id;

end$$

DROP PROCEDURE IF EXISTS `userDetails_update`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `userDetails_update`(in p_user_id int, in p_introduction varchar(1024), in p_status int, in p_language_id int, out p_message varchar(256))
BEGIN

set p_message = '';

if exists(select * from tbluser where username = p_username and id != p_user_id) then
    set p_message = 'User name already exists';
else
    UPDATE tbluser 
    set
    introduction = p_introduction, 
    status = p_status, 
    language_id = p_language_id
    WHERE id = p_user_id;
end if;

end$$

DROP PROCEDURE IF EXISTS `userDetails_view`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `userDetails_view`(IN p_user_id INT, in p_language_id int)
BEGIN

    drop table if exists temp_userStatus;
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_userStatus(id int, txt varchar(1024));

    insert into temp_userStatus (id, txt)
    SELECT u.id, t.text
    FROM tbl_lookup_userstatus as u
    inner join tblText as t
    on u.language_element_id = t.id_html_element
    and u.txt_id = t.id_text
    where t.id_language = p_language_id;

    SELECT u.isBot, u.introduction, u.createdAt, u.lastLoginAt, u.status as status_id, s.txt as status_description, u.language_id 
    FROM tbluser as u
    inner join temp_userStatus as s
    on s.id = u.status
    where u.id = p_user_id;

end$$

DROP PROCEDURE IF EXISTS `userId_view`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `userId_view`(IN p_user_id INT)
BEGIN

    SELECT u.isBot, u.username, u.email
    FROM tbluser as u
    where u.id = p_user_id;

end$$

DROP PROCEDURE IF EXISTS `userMakesMove`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `userMakesMove`(IN `p_GameId` INT, IN p_move_number int, IN `p_PieceMoved` INT, IN `p_UserId` INT, IN `p_OpponentId` INT, IN `p_DestinationSquare` INT, IN `p_is_taking_piece` BOOLEAN, IN `p_taken_piece_id` INT, OUT `p_message_out` VARCHAR(1024))
BEGIN
declare iProcessTypeId int;
declare ciProcessTypeId_humanVBot int default 2;
declare ciProcessTypeId_humanVHuman int default 1;
declare ciProcessStatus_unassigned int default 1;
declare iPieceColour int;
declare ciPieceColour_White int default 1;
declare ciPieceColour_Black int default 2;

/*
update list of all moves
update current board status
*/
set p_message_out = "";

drop table if exists tempTblGameDetails;
CREATE TEMPORARY TABLE IF NOT EXISTS tempTblGameDetails (

id int(11),
  last_move_id int(11), 
  player_white_id int(11),
  player_black_id int(11),
  whos_turn_next_id int(11),
  game_type int(11),
  status_id int(11));

insert into tempTblGameDetails (
  id,
  last_move_id, 
  player_white_id,
  player_black_id,
  whos_turn_next_id,
  game_type,
  status_id)
select
  id,
  last_move_id, 
  player_white_id,
  player_black_id,
  whos_turn_next_id,
  game_type,
  status_id
from tbl_games
where id = p_gameId;

if not exists(select * from tempTblGameDetails where whos_turn_next_id = p_UserId) then
   set p_message_out = "not your turn";
end if;

if not exists(select * from tempTblGameDetails where last_move_id = p_move_number - 1) then
   set p_message_out = "wrong move number";
end if;

if exists(select * from tempTblGameDetails where (player_white_id = p_UserId and player_black_id = p_OpponentId)) then
    set iPieceColour = ciPieceColour_White; 
elseif exists(select * from tempTblGameDetails where (player_white_id = p_OpponentId and player_black_id = p_UserId)) then
    set iPieceColour = ciPieceColour_Black; 
else
    set p_message_out = "wrong players";
end if;

if p_message_out = "" then
    insert into tbl_game_all_moves (
         game_id,
         piece_id,
         colour_id,
         square_no,
         move_type)
    values (
        p_GameId,
        p_PieceMoved,
        iPieceColour,
        p_DestinationSquare,
        1);

    update tbl_games
    set last_move_id = p_move_number,
        whos_turn_next_id = p_OpponentId
    where id = p_GameId;
    
    update tbl_game_current_positions
    set square_no = p_DestinationSquare
    where game_id = p_GameId
    and piece_id = p_PieceMoved;

    if p_is_taking_piece = true then
        insert into tbl_game_all_moves (
             game_id,
             piece_id,
             square_no,
             move_type)
        values (
            p_GameId,
            p_taken_piece_id,
            -1,
            2);

        update tbl_game_current_positions
        set square_no = -1,
            is_taken = true
        where game_id = p_GameId
        and piece_id = p_taken_piece_id;
    end if;

    if exists(select * from tbluser where id = p_OpponentId and isBot = true) then
	set iProcessTypeId = ciProcessTypeId_humanVBot;
    else
	set iProcessTypeId = ciProcessTypeId_humanVHuman;
    end if;
    
    delete from tblserverprocesses_main where game_id = p_GameId;
    INSERT INTO tblserverprocesses_main(server_id, process_type_id, game_id, status_id, start_time, count_of_possible_moves) 
    VALUES (-1, iProcessTypeId, p_GameId, ciProcessStatus_unassigned, NOW(),0);
end if;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `all_rule_types_in_english`
--

DROP TABLE IF EXISTS `all_rule_types_in_english`;
CREATE TABLE IF NOT EXISTS `all_rule_types_in_english` (
  `id` int(11) DEFAULT NULL,
  `short_desc` varchar(1024) DEFAULT NULL,
  `long_desc` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `error_log`
--

DROP TABLE IF EXISTS `error_log`;
CREATE TABLE IF NOT EXISTS `error_log` (
  `id` int(10) unsigned NOT NULL,
  `createdAt` datetime NOT NULL,
  `txt` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tblcrossref_competitionuser`
--

DROP TABLE IF EXISTS `tblcrossref_competitionuser`;
CREATE TABLE IF NOT EXISTS `tblcrossref_competitionuser` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `competition_id` int(11) NOT NULL,
  `participant_type_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tblcrossref_gametypepiecetype`
--

DROP TABLE IF EXISTS `tblcrossref_gametypepiecetype`;
CREATE TABLE IF NOT EXISTS `tblcrossref_gametypepiecetype` (
  `id` int(11) NOT NULL,
  `gametype_id` int(11) NOT NULL,
  `piecetype_id` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tblcrossref_gametypepiecetype`
--

INSERT INTO `tblcrossref_gametypepiecetype` (`id`, `gametype_id`, `piecetype_id`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 1, 2),
(4, 2, 2),
(5, 4, 1),
(6, 4, 2);

-- --------------------------------------------------------

--
-- Table structure for table `tblcrossref_gametyperulegame`
--

DROP TABLE IF EXISTS `tblcrossref_gametyperulegame`;
CREATE TABLE IF NOT EXISTS `tblcrossref_gametyperulegame` (
  `id` int(11) NOT NULL,
  `gametype_id` int(11) NOT NULL,
  `rule_id` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tblcrossref_gametyperulegame`
--

INSERT INTO `tblcrossref_gametyperulegame` (`id`, `gametype_id`, `rule_id`) VALUES
(1, 1, 8),
(2, 1, 9);

-- --------------------------------------------------------

--
-- Table structure for table `tblcrossref_gametyperulepiece`
--

DROP TABLE IF EXISTS `tblcrossref_gametyperulepiece`;
CREATE TABLE IF NOT EXISTS `tblcrossref_gametyperulepiece` (
  `id` int(11) NOT NULL,
  `gametype_id` int(11) NOT NULL,
  `piecetype_id` int(11) NOT NULL,
  `rule_id` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tblcrossref_gametyperulepiece`
--

INSERT INTO `tblcrossref_gametyperulepiece` (`id`, `gametype_id`, `piecetype_id`, `rule_id`) VALUES
(1, 1, 1, 1),
(2, 1, 1, 3),
(3, 1, 1, 7),
(4, 1, 2, 5),
(5, 1, 2, 7);

-- --------------------------------------------------------

--
-- Table structure for table `tblcrossref_userhouse`
--

DROP TABLE IF EXISTS `tblcrossref_userhouse`;
CREATE TABLE IF NOT EXISTS `tblcrossref_userhouse` (
  `id` int(11) NOT NULL,
  `houseid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `membership_type_id` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tblcrossref_userhouse`
--

INSERT INTO `tblcrossref_userhouse` (`id`, `houseid`, `userid`, `membership_type_id`) VALUES
(1, 1, 1, 1),
(2, 1, 2, 2),
(3, 1, 5, 2),
(4, 2, 1, 1),
(5, 4, 1, 2),
(6, 1, 6, 1),
(7, 1, 6, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tblcrossref_userplaysgametype`
--

DROP TABLE IF EXISTS `tblcrossref_userplaysgametype`;
CREATE TABLE IF NOT EXISTS `tblcrossref_userplaysgametype` (
  `id` int(11) NOT NULL,
  `gameTypeId` int(11) NOT NULL,
  `userId` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tblcrossref_userplaysgametype`
--

INSERT INTO `tblcrossref_userplaysgametype` (`id`, `gameTypeId`, `userId`) VALUES
(1, 1, 2),
(2, 2, 3),
(3, 4, 4);

-- --------------------------------------------------------

--
-- Table structure for table `tblgametype`
--

DROP TABLE IF EXISTS `tblgametype`;
CREATE TABLE IF NOT EXISTS `tblgametype` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `name_txt_id` int(11) NOT NULL,
  `board_width` int(11) NOT NULL,
  `board_height` int(11) NOT NULL,
  `board_type_id` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tblgametype`
--

INSERT INTO `tblgametype` (`id`, `language_element_id`, `name_txt_id`, `board_width`, `board_height`, `board_type_id`) VALUES
(1, 4, 1, 8, 8, 1),
(2, 4, 2, 10, 10, 1),
(3, 4, 3, 8, 8, 1),
(4, 4, 4, 12, 12, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tblhouse`
--

DROP TABLE IF EXISTS `tblhouse`;
CREATE TABLE IF NOT EXISTS `tblhouse` (
  `id` int(11) NOT NULL,
  `housename` varchar(256) NOT NULL,
  `description` varchar(1000) NOT NULL,
  `rules` varchar(1000) NOT NULL,
  `createdAt` datetime NOT NULL,
  `lastLoginAt` datetime NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tblhouse`
--

INSERT INTO `tblhouse` (`id`, `housename`, `description`, `rules`, `createdAt`, `lastLoginAt`, `status`) VALUES
(1, 'my house', 'wfsdfsdf', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1),
(2, 'new house', 'something', '', '2015-02-12 20:33:23', '0000-00-00 00:00:00', 1),
(3, 'aaa', 'the a', '', '2015-02-12 20:37:52', '0000-00-00 00:00:00', 1),
(4, 'bbb', 'this should work', '', '2015-02-12 20:40:21', '0000-00-00 00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tblpiecestartposition`
--

DROP TABLE IF EXISTS `tblpiecestartposition`;
CREATE TABLE IF NOT EXISTS `tblpiecestartposition` (
  `id` int(11) NOT NULL,
  `isWhite` tinyint(1) NOT NULL,
  `colour_id` int(11) NOT NULL,
  `piece_type_id` int(11) NOT NULL,
  `piece_no` int(11) NOT NULL,
  `gameType_id` int(11) NOT NULL,
  `squareNumber` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=85 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tblpiecestartposition`
--

INSERT INTO `tblpiecestartposition` (`id`, `isWhite`, `colour_id`, `piece_type_id`, `piece_no`, `gameType_id`, `squareNumber`) VALUES
(1, 1, 1, 1, 1, 1, 0),
(2, 1, 1, 1, 2, 1, 2),
(3, 1, 1, 1, 3, 1, 4),
(4, 1, 1, 1, 4, 1, 6),
(5, 1, 1, 1, 5, 1, 9),
(6, 1, 1, 1, 6, 1, 11),
(7, 1, 1, 1, 7, 1, 13),
(8, 1, 1, 1, 8, 1, 15),
(9, 1, 1, 1, 9, 1, 16),
(10, 1, 1, 1, 10, 1, 18),
(11, 1, 1, 1, 11, 1, 20),
(12, 1, 1, 1, 12, 1, 22),
(13, 0, 2, 1, 13, 1, 62),
(14, 0, 2, 1, 14, 1, 60),
(15, 0, 2, 1, 15, 1, 58),
(16, 0, 2, 1, 16, 1, 56),
(17, 0, 2, 1, 17, 1, 55),
(18, 0, 2, 1, 18, 1, 53),
(19, 0, 2, 1, 19, 1, 51),
(20, 0, 2, 1, 20, 1, 49),
(21, 0, 2, 1, 21, 1, 46),
(22, 0, 2, 1, 22, 1, 44),
(23, 0, 2, 1, 23, 1, 42),
(24, 0, 2, 1, 24, 1, 40),
(25, 1, 1, 1, 1, 4, 1),
(26, 1, 1, 1, 2, 4, 3),
(27, 1, 1, 1, 3, 4, 5),
(28, 1, 1, 1, 4, 4, 7),
(29, 1, 1, 1, 5, 4, 9),
(30, 1, 1, 1, 6, 4, 11),
(31, 1, 1, 1, 7, 4, 12),
(32, 1, 1, 1, 8, 4, 14),
(33, 1, 1, 1, 9, 4, 16),
(34, 1, 1, 1, 10, 4, 18),
(35, 1, 1, 1, 11, 4, 20),
(36, 1, 1, 1, 12, 4, 22),
(37, 1, 1, 1, 13, 4, 25),
(38, 1, 1, 1, 14, 4, 27),
(39, 1, 1, 1, 15, 4, 29),
(40, 1, 1, 1, 16, 4, 31),
(41, 1, 1, 1, 17, 4, 33),
(42, 1, 1, 1, 18, 4, 35),
(43, 1, 1, 1, 19, 4, 36),
(44, 1, 1, 1, 20, 4, 38),
(45, 1, 1, 1, 21, 4, 40),
(46, 1, 1, 1, 22, 4, 42),
(47, 1, 1, 1, 23, 4, 44),
(48, 1, 1, 1, 24, 4, 46),
(49, 1, 1, 1, 25, 4, 49),
(50, 1, 1, 1, 26, 4, 51),
(51, 1, 1, 1, 27, 4, 53),
(52, 1, 1, 1, 28, 4, 55),
(53, 1, 1, 1, 29, 4, 57),
(54, 1, 1, 1, 30, 4, 59),
(55, 0, 2, 1, 31, 4, 84),
(56, 0, 2, 1, 32, 4, 86),
(57, 0, 2, 1, 33, 4, 88),
(58, 0, 2, 1, 34, 4, 90),
(59, 0, 2, 1, 35, 4, 92),
(60, 0, 2, 1, 36, 4, 94),
(61, 0, 2, 1, 37, 4, 97),
(62, 0, 2, 1, 38, 4, 99),
(63, 0, 2, 1, 39, 4, 101),
(64, 0, 2, 1, 40, 4, 103),
(65, 0, 2, 1, 41, 4, 105),
(66, 0, 2, 1, 42, 4, 107),
(67, 0, 2, 1, 43, 4, 108),
(68, 0, 2, 1, 44, 4, 110),
(69, 0, 2, 1, 45, 4, 112),
(70, 0, 2, 1, 46, 4, 114),
(71, 0, 2, 1, 47, 4, 116),
(72, 0, 2, 1, 48, 4, 118),
(73, 0, 2, 1, 49, 4, 121),
(74, 0, 2, 1, 50, 4, 123),
(75, 0, 2, 1, 51, 4, 125),
(76, 0, 2, 1, 52, 4, 127),
(77, 0, 2, 1, 53, 4, 129),
(78, 0, 2, 1, 54, 4, 131),
(79, 0, 2, 1, 55, 4, 132),
(80, 0, 2, 1, 56, 4, 134),
(81, 0, 2, 1, 57, 4, 136),
(82, 0, 2, 1, 58, 4, 138),
(83, 0, 2, 1, 59, 4, 140),
(84, 0, 2, 1, 60, 4, 142);

-- --------------------------------------------------------

--
-- Table structure for table `tblpiecetype`
--

DROP TABLE IF EXISTS `tblpiecetype`;
CREATE TABLE IF NOT EXISTS `tblpiecetype` (
  `id` int(11) NOT NULL,
  `piece_type_id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `name_txt_id` int(11) NOT NULL,
  `white_file_name` varchar(256) NOT NULL,
  `black_file_name` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tblpiecetype`
--

INSERT INTO `tblpiecetype` (`id`, `piece_type_id`, `language_element_id`, `name_txt_id`, `white_file_name`, `black_file_name`) VALUES
(1, 1, 5, 1, '/pics/Single White50x43.png', '/pics/Single Black50x43.png'),
(2, 2, 5, 2, '/pics/Double White50x43.png', '/pics/Double Black50x43.png');

-- --------------------------------------------------------

--
-- Table structure for table `tblrule_game`
--

DROP TABLE IF EXISTS `tblrule_game`;
CREATE TABLE IF NOT EXISTS `tblrule_game` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `name_txt_id` int(11) NOT NULL,
  `description_txt_id` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tblrule_game`
--

INSERT INTO `tblrule_game` (`id`, `language_element_id`, `name_txt_id`, `description_txt_id`) VALUES
(1, 6, 1, 2),
(2, 6, 3, 4),
(3, 6, 5, 6),
(4, 6, 7, 8),
(5, 6, 9, 10),
(6, 6, 11, 12),
(7, 6, 13, 14),
(8, 6, 15, 16),
(9, 6, 17, 18),
(10, 6, 19, 20),
(11, 6, 21, 22),
(12, 6, 23, 24);

-- --------------------------------------------------------

--
-- Table structure for table `tblserverprocesses_main`
--

DROP TABLE IF EXISTS `tblserverprocesses_main`;
CREATE TABLE IF NOT EXISTS `tblserverprocesses_main` (
  `id` int(11) NOT NULL,
  `server_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `process_type_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL,
  `start_time` datetime NOT NULL,
  `count_of_possible_moves` int(11) DEFAULT NULL
) ENGINE=MyISAM AUTO_INCREMENT=86 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tblserverprocesses_main`
--

INSERT INTO `tblserverprocesses_main` (`id`, `server_id`, `game_id`, `process_type_id`, `status_id`, `start_time`, `count_of_possible_moves`) VALUES
(1, -1, 119, 2, 2, '2015-02-03 15:14:22', 0),
(2, -1, 119, 2, 2, '2015-02-03 17:47:46', 0),
(3, -1, 119, 2, 2, '2015-02-03 17:51:08', 0),
(4, -1, 119, 2, 2, '2015-02-03 17:55:34', 0),
(5, -1, 119, 2, 2, '2015-02-03 17:57:31', 0),
(6, -1, 119, 2, 2, '2015-02-03 17:58:45', 0),
(7, -1, 119, 2, 2, '2015-02-03 18:02:34', 0),
(8, -1, 119, 2, 2, '2015-02-03 18:12:09', 0),
(9, -1, 119, 2, 2, '2015-02-03 18:12:10', 0),
(10, 1, 119, 2, 2, '2015-02-03 18:29:17', 0),
(11, 1, 119, 2, 2, '2015-02-03 18:32:10', 0),
(12, 1, 119, 2, 2, '2015-02-03 18:33:37', 0),
(13, 1, 119, 2, 2, '2015-02-03 19:04:38', 0),
(14, 1, 119, 2, 2, '2015-02-03 19:12:59', 0),
(15, 1, 119, 2, 2, '2015-02-03 19:18:17', 0),
(16, 1, 120, 2, 2, '2015-02-03 19:53:56', 0),
(17, 1, 120, 2, 2, '2015-02-03 20:02:13', 0),
(18, 1, 120, 2, 2, '2015-02-03 20:11:53', 0),
(69, 1, 122, 2, 2, '2015-02-05 10:27:09', 0),
(68, 1, 121, 2, 2, '2015-02-04 17:32:18', 0),
(70, 1, 123, 2, 2, '2015-02-10 16:05:22', 0),
(71, 1, 124, 2, 2, '2015-02-10 18:16:52', 0),
(72, 1, 130, 2, 2, '2015-02-12 16:50:48', 0),
(73, 1, 131, 2, 2, '2015-02-12 16:51:25', 0),
(74, 1, 132, 2, 2, '2015-02-12 20:30:55', 0),
(75, 1, 137, 2, 2, '2015-02-28 18:13:20', 0),
(76, 1, 125, 2, 2, '2015-03-01 13:35:11', 0),
(85, 1, 140, 1, 2, '2015-03-30 19:58:55', 0),
(80, 1, 143, 1, 2, '2015-03-30 17:15:15', 0),
(79, 1, 145, 2, 2, '2015-03-30 17:06:48', 0),
(82, 1, 141, 1, 2, '2015-03-30 19:14:48', 0),
(83, 1, 146, 2, 2, '2015-03-30 19:14:57', 0),
(84, 1, 147, 2, 2, '2015-03-30 19:18:42', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tblserverprocesses_possiblemoves`
--

DROP TABLE IF EXISTS `tblserverprocesses_possiblemoves`;
CREATE TABLE IF NOT EXISTS `tblserverprocesses_possiblemoves` (
  `id` int(11) NOT NULL,
  `process_id` int(11) NOT NULL,
  `multi_move` tinyint(1) NOT NULL,
  `square_no` int(11) NOT NULL,
  `piece_id` int(11) NOT NULL,
  `move_order` int(11) NOT NULL,
  `is_compulsary` tinyint(1) NOT NULL,
  `is_next_move` tinyint(1) NOT NULL,
  `player_id` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=81 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tblserverprocesses_possiblemoves`
--

INSERT INTO `tblserverprocesses_possiblemoves` (`id`, `process_id`, `multi_move`, `square_no`, `piece_id`, `move_order`, `is_compulsary`, `is_next_move`, `player_id`) VALUES
(1, 67, 0, 37, 5, 0, 0, 1, 1),
(2, 67, 0, 22, 7, 0, 0, 1, 1),
(3, 67, 0, 68, 8, 0, 0, 1, 1),
(4, 67, 0, 58, 9, 0, 0, 1, 1),
(5, 67, 0, 22, 10, 0, 0, 1, 1),
(6, 67, 0, 29, 11, 0, 0, 1, 1),
(7, 67, 0, 31, 12, 0, 0, 1, 1),
(8, 68, 0, 37, 5, 0, 0, 1, 1),
(9, 68, 0, 22, 7, 0, 0, 1, 1),
(10, 68, 0, 68, 8, 0, 0, 1, 1),
(11, 68, 0, 50, 9, 0, 0, 1, 1),
(12, 68, 0, 22, 10, 0, 0, 1, 1),
(13, 68, 0, 29, 11, 0, 0, 1, 1),
(14, 68, 0, 31, 12, 0, 0, 1, 1),
(15, 70, 0, 42, 19, 0, 0, 1, 2),
(16, 70, 0, 37, 21, 0, 0, 1, 2),
(17, 70, 0, 35, 22, 0, 0, 1, 2),
(18, 70, 0, 24, 23, 0, 0, 1, 2),
(19, 74, 0, 44, 18, 0, 0, 1, 2),
(20, 73, 0, 37, 21, 0, 0, 1, 2),
(21, 76, 0, 42, 19, 0, 0, 1, 2),
(22, 73, 0, 35, 22, 0, 0, 1, 2),
(23, 73, 0, 33, 23, 0, 0, 1, 2),
(24, 74, 0, 37, 21, 0, 0, 1, 2),
(25, 76, 0, 37, 21, 0, 0, 1, 2),
(26, 76, 0, 35, 22, 0, 0, 1, 2),
(27, 77, 0, 44, 18, 0, 0, 1, 5),
(28, 74, 0, 26, 22, 0, 0, 1, 2),
(29, 77, 0, 37, 21, 0, 0, 1, 5),
(30, 74, 0, 33, 23, 0, 0, 1, 2),
(31, 77, 0, 26, 22, 0, 0, 1, 5),
(32, 77, 0, 33, 23, 0, 0, 1, 5),
(33, 76, 0, 24, 23, 0, 0, 1, 2),
(34, 72, 0, 37, 21, 0, 0, 1, 2),
(35, 72, 0, 35, 22, 0, 0, 1, 2),
(36, 72, 0, 33, 23, 0, 0, 1, 2),
(37, 71, 0, 26, 14, 0, 0, 1, 2),
(38, 71, 0, 37, 21, 0, 0, 1, 2),
(39, 71, 0, 33, 23, 0, 0, 1, 2),
(40, 82, 0, 46, 17, 0, 0, 1, 1),
(41, 83, 0, 46, 17, 0, 0, 1, 2),
(42, 80, 0, 18, 5, 0, 0, 1, 1),
(43, 84, 0, 46, 17, 0, 0, 1, 2),
(44, 85, 0, 46, 17, 0, 0, 1, 5),
(45, 79, 0, 46, 17, 0, 0, 1, 2),
(46, 80, 0, 20, 6, 0, 0, 1, 1),
(47, 83, 0, 44, 18, 0, 0, 1, 2),
(48, 85, 0, 44, 18, 0, 0, 1, 5),
(49, 84, 0, 44, 18, 0, 0, 1, 2),
(50, 82, 0, 44, 18, 0, 0, 1, 1),
(51, 79, 0, 44, 18, 0, 0, 1, 2),
(52, 80, 0, 22, 7, 0, 0, 1, 1),
(53, 83, 0, 42, 19, 0, 0, 1, 2),
(54, 82, 0, 42, 19, 0, 0, 1, 1),
(55, 84, 0, 42, 19, 0, 0, 1, 2),
(56, 85, 0, 42, 19, 0, 0, 1, 5),
(57, 79, 0, 42, 19, 0, 0, 1, 2),
(58, 80, 0, 35, 9, 0, 0, 1, 1),
(59, 84, 0, 40, 20, 0, 0, 1, 2),
(60, 85, 0, 40, 20, 0, 0, 1, 5),
(61, 82, 0, 40, 20, 0, 0, 1, 1),
(62, 83, 0, 40, 20, 0, 0, 1, 2),
(63, 79, 0, 40, 20, 0, 0, 1, 2),
(64, 80, 0, 27, 10, 0, 0, 1, 1),
(65, 84, 0, 37, 21, 0, 0, 1, 2),
(66, 85, 0, 37, 21, 0, 0, 1, 5),
(67, 82, 0, 37, 21, 0, 0, 1, 1),
(68, 83, 0, 37, 21, 0, 0, 1, 2),
(69, 79, 0, 37, 21, 0, 0, 1, 2),
(70, 84, 0, 35, 22, 0, 0, 1, 2),
(71, 80, 0, 29, 11, 0, 0, 1, 1),
(72, 82, 0, 35, 22, 0, 0, 1, 1),
(73, 83, 0, 35, 22, 0, 0, 1, 2),
(74, 79, 0, 35, 22, 0, 0, 1, 2),
(75, 84, 0, 33, 23, 0, 0, 1, 2),
(76, 85, 0, 26, 22, 0, 0, 1, 5),
(77, 82, 0, 24, 23, 0, 0, 1, 1),
(78, 79, 0, 24, 23, 0, 0, 1, 2),
(79, 83, 0, 24, 23, 0, 0, 1, 2),
(80, 80, 0, 31, 12, 0, 0, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbltext`
--

DROP TABLE IF EXISTS `tbltext`;
CREATE TABLE IF NOT EXISTS `tbltext` (
  `id` int(11) NOT NULL,
  `id_language` int(11) NOT NULL,
  `id_html_element` int(11) NOT NULL,
  `id_text` int(11) NOT NULL,
  `text` varchar(1024) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=281 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbltext`
--

INSERT INTO `tbltext` (`id`, `id_language`, `id_html_element`, `id_text`, `text`) VALUES
(1, 1, 1, 1, 'News'),
(2, 2, 1, 1, 'Nachrichten'),
(3, 1, 1, 2, 'New Game'),
(4, 1, 1, 3, 'Play'),
(5, 1, 1, 4, 'Spectator'),
(6, 1, 1, 5, 'Settings'),
(7, 1, 1, 6, 'Log out'),
(8, 2, 1, 2, 'neues Spiel'),
(9, 2, 1, 3, 'spielen'),
(10, 2, 1, 4, 'Zuschauer'),
(11, 2, 1, 5, 'Einstellungen'),
(12, 2, 1, 6, 'ausloggen'),
(13, 1, 3, 1, 'Select Bot'),
(14, 1, 3, 2, 'Send Ad'),
(15, 1, 3, 3, 'Browse Ads'),
(16, 1, 3, 4, 'Send Request'),
(17, 1, 3, 5, 'Request Recieved'),
(18, 2, 3, 1, 'Waehlen Bot'),
(19, 2, 3, 2, 'Stuur'),
(20, 2, 3, 3, 'Durchsuchen Anzeigen'),
(21, 2, 3, 4, 'Anfrage senden'),
(22, 2, 3, 5, 'Anfrage erhielt'),
(23, 1, 4, 1, 'Draughts (British)'),
(24, 2, 4, 1, 'Dame (Britisch)'),
(25, 1, 4, 2, 'Draughts (International)'),
(26, 2, 4, 2, 'Dame (International)'),
(27, 1, 4, 3, 'Chess'),
(28, 2, 4, 3, 'Schach'),
(29, 1, 5, 1, 'Man'),
(30, 2, 5, 1, 'Mann'),
(31, 1, 5, 2, 'King'),
(32, 2, 5, 2, 'Koenig'),
(33, 1, 4, 4, 'Canadian draughts'),
(34, 2, 4, 4, 'Kanadische Dame'),
(35, 1, 6, 1, 'Move one space diagonally forward'),
(36, 2, 6, 1, 'Bewegen Sie ein Feld diagonal nach vorne'),
(37, 1, 6, 2, 'Piece can only move one space diagonally forward when not taking another piece.'),
(38, 2, 6, 2, 'Stueck kann nur einen Raum zu bewegen diagonal nach vorne, wenn nicht an ein anderes Stueck.'),
(39, 1, 6, 3, 'End of board Convert to King (takes no move)'),
(40, 2, 6, 3, 'Ende Bord Convert to King (nimmt keine Anstalten)'),
(41, 1, 6, 4, 'When the piece reaches the end of the board, the piece is converted to a king.  Doesn''t take a move.'),
(42, 2, 6, 4, 'Wenn das Stück das Ende der Platte erreicht, wird das Stück zu einem König umgewandelt. Braucht nicht eine Bewegung.'),
(43, 1, 6, 5, 'End of board Convert to King (takes one move)'),
(44, 2, 6, 5, 'Ende Bord Convert to King (nimmt einen Zug)'),
(45, 1, 6, 6, 'When the piece reaches the end of the board, the piece is converted to a king.  One move is used to convert piece.'),
(46, 2, 6, 6, 'Wenn das Stück das Ende der Platte erreicht, wird das Stueck zu einem Koenig umgewandelt. Eine Bewegung wird verwendet, um Stueck zu konvertieren.'),
(47, 1, 6, 7, 'Move diaginally forward any number'),
(48, 2, 6, 7, 'Bewegen diaginally weiterleiten beliebige Anzahl'),
(49, 1, 6, 8, 'Move diagonally forward any number of spaces.'),
(50, 2, 6, 8, 'Bewegen diagonal nach vorne beliebige Anzahl von Feldern.'),
(51, 1, 6, 9, 'Move diaginally any direction any number'),
(52, 2, 6, 9, 'Bewegen diaginally jede Richtung eine beliebige Anzahl'),
(53, 1, 6, 10, 'Move diagonally in any direction any number of spaces.'),
(54, 2, 6, 10, 'Diagonal bewegen sich in jede Richtung beliebig viele Raeume.'),
(55, 1, 6, 13, 'Take any piece by jumping over it'),
(56, 2, 6, 13, 'Nehmen Sie jedes Stueck durch einen Sprung ueber sie.'),
(57, 1, 6, 14, 'Take any piece by jumping over it.'),
(58, 2, 6, 14, 'Nehmen Sie jedes Stueck durch einen Sprung ueber sie.'),
(59, 1, 6, 15, 'Must take opponents piece'),
(60, 2, 6, 15, 'Muss Gegner Stueck nehmen'),
(61, 1, 6, 16, 'If one has the possibility to capture a piece then this must be done even if it is disadvantageous.'),
(62, 2, 6, 16, 'Hat man die Moeglichkeit, ein Stueck muss dies geschehen, selbst wenn es von Nachteil ist, werden zu erfassen.'),
(63, 1, 6, 17, 'Can''t move means you loose'),
(64, 2, 6, 17, 'Kann sich nicht bewegen bedeutet, dass Sie locker'),
(65, 1, 6, 18, 'A player with no valid move remaining loses'),
(66, 2, 6, 18, 'Ein Spieler, der keinen gueltigen Zug uebrigen verliert'),
(67, 1, 6, 19, 'Piece cannot jump over other piece'),
(68, 2, 6, 19, 'Stueck nicht ueber andere Stueck springen'),
(69, 1, 6, 20, 'Piece cannot jump over other piece'),
(70, 2, 6, 20, 'Stueck nicht ueber andere Stueck springen.'),
(71, 1, 6, 21, 'Piece can jump over other piece'),
(72, 2, 6, 21, 'Stueck kann ueber andere Stueck springen'),
(73, 1, 6, 22, 'Piece can jump over other piece'),
(74, 2, 6, 22, 'Stueck kann ueber andere Stueck springen.'),
(75, 1, 6, 23, 'Piece can move one space diagonally in any direction.'),
(76, 2, 6, 23, 'Stueck koennen ein Feld diagonal in jede Richtung bewegen.'),
(77, 1, 6, 24, 'Piece can move one space diagonally in any direction.'),
(78, 2, 6, 24, 'Stueck koennen ein Feld diagonal in jede Richtung bewegen.'),
(79, 1, 7, 1, '[Select all]'),
(80, 2, 7, 1, '[Alle waehlen]'),
(81, 1, 7, 2, 'Houses'),
(82, 2, 7, 2, 'Haeuser'),
(83, 1, 8, 1, 'Details'),
(84, 2, 8, 1, 'Einzelheiten'),
(85, 1, 8, 2, 'Houses'),
(86, 2, 8, 2, 'Haeuser'),
(89, 1, 9, 1, 'single square board'),
(90, 2, 9, 1, 'Einzel quadratischen Brett'),
(91, 1, 9, 2, 'single square board with square gap in middle'),
(92, 2, 9, 2, 'Einzel quadratischen Brett mit Platz Luecke in Mitte'),
(93, 1, 9, 3, 'double square board'),
(94, 2, 9, 3, 'Doppel quadratischen Brett'),
(95, 1, 9, 4, 'spherical'),
(96, 2, 9, 4, 'sphaerisch'),
(97, 1, 10, 1, 'requested'),
(98, 2, 10, 1, 'angefordert'),
(99, 1, 10, 2, 'rejected'),
(100, 2, 10, 2, 'abgelehnt'),
(101, 1, 10, 3, 'accepted'),
(102, 2, 10, 3, 'akzeptiert'),
(103, 1, 11, 1, 'waiting for human'),
(104, 2, 11, 1, 'Warten auf die menschliche'),
(105, 1, 11, 2, 'over'),
(106, 2, 11, 2, 'zu ende'),
(107, 1, 11, 3, 'waiting for computer'),
(108, 2, 11, 3, 'Warten auf Computer'),
(109, 1, 11, 4, 'processing'),
(110, 2, 11, 4, 'wird bearbeitet'),
(111, 1, 12, 1, 'chess'),
(112, 2, 12, 1, 'Schach'),
(113, 1, 12, 2, 'draughts'),
(114, 2, 12, 2, 'Dame'),
(115, 1, 13, 1, 'active'),
(116, 2, 13, 1, 'aktiv'),
(117, 1, 13, 2, 'deactive'),
(118, 2, 13, 2, 'deaktiv'),
(119, 1, 14, 1, 'Owner'),
(120, 2, 14, 1, 'Eigentuemer'),
(121, 1, 14, 2, 'Standard'),
(122, 2, 14, 2, 'Standard'),
(123, 1, 14, 3, 'Temporary Guest'),
(124, 2, 14, 3, 'Voruebergehend Gast'),
(125, 1, 15, 1, 'no piece type change'),
(126, 2, 15, 1, 'kein Stueck Typaenderung'),
(127, 1, 15, 2, 'taking'),
(128, 2, 15, 2, 'Einnahme'),
(129, 1, 15, 3, 'change piece type'),
(130, 2, 15, 3, 'Aenderung Stueck Typ'),
(131, 1, 15, 4, 'start position'),
(132, 2, 15, 4, 'Startposition'),
(133, 1, 16, 1, 'white'),
(134, 2, 16, 1, 'weiss'),
(135, 1, 16, 2, 'black'),
(136, 2, 16, 2, 'schwarz'),
(137, 1, 17, 1, 'Active'),
(138, 2, 17, 1, 'aktiv'),
(139, 1, 17, 2, 'Disabled'),
(140, 2, 17, 2, 'behindert'),
(141, 1, 17, 3, 'Blocked'),
(142, 2, 17, 3, 'verstopft'),
(143, 1, 18, 1, 'Edit'),
(144, 2, 18, 1, 'Bearbeiten'),
(145, 1, 18, 2, 'View'),
(146, 2, 18, 2, 'Ansicht'),
(147, 1, 18, 3, 'Members'),
(148, 2, 18, 3, 'Mitglieder'),
(149, 1, 18, 4, 'Create'),
(150, 2, 18, 4, 'Schaffen'),
(151, 1, 19, 1, 'Create'),
(152, 2, 19, 1, 'Schaffen'),
(153, 1, 19, 2, 'Edit'),
(154, 2, 19, 2, 'Bearbeiten'),
(155, 1, 19, 3, 'Close'),
(156, 2, 19, 3, 'Zu Schliessen'),
(157, 1, 18, 5, 'Close'),
(158, 2, 18, 5, 'Zu Schliessen'),
(159, 1, 18, 6, 'Name'),
(160, 2, 18, 6, 'Name'),
(161, 1, 18, 7, 'Created At'),
(162, 2, 18, 7, 'Erstellt am'),
(163, 1, 18, 8, 'Membership type'),
(164, 2, 18, 8, 'Mitgliedertyp'),
(165, 1, 20, 1, 'Name'),
(166, 2, 20, 1, 'Name'),
(167, 1, 20, 2, 'Email'),
(168, 2, 20, 2, 'E-Mail'),
(169, 1, 20, 3, 'Introduction'),
(170, 2, 20, 3, 'Einfuehrung'),
(171, 1, 20, 4, 'Created At'),
(172, 2, 20, 4, 'Erstellt am'),
(173, 1, 20, 5, 'Last Log in'),
(174, 2, 20, 5, 'Letztes Einloggen'),
(175, 1, 20, 6, 'Status'),
(176, 2, 20, 6, 'Status'),
(177, 1, 20, 7, 'Preferred Language'),
(178, 2, 20, 7, 'bevorzugte Sprache'),
(179, 1, 20, 8, 'Save Changes'),
(180, 2, 20, 8, 'Aenderungen Speichern'),
(181, 1, 21, 1, 'Super User'),
(182, 2, 21, 1, 'Super-User'),
(183, 1, 21, 2, 'language expert'),
(184, 2, 21, 2, 'Sprachexperten'),
(185, 1, 8, 3, 'Identity'),
(186, 2, 8, 3, 'Identitaet'),
(187, 1, 20, 9, 'Change Password'),
(188, 2, 20, 9, 'Kennwort Aendern'),
(189, 1, 18, 9, 'Competitions'),
(190, 2, 18, 9, 'Wettbewerbe'),
(191, 1, 7, 3, 'Game Type'),
(192, 2, 7, 3, 'Spieltyp'),
(193, 1, 7, 4, '[Random Game]'),
(194, 2, 7, 4, '[Zufallsspiel]'),
(195, 1, 10, 1, 'Requested'),
(196, 2, 10, 1, 'Angeforderte'),
(197, 1, 10, 1, 'Rejected'),
(198, 2, 10, 1, 'Abgelehnt'),
(199, 1, 10, 1, 'Accepted'),
(200, 2, 10, 1, 'Akzeptiert'),
(201, 1, 22, 1, 'My news'),
(202, 2, 22, 1, 'Meine Nachrichten'),
(203, 1, 22, 2, 'All news'),
(204, 2, 22, 2, 'Alle News'),
(205, 1, 22, 3, 'News in housee...'),
(206, 2, 22, 3, 'Nachrichten in Haus...'),
(207, 1, 22, 4, '[All houses]'),
(208, 2, 22, 4, '[Alle Wohnungen]'),
(209, 1, 22, 5, 'Game Started'),
(210, 2, 22, 5, 'Spiel gestartet'),
(211, 1, 22, 6, 'Game Requested'),
(212, 2, 22, 6, 'Spiel Fragt'),
(213, 1, 22, 7, 'Game won'),
(214, 2, 22, 7, 'Spiel gewonnen'),
(215, 1, 22, 8, 'Game lost'),
(216, 2, 22, 8, 'Spiel verloren'),
(217, 1, 22, 9, 'Game Drawn'),
(218, 2, 22, 9, 'Spiel unentschieden'),
(219, 1, 22, 10, ' requests game with '),
(220, 2, 22, 10, ' fordert Spiel mit '),
(221, 1, 23, 1, 'Knock out'),
(222, 2, 23, 1, 'Schlagen'),
(223, 1, 23, 2, 'League'),
(224, 2, 23, 2, 'Liga'),
(240, 2, 25, 1, 'Person gegen Person'),
(239, 1, 25, 1, 'Person versus person'),
(229, 1, 24, 1, 'Daily'),
(230, 2, 24, 1, 'Taeglich'),
(231, 1, 24, 2, 'Weekly'),
(232, 2, 24, 2, 'Woechentlich'),
(233, 1, 24, 3, 'Monthly'),
(234, 2, 24, 3, 'Monatlich'),
(235, 1, 24, 4, 'Annual'),
(236, 2, 24, 4, 'Jaehrlich'),
(237, 1, 24, 5, 'Not repeating'),
(238, 2, 24, 5, 'Nicht wiederholen'),
(241, 1, 25, 2, 'Team versus team'),
(242, 2, 25, 2, 'Team gegen Team'),
(243, 1, 26, 1, 'All house'),
(244, 2, 26, 1, 'Alle Haus'),
(245, 1, 26, 2, 'Opt in'),
(246, 2, 26, 2, 'Beitreten'),
(247, 1, 8, 4, 'Competition templates'),
(248, 2, 8, 4, 'Wettbewerb Vorlagen'),
(249, 1, 28, 1, 'Competitor'),
(250, 2, 28, 1, 'Wettbewerber'),
(251, 1, 28, 2, 'Organiser'),
(252, 2, 28, 2, 'Veranstalter'),
(253, 1, 1, 7, 'New User'),
(254, 2, 1, 7, 'Neuen Benutzer'),
(255, 1, 1, 8, 'Log In'),
(256, 2, 1, 8, 'Einloggen'),
(257, 1, 29, 1, '<p>Dear %1%</p>'),
(258, 2, 29, 1, '<p>Liebe %1%</p>'),
(259, 1, 29, 2, '<p>To resent your password please click on <a href=''%2%/resetPassword.php?x=%3%''>this link</a>.</p>'),
(260, 2, 29, 2, '<p>Um Ihr Passwort zurückzusetzen, klicken Sie bitte auf <a href=''%2%/resetPassword.php?x=%3%''>diesen Link.</a></p>'),
(261, 1, 29, 3, '<p>Regards</p>'),
(262, 2, 29, 3, '<p>Grüße</p>'),
(263, 1, 30, 1, 'Reset Password'),
(264, 2, 30, 1, 'Kennwort zuruecksetzen'),
(265, 1, 1, 9, 'Forgot password'),
(266, 2, 1, 9, 'Passwort vergessen'),
(267, 1, 1, 10, 'Competitions'),
(268, 2, 1, 10, 'Wettbewerbe'),
(269, 1, 31, 1, '<p>Dear %1%</p>'),
(270, 2, 31, 1, '<p>Liebe %1%</p>'),
(271, 1, 31, 2, '<p>This is just a reminder to you because you have changed your user name from %2% to %3%.</p>'),
(272, 2, 31, 2, '<p>Dies ist nur eine Erinnerung für Sie, weil Sie Ihren Benutzernamen aus %2% bis %3% verändert haben.</p>'),
(273, 1, 31, 3, '<p>Regards</p>'),
(274, 2, 31, 3, '<p>Grüße</p>'),
(275, 1, 32, 1, 'Reminder: Changed User name'),
(276, 2, 32, 1, 'Zur Erinnerung: Geaenderte Benutzername'),
(277, 1, 20, 10, 'Change Email Address'),
(278, 2, 20, 10, 'E-Mail Adresse Aendern'),
(279, 1, 8, 5, 'Notifications'),
(280, 2, 8, 5, 'Benachrichtigungen');

-- --------------------------------------------------------

--
-- Table structure for table `tbluser`
--

DROP TABLE IF EXISTS `tbluser`;
CREATE TABLE IF NOT EXISTS `tbluser` (
  `id` int(11) NOT NULL,
  `isBot` tinyint(1) DEFAULT '0',
  `username` varchar(256) NOT NULL,
  `pwd` varchar(256) NOT NULL,
  `salt` varchar(1024) NOT NULL,
  `count_failed_logins` int(11) NOT NULL DEFAULT '0',
  `introduction` varchar(1024) NOT NULL,
  `email` varchar(256) NOT NULL,
  `createdAt` datetime NOT NULL,
  `lastLoginAt` datetime NOT NULL,
  `status` int(11) NOT NULL,
  `language_id` int(11) NOT NULL DEFAULT '1',
  `notifications_regularNews` tinyint(1) NOT NULL DEFAULT '1',
  `notifications_newCompetitionInHouse` tinyint(1) NOT NULL DEFAULT '1',
  `notifications_competitionResults` tinyint(1) NOT NULL DEFAULT '1',
  `notifications_adsPosted` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=MyISAM AUTO_INCREMENT=1989 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbluser`
--

INSERT INTO `tbluser` (`id`, `isBot`, `username`, `pwd`, `salt`, `count_failed_logins`, `introduction`, `email`, `createdAt`, `lastLoginAt`, `status`, `language_id`, `notifications_regularNews`, `notifications_newCompetitionInHouse`, `notifications_competitionResults`, `notifications_adsPosted`) VALUES
(1, 0, 'matthew', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, 'stuff', 'matthew.baynham@gmail.com', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(2, 1, 'fred', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '2014-12-17 20:29:31', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(3, 1, 'bob', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '2014-12-17 20:31:41', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(4, 1, 'Maria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(5, 0, 'Martina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 2, 1, 1, 1, 1),
(6, 0, 'john', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, 'stuff', 'matthew.baynham@gmail.com', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(7, 1, 'Aaliyah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(8, 1, 'Aarushi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(9, 1, 'Abagail', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(10, 1, 'Abbey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(11, 1, 'Abbi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(12, 1, 'Abbie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(13, 1, 'Abby', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(14, 1, 'Abi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(15, 1, 'Abia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(16, 1, 'Abigail', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(17, 1, 'Abrianna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(18, 1, 'Abrielle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(19, 1, 'Aby', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(20, 1, 'Acacia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(21, 1, 'Ada', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(22, 1, 'Adalia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(23, 1, 'Adalyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(24, 1, 'Addie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(25, 1, 'Addilyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(26, 1, 'Addison', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(27, 1, 'Adelaide', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(28, 1, 'Adele', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(29, 1, 'Adelene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(30, 1, 'Adelia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(31, 1, 'Adelina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(32, 1, 'Adeline', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(33, 1, 'Adelynn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(34, 1, 'Adreanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(35, 1, 'Adriana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(36, 1, 'Adrianna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(37, 1, 'Adrianne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(38, 1, 'Adrienne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(39, 1, 'Aerona', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(40, 1, 'Agatha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(41, 1, 'Aggie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(42, 1, 'Agnes', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(43, 1, 'Aida', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(44, 1, 'Aileen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(45, 1, 'Ailsa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(46, 1, 'Aimee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(47, 1, 'Aine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(48, 1, 'Ainsleigh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(49, 1, 'Ainsley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(50, 1, 'Aisha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(51, 1, 'Aisling', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(52, 1, 'Aislinn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(53, 1, 'Aislynn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(54, 1, 'Alaina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(55, 1, 'Alana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(56, 1, 'Alanis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(57, 1, 'Alanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(58, 1, 'Alannah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(59, 1, 'Alaska', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(60, 1, 'Alayah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(61, 1, 'Alayna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(62, 1, 'Alba', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(63, 1, 'Albany', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(64, 1, 'Alberta', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(65, 1, 'Aleah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(66, 1, 'Alecia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(67, 1, 'Aleisha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(68, 1, 'Alejandra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(69, 1, 'Alena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(70, 1, 'Alessandra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(71, 1, 'Alessia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(72, 1, 'Alex', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(73, 1, 'Alexa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(74, 1, 'Alexandra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(75, 1, 'Alexandria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(76, 1, 'Alexia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(77, 1, 'Alexis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(78, 1, 'Alexus', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(79, 1, 'Ali', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(80, 1, 'Alia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(81, 1, 'Alice', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(82, 1, 'Alicia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(83, 1, 'Alina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(84, 1, 'Alisa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(85, 1, 'Alisha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(86, 1, 'Alison', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(87, 1, 'Alissa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(88, 1, 'Alivia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(89, 1, 'Aliyah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(90, 1, 'Aliza', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(91, 1, 'Alize', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(92, 1, 'Alka', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(93, 1, 'Allie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(94, 1, 'Allison', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(95, 1, 'Ally', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(96, 1, 'Allyson', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(97, 1, 'Alma', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(98, 1, 'Alondra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(99, 1, 'Alycia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(100, 1, 'Alyshialynn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(101, 1, 'Alyson', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(102, 1, 'Alyssa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(103, 1, 'Alyssia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(104, 1, 'Amalia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(105, 1, 'Amanda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(106, 1, 'Amani', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(107, 1, 'Amara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(108, 1, 'Amari', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(109, 1, 'Amaris', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(110, 1, 'Amaryllis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(111, 1, 'Amaya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(112, 1, 'Amber', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(113, 1, 'Amberly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(114, 1, 'Amelia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(115, 1, 'Amelie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(116, 1, 'America', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(117, 1, 'Amethyst', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(118, 1, 'Amie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(119, 1, 'Amina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(120, 1, 'Amirah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(121, 1, 'Amity', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(122, 1, 'Amy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(123, 1, 'Amya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(124, 1, 'Ana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(125, 1, 'Anabel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(126, 1, 'Anabelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(127, 1, 'Anahi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(128, 1, 'Anais', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(129, 1, 'Anamaria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(130, 1, 'Ananya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(131, 1, 'Anastasia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(132, 1, 'Andie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(133, 1, 'Andrea', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(134, 1, 'Andromeda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(135, 1, 'Angel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(136, 1, 'Angela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(137, 1, 'Angelia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(138, 1, 'Angelica', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(139, 1, 'Angelina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(140, 1, 'Angeline', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(141, 1, 'Angelique', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(142, 1, 'Angie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(143, 1, 'Anika', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(144, 1, 'Anisa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(145, 1, 'Anissa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(146, 1, 'Anita', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(147, 1, 'Aniya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(148, 1, 'Aniyah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(149, 1, 'Anjali', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(150, 1, 'Ann', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(151, 1, 'Anna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(152, 1, 'Annabel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(153, 1, 'Annabella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(154, 1, 'Annabelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(155, 1, 'Annabeth', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(156, 1, 'Annalisa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(157, 1, 'Annalise', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(158, 1, 'Annamaria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(159, 1, 'Anne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(160, 1, 'Anneke', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(161, 1, 'Annemarie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(162, 1, 'Annette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(163, 1, 'Annie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(164, 1, 'Annika', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(165, 1, 'Annmarie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(166, 1, 'Anthea', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(167, 1, 'Antoinette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(168, 1, 'Antonia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(169, 1, 'Anuja', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(170, 1, 'Anusha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(171, 1, 'Anushka', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(172, 1, 'Anya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(173, 1, 'Aoibhe', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(174, 1, 'Aoibheann', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(175, 1, 'Aoife', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(176, 1, 'Aphrodite', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(177, 1, 'Apple', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(178, 1, 'April', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1);
INSERT INTO `tbluser` (`id`, `isBot`, `username`, `pwd`, `salt`, `count_failed_logins`, `introduction`, `email`, `createdAt`, `lastLoginAt`, `status`, `language_id`, `notifications_regularNews`, `notifications_newCompetitionInHouse`, `notifications_competitionResults`, `notifications_adsPosted`) VALUES
(179, 1, 'Aqua', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(180, 1, 'Arabella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(181, 1, 'Arabelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(182, 1, 'Arden', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(183, 1, 'Aria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(184, 1, 'Ariadne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(185, 1, 'Ariana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(186, 1, 'Arianna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(187, 1, 'Arianne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(188, 1, 'Ariel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(189, 1, 'Ariella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(190, 1, 'Arielle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(191, 1, 'Arisha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(192, 1, 'Arleen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(193, 1, 'Arlene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(194, 1, 'Arlette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(195, 1, 'Artemis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(196, 1, 'Arwen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(197, 1, 'Arya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(198, 1, 'Asha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(199, 1, 'Ashanti', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(200, 1, 'Ashlee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(201, 1, 'Ashleigh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(202, 1, 'Ashley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(203, 1, 'Ashlie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(204, 1, 'Ashlyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(205, 1, 'Ashlynn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(206, 1, 'Ashton', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(207, 1, 'Ashvini', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(208, 1, 'Asia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(209, 1, 'Asma', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(210, 1, 'Aspen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(211, 1, 'Astrid', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(212, 1, 'Athalia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(213, 1, 'Athena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(214, 1, 'Athene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(215, 1, 'Atlanta', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(216, 1, 'Aubreanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(217, 1, 'Aubree', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(218, 1, 'Aubrey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(219, 1, 'Audra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(220, 1, 'Audrey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(221, 1, 'Audriana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(222, 1, 'Audrina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(223, 1, 'Augustina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(224, 1, 'Aurelia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(225, 1, 'Aurora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(226, 1, 'Autumn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(227, 1, 'Ava', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(228, 1, 'Avaline', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(229, 1, 'Avalon', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(230, 1, 'Avery', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(231, 1, 'Avia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(232, 1, 'Avril', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(233, 1, 'Aya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(234, 1, 'Ayana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(235, 1, 'Ayanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(236, 1, 'Ayesha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(237, 1, 'Ayisha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(238, 1, 'Ayla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(239, 1, 'Azalea', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(240, 1, 'Azaria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(241, 1, 'Azariah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(242, 1, 'Bailey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(243, 1, 'Barbara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(244, 1, 'Barbie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(245, 1, 'Bay', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(246, 1, 'Baylee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(247, 1, 'Bea', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(248, 1, 'Beatrice', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(249, 1, 'Beatrix', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(250, 1, 'Becca', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(251, 1, 'Beccy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(252, 1, 'Becky', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(253, 1, 'Belinda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(254, 1, 'Bella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(255, 1, 'Bellatrix', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(256, 1, 'Belle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(257, 1, 'Benita', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(258, 1, 'Bernadette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(259, 1, 'Bernice', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(260, 1, 'Bertha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(261, 1, 'Beryl', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(262, 1, 'Bess', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(263, 1, 'Bessie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(264, 1, 'Beth', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(265, 1, 'Bethan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(266, 1, 'Bethanie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(267, 1, 'Bethany', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(268, 1, 'Betsy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(269, 1, 'Bettina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(270, 1, 'Betty', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(271, 1, 'Beverly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(272, 1, 'Beyonce', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(273, 1, 'Bianca', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(274, 1, 'Billie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(275, 1, 'Blair', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(276, 1, 'Blaire', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(277, 1, 'Blake', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(278, 1, 'Blakely', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(279, 1, 'Blanche', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(280, 1, 'Blaze', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(281, 1, 'Blessing', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(282, 1, 'Bliss', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(283, 1, 'Bloom', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(284, 1, 'Blossom', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(285, 1, 'Blythe', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(286, 1, 'Bobbi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(287, 1, 'Bobbie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(288, 1, 'Bobby', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(289, 1, 'Bonita', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(290, 1, 'Bonnie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(291, 1, 'Bonquesha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(292, 1, 'Braelyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(293, 1, 'Brandi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(294, 1, 'Brandy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(295, 1, 'Braylee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(296, 1, 'Brea', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(297, 1, 'Breanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(298, 1, 'Bree', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(299, 1, 'Breeze', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(300, 1, 'Brenda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(301, 1, 'Brenna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(302, 1, 'Bria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(303, 1, 'Briana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(304, 1, 'Brianna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(305, 1, 'Brianne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(306, 1, 'Briar', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(307, 1, 'Bridget', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(308, 1, 'Bridgette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(309, 1, 'Bridie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(310, 1, 'Brie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(311, 1, 'Briella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(312, 1, 'Brielle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(313, 1, 'Brigid', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(314, 1, 'Briley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(315, 1, 'Brinley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(316, 1, 'Briony', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(317, 1, 'Brisa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(318, 1, 'Bristol', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(319, 1, 'Britney', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(320, 1, 'Britt', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(321, 1, 'Brittany', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(322, 1, 'Brittney', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(323, 1, 'Brodie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(324, 1, 'Brogan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(325, 1, 'Bronagh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(326, 1, 'Bronte', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(327, 1, 'Bronwen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(328, 1, 'Bronwyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(329, 1, 'Brook', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(330, 1, 'Brooke', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(331, 1, 'Brooklyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(332, 1, 'Brooklynn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(333, 1, 'Bryanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(334, 1, 'Brylee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(335, 1, 'Bryn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(336, 1, 'Brynlee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(337, 1, 'Brynn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(338, 1, 'Bryony', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(339, 1, 'Bunty', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(340, 1, 'Cadence', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(341, 1, 'Cailin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(342, 1, 'Caitlan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(343, 1, 'Caitlin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(344, 1, 'Caitlyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(345, 1, 'Caleigh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(346, 1, 'Cali', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(347, 1, 'Calista', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(348, 1, 'Callie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(349, 1, 'Calliope', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(350, 1, 'Callista', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(351, 1, 'Calypso', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(352, 1, 'Cambria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(353, 1, 'Cameron', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(354, 1, 'Cami', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(355, 1, 'Camila', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(356, 1, 'Camilla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1);
INSERT INTO `tbluser` (`id`, `isBot`, `username`, `pwd`, `salt`, `count_failed_logins`, `introduction`, `email`, `createdAt`, `lastLoginAt`, `status`, `language_id`, `notifications_regularNews`, `notifications_newCompetitionInHouse`, `notifications_competitionResults`, `notifications_adsPosted`) VALUES
(357, 1, 'Camille', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(358, 1, 'Camry', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(359, 1, 'Camryn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(360, 1, 'Candace', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(361, 1, 'Candice', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(362, 1, 'Candis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(363, 1, 'Candy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(364, 1, 'Caoimhe', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(365, 1, 'Caprice', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(366, 1, 'Cara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(367, 1, 'Carina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(368, 1, 'Caris', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(369, 1, 'Carissa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(370, 1, 'Carla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(371, 1, 'Carlene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(372, 1, 'Carley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(373, 1, 'Carlie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(374, 1, 'Carly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(375, 1, 'Carlynn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(376, 1, 'Carmel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(377, 1, 'Carmela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(378, 1, 'Carmen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(379, 1, 'Carol', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(380, 1, 'Carole', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(381, 1, 'Carolina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(382, 1, 'Caroline', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(383, 1, 'Carolyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(384, 1, 'Carrie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(385, 1, 'Carter', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(386, 1, 'Carys', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(387, 1, 'Casey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(388, 1, 'Cassandra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(389, 1, 'Cassia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(390, 1, 'Cassidy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(391, 1, 'Cassie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(392, 1, 'Cassiopeia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(393, 1, 'Cat', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(394, 1, 'Catalina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(395, 1, 'Cate', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(396, 1, 'Caterina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(397, 1, 'Cathalina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(398, 1, 'Catherine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(399, 1, 'Cathleen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(400, 1, 'Cathryn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(401, 1, 'Cathy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(402, 1, 'Catlin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(403, 1, 'Catrina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(404, 1, 'Catriona', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(405, 1, 'Cayla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(406, 1, 'Cece', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(407, 1, 'Cecelia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(408, 1, 'Cecilia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(409, 1, 'Cecily', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(410, 1, 'Celeste', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(411, 1, 'Celestia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(412, 1, 'Celestine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(413, 1, 'Celia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(414, 1, 'Celina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(415, 1, 'Celine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(416, 1, 'Celise', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(417, 1, 'Ceri', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(418, 1, 'Cerise', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(419, 1, 'Cerys', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(420, 1, 'Chanel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(421, 1, 'Chanelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(422, 1, 'Chantal', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(423, 1, 'Chantelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(424, 1, 'Charis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(425, 1, 'Charissa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(426, 1, 'Charity', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(427, 1, 'Charla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(428, 1, 'Charlene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(429, 1, 'Charlette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(430, 1, 'Charley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(431, 1, 'Charlie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(432, 1, 'Charlize', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(433, 1, 'Charlotte', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(434, 1, 'Charmaine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(435, 1, 'Chastity', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(436, 1, 'Chelsea', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(437, 1, 'Chelsey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(438, 1, 'Chenai', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(439, 1, 'Chenille', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(440, 1, 'Cher', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(441, 1, 'Cheri', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(442, 1, 'Cherie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(443, 1, 'Cherry', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(444, 1, 'Cheryl', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(445, 1, 'Cheyanne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(446, 1, 'Cheyenne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(447, 1, 'Chiara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(448, 1, 'Chloe', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(449, 1, 'Chole', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(450, 1, 'Chris', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(451, 1, 'Chrissy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(452, 1, 'Christa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(453, 1, 'Christabel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(454, 1, 'Christal', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(455, 1, 'Christen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(456, 1, 'Christi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(457, 1, 'Christiana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(458, 1, 'Christie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(459, 1, 'Christina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(460, 1, 'Christine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(461, 1, 'Christy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(462, 1, 'Chrysanthemum', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(463, 1, 'Chrystal', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(464, 1, 'Ciara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(465, 1, 'Cici', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(466, 1, 'Ciel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(467, 1, 'Cierra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(468, 1, 'Cindy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(469, 1, 'Clair', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(470, 1, 'Claire', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(471, 1, 'Clara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(472, 1, 'Clarabelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(473, 1, 'Clare', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(474, 1, 'Clarice', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(475, 1, 'Claris', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(476, 1, 'Clarissa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(477, 1, 'Clarisse', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(478, 1, 'Clarity', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(479, 1, 'Clary', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(480, 1, 'Claudette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(481, 1, 'Claudia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(482, 1, 'Claudine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(483, 1, 'Clea', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(484, 1, 'Clementine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(485, 1, 'Cleo', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(486, 1, 'Cleopatra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(487, 1, 'Clodagh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(488, 1, 'Cloe', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(489, 1, 'Clotilde', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(490, 1, 'Clover', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(491, 1, 'Coco', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(492, 1, 'Colette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(493, 1, 'Colleen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(494, 1, 'Connie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(495, 1, 'Constance', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(496, 1, 'Cora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(497, 1, 'Coral', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(498, 1, 'Coralie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(499, 1, 'Coraline', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(500, 1, 'Cordelia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(501, 1, 'Cori', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(502, 1, 'Corina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(503, 1, 'Corinne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(504, 1, 'Cornelia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(505, 1, 'Corra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(506, 1, 'Cosette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(507, 1, 'Courtney', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(508, 1, 'Cressida', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(509, 1, 'Cristal', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(510, 1, 'Cristina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(511, 1, 'Crystal', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(512, 1, 'Cyndi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(513, 1, 'Cynthia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(514, 1, 'Dagmar', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(515, 1, 'Dahlia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(516, 1, 'Daina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(517, 1, 'Daisy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(518, 1, 'Dakota', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(519, 1, 'Damaris', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(520, 1, 'Dana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(521, 1, 'Danette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(522, 1, 'Dani', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(523, 1, 'Danica', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(524, 1, 'Daniela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(525, 1, 'Daniella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(526, 1, 'Danielle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(527, 1, 'Danika', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(528, 1, 'Daphne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(529, 1, 'Dara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(530, 1, 'Darby', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(531, 1, 'Darcey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(532, 1, 'Darcie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(533, 1, 'Darcy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1);
INSERT INTO `tbluser` (`id`, `isBot`, `username`, `pwd`, `salt`, `count_failed_logins`, `introduction`, `email`, `createdAt`, `lastLoginAt`, `status`, `language_id`, `notifications_regularNews`, `notifications_newCompetitionInHouse`, `notifications_competitionResults`, `notifications_adsPosted`) VALUES
(534, 1, 'Daria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(535, 1, 'Darla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(536, 1, 'Darlene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(537, 1, 'Dasia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(538, 1, 'Davida', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(539, 1, 'Davina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(540, 1, 'Dawn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(541, 1, 'Dayna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(542, 1, 'Daysha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(543, 1, 'Deana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(544, 1, 'Deandra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(545, 1, 'Deann', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(546, 1, 'Deanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(547, 1, 'Deanne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(548, 1, 'Deb', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(549, 1, 'Debbie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(550, 1, 'Debby', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(551, 1, 'Debora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(552, 1, 'Deborah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(553, 1, 'Debra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(554, 1, 'Dede', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(555, 1, 'Dee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(556, 1, 'Deedee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(557, 1, 'Deena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(558, 1, 'Deidre', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(559, 1, 'Deirdre', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(560, 1, 'Deja', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(561, 1, 'Delaney', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(562, 1, 'Delanie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(563, 1, 'Delany', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(564, 1, 'Delia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(565, 1, 'Delilah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(566, 1, 'Delina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(567, 1, 'Della', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(568, 1, 'Delores', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(569, 1, 'Delphine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(570, 1, 'Demetria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(571, 1, 'Demi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(572, 1, 'Dena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(573, 1, 'Denice', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(574, 1, 'Denise', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(575, 1, 'Denny', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(576, 1, 'Desiree', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(577, 1, 'Destinee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(578, 1, 'Destiny', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(579, 1, 'Diamond', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(580, 1, 'Diana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(581, 1, 'Diane', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(582, 1, 'Dianna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(583, 1, 'Dianne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(584, 1, 'Dido', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(585, 1, 'Dilys', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(586, 1, 'Dina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(587, 1, 'Dinah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(588, 1, 'Dionne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(589, 1, 'Dior', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(590, 1, 'Dixie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(591, 1, 'Dolly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(592, 1, 'Dolores', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(593, 1, 'Dominique', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(594, 1, 'Donna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(595, 1, 'Dora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(596, 1, 'Doreen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(597, 1, 'Doris', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(598, 1, 'Dorla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(599, 1, 'Dorothy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(600, 1, 'Dot', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(601, 1, 'Dottie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(602, 1, 'Drew', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(603, 1, 'Dulce', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(604, 1, 'Dusty', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(605, 1, 'Eabha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(606, 1, 'Ebony', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(607, 1, 'Echo', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(608, 1, 'Eden', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(609, 1, 'Edie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(610, 1, 'Edith', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(611, 1, 'Edna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(612, 1, 'Edwina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(613, 1, 'Effie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(614, 1, 'Eileen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(615, 1, 'Eilidh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(616, 1, 'Eimear', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(617, 1, 'Elaina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(618, 1, 'Elaine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(619, 1, 'Elana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(620, 1, 'Eleanor', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(621, 1, 'Electra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(622, 1, 'Elektra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(623, 1, 'Elen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(624, 1, 'Elena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(625, 1, 'Eliana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(626, 1, 'Elicia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(627, 1, 'Elida', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(628, 1, 'Elin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(629, 1, 'Elina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(630, 1, 'Elinor', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(631, 1, 'Elisa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(632, 1, 'Elisabeth', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(633, 1, 'Elise', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(634, 1, 'Eliza', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(635, 1, 'Elizabeth', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(636, 1, 'Ella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(637, 1, 'Elle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(638, 1, 'Ellen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(639, 1, 'Ellery', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(640, 1, 'Ellie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(641, 1, 'Ellis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(642, 1, 'Elly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(643, 1, 'Elodie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(644, 1, 'Eloise', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(645, 1, 'Elora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(646, 1, 'Elouise', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(647, 1, 'Elsa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(648, 1, 'Elsie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(649, 1, 'Elspeth', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(650, 1, 'Elva', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(651, 1, 'Elvina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(652, 1, 'Elvira', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(653, 1, 'Elysia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(654, 1, 'Elyza', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(655, 1, 'Emanuela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(656, 1, 'Ember', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(657, 1, 'Emelda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(658, 1, 'Emely', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(659, 1, 'Emer', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(660, 1, 'Emerald', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(661, 1, 'Emerson', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(662, 1, 'Emi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(663, 1, 'Emilee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(664, 1, 'Emilia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(665, 1, 'Emilie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(666, 1, 'Emily', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(667, 1, 'Emma', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(668, 1, 'Emmalee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(669, 1, 'Emmaline', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(670, 1, 'Emmalyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(671, 1, 'Emmanuelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(672, 1, 'Emmeline', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(673, 1, 'Emmie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(674, 1, 'Emmy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(675, 1, 'Enid', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(676, 1, 'Enya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(677, 1, 'Erica', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(678, 1, 'Erika', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(679, 1, 'Erin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(680, 1, 'Eris', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(681, 1, 'Ernestine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(682, 1, 'Eryn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(683, 1, 'Esmay', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(684, 1, 'Esme', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(685, 1, 'Esmeralda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(686, 1, 'Esparanza', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(687, 1, 'Esperanza', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(688, 1, 'Estee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(689, 1, 'Estelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(690, 1, 'Ester', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(691, 1, 'Esther', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(692, 1, 'Estrella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(693, 1, 'Ethel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(694, 1, 'Eudora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(695, 1, 'Eugenie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(696, 1, 'Eunice', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(697, 1, 'Eva', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(698, 1, 'Evaline', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(699, 1, 'Evangelina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(700, 1, 'Evangeline', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(701, 1, 'Eve', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(702, 1, 'Evelin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(703, 1, 'Evelyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(704, 1, 'Everly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(705, 1, 'Evie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(706, 1, 'Evita', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(707, 1, 'Fabrizia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(708, 1, 'Faith', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(709, 1, 'Fallon', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(710, 1, 'Fanny', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(711, 1, 'Farah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1);
INSERT INTO `tbluser` (`id`, `isBot`, `username`, `pwd`, `salt`, `count_failed_logins`, `introduction`, `email`, `createdAt`, `lastLoginAt`, `status`, `language_id`, `notifications_regularNews`, `notifications_newCompetitionInHouse`, `notifications_competitionResults`, `notifications_adsPosted`) VALUES
(712, 1, 'Farrah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(713, 1, 'Fatima', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(714, 1, 'Fawn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(715, 1, 'Fay', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(716, 1, 'Faye', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(717, 1, 'Felicia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(718, 1, 'Felicity', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(719, 1, 'Fern', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(720, 1, 'Fernanda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(721, 1, 'Ffion', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(722, 1, 'Fifi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(723, 1, 'Fion', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(724, 1, 'Fiona', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(725, 1, 'Fleur', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(726, 1, 'Flick', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(727, 1, 'Flo', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(728, 1, 'Flora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(729, 1, 'Florence', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(730, 1, 'Fran', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(731, 1, 'Frances', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(732, 1, 'Francesca', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(733, 1, 'Francine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(734, 1, 'Francoise', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(735, 1, 'Frankie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(736, 1, 'Freda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(737, 1, 'Freya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(738, 1, 'Frida', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(739, 1, 'Gabby', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(740, 1, 'Gabriela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(741, 1, 'Gabriella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(742, 1, 'Gabrielle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(743, 1, 'Gail', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(744, 1, 'Garnet', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(745, 1, 'Gayle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(746, 1, 'Gaynor', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(747, 1, 'Geena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(748, 1, 'Gemma', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(749, 1, 'Gena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(750, 1, 'Genesis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(751, 1, 'Genevieve', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(752, 1, 'Genna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(753, 1, 'Georgette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(754, 1, 'Georgia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(755, 1, 'Georgie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(756, 1, 'Georgina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(757, 1, 'Geraldine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(758, 1, 'Germaine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(759, 1, 'Gert', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(760, 1, 'Gertrude', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(761, 1, 'Gia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(762, 1, 'Gianna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(763, 1, 'Gigi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(764, 1, 'Gilda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(765, 1, 'Gillian', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(766, 1, 'Gina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(767, 1, 'Ginger', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(768, 1, 'Ginny', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(769, 1, 'Giovanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(770, 1, 'Gisela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(771, 1, 'Giselle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(772, 1, 'Gisselle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(773, 1, 'Gladys', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(774, 1, 'Glenda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(775, 1, 'Glenys', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(776, 1, 'Gloria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(777, 1, 'Glynis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(778, 1, 'Golda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(779, 1, 'Goldie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(780, 1, 'Grace', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(781, 1, 'Gracelyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(782, 1, 'Gracie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(783, 1, 'Grainne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(784, 1, 'Greta', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(785, 1, 'Gretchen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(786, 1, 'Griselda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(787, 1, 'Guadalupe', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(788, 1, 'Guinevere', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(789, 1, 'Gwen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(790, 1, 'Gwendolyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(791, 1, 'Gwyneth', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(792, 1, 'Habiba', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(793, 1, 'Hadley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(794, 1, 'Hailee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(795, 1, 'Hailey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(796, 1, 'Haleigh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(797, 1, 'Haley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(798, 1, 'Halle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(799, 1, 'Hallie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(800, 1, 'Hanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(801, 1, 'Hannah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(802, 1, 'Harley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(803, 1, 'Harmony', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(804, 1, 'Harper', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(805, 1, 'Harriet', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(806, 1, 'Hattie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(807, 1, 'Haven', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(808, 1, 'Hayden', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(809, 1, 'Haylee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(810, 1, 'Hayley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(811, 1, 'Hazel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(812, 1, 'Hazeline', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(813, 1, 'Heather', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(814, 1, 'Heaven', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(815, 1, 'Heidi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(816, 1, 'Helen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(817, 1, 'Helena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(818, 1, 'Helene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(819, 1, 'Helga', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(820, 1, 'Helina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(821, 1, 'Henrietta', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(822, 1, 'Hepsiba', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(823, 1, 'Hera', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(824, 1, 'Hermine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(825, 1, 'Hermione', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(826, 1, 'Hester', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(827, 1, 'Hetty', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(828, 1, 'Hilary', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(829, 1, 'Hilda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(830, 1, 'Hildegard', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(831, 1, 'Hillary', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(832, 1, 'Hollie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(833, 1, 'Holly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(834, 1, 'Honesty', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(835, 1, 'Honey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(836, 1, 'Honor', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(837, 1, 'Honour', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(838, 1, 'Hope', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(839, 1, 'Hortense', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(840, 1, 'Hyacinth', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(841, 1, 'Ianthe', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(842, 1, 'Ida', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(843, 1, 'Ila', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(844, 1, 'Ilene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(845, 1, 'Iliana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(846, 1, 'Ilona', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(847, 1, 'Ilse', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(848, 1, 'Imani', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(849, 1, 'Imelda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(850, 1, 'Immy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(851, 1, 'Imogen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(852, 1, 'India', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(853, 1, 'Indie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(854, 1, 'Indigo', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(855, 1, 'Indira', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(856, 1, 'Ines', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(857, 1, 'Ingrid', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(858, 1, 'Iona', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(859, 1, 'Ira', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(860, 1, 'Irena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(861, 1, 'Irene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(862, 1, 'Irina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(863, 1, 'Iris', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(864, 1, 'Irma', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(865, 1, 'Isa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(866, 1, 'Isabel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(867, 1, 'Isabell', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(868, 1, 'Isabella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(869, 1, 'Isabelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(870, 1, 'Isadora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(871, 1, 'Isha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(872, 1, 'Isidora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(873, 1, 'Isis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(874, 1, 'Isla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(875, 1, 'Isobel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(876, 1, 'Isolde', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(877, 1, 'Itzel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(878, 1, 'Ivana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(879, 1, 'Ivy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(880, 1, 'Iyanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(881, 1, 'Izabella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(882, 1, 'Izidora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(883, 1, 'Izzie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(884, 1, 'Izzy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(885, 1, 'Jacinda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(886, 1, 'Jacinta', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(887, 1, 'Jackie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(888, 1, 'Jacqueline', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(889, 1, 'Jacquelyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1);
INSERT INTO `tbluser` (`id`, `isBot`, `username`, `pwd`, `salt`, `count_failed_logins`, `introduction`, `email`, `createdAt`, `lastLoginAt`, `status`, `language_id`, `notifications_regularNews`, `notifications_newCompetitionInHouse`, `notifications_competitionResults`, `notifications_adsPosted`) VALUES
(890, 1, 'Jada', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(891, 1, 'Jade', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(892, 1, 'Jaden', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(893, 1, 'Jadyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(894, 1, 'Jaelynn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(895, 1, 'Jaida', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(896, 1, 'Jaime', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(897, 1, 'Jamie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(898, 1, 'Jamiya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(899, 1, 'Jan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(900, 1, 'Jana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(901, 1, 'Janae', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(902, 1, 'Jancis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(903, 1, 'Jane', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(904, 1, 'Janelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(905, 1, 'Janessa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(906, 1, 'Janet', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(907, 1, 'Janette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(908, 1, 'Jania', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(909, 1, 'Janice', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(910, 1, 'Janie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(911, 1, 'Janine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(912, 1, 'Janis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(913, 1, 'Janiya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(914, 1, 'January', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(915, 1, 'Jaqueline', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(916, 1, 'Jasmin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(917, 1, 'Jasmine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(918, 1, 'Jaya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(919, 1, 'Jayda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(920, 1, 'Jayden', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(921, 1, 'Jayla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(922, 1, 'Jaylene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(923, 1, 'Jaylinn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(924, 1, 'Jaylynn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(925, 1, 'Jayne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(926, 1, 'Jazlyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(927, 1, 'Jazmin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(928, 1, 'Jazmine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(929, 1, 'Jazz', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(930, 1, 'Jean', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(931, 1, 'Jeanette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(932, 1, 'Jeanine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(933, 1, 'Jeanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(934, 1, 'Jeanne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(935, 1, 'Jeannette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(936, 1, 'Jeannie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(937, 1, 'Jeannine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(938, 1, 'Jemima', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(939, 1, 'Jemma', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(940, 1, 'Jen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(941, 1, 'Jena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(942, 1, 'Jenelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(943, 1, 'Jenessa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(944, 1, 'Jenna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(945, 1, 'Jennette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(946, 1, 'Jenni', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(947, 1, 'Jennie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(948, 1, 'Jennifer', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(949, 1, 'Jenny', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(950, 1, 'Jensen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(951, 1, 'Jeri', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(952, 1, 'Jerri', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(953, 1, 'Jess', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(954, 1, 'Jessa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(955, 1, 'Jessica', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(956, 1, 'Jessie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(957, 1, 'Jet', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(958, 1, 'Jewel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(959, 1, 'Jill', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(960, 1, 'Jillian', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(961, 1, 'Jo', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(962, 1, 'Joan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(963, 1, 'Joann', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(964, 1, 'Joanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(965, 1, 'Joanne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(966, 1, 'Jocelyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(967, 1, 'Jodi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(968, 1, 'Jodie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(969, 1, 'Jody', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(970, 1, 'Joelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(971, 1, 'Johanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(972, 1, 'Joleen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(973, 1, 'Jolene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(974, 1, 'Jolie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(975, 1, 'Joni', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(976, 1, 'Jordan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(977, 1, 'Jordana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(978, 1, 'Jordyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(979, 1, 'Jorja', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(980, 1, 'Joselyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(981, 1, 'Josephine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(982, 1, 'Josie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(983, 1, 'Journey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(984, 1, 'Joy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(985, 1, 'Joya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(986, 1, 'Joyce', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(987, 1, 'Juanita', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(988, 1, 'Jude', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(989, 1, 'Judith', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(990, 1, 'Judy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(991, 1, 'Jules', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(992, 1, 'Julia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(993, 1, 'Juliana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(994, 1, 'Julianna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(995, 1, 'Julianne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(996, 1, 'Julie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(997, 1, 'Julienne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(998, 1, 'Juliet', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(999, 1, 'Juliette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1000, 1, 'Julissa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1001, 1, 'July', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1002, 1, 'June', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1003, 1, 'Juniper', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1004, 1, 'Juno', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1005, 1, 'Justice', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1006, 1, 'Justina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1007, 1, 'Justine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1008, 1, 'Kacey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1009, 1, 'Kadence', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1010, 1, 'Kaelyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1011, 1, 'Kaidence', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1012, 1, 'Kailey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1013, 1, 'Kailyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1014, 1, 'Kaitlin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1015, 1, 'Kaitlyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1016, 1, 'Kaitlynn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1017, 1, 'Kalea', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1018, 1, 'Kaleigh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1019, 1, 'Kali', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1020, 1, 'Kalia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1021, 1, 'Kalista', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1022, 1, 'Kaliyah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1023, 1, 'Kallie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1024, 1, 'Kamala', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1025, 1, 'Kamryn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1026, 1, 'Kara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1027, 1, 'Karen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1028, 1, 'Kari', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1029, 1, 'Karin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1030, 1, 'Karina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1031, 1, 'Karissa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1032, 1, 'Karla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1033, 1, 'Karlee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1034, 1, 'Karly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1035, 1, 'Karolina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1036, 1, 'Karyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1037, 1, 'Kasey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1038, 1, 'Kassandra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1039, 1, 'Kassidy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1040, 1, 'Kassie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1041, 1, 'Kat', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1042, 1, 'Katara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1043, 1, 'Katarina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1044, 1, 'Kate', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1045, 1, 'Katelyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1046, 1, 'Katelynn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1047, 1, 'Katerina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1048, 1, 'Katharine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1049, 1, 'Katherine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1050, 1, 'Kathleen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1051, 1, 'Kathryn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1052, 1, 'Kathy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1053, 1, 'Katia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1054, 1, 'Katie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1055, 1, 'Katlyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1056, 1, 'Katniss', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1057, 1, 'Katrina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1058, 1, 'Katy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1059, 1, 'Katya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1060, 1, 'Kay', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1061, 1, 'Kaya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1062, 1, 'Kaye', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1063, 1, 'Kayla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1064, 1, 'Kaylee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1065, 1, 'Kayleigh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1066, 1, 'Kayley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1);
INSERT INTO `tbluser` (`id`, `isBot`, `username`, `pwd`, `salt`, `count_failed_logins`, `introduction`, `email`, `createdAt`, `lastLoginAt`, `status`, `language_id`, `notifications_regularNews`, `notifications_newCompetitionInHouse`, `notifications_competitionResults`, `notifications_adsPosted`) VALUES
(1067, 1, 'Kaylie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1068, 1, 'Kaylin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1069, 1, 'Keara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1070, 1, 'Keeley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1071, 1, 'Keely', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1072, 1, 'Keira', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1073, 1, 'Keisha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1074, 1, 'Kelis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1075, 1, 'Kelley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1076, 1, 'Kelli', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1077, 1, 'Kellie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1078, 1, 'Kelly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1079, 1, 'Kelsey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1080, 1, 'Kelsie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1081, 1, 'Kendall', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1082, 1, 'Kendra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1083, 1, 'Kenna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1084, 1, 'Kennedy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1085, 1, 'Kenzie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1086, 1, 'Kera', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1087, 1, 'Keri', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1088, 1, 'Kerian', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1089, 1, 'Kerri', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1090, 1, 'Kerry', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1091, 1, 'Kia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1092, 1, 'Kiana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1093, 1, 'Kiara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1094, 1, 'Kiera', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1095, 1, 'Kierra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1096, 1, 'Kiersten', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1097, 1, 'Kiki', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1098, 1, 'Kiley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1099, 1, 'Kim', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1100, 1, 'Kimberlee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1101, 1, 'Kimberley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1102, 1, 'Kimberly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1103, 1, 'Kimbriella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1104, 1, 'Kimmy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1105, 1, 'Kinley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1106, 1, 'Kinsey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1107, 1, 'Kinsley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1108, 1, 'Kira', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1109, 1, 'Kirsten', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1110, 1, 'Kirstin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1111, 1, 'Kirsty', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1112, 1, 'Kit', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1113, 1, 'Kitty', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1114, 1, 'Kizzy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1115, 1, 'Kloe', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1116, 1, 'Kora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1117, 1, 'Kori', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1118, 1, 'Kourtney', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1119, 1, 'Kris', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1120, 1, 'Krista', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1121, 1, 'Kristen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1122, 1, 'Kristi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1123, 1, 'Kristie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1124, 1, 'Kristin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1125, 1, 'Kristina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1126, 1, 'Kristine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1127, 1, 'Kristy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1128, 1, 'Krystal', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1129, 1, 'Kya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1130, 1, 'Kyla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1131, 1, 'Kylee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1132, 1, 'Kyleigh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1133, 1, 'Kylie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1134, 1, 'Kyra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1135, 1, 'Lacey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1136, 1, 'Lacie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1137, 1, 'Lacy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1138, 1, 'Ladonna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1139, 1, 'Laila', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1140, 1, 'Lainey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1141, 1, 'Lakyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1142, 1, 'Lala', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1143, 1, 'Lana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1144, 1, 'Laney', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1145, 1, 'Lara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1146, 1, 'Larissa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1147, 1, 'Lark', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1148, 1, 'Latoya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1149, 1, 'Laura', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1150, 1, 'Laurel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1151, 1, 'Lauren', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1152, 1, 'Laurie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1153, 1, 'Lauryn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1154, 1, 'Lavana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1155, 1, 'Lavender', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1156, 1, 'Lavinia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1157, 1, 'Layla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1158, 1, 'Lea', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1159, 1, 'Leah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1160, 1, 'Leandra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1161, 1, 'Leann', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1162, 1, 'Leanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1163, 1, 'Leanne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1164, 1, 'Leda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1165, 1, 'Lee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1166, 1, 'Leela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1167, 1, 'Leena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1168, 1, 'Leia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1169, 1, 'Leigh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1170, 1, 'Leila', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1171, 1, 'Leilani', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1172, 1, 'Lela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1173, 1, 'Lena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1174, 1, 'Lenore', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1175, 1, 'Leona', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1176, 1, 'Leonie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1177, 1, 'Leonora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1178, 1, 'Leora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1179, 1, 'Lesley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1180, 1, 'Leslie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1181, 1, 'Lesly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1182, 1, 'Leticia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1183, 1, 'Letitia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1184, 1, 'Lettie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1185, 1, 'Lexi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1186, 1, 'Lexia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1187, 1, 'Lexie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1188, 1, 'Lexis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1189, 1, 'Leyla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1190, 1, 'Lia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1191, 1, 'Liah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1192, 1, 'Liana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1193, 1, 'Lianne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1194, 1, 'Libbie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1195, 1, 'Libby', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1196, 1, 'Liberty', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1197, 1, 'Lidia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1198, 1, 'Liesl', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1199, 1, 'Lila', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1200, 1, 'Lilac', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1201, 1, 'Lilah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1202, 1, 'Lili', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1203, 1, 'Lilian', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1204, 1, 'Liliana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1205, 1, 'Lilita', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1206, 1, 'Lilith', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1207, 1, 'Lillia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1208, 1, 'Lillian', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1209, 1, 'Lillie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1210, 1, 'Lilly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1211, 1, 'Lily', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1212, 1, 'Lina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1213, 1, 'Linda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1214, 1, 'Lindsay', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1215, 1, 'Lindsey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1216, 1, 'Lindy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1217, 1, 'Lisa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1218, 1, 'Lisette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1219, 1, 'Liv', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1220, 1, 'Livia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1221, 1, 'Livvy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1222, 1, 'Liz', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1223, 1, 'Liza', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1224, 1, 'Lizbeth', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1225, 1, 'Lizette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1226, 1, 'Lizzie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1227, 1, 'Lizzy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1228, 1, 'Logan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1229, 1, 'Lois', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1230, 1, 'Lola', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1231, 1, 'Lolita', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1232, 1, 'London', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1233, 1, 'Lora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1234, 1, 'Loran', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1235, 1, 'Lorelei', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1236, 1, 'Loren', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1237, 1, 'Lorena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1238, 1, 'Loretta', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1239, 1, 'Lori', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1240, 1, 'Lorie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1241, 1, 'Lorna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1242, 1, 'Lorraine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1243, 1, 'Lorri', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1);
INSERT INTO `tbluser` (`id`, `isBot`, `username`, `pwd`, `salt`, `count_failed_logins`, `introduction`, `email`, `createdAt`, `lastLoginAt`, `status`, `language_id`, `notifications_regularNews`, `notifications_newCompetitionInHouse`, `notifications_competitionResults`, `notifications_adsPosted`) VALUES
(1244, 1, 'Lorrie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1245, 1, 'Lottie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1246, 1, 'Lotus', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1247, 1, 'Lou', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1248, 1, 'Louella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1249, 1, 'Louisa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1250, 1, 'Louise', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1251, 1, 'Luann', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1252, 1, 'Lucia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1253, 1, 'Luciana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1254, 1, 'Lucie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1255, 1, 'Lucille', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1256, 1, 'Lucinda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1257, 1, 'Lucky', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1258, 1, 'Lucy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1259, 1, 'Luisa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1260, 1, 'Lulu', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1261, 1, 'Luna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1262, 1, 'Lupita', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1263, 1, 'Luz', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1264, 1, 'Lydia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1265, 1, 'Lyla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1266, 1, 'Lynda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1267, 1, 'Lyndsey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1268, 1, 'Lynette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1269, 1, 'Lynn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1270, 1, 'Lynne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1271, 1, 'Lynnette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1272, 1, 'Lynsey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1273, 1, 'Lyra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1274, 1, 'Lyric', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1275, 1, 'Mabel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1276, 1, 'Macey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1277, 1, 'Macie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1278, 1, 'Mackenzie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1279, 1, 'Macy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1280, 1, 'Madalyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1281, 1, 'Maddie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1282, 1, 'Maddison', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1283, 1, 'Maddy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1284, 1, 'Madeleine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1285, 1, 'Madeline', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1286, 1, 'Madelyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1287, 1, 'Madison', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1288, 1, 'Madisyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1289, 1, 'Madonna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1290, 1, 'Madyson', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1291, 1, 'Mae', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1292, 1, 'Maeve', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1293, 1, 'Magda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1294, 1, 'Magdalena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1295, 1, 'Magdalene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1296, 1, 'Maggie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1297, 1, 'Maia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1298, 1, 'Maire', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1299, 1, 'Mairead', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1300, 1, 'Maisie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1301, 1, 'Maisy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1302, 1, 'Maja', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1303, 1, 'Makayla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1304, 1, 'Makenna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1305, 1, 'Makenzie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1306, 1, 'Malia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1307, 1, 'Malina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1308, 1, 'Malinda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1309, 1, 'Mallory', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1310, 1, 'Malory', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1311, 1, 'Mandy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1312, 1, 'Manuela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1313, 1, 'Mara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1314, 1, 'Marcela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1315, 1, 'Marcella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1316, 1, 'Marcelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1317, 1, 'Marci', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1318, 1, 'Marcia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1319, 1, 'Marcie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1320, 1, 'Marcy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1321, 1, 'Margaret', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1322, 1, 'Margarita', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1323, 1, 'Margaux', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1324, 1, 'Marge', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1325, 1, 'Margie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1326, 1, 'Margo', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1327, 1, 'Margot', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1328, 1, 'Margret', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1329, 1, 'Mariah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1330, 1, 'Mariam', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1331, 1, 'Marian', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1332, 1, 'Mariana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1333, 1, 'Marianna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1334, 1, 'Marianne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1335, 1, 'Maribel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1336, 1, 'Marie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1337, 1, 'Mariela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1338, 1, 'Mariella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1339, 1, 'Marilyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1340, 1, 'Marina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1341, 1, 'Marion', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1342, 1, 'Maris', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1343, 1, 'Marisa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1344, 1, 'Marisol', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1345, 1, 'Marissa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1346, 1, 'Maritza', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1347, 1, 'Marjorie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1348, 1, 'Marla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1349, 1, 'Marlee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1350, 1, 'Marlena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1351, 1, 'Marlene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1352, 1, 'Marley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1353, 1, 'Marnie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1354, 1, 'Marsha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1355, 1, 'Martha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1356, 1, 'Mary', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1357, 1, 'Maryam', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1358, 1, 'Maryann', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1359, 1, 'Marybeth', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1360, 1, 'Maryjane', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1361, 1, 'Masie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1362, 1, 'Matilda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1363, 1, 'Mattie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1364, 1, 'Maude', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1365, 1, 'Maura', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1366, 1, 'Maureen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1367, 1, 'Mavis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1368, 1, 'Maxime', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1369, 1, 'Maxine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1370, 1, 'May', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1371, 1, 'Maya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1372, 1, 'Maybell', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1373, 1, 'Mazie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1374, 1, 'Mckayla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1375, 1, 'Mckenna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1376, 1, 'Mckenzie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1377, 1, 'Mea', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1378, 1, 'Meadow', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1379, 1, 'Meagan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1380, 1, 'Meera', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1381, 1, 'Meg', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1382, 1, 'Megan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1383, 1, 'Meghan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1384, 1, 'Mei', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1385, 1, 'Mel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1386, 1, 'Melanie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1387, 1, 'Melina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1388, 1, 'Melinda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1389, 1, 'Melissa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1390, 1, 'Melody', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1391, 1, 'Mercedes', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1392, 1, 'Mercy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1393, 1, 'Meredith', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1394, 1, 'Merida', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1395, 1, 'Merissa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1396, 1, 'Meryl', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1397, 1, 'Mia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1398, 1, 'Michaela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1399, 1, 'Michele', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1400, 1, 'Michelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1401, 1, 'Mika', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1402, 1, 'Mikaela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1403, 1, 'Mikayla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1404, 1, 'Mikhaela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1405, 1, 'Mila', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1406, 1, 'Mildred', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1407, 1, 'Milena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1408, 1, 'Miley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1409, 1, 'Millicent', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1410, 1, 'Millie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1411, 1, 'Milly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1412, 1, 'Mimi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1413, 1, 'Mina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1414, 1, 'Mindy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1415, 1, 'Minerva', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1416, 1, 'Minnie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1417, 1, 'Mira', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1418, 1, 'Mirabel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1419, 1, 'Mirabelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1420, 1, 'Miracle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1);
INSERT INTO `tbluser` (`id`, `isBot`, `username`, `pwd`, `salt`, `count_failed_logins`, `introduction`, `email`, `createdAt`, `lastLoginAt`, `status`, `language_id`, `notifications_regularNews`, `notifications_newCompetitionInHouse`, `notifications_competitionResults`, `notifications_adsPosted`) VALUES
(1421, 1, 'Miranda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1422, 1, 'Miriam', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1423, 1, 'Mirielle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1424, 1, 'Missie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1425, 1, 'Misty', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1426, 1, 'Mitzi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1427, 1, 'Moira', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1428, 1, 'Mollie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1429, 1, 'Molly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1430, 1, 'Mona', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1431, 1, 'Monica', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1432, 1, 'Monika', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1433, 1, 'Monique', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1434, 1, 'Montana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1435, 1, 'Montserrat', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1436, 1, 'Morgan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1437, 1, 'Morgana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1438, 1, 'Moya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1439, 1, 'Muriel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1440, 1, 'Mya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1441, 1, 'Myfanwy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1442, 1, 'Myla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1443, 1, 'Myra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1444, 1, 'Myrna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1445, 1, 'Myrtle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1446, 1, 'Nadene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1447, 1, 'Nadia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1448, 1, 'Nadine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1449, 1, 'Naja', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1450, 1, 'Nala', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1451, 1, 'Nana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1452, 1, 'Nancy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1453, 1, 'Nanette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1454, 1, 'Naomi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1455, 1, 'Natalia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1456, 1, 'Natalie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1457, 1, 'Natasha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1458, 1, 'Naya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1459, 1, 'Nayeli', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1460, 1, 'Nell', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1461, 1, 'Nellie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1462, 1, 'Nelly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1463, 1, 'Nena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1464, 1, 'Nerissa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1465, 1, 'Nessa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1466, 1, 'Nevaeh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1467, 1, 'Neve', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1468, 1, 'Nia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1469, 1, 'Niamh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1470, 1, 'Nichola', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1471, 1, 'Nichole', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1472, 1, 'Nicki', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1473, 1, 'Nicky', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1474, 1, 'Nicola', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1475, 1, 'Nicole', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1476, 1, 'Nicolette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1477, 1, 'Nieve', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1478, 1, 'Niki', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1479, 1, 'Nikita', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1480, 1, 'Nikki', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1481, 1, 'Nila', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1482, 1, 'Nina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1483, 1, 'Nisha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1484, 1, 'Nishka', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1485, 1, 'Nita', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1486, 1, 'Noella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1487, 1, 'Noelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1488, 1, 'Noely', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1489, 1, 'Noemi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1490, 1, 'Nola', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1491, 1, 'Nora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1492, 1, 'Norah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1493, 1, 'Noreen', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1494, 1, 'Norma', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1495, 1, 'Nova', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1496, 1, 'Nyla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1497, 1, 'Oasis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1498, 1, 'Ocean', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1499, 1, 'Octavia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1500, 1, 'Odalis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1501, 1, 'Odalys', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1502, 1, 'Odele', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1503, 1, 'Odelia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1504, 1, 'Odette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1505, 1, 'Olga', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1506, 1, 'Olive', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1507, 1, 'Olivia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1508, 1, 'Oona', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1509, 1, 'Oonagh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1510, 1, 'Opal', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1511, 1, 'Ophelia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1512, 1, 'Oprah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1513, 1, 'Oriana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1514, 1, 'Orianna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1515, 1, 'Orla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1516, 1, 'Orlaith', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1517, 1, 'Page', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1518, 1, 'Paige', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1519, 1, 'Paisley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1520, 1, 'Paloma', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1521, 1, 'Pam', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1522, 1, 'Pamela', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1523, 1, 'Pandora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1524, 1, 'Pansy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1525, 1, 'Paola', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1526, 1, 'Paris', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1527, 1, 'Patience', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1528, 1, 'Patrice', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1529, 1, 'Patricia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1530, 1, 'Patsy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1531, 1, 'Patti', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1532, 1, 'Patty', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1533, 1, 'Paula', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1534, 1, 'Paulette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1535, 1, 'Paulina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1536, 1, 'Pauline', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1537, 1, 'Payton', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1538, 1, 'Peace', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1539, 1, 'Pearl', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1540, 1, 'Peggy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1541, 1, 'Penelope', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1542, 1, 'Penny', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1543, 1, 'Perla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1544, 1, 'Perrie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1545, 1, 'Persephone', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1546, 1, 'Petra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1547, 1, 'Petunia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1548, 1, 'Peyton', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1549, 1, 'Phillipa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1550, 1, 'Philomena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1551, 1, 'Phoebe', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1552, 1, 'Phoenix', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1553, 1, 'Phyllis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1554, 1, 'Piper', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1555, 1, 'Pippa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1556, 1, 'Pixie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1557, 1, 'Polly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1558, 1, 'Pollyanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1559, 1, 'Poppy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1560, 1, 'Portia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1561, 1, 'Precious', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1562, 1, 'Presley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1563, 1, 'Preslie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1564, 1, 'Primrose', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1565, 1, 'Princess', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1566, 1, 'Priscilla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1567, 1, 'Priya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1568, 1, 'Promise', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1569, 1, 'Prudence', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1570, 1, 'Prue', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1571, 1, 'Queenie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1572, 1, 'Quiana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1573, 1, 'Quinn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1574, 1, 'Rabia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1575, 1, 'Rachael', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1576, 1, 'Rachel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1577, 1, 'Rachelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1578, 1, 'Rae', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1579, 1, 'Raegan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1580, 1, 'Raelyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1581, 1, 'Raina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1582, 1, 'Raine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1583, 1, 'Ramona', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1584, 1, 'Ramsha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1585, 1, 'Randi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1586, 1, 'Rani', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1587, 1, 'Rania', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1588, 1, 'Raquel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1589, 1, 'Raven', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1590, 1, 'Raya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1591, 1, 'Rayna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1592, 1, 'Rayne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1593, 1, 'Reagan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1594, 1, 'Reanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1595, 1, 'Reanne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1596, 1, 'Rebecca', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1597, 1, 'Rebekah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1);
INSERT INTO `tbluser` (`id`, `isBot`, `username`, `pwd`, `salt`, `count_failed_logins`, `introduction`, `email`, `createdAt`, `lastLoginAt`, `status`, `language_id`, `notifications_regularNews`, `notifications_newCompetitionInHouse`, `notifications_competitionResults`, `notifications_adsPosted`) VALUES
(1598, 1, 'Reese', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1599, 1, 'Regan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1600, 1, 'Regina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1601, 1, 'Reilly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1602, 1, 'Reina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1603, 1, 'Remi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1604, 1, 'Rena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1605, 1, 'Renae', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1606, 1, 'Renata', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1607, 1, 'Rene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1608, 1, 'Renee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1609, 1, 'Renesmee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1610, 1, 'Reyna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1611, 1, 'Rhea', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1612, 1, 'Rhian', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1613, 1, 'Rhianna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1614, 1, 'Rhiannon', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1615, 1, 'Rhoda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1616, 1, 'Rhona', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1617, 1, 'Rhonda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1618, 1, 'Ria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1619, 1, 'Rianna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1620, 1, 'Richelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1621, 1, 'Ricki', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1622, 1, 'Rihanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1623, 1, 'Rikki', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1624, 1, 'Riley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1625, 1, 'Rina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1626, 1, 'Rita', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1627, 1, 'River', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1628, 1, 'Riya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1629, 1, 'Roanne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1630, 1, 'Roberta', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1631, 1, 'Robin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1632, 1, 'Robyn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1633, 1, 'Rochelle', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1634, 1, 'Rocio', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1635, 1, 'Roisin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1636, 1, 'Rolanda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1637, 1, 'Ronda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1638, 1, 'Roni', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1639, 1, 'Rosa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1640, 1, 'Rosalie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1641, 1, 'Rosalina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1642, 1, 'Rosalind', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1643, 1, 'Rosalinda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1644, 1, 'Rosalynn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1645, 1, 'Rosanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1646, 1, 'Rose', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1647, 1, 'Roseanne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1648, 1, 'Rosella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1649, 1, 'Rosemarie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1650, 1, 'Rosemary', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1651, 1, 'Rosetta', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1652, 1, 'Rosie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1653, 1, 'Rosy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1654, 1, 'Rowan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1655, 1, 'Rowena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1656, 1, 'Roxana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1657, 1, 'Roxanne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1658, 1, 'Roxie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1659, 1, 'Roxy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1660, 1, 'Rozlynn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1661, 1, 'Ruby', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1662, 1, 'Rue', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1663, 1, 'Ruth', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1664, 1, 'Ruthie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1665, 1, 'Ryanne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1666, 1, 'Rydel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1667, 1, 'Rylee', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1668, 1, 'Ryleigh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1669, 1, 'Rylie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1670, 1, 'Sabina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1671, 1, 'Sabine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1672, 1, 'Sable', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1673, 1, 'Sabrina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1674, 1, 'Sade', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1675, 1, 'Sadhbh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1676, 1, 'Sadie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1677, 1, 'Saffron', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1678, 1, 'Safire', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1679, 1, 'Safiya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1680, 1, 'Sage', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1681, 1, 'Sahara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1682, 1, 'Saige', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1683, 1, 'Saira', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1684, 1, 'Sally', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1685, 1, 'Salma', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1686, 1, 'Salome', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1687, 1, 'Sam', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1688, 1, 'Samantha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1689, 1, 'Samara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1690, 1, 'Samia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1691, 1, 'Samira', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1692, 1, 'Sammie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1693, 1, 'Sammy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1694, 1, 'Sandra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1695, 1, 'Sandy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1696, 1, 'Sania', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1697, 1, 'Saoirse', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1698, 1, 'Sapphire', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1699, 1, 'Sara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1700, 1, 'Sarah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1701, 1, 'Sarina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1702, 1, 'Sariya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1703, 1, 'Sascha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1704, 1, 'Sasha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1705, 1, 'Saskia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1706, 1, 'Savanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1707, 1, 'Savannah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1708, 1, 'Scarlet', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1709, 1, 'Scarlett', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1710, 1, 'Sebastianne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1711, 1, 'Selah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1712, 1, 'Selena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1713, 1, 'Selene', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1714, 1, 'Selina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1715, 1, 'Selma', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1716, 1, 'Senuri', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1717, 1, 'September', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1718, 1, 'Seren', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1719, 1, 'Serena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1720, 1, 'Serenity', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1721, 1, 'Shakira', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1722, 1, 'Shana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1723, 1, 'Shania', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1724, 1, 'Shannon', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1725, 1, 'Shari', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1726, 1, 'Sharon', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1727, 1, 'Shary', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1728, 1, 'Shauna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1729, 1, 'Shawn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1730, 1, 'Shawna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1731, 1, 'Shawnette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1732, 1, 'Shayla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1733, 1, 'Shayna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1734, 1, 'Shea', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1735, 1, 'Sheba', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1736, 1, 'Sheena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1737, 1, 'Sheila', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1738, 1, 'Shelby', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1739, 1, 'Shelia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1740, 1, 'Shelley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1741, 1, 'Shelly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1742, 1, 'Sheri', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1743, 1, 'Sheridan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1744, 1, 'Sherri', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1745, 1, 'Sherrie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1746, 1, 'Sherry', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1747, 1, 'Sheryl', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1748, 1, 'Shirley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1749, 1, 'Shivani', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1750, 1, 'Shona', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1751, 1, 'Shonagh', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1752, 1, 'Shreya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1753, 1, 'Shyann', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1754, 1, 'Shyla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1755, 1, 'Sian', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1756, 1, 'Sidney', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1757, 1, 'Sienna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1758, 1, 'Sierra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1759, 1, 'Sigourney', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1760, 1, 'Silvia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1761, 1, 'Simone', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1762, 1, 'Simran', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1763, 1, 'Sindy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1764, 1, 'Sinead', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1765, 1, 'Siobhan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1766, 1, 'Sky', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1767, 1, 'Skye', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1768, 1, 'Skylar', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1769, 1, 'Skyler', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1770, 1, 'Sloane', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1771, 1, 'Snow', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1772, 1, 'Sofia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1773, 1, 'Sofie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1774, 1, 'Sondra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1);
INSERT INTO `tbluser` (`id`, `isBot`, `username`, `pwd`, `salt`, `count_failed_logins`, `introduction`, `email`, `createdAt`, `lastLoginAt`, `status`, `language_id`, `notifications_regularNews`, `notifications_newCompetitionInHouse`, `notifications_competitionResults`, `notifications_adsPosted`) VALUES
(1775, 1, 'Sonia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1776, 1, 'Sonja', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1777, 1, 'Sonya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1778, 1, 'Sophia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1779, 1, 'Sophie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1780, 1, 'Sophy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1781, 1, 'Sorrel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1782, 1, 'Spring', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1783, 1, 'Stacey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1784, 1, 'Staci', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1785, 1, 'Stacie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1786, 1, 'Stacy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1787, 1, 'Star', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1788, 1, 'Starla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1789, 1, 'Stefanie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1790, 1, 'Stella', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1791, 1, 'Steph', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1792, 1, 'Stephanie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1793, 1, 'Sue', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1794, 1, 'Sugar', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1795, 1, 'Suki', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1796, 1, 'Summer', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1797, 1, 'Susan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1798, 1, 'Susanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1799, 1, 'Susannah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1800, 1, 'Susanne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1801, 1, 'Susie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1802, 1, 'Sutton', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1803, 1, 'Suzanna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1804, 1, 'Suzanne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1805, 1, 'Suzette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1806, 1, 'Suzie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1807, 1, 'Suzy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1808, 1, 'Sybil', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1809, 1, 'Sydney', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1810, 1, 'Sylvia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1811, 1, 'Sylvie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1812, 1, 'Tabatha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1813, 1, 'Tabitha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1814, 1, 'Tagan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1815, 1, 'Tahlia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1816, 1, 'Tala', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1817, 1, 'Talia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1818, 1, 'Talitha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1819, 1, 'Taliyah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1820, 1, 'Tallulah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1821, 1, 'Tamara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1822, 1, 'Tamera', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1823, 1, 'Tami', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1824, 1, 'Tamia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1825, 1, 'Tamika', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1826, 1, 'Tammi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1827, 1, 'Tammie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1828, 1, 'Tammy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1829, 1, 'Tamra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1830, 1, 'Tamsin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1831, 1, 'Tania', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1832, 1, 'Tanika', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1833, 1, 'Tanisha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1834, 1, 'Tanya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1835, 1, 'Tara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1836, 1, 'Taryn', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1837, 1, 'Tasha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1838, 1, 'Tasmin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1839, 1, 'Tatiana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1840, 1, 'Tatum', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1841, 1, 'Tawana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1842, 1, 'Taya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1843, 1, 'Tayah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1844, 1, 'Tayla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1845, 1, 'Taylah', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1846, 1, 'Tayler', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1847, 1, 'Taylor', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1848, 1, 'Teagan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1849, 1, 'Teegan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1850, 1, 'Tegan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1851, 1, 'Teigan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1852, 1, 'Tenille', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1853, 1, 'Teresa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1854, 1, 'Teri', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1855, 1, 'Terri', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1856, 1, 'Terrie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1857, 1, 'Terry', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1858, 1, 'Tess', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1859, 1, 'Tessa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1860, 1, 'Thalia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1861, 1, 'Thea', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1862, 1, 'Thelma', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1863, 1, 'Theodora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1864, 1, 'Theresa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1865, 1, 'Therese', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1866, 1, 'Thomasina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1867, 1, 'Tia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1868, 1, 'Tiana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1869, 1, 'Tiara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1870, 1, 'Tiegan', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1871, 1, 'Tiffany', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1872, 1, 'Tilly', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1873, 1, 'Tina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1874, 1, 'Tisha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1875, 1, 'Toni', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1876, 1, 'Tonia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1877, 1, 'Tonya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1878, 1, 'Tora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1879, 1, 'Tori', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1880, 1, 'Tracey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1881, 1, 'Traci', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1882, 1, 'Tracie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1883, 1, 'Tracy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1884, 1, 'Tricia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1885, 1, 'Trina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1886, 1, 'Trinity', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1887, 1, 'Trish', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1888, 1, 'Trisha', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1889, 1, 'Trista', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1890, 1, 'Trixie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1891, 1, 'Trixy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1892, 1, 'Trudy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1893, 1, 'Tula', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1894, 1, 'Tulip', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1895, 1, 'Tyra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1896, 1, 'Ulrica', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1897, 1, 'Uma', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1898, 1, 'Una', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1899, 1, 'Ursula', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1900, 1, 'Valentina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1901, 1, 'Valeria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1902, 1, 'Valerie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1903, 1, 'Valery', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1904, 1, 'Vanessa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1905, 1, 'Veda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1906, 1, 'Velma', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1907, 1, 'Venetia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1908, 1, 'Venus', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1909, 1, 'Vera', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1910, 1, 'Verity', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1911, 1, 'Veronica', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1912, 1, 'Vicki', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1913, 1, 'Vickie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1914, 1, 'Vicky', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1915, 1, 'Victoria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1916, 1, 'Vienna', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1917, 1, 'Viola', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1918, 1, 'Violet', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1919, 1, 'Violetta', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1920, 1, 'Virginia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1921, 1, 'Virginie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1922, 1, 'Vivian', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1923, 1, 'Viviana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1924, 1, 'Vivien', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1925, 1, 'Vivienne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1926, 1, 'Wallis', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1927, 1, 'Wanda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1928, 1, 'Waverley', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1929, 1, 'Wendi', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1930, 1, 'Wendy', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1931, 1, 'Whitney', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1932, 1, 'Wilhelmina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1933, 1, 'Willa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1934, 1, 'Willow', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1935, 1, 'Wilma', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1936, 1, 'Winifred', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1937, 1, 'Winnie', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1938, 1, 'Winnifred', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1939, 1, 'Winona', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1940, 1, 'Winter', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1941, 1, 'Xandra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1942, 1, 'Xandria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1943, 1, 'Xanthe', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1944, 1, 'Xaviera', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1945, 1, 'Xena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1946, 1, 'Xia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1947, 1, 'Ximena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1948, 1, 'Xochil', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1949, 1, 'Xochitl', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1950, 1, 'Yasmin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1951, 1, 'Yasmina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1);
INSERT INTO `tbluser` (`id`, `isBot`, `username`, `pwd`, `salt`, `count_failed_logins`, `introduction`, `email`, `createdAt`, `lastLoginAt`, `status`, `language_id`, `notifications_regularNews`, `notifications_newCompetitionInHouse`, `notifications_competitionResults`, `notifications_adsPosted`) VALUES
(1952, 1, 'Yasmine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1953, 1, 'Yazmin', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1954, 1, 'Yelena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1955, 1, 'Yesenia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1956, 1, 'Yessica', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1957, 1, 'Yolanda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1958, 1, 'Ysabel', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1959, 1, 'Yulissa', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1960, 1, 'Yvaine', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1961, 1, 'Yvette', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1962, 1, 'Yvonne', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1963, 1, 'Zada', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1964, 1, 'Zaheera', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1965, 1, 'Zahra', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1966, 1, 'Zaira', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1967, 1, 'Zakia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1968, 1, 'Zali', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1969, 1, 'Zara', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1970, 1, 'Zaria', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1971, 1, 'Zaya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1972, 1, 'Zayla', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1973, 1, 'Zelda', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1974, 1, 'Zelida', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1975, 1, 'Zelina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1976, 1, 'Zena', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1977, 1, 'Zendaya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1978, 1, 'Zia', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1979, 1, 'Zina', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1980, 1, 'Ziva', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1981, 1, 'Zoe', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1982, 1, 'Zoey', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1983, 1, 'Zola', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1984, 1, 'Zora', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1985, 1, 'Zoya', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1986, 1, 'Zula', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1987, 1, 'Zuri', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1),
(1988, 1, 'Zyana', '961fdf7006233840a29afb39928cdaf101f677058c4f7ce5d782e28e9e03e50b24cae3f483890bc2156748edc2fd82754dffb3b886cf3ad6dbeb0a15af4eadf9', 'BQLHMHIDGFCHFBCKNCAQREJAPBJQMDJGQAPCCFOLHGBBEJALCB', 0, '', '', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_ads`
--

DROP TABLE IF EXISTS `tbl_ads`;
CREATE TABLE IF NOT EXISTS `tbl_ads` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  `posted_date` date NOT NULL,
  `posted_time` date NOT NULL,
  `status_id` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_ads`
--

INSERT INTO `tbl_ads` (`id`, `user_id`, `description`, `posted_date`, `posted_time`, `status_id`) VALUES
(1, 1, 'baaaa', '2015-03-05', '0000-00-00', 1),
(2, 1, 'baaaa', '2015-03-05', '0000-00-00', 1),
(3, 1, 'baaaa', '2015-03-05', '0000-00-00', 1),
(4, 1, 'baaaa', '2015-03-05', '0000-00-00', 1),
(5, 1, 'baaaa', '2015-03-05', '0000-00-00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_ads_game_types`
--

DROP TABLE IF EXISTS `tbl_ads_game_types`;
CREATE TABLE IF NOT EXISTS `tbl_ads_game_types` (
  `id` int(11) NOT NULL,
  `ads_id` int(11) NOT NULL,
  `game_type_id` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_ads_game_types`
--

INSERT INTO `tbl_ads_game_types` (`id`, `ads_id`, `game_type_id`) VALUES
(1, 5, 1),
(2, 5, 4);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_ads_houses`
--

DROP TABLE IF EXISTS `tbl_ads_houses`;
CREATE TABLE IF NOT EXISTS `tbl_ads_houses` (
  `id` int(11) NOT NULL,
  `ads_id` int(11) NOT NULL,
  `house_id` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_ads_houses`
--

INSERT INTO `tbl_ads_houses` (`id`, `ads_id`, `house_id`) VALUES
(1, 5, 1),
(2, 5, 4);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_authentication_strings`
--

DROP TABLE IF EXISTS `tbl_authentication_strings`;
CREATE TABLE IF NOT EXISTS `tbl_authentication_strings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `createdAt_date` date NOT NULL,
  `createdAt_time` time NOT NULL,
  `txt` varchar(100) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_authentication_strings`
--

INSERT INTO `tbl_authentication_strings` (`id`, `user_id`, `createdAt_date`, `createdAt_time`, `txt`) VALUES
(7, 1, '2015-03-25', '21:09:20', 'MGOWMGOBMNOCTNWJTOIDNIXZHBKZIQLMJYMARFTWMGPDUIKEIRTURFBITACYAJSGYTHPMAXZBRMOSHIYOJZGKTWYAQLNRLIDOQZO'),
(6, 1, '2015-03-25', '20:25:24', 'TUAIPNHIFUHJMUPQMVBKGOJKOWRSPJSFQRTVYYUBFNIKNPDLBYMGDTOPMHXEAJSGYTHPMAXZBRMOSHIYOJZGKTWYAQLNRLIDOQZO'),
(5, 1, '2015-03-25', '19:53:46', 'TUAIPNHIFUHJMUPQMVBKGOJKOWRSPJSFQRTVYYUBFNIKNPDLBYMGDTOPMHXEAJSGYTHPMAXZBRMOSHIYOJZGKTWYAQLNRLIDOQZO');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_captcha`
--

DROP TABLE IF EXISTS `tbl_captcha`;
CREATE TABLE IF NOT EXISTS `tbl_captcha` (
  `id` int(11) NOT NULL,
  `code` varchar(256) NOT NULL,
  `file` varchar(1024) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_captcha`
--

INSERT INTO `tbl_captcha` (`id`, `code`, `file`) VALUES
(1, '123', 'pics/Captcha/C00002.png'),
(2, 'Fewd', 'pics/Captcha/C00001.png'),
(3, 'Zfqs', 'pics/Captcha/C00003.png'),
(4, 'KJVW', 'pics/Captcha/C00005.png'),
(5, 'LXHK', 'pics/Captcha/C00004.png'),
(6, 'PXMC', 'pics/Captcha/C00006.png'),
(7, 'GYJX', 'pics/Captcha/C00007.png'),
(8, 'VXUY', 'pics/Captcha/C00008.png');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_captcharequests`
--

DROP TABLE IF EXISTS `tbl_captcharequests`;
CREATE TABLE IF NOT EXISTS `tbl_captcharequests` (
  `id` int(11) NOT NULL,
  `createdAt_date` date NOT NULL,
  `session_id` varchar(256) NOT NULL,
  `captcha_txt` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_captcharequests`
--

INSERT INTO `tbl_captcharequests` (`id`, `createdAt_date`, `session_id`, `captcha_txt`) VALUES
(22, '2015-03-30', 'kemea4vnvkn48ii231c465tam1', 'GYJX'),
(26, '2015-03-30', 'prfkt8lv21gg2r1etn88pj4cr7', 'GYJX'),
(25, '2015-03-30', 'kemea4vnvkn48ii231c465tam1', 'PXMC'),
(24, '2015-03-30', 'kemea4vnvkn48ii231c465tam1', 'PXMC'),
(23, '2015-03-30', 'kemea4vnvkn48ii231c465tam1', 'Fewd');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_competition`
--

DROP TABLE IF EXISTS `tbl_competition`;
CREATE TABLE IF NOT EXISTS `tbl_competition` (
  `id` int(11) NOT NULL,
  `competition_template_id` int(11) NOT NULL,
  `series_number` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_competitiontemplate`
--

DROP TABLE IF EXISTS `tbl_competitiontemplate`;
CREATE TABLE IF NOT EXISTS `tbl_competitiontemplate` (
  `id` int(11) NOT NULL,
  `type_id` int(11) NOT NULL,
  `period_type_id` int(11) NOT NULL,
  `competitor_type_id` int(11) NOT NULL,
  `signup_type_id` int(11) NOT NULL,
  `game_type_id` int(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `name` varchar(256) NOT NULL,
  `description` varchar(1024) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_email`
--

DROP TABLE IF EXISTS `tbl_email`;
CREATE TABLE IF NOT EXISTS `tbl_email` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `createdAt_date` date NOT NULL,
  `createdAt_time` time NOT NULL,
  `status_id` int(11) NOT NULL,
  `language_id` int(11) NOT NULL,
  `email_type` int(11) NOT NULL,
  `address_to` varchar(1024) NOT NULL,
  `address_cc` varchar(1024) NOT NULL,
  `title` varchar(256) NOT NULL,
  `message` varchar(4000) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_email`
--

INSERT INTO `tbl_email` (`id`, `user_id`, `createdAt_date`, `createdAt_time`, `status_id`, `language_id`, `email_type`, `address_to`, `address_cc`, `title`, `message`) VALUES
(1, 1, '2015-03-18', '17:46:00', 1, 1, 1, 'matthew.baynham@gmail.com', '', 'Reset Password', '<p>Dear %1%</p><p>To resent your password please click on <a href=''%2%?x=%3%''>this link</a>.</p><p>Regards</p>'),
(2, 1, '2015-03-18', '17:56:52', 1, 1, 1, 'matthew.baynham@gmail.com', '', 'Reset Password', '<p>Dear matthew</p><p>To resent your password please click on <a href=''http://localhost?x=TUAIPNHIFUHJMUPQMVBKGOJKOWRSPJSFQRTVYYUBFNIKNPDLBYMGDTOPMHXEAJSGYTHPMAXZBRMOSHIYOJZGKTWYAQLNRLIDOQZOSJPLBYUBXWKTYMHKVDMATVKLYMIRWKGPNQEOSAKMRGIECZODAYUCGQJWUQLOFIZOMIKGZARNEHYNLODUSOSAFWZATWMIUQMXHRBQBSVZXTQFDAKGKITBGYGDIYWTROYVTQUJILBYKOKVGXGKCMXYFWYXIEBTZWYCHZIMLPMCIFQUMXNRJUKHGRHFLITXPYDOYYWTSBUYQYEPATJGNRPMLXULYPFKJOSCBGKWOYRHOSQVUZCUYSCNYEJYNEXAGEQAVTDOAYDIIUSQCAMYRPYSZCHGUSCOOYLQQAFZSJANNZXWINTRYCVYNEYIJAUEZYQAVNMYSQBUONEKSJBOOYMDSYJAWVNYMZKCYXOYHNYEYSDXRQPVBOUTNMERSRJWYXPHBAVNOGGTUMTZFSZKLEKKLDDQSRRCDYCJYDXEKRKZSKRTEZEFTTSUGMYHAUUIIVACXQXZKDRMFYTAHOHXXQXZLLSUGGGWWJCSSLSVOHVQKKKTGNGXCQDFTUYQQCRTNNOCDYLNAHBDSYMWIQRFGAVKSETWXQYGVHWZTUHJYEFWJRSGHIQYYOBLYUVKZGOYLTYQRMGJDEMXRZYCRZGXDSNQRMGDLFVDTGBLYVCTHWRUPCZAXEMCRYVKYACYOQLOJSYCSGIFNIDHJLGKMNWMHQZPDYHLNQLWRYVLGPZWDYOLVXLBSNIMWYMYYOKVQYATOYMXTOKVRFPMWZUZNCLCYHDOKYQGXTVTPENEARGYNJMYYQSQFIEQTBZJMWLJYILQYWLCYCYYYQUEORNZBZAFQYCHRURILWSDNQUEIZIUYNYBMBMRAKHYJGQPTITZOSWHRVEJUDAUDNDCYKAYCGKCGYONRHZYVSIHEBMZIUYJUKAYEWTLPGDXGSWHTQYNYHFLBGRYASJP''>this link</a>.</p><p>Regards</p>'),
(3, 1, '2015-03-18', '18:05:47', 1, 1, 1, 'matthew.baynham@gmail.com', '', 'Reset Password', '<p>Dear matthew</p><p>To resent your password please click on <a href="http://localhost?x=FGOWMGOBMNOCTNWJTOIDNIXZHBKZIQLMJYMARFTWMGPDUIKEIRTURFBITACYAJSGYTHPMAXZBRMOSHIYOJZGKTWYAQLNRLIDOQZO">this link</a>.</p><p>Regards</p>'),
(4, 1, '2015-03-19', '15:20:36', 1, 1, 1, 'matthew.baynham@gmail.com', '', 'Reset Password', '<p>Dear matthew</p><p>To resent your password please click on <a href="http://localhost?x=MGOWMGOBMNOCTNWJTOIDNIXZHBKZIQLMJYMARFTWMGPDUIKEIRTURFBITACYAJSGYTHPMAXZBRMOSHIYOJZGKTWYAQLNRLIDOQZO">this link</a>.</p><p>Regards</p>'),
(5, 1, '2015-03-20', '07:21:02', 1, 1, 1, 'matthew.baynham@gmail.com', '', 'Reset Password', '<p>Dear matthew</p><p>To resent your password please click on <a href=''http://localhost?x=TUAIPNHIFUHJMUPQMVBKGOJKOWRSPJSFQRTVYYUBFNIKNPDLBYMGDTOPMHXEAJSGYTHPMAXZBRMOSHIYOJZGKTWYAQLNRLIDOQZO''>this link</a>.</p><p>Regards</p>'),
(6, 5, '2015-03-20', '18:08:37', 1, 2, 1, 'matthew.baynham@gmail.com', '', 'Kennwort zuruecksetzen', '<p>Liebe Martina</p><p>Um Ihr Passwort zurückzusetzen, klicken Sie bitte auf <a href=''http://localhost?x=FGOWMGOBMNOCTNWJTOIDNIXZHBKZIQLMJYMARFTWMGPDUIKEIRTURFBITACYAJSGYTHPMAXZBRMOSHIYOJZGKTWYAQLNRLIDOQZO''>diesen Link.</a></p><p>Grüße</p>'),
(7, 1, '2015-03-25', '19:53:46', 1, 1, 1, 'matthew.baynham@gmail.com', '', 'Reset Password', '<p>Dear matthew</p><p>To resent your password please click on <a href=''http://localhost?x=TUAIPNHIFUHJMUPQMVBKGOJKOWRSPJSFQRTVYYUBFNIKNPDLBYMGDTOPMHXEAJSGYTHPMAXZBRMOSHIYOJZGKTWYAQLNRLIDOQZO''>this link</a>.</p><p>Regards</p>'),
(8, 1, '2015-03-25', '20:25:24', 1, 1, 1, 'matthew.baynham@gmail.com', '', 'Reset Password', '<p>Dear matthew</p><p>To resent your password please click on <a href=''http://localhost:8080/resetPassword.php?x=TUAIPNHIFUHJMUPQMVBKGOJKOWRSPJSFQRTVYYUBFNIKNPDLBYMGDTOPMHXEAJSGYTHPMAXZBRMOSHIYOJZGKTWYAQLNRLIDOQZO''>this link</a>.</p><p>Regards</p>'),
(9, 1, '2015-03-25', '21:09:20', 1, 1, 1, 'matthew.baynham@gmail.com', '', 'Reset Password', '<p>Dear matthew</p><p>To resent your password please click on <a href=''http://localhost:8080/resetPassword.php?x=MGOWMGOBMNOCTNWJTOIDNIXZHBKZIQLMJYMARFTWMGPDUIKEIRTURFBITACYAJSGYTHPMAXZBRMOSHIYOJZGKTWYAQLNRLIDOQZO''>this link</a>.</p><p>Regards</p>'),
(10, 1, '2015-04-17', '15:38:13', 1, 1, 5, 'matthew.baynham@gmail.com', '', 'Reminder: Changed User name', '<p>Dear matthew</p><p>This is just a reminder to you because you have changed your user name from matthew123 to matthew.</p><p>Regards</p>'),
(11, 1, '2015-04-17', '15:57:05', 1, 1, 5, 'matthew.baynham@gmail.com', '', 'Reminder: Changed User name', '<p>Dear matthew99</p><p>This is just a reminder to you because you have changed your user name from matthew to matthew99.</p><p>Regards</p>'),
(12, 1, '2015-04-17', '15:57:13', 1, 1, 5, 'matthew.baynham@gmail.com', '', 'Reminder: Changed User name', '<p>Dear matthew</p><p>This is just a reminder to you because you have changed your user name from matthew99 to matthew.</p><p>Regards</p>');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_games`
--

DROP TABLE IF EXISTS `tbl_games`;
CREATE TABLE IF NOT EXISTS `tbl_games` (
  `id` int(11) NOT NULL,
  `last_move_id` int(11) NOT NULL DEFAULT '0',
  `player_white_id` int(11) NOT NULL,
  `player_black_id` int(11) NOT NULL,
  `whos_turn_next_id` int(11) NOT NULL,
  `game_type` int(11) NOT NULL,
  `status_id` int(11) NOT NULL,
  `startedAt_date` date NOT NULL,
  `startedAt_time` time NOT NULL,
  `endedAt_date` date DEFAULT NULL,
  `endedAt_time` time DEFAULT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=148 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_games`
--

INSERT INTO `tbl_games` (`id`, `last_move_id`, `player_white_id`, `player_black_id`, `whos_turn_next_id`, `game_type`, `status_id`, `startedAt_date`, `startedAt_time`, `endedAt_date`, `endedAt_time`, `description`) VALUES
(123, 1, 1, 2, 2, 1, 1, '2015-02-10', '16:05:16', NULL, NULL, ''),
(124, 1, 1, 2, 2, 1, 1, '2015-02-10', '18:16:50', NULL, NULL, ''),
(125, 1, 1, 2, 2, 1, 1, '2015-02-12', '10:54:39', NULL, NULL, ''),
(126, 0, 1, 2, 1, 1, 1, '2015-02-12', '14:57:28', NULL, NULL, ''),
(127, 0, 1, 2, 1, 1, 1, '2015-02-12', '15:38:24', NULL, NULL, ''),
(128, 0, 1, 2, 1, 1, 1, '2015-02-12', '15:44:02', NULL, NULL, ''),
(129, 0, 1, 2, 1, 1, 1, '2015-02-12', '16:05:59', NULL, NULL, ''),
(130, 1, 1, 2, 2, 1, 1, '2015-02-12', '16:08:42', NULL, NULL, ''),
(131, 1, 1, 2, 2, 1, 1, '2015-02-12', '16:51:09', NULL, NULL, ''),
(132, 1, 1, 2, 2, 1, 1, '2015-02-12', '20:29:21', NULL, NULL, ''),
(133, 0, 1, 2, 1, 1, 1, '2015-02-18', '20:56:22', NULL, NULL, ''),
(134, 0, 1, 2, 1, 1, 1, '2015-02-27', '13:46:21', NULL, NULL, ''),
(135, 0, 1, 2, 1, 1, 1, '2015-02-27', '16:08:33', NULL, NULL, ''),
(136, 0, 1, 2, 1, 1, 1, '2015-02-27', '17:12:04', NULL, NULL, ''),
(137, 1, 1, 4, 4, 4, 1, '2015-02-27', '17:46:15', NULL, NULL, ''),
(138, 0, 1, 2, 1, 1, 1, '2015-03-01', '18:34:27', NULL, NULL, ''),
(139, 0, 2, 1, 2, 1, 1, '2015-03-04', '16:14:53', NULL, NULL, ''),
(140, 3, 1, 5, 5, 1, 1, '2015-03-04', '17:37:52', NULL, NULL, ''),
(141, 1, 5, 1, 1, 1, 1, '2015-03-04', '17:41:15', NULL, NULL, ''),
(142, 0, 1, 5, 1, 1, 1, '2015-03-04', '17:49:54', NULL, NULL, ''),
(143, 2, 1, 5, 1, 1, 1, '2015-03-04', '17:51:20', NULL, NULL, ''),
(144, 0, 1, 3, 1, 2, 1, '2015-03-30', '17:06:29', NULL, NULL, ''),
(145, 1, 1, 2, 2, 1, 1, '2015-03-30', '17:06:45', NULL, NULL, ''),
(146, 1, 5, 2, 2, 1, 1, '2015-03-30', '19:14:55', NULL, NULL, ''),
(147, 1, 5, 2, 2, 1, 1, '2015-03-30', '19:18:39', NULL, NULL, '');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_game_all_moves`
--

DROP TABLE IF EXISTS `tbl_game_all_moves`;
CREATE TABLE IF NOT EXISTS `tbl_game_all_moves` (
  `id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `piece_id` int(11) NOT NULL,
  `colour_id` int(11) NOT NULL,
  `square_no` int(11) NOT NULL,
  `move_type` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=254 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_game_all_moves`
--

INSERT INTO `tbl_game_all_moves` (`id`, `game_id`, `piece_id`, `colour_id`, `square_no`, `move_type`) VALUES
(238, 123, 23, 1, 33, 1),
(239, 124, 14, 1, 35, 1),
(240, 130, 8, 1, 16, 1),
(241, 131, 8, 1, 25, 1),
(242, 132, 22, 1, 35, 1),
(243, 137, 31, 1, 64, 1),
(244, 125, 23, 1, 33, 1),
(245, 140, 22, 1, 35, 1),
(246, 143, 23, 1, 34, 1),
(247, 145, 23, 1, 33, 1),
(248, 143, 9, 2, 26, 1),
(249, 140, 8, 2, 33, 1),
(250, 141, 23, 1, 33, 1),
(251, 146, 23, 1, 33, 1),
(252, 147, 4, 1, 25, 1),
(253, 140, 23, 1, 24, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_game_current_positions`
--

DROP TABLE IF EXISTS `tbl_game_current_positions`;
CREATE TABLE IF NOT EXISTS `tbl_game_current_positions` (
  `id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `piece_id` int(11) NOT NULL,
  `colour_id` int(11) NOT NULL,
  `square_no` int(11) NOT NULL,
  `move_type` int(11) NOT NULL,
  `piece_type_id` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3517 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_game_current_positions`
--

INSERT INTO `tbl_game_current_positions` (`id`, `game_id`, `piece_id`, `colour_id`, `square_no`, `move_type`, `piece_type_id`) VALUES
(2905, 123, 1, 1, 0, 4, 1),
(2906, 123, 2, 1, 2, 4, 1),
(2907, 123, 3, 1, 4, 4, 1),
(2908, 123, 4, 1, 6, 4, 1),
(2909, 123, 5, 1, 9, 4, 1),
(2910, 123, 6, 1, 11, 4, 1),
(2911, 123, 7, 1, 13, 4, 1),
(2912, 123, 8, 1, 15, 4, 1),
(2913, 123, 9, 1, 16, 4, 1),
(2914, 123, 10, 1, 18, 4, 1),
(2915, 123, 11, 1, 20, 4, 1),
(2916, 123, 12, 1, 22, 4, 1),
(2917, 123, 13, 2, 62, 4, 1),
(2918, 123, 14, 2, 60, 4, 1),
(2919, 123, 15, 2, 58, 4, 1),
(2920, 123, 16, 2, 56, 4, 1),
(2921, 123, 17, 2, 55, 4, 1),
(2922, 123, 18, 2, 53, 4, 1),
(2923, 123, 19, 2, 51, 4, 1),
(2924, 123, 20, 2, 49, 4, 1),
(2925, 123, 21, 2, 46, 4, 1),
(2926, 123, 22, 2, 44, 4, 1),
(2927, 123, 23, 2, 33, 4, 1),
(2928, 123, 24, 2, 40, 4, 1),
(2929, 124, 1, 1, 0, 4, 1),
(2930, 124, 2, 1, 2, 4, 1),
(2931, 124, 3, 1, 4, 4, 1),
(2932, 124, 4, 1, 6, 4, 1),
(2933, 124, 5, 1, 9, 4, 1),
(2934, 124, 6, 1, 11, 4, 1),
(2935, 124, 7, 1, 13, 4, 1),
(2936, 124, 8, 1, 15, 4, 1),
(2937, 124, 9, 1, 16, 4, 1),
(2938, 124, 10, 1, 18, 4, 1),
(2939, 124, 11, 1, 20, 4, 1),
(2940, 124, 12, 1, 22, 4, 1),
(2941, 124, 13, 2, 62, 4, 1),
(2942, 124, 14, 2, 35, 4, 1),
(2943, 124, 15, 2, 58, 4, 1),
(2944, 124, 16, 2, 56, 4, 1),
(2945, 124, 17, 2, 55, 4, 1),
(2946, 124, 18, 2, 53, 4, 1),
(2947, 124, 19, 2, 51, 4, 1),
(2948, 124, 20, 2, 49, 4, 1),
(2949, 124, 21, 2, 46, 4, 1),
(2950, 124, 22, 2, 44, 4, 1),
(2951, 124, 23, 2, 42, 4, 1),
(2952, 124, 24, 2, 40, 4, 1),
(2953, 125, 1, 1, 0, 4, 1),
(2954, 125, 2, 1, 2, 4, 1),
(2955, 125, 3, 1, 4, 4, 1),
(2956, 125, 4, 1, 6, 4, 1),
(2957, 125, 5, 1, 9, 4, 1),
(2958, 125, 6, 1, 11, 4, 1),
(2959, 125, 7, 1, 13, 4, 1),
(2960, 125, 8, 1, 15, 4, 1),
(2961, 125, 9, 1, 16, 4, 1),
(2962, 125, 10, 1, 18, 4, 1),
(2963, 125, 11, 1, 20, 4, 1),
(2964, 125, 12, 1, 22, 4, 1),
(2965, 125, 13, 2, 62, 4, 1),
(2966, 125, 14, 2, 60, 4, 1),
(2967, 125, 15, 2, 58, 4, 1),
(2968, 125, 16, 2, 56, 4, 1),
(2969, 125, 17, 2, 55, 4, 1),
(2970, 125, 18, 2, 53, 4, 1),
(2971, 125, 19, 2, 51, 4, 1),
(2972, 125, 20, 2, 49, 4, 1),
(2973, 125, 21, 2, 46, 4, 1),
(2974, 125, 22, 2, 44, 4, 1),
(2975, 125, 23, 2, 33, 4, 1),
(2976, 125, 24, 2, 40, 4, 1),
(2977, 126, 1, 1, 0, 4, 1),
(2978, 126, 2, 1, 2, 4, 1),
(2979, 126, 3, 1, 4, 4, 1),
(2980, 126, 4, 1, 6, 4, 1),
(2981, 126, 5, 1, 9, 4, 1),
(2982, 126, 6, 1, 11, 4, 1),
(2983, 126, 7, 1, 13, 4, 1),
(2984, 126, 8, 1, 15, 4, 1),
(2985, 126, 9, 1, 16, 4, 1),
(2986, 126, 10, 1, 18, 4, 1),
(2987, 126, 11, 1, 20, 4, 1),
(2988, 126, 12, 1, 22, 4, 1),
(2989, 126, 13, 2, 62, 4, 1),
(2990, 126, 14, 2, 60, 4, 1),
(2991, 126, 15, 2, 58, 4, 1),
(2992, 126, 16, 2, 56, 4, 1),
(2993, 126, 17, 2, 55, 4, 1),
(2994, 126, 18, 2, 53, 4, 1),
(2995, 126, 19, 2, 51, 4, 1),
(2996, 126, 20, 2, 49, 4, 1),
(2997, 126, 21, 2, 46, 4, 1),
(2998, 126, 22, 2, 44, 4, 1),
(2999, 126, 23, 2, 42, 4, 1),
(3000, 126, 24, 2, 40, 4, 1),
(3001, 127, 1, 1, 0, 4, 1),
(3002, 127, 2, 1, 2, 4, 1),
(3003, 127, 3, 1, 4, 4, 1),
(3004, 127, 4, 1, 6, 4, 1),
(3005, 127, 5, 1, 9, 4, 1),
(3006, 127, 6, 1, 11, 4, 1),
(3007, 127, 7, 1, 13, 4, 1),
(3008, 127, 8, 1, 15, 4, 1),
(3009, 127, 9, 1, 16, 4, 1),
(3010, 127, 10, 1, 18, 4, 1),
(3011, 127, 11, 1, 20, 4, 1),
(3012, 127, 12, 1, 22, 4, 1),
(3013, 127, 13, 2, 62, 4, 1),
(3014, 127, 14, 2, 60, 4, 1),
(3015, 127, 15, 2, 58, 4, 1),
(3016, 127, 16, 2, 56, 4, 1),
(3017, 127, 17, 2, 55, 4, 1),
(3018, 127, 18, 2, 53, 4, 1),
(3019, 127, 19, 2, 51, 4, 1),
(3020, 127, 20, 2, 49, 4, 1),
(3021, 127, 21, 2, 46, 4, 1),
(3022, 127, 22, 2, 44, 4, 1),
(3023, 127, 23, 2, 42, 4, 1),
(3024, 127, 24, 2, 40, 4, 1),
(3025, 128, 1, 1, 0, 4, 1),
(3026, 128, 2, 1, 2, 4, 1),
(3027, 128, 3, 1, 4, 4, 1),
(3028, 128, 4, 1, 6, 4, 1),
(3029, 128, 5, 1, 9, 4, 1),
(3030, 128, 6, 1, 11, 4, 1),
(3031, 128, 7, 1, 13, 4, 1),
(3032, 128, 8, 1, 15, 4, 1),
(3033, 128, 9, 1, 16, 4, 1),
(3034, 128, 10, 1, 18, 4, 1),
(3035, 128, 11, 1, 20, 4, 1),
(3036, 128, 12, 1, 22, 4, 1),
(3037, 128, 13, 2, 62, 4, 1),
(3038, 128, 14, 2, 60, 4, 1),
(3039, 128, 15, 2, 58, 4, 1),
(3040, 128, 16, 2, 56, 4, 1),
(3041, 128, 17, 2, 55, 4, 1),
(3042, 128, 18, 2, 53, 4, 1),
(3043, 128, 19, 2, 51, 4, 1),
(3044, 128, 20, 2, 49, 4, 1),
(3045, 128, 21, 2, 46, 4, 1),
(3046, 128, 22, 2, 44, 4, 1),
(3047, 128, 23, 2, 42, 4, 1),
(3048, 128, 24, 2, 40, 4, 1),
(3049, 129, 1, 1, 0, 4, 1),
(3050, 129, 2, 1, 2, 4, 1),
(3051, 129, 3, 1, 4, 4, 1),
(3052, 129, 4, 1, 6, 4, 1),
(3053, 129, 5, 1, 9, 4, 1),
(3054, 129, 6, 1, 11, 4, 1),
(3055, 129, 7, 1, 13, 4, 1),
(3056, 129, 8, 1, 15, 4, 1),
(3057, 129, 9, 1, 16, 4, 1),
(3058, 129, 10, 1, 18, 4, 1),
(3059, 129, 11, 1, 20, 4, 1),
(3060, 129, 12, 1, 22, 4, 1),
(3061, 129, 13, 2, 62, 4, 1),
(3062, 129, 14, 2, 60, 4, 1),
(3063, 129, 15, 2, 58, 4, 1),
(3064, 129, 16, 2, 56, 4, 1),
(3065, 129, 17, 2, 55, 4, 1),
(3066, 129, 18, 2, 53, 4, 1),
(3067, 129, 19, 2, 51, 4, 1),
(3068, 129, 20, 2, 49, 4, 1),
(3069, 129, 21, 2, 46, 4, 1),
(3070, 129, 22, 2, 44, 4, 1),
(3071, 129, 23, 2, 42, 4, 1),
(3072, 129, 24, 2, 40, 4, 1),
(3073, 130, 1, 1, 0, 4, 1),
(3074, 130, 2, 1, 2, 4, 1),
(3075, 130, 3, 1, 4, 4, 1),
(3076, 130, 4, 1, 6, 4, 1),
(3077, 130, 5, 1, 9, 4, 1),
(3078, 130, 6, 1, 11, 4, 1),
(3079, 130, 7, 1, 13, 4, 1),
(3080, 130, 8, 1, 16, 4, 1),
(3081, 130, 9, 1, 16, 4, 1),
(3082, 130, 10, 1, 18, 4, 1),
(3083, 130, 11, 1, 20, 4, 1),
(3084, 130, 12, 1, 22, 4, 1),
(3085, 130, 13, 2, 62, 4, 1),
(3086, 130, 14, 2, 60, 4, 1),
(3087, 130, 15, 2, 58, 4, 1),
(3088, 130, 16, 2, 56, 4, 1),
(3089, 130, 17, 2, 55, 4, 1),
(3090, 130, 18, 2, 53, 4, 1),
(3091, 130, 19, 2, 51, 4, 1),
(3092, 130, 20, 2, 49, 4, 1),
(3093, 130, 21, 2, 46, 4, 1),
(3094, 130, 22, 2, 44, 4, 1),
(3095, 130, 23, 2, 42, 4, 1),
(3096, 130, 24, 2, 40, 4, 1),
(3097, 131, 1, 1, 0, 4, 1),
(3098, 131, 2, 1, 2, 4, 1),
(3099, 131, 3, 1, 4, 4, 1),
(3100, 131, 4, 1, 6, 4, 1),
(3101, 131, 5, 1, 9, 4, 1),
(3102, 131, 6, 1, 11, 4, 1),
(3103, 131, 7, 1, 13, 4, 1),
(3104, 131, 8, 1, 25, 4, 1),
(3105, 131, 9, 1, 16, 4, 1),
(3106, 131, 10, 1, 18, 4, 1),
(3107, 131, 11, 1, 20, 4, 1),
(3108, 131, 12, 1, 22, 4, 1),
(3109, 131, 13, 2, 62, 4, 1),
(3110, 131, 14, 2, 60, 4, 1),
(3111, 131, 15, 2, 58, 4, 1),
(3112, 131, 16, 2, 56, 4, 1),
(3113, 131, 17, 2, 55, 4, 1),
(3114, 131, 18, 2, 53, 4, 1),
(3115, 131, 19, 2, 51, 4, 1),
(3116, 131, 20, 2, 49, 4, 1),
(3117, 131, 21, 2, 46, 4, 1),
(3118, 131, 22, 2, 44, 4, 1),
(3119, 131, 23, 2, 42, 4, 1),
(3120, 131, 24, 2, 40, 4, 1),
(3121, 132, 1, 1, 0, 4, 1),
(3122, 132, 2, 1, 2, 4, 1),
(3123, 132, 3, 1, 4, 4, 1),
(3124, 132, 4, 1, 6, 4, 1),
(3125, 132, 5, 1, 9, 4, 1),
(3126, 132, 6, 1, 11, 4, 1),
(3127, 132, 7, 1, 13, 4, 1),
(3128, 132, 8, 1, 15, 4, 1),
(3129, 132, 9, 1, 16, 4, 1),
(3130, 132, 10, 1, 18, 4, 1),
(3131, 132, 11, 1, 20, 4, 1),
(3132, 132, 12, 1, 22, 4, 1),
(3133, 132, 13, 2, 62, 4, 1),
(3134, 132, 14, 2, 60, 4, 1),
(3135, 132, 15, 2, 58, 4, 1),
(3136, 132, 16, 2, 56, 4, 1),
(3137, 132, 17, 2, 55, 4, 1),
(3138, 132, 18, 2, 53, 4, 1),
(3139, 132, 19, 2, 51, 4, 1),
(3140, 132, 20, 2, 49, 4, 1),
(3141, 132, 21, 2, 46, 4, 1),
(3142, 132, 22, 2, 35, 4, 1),
(3143, 132, 23, 2, 42, 4, 1),
(3144, 132, 24, 2, 40, 4, 1),
(3145, 133, 1, 1, 0, 4, 1),
(3146, 133, 2, 1, 2, 4, 1),
(3147, 133, 3, 1, 4, 4, 1),
(3148, 133, 4, 1, 6, 4, 1),
(3149, 133, 5, 1, 9, 4, 1),
(3150, 133, 6, 1, 11, 4, 1),
(3151, 133, 7, 1, 13, 4, 1),
(3152, 133, 8, 1, 15, 4, 1),
(3153, 133, 9, 1, 16, 4, 1),
(3154, 133, 10, 1, 18, 4, 1),
(3155, 133, 11, 1, 20, 4, 1),
(3156, 133, 12, 1, 22, 4, 1),
(3157, 133, 13, 2, 62, 4, 1),
(3158, 133, 14, 2, 60, 4, 1),
(3159, 133, 15, 2, 58, 4, 1),
(3160, 133, 16, 2, 56, 4, 1),
(3161, 133, 17, 2, 55, 4, 1),
(3162, 133, 18, 2, 53, 4, 1),
(3163, 133, 19, 2, 51, 4, 1),
(3164, 133, 20, 2, 49, 4, 1),
(3165, 133, 21, 2, 46, 4, 1),
(3166, 133, 22, 2, 44, 4, 1),
(3167, 133, 23, 2, 42, 4, 1),
(3168, 133, 24, 2, 40, 4, 1),
(3169, 134, 1, 1, 0, 4, 1),
(3170, 134, 2, 1, 2, 4, 1),
(3171, 134, 3, 1, 4, 4, 1),
(3172, 134, 4, 1, 6, 4, 1),
(3173, 134, 5, 1, 9, 4, 1),
(3174, 134, 6, 1, 11, 4, 1),
(3175, 134, 7, 1, 13, 4, 1),
(3176, 134, 8, 1, 15, 4, 1),
(3177, 134, 9, 1, 16, 4, 1),
(3178, 134, 10, 1, 18, 4, 1),
(3179, 134, 11, 1, 20, 4, 1),
(3180, 134, 12, 1, 22, 4, 1),
(3181, 134, 13, 2, 62, 4, 1),
(3182, 134, 14, 2, 60, 4, 1),
(3183, 134, 15, 2, 58, 4, 1),
(3184, 134, 16, 2, 56, 4, 1),
(3185, 134, 17, 2, 55, 4, 1),
(3186, 134, 18, 2, 53, 4, 1),
(3187, 134, 19, 2, 51, 4, 1),
(3188, 134, 20, 2, 49, 4, 1),
(3189, 134, 21, 2, 46, 4, 1),
(3190, 134, 22, 2, 44, 4, 1),
(3191, 134, 23, 2, 42, 4, 1),
(3192, 134, 24, 2, 40, 4, 1),
(3193, 135, 1, 1, 0, 4, 1),
(3194, 135, 2, 1, 2, 4, 1),
(3195, 135, 3, 1, 4, 4, 1),
(3196, 135, 4, 1, 6, 4, 1),
(3197, 135, 5, 1, 9, 4, 1),
(3198, 135, 6, 1, 11, 4, 1),
(3199, 135, 7, 1, 13, 4, 1),
(3200, 135, 8, 1, 15, 4, 1),
(3201, 135, 9, 1, 16, 4, 1),
(3202, 135, 10, 1, 18, 4, 1),
(3203, 135, 11, 1, 20, 4, 1),
(3204, 135, 12, 1, 22, 4, 1),
(3205, 135, 13, 2, 62, 4, 1),
(3206, 135, 14, 2, 60, 4, 1),
(3207, 135, 15, 2, 58, 4, 1),
(3208, 135, 16, 2, 56, 4, 1),
(3209, 135, 17, 2, 55, 4, 1),
(3210, 135, 18, 2, 53, 4, 1),
(3211, 135, 19, 2, 51, 4, 1),
(3212, 135, 20, 2, 49, 4, 1),
(3213, 135, 21, 2, 46, 4, 1),
(3214, 135, 22, 2, 44, 4, 1),
(3215, 135, 23, 2, 42, 4, 1),
(3216, 135, 24, 2, 40, 4, 1),
(3217, 136, 1, 1, 0, 4, 1),
(3218, 136, 2, 1, 2, 4, 1),
(3219, 136, 3, 1, 4, 4, 1),
(3220, 136, 4, 1, 6, 4, 1),
(3221, 136, 5, 1, 9, 4, 1),
(3222, 136, 6, 1, 11, 4, 1),
(3223, 136, 7, 1, 13, 4, 1),
(3224, 136, 8, 1, 15, 4, 1),
(3225, 136, 9, 1, 16, 4, 1),
(3226, 136, 10, 1, 18, 4, 1),
(3227, 136, 11, 1, 20, 4, 1),
(3228, 136, 12, 1, 22, 4, 1),
(3229, 136, 13, 2, 62, 4, 1),
(3230, 136, 14, 2, 60, 4, 1),
(3231, 136, 15, 2, 58, 4, 1),
(3232, 136, 16, 2, 56, 4, 1),
(3233, 136, 17, 2, 55, 4, 1),
(3234, 136, 18, 2, 53, 4, 1),
(3235, 136, 19, 2, 51, 4, 1),
(3236, 136, 20, 2, 49, 4, 1),
(3237, 136, 21, 2, 46, 4, 1),
(3238, 136, 22, 2, 44, 4, 1),
(3239, 136, 23, 2, 42, 4, 1),
(3240, 136, 24, 2, 40, 4, 1),
(3241, 137, 1, 1, 1, 4, 1),
(3242, 137, 2, 1, 3, 4, 1),
(3243, 137, 3, 1, 5, 4, 1),
(3244, 137, 4, 1, 7, 4, 1),
(3245, 137, 5, 1, 9, 4, 1),
(3246, 137, 6, 1, 11, 4, 1),
(3247, 137, 7, 1, 12, 4, 1),
(3248, 137, 8, 1, 14, 4, 1),
(3249, 137, 9, 1, 16, 4, 1),
(3250, 137, 10, 1, 18, 4, 1),
(3251, 137, 11, 1, 20, 4, 1),
(3252, 137, 12, 1, 22, 4, 1),
(3253, 137, 13, 1, 25, 4, 1),
(3254, 137, 14, 1, 27, 4, 1),
(3255, 137, 15, 1, 29, 4, 1),
(3256, 137, 16, 1, 31, 4, 1),
(3257, 137, 17, 1, 33, 4, 1),
(3258, 137, 18, 1, 35, 4, 1),
(3259, 137, 19, 1, 36, 4, 1),
(3260, 137, 20, 1, 38, 4, 1),
(3261, 137, 21, 1, 40, 4, 1),
(3262, 137, 22, 1, 42, 4, 1),
(3263, 137, 23, 1, 44, 4, 1),
(3264, 137, 24, 1, 46, 4, 1),
(3265, 137, 25, 1, 49, 4, 1),
(3266, 137, 26, 1, 51, 4, 1),
(3267, 137, 27, 1, 53, 4, 1),
(3268, 137, 28, 1, 55, 4, 1),
(3269, 137, 29, 1, 57, 4, 1),
(3270, 137, 30, 1, 59, 4, 1),
(3271, 137, 31, 2, 64, 4, 1),
(3272, 137, 32, 2, 86, 4, 1),
(3273, 137, 33, 2, 88, 4, 1),
(3274, 137, 34, 2, 90, 4, 1),
(3275, 137, 35, 2, 92, 4, 1),
(3276, 137, 36, 2, 94, 4, 1),
(3277, 137, 37, 2, 97, 4, 1),
(3278, 137, 38, 2, 99, 4, 1),
(3279, 137, 39, 2, 101, 4, 1),
(3280, 137, 40, 2, 103, 4, 1),
(3281, 137, 41, 2, 105, 4, 1),
(3282, 137, 42, 2, 107, 4, 1),
(3283, 137, 43, 2, 108, 4, 1),
(3284, 137, 44, 2, 110, 4, 1),
(3285, 137, 45, 2, 112, 4, 1),
(3286, 137, 46, 2, 114, 4, 1),
(3287, 137, 47, 2, 116, 4, 1),
(3288, 137, 48, 2, 118, 4, 1),
(3289, 137, 49, 2, 121, 4, 1),
(3290, 137, 50, 2, 123, 4, 1),
(3291, 137, 51, 2, 125, 4, 1),
(3292, 137, 52, 2, 127, 4, 1),
(3293, 137, 53, 2, 129, 4, 1),
(3294, 137, 54, 2, 131, 4, 1),
(3295, 137, 55, 2, 132, 4, 1),
(3296, 137, 56, 2, 134, 4, 1),
(3297, 137, 57, 2, 136, 4, 1),
(3298, 137, 58, 2, 138, 4, 1),
(3299, 137, 59, 2, 140, 4, 1),
(3300, 137, 60, 2, 142, 4, 1),
(3301, 138, 1, 1, 0, 4, 1),
(3302, 138, 2, 1, 2, 4, 1),
(3303, 138, 3, 1, 4, 4, 1),
(3304, 138, 4, 1, 6, 4, 1),
(3305, 138, 5, 1, 9, 4, 1),
(3306, 138, 6, 1, 11, 4, 1),
(3307, 138, 7, 1, 13, 4, 1),
(3308, 138, 8, 1, 15, 4, 1),
(3309, 138, 9, 1, 16, 4, 1),
(3310, 138, 10, 1, 18, 4, 1),
(3311, 138, 11, 1, 20, 4, 1),
(3312, 138, 12, 1, 22, 4, 1),
(3313, 138, 13, 2, 62, 4, 1),
(3314, 138, 14, 2, 60, 4, 1),
(3315, 138, 15, 2, 58, 4, 1),
(3316, 138, 16, 2, 56, 4, 1),
(3317, 138, 17, 2, 55, 4, 1),
(3318, 138, 18, 2, 53, 4, 1),
(3319, 138, 19, 2, 51, 4, 1),
(3320, 138, 20, 2, 49, 4, 1),
(3321, 138, 21, 2, 46, 4, 1),
(3322, 138, 22, 2, 44, 4, 1),
(3323, 138, 23, 2, 42, 4, 1),
(3324, 138, 24, 2, 40, 4, 1),
(3325, 139, 1, 1, 0, 4, 1),
(3326, 139, 2, 1, 2, 4, 1),
(3327, 139, 3, 1, 4, 4, 1),
(3328, 139, 4, 1, 6, 4, 1),
(3329, 139, 5, 1, 9, 4, 1),
(3330, 139, 6, 1, 11, 4, 1),
(3331, 139, 7, 1, 13, 4, 1),
(3332, 139, 8, 1, 15, 4, 1),
(3333, 139, 9, 1, 16, 4, 1),
(3334, 139, 10, 1, 18, 4, 1),
(3335, 139, 11, 1, 20, 4, 1),
(3336, 139, 12, 1, 22, 4, 1),
(3337, 139, 13, 2, 62, 4, 1),
(3338, 139, 14, 2, 60, 4, 1),
(3339, 139, 15, 2, 58, 4, 1),
(3340, 139, 16, 2, 56, 4, 1),
(3341, 139, 17, 2, 55, 4, 1),
(3342, 139, 18, 2, 53, 4, 1),
(3343, 139, 19, 2, 51, 4, 1),
(3344, 139, 20, 2, 49, 4, 1),
(3345, 139, 21, 2, 46, 4, 1),
(3346, 139, 22, 2, 44, 4, 1),
(3347, 139, 23, 2, 42, 4, 1),
(3348, 139, 24, 2, 40, 4, 1),
(3349, 140, 1, 1, 0, 4, 1),
(3350, 140, 2, 1, 2, 4, 1),
(3351, 140, 3, 1, 4, 4, 1),
(3352, 140, 4, 1, 6, 4, 1),
(3353, 140, 5, 1, 9, 4, 1),
(3354, 140, 6, 1, 11, 4, 1),
(3355, 140, 7, 1, 13, 4, 1),
(3356, 140, 8, 1, 33, 4, 1),
(3357, 140, 9, 1, 16, 4, 1),
(3358, 140, 10, 1, 18, 4, 1),
(3359, 140, 11, 1, 20, 4, 1),
(3360, 140, 12, 1, 22, 4, 1),
(3361, 140, 13, 2, 62, 4, 1),
(3362, 140, 14, 2, 60, 4, 1),
(3363, 140, 15, 2, 58, 4, 1),
(3364, 140, 16, 2, 56, 4, 1),
(3365, 140, 17, 2, 55, 4, 1),
(3366, 140, 18, 2, 53, 4, 1),
(3367, 140, 19, 2, 51, 4, 1),
(3368, 140, 20, 2, 49, 4, 1),
(3369, 140, 21, 2, 46, 4, 1),
(3370, 140, 22, 2, 35, 4, 1),
(3371, 140, 23, 2, 24, 4, 1),
(3372, 140, 24, 2, 40, 4, 1),
(3373, 141, 1, 1, 0, 4, 1),
(3374, 141, 2, 1, 2, 4, 1),
(3375, 141, 3, 1, 4, 4, 1),
(3376, 141, 4, 1, 6, 4, 1),
(3377, 141, 5, 1, 9, 4, 1),
(3378, 141, 6, 1, 11, 4, 1),
(3379, 141, 7, 1, 13, 4, 1),
(3380, 141, 8, 1, 15, 4, 1),
(3381, 141, 9, 1, 16, 4, 1),
(3382, 141, 10, 1, 18, 4, 1),
(3383, 141, 11, 1, 20, 4, 1),
(3384, 141, 12, 1, 22, 4, 1),
(3385, 141, 13, 2, 62, 4, 1),
(3386, 141, 14, 2, 60, 4, 1),
(3387, 141, 15, 2, 58, 4, 1),
(3388, 141, 16, 2, 56, 4, 1),
(3389, 141, 17, 2, 55, 4, 1),
(3390, 141, 18, 2, 53, 4, 1),
(3391, 141, 19, 2, 51, 4, 1),
(3392, 141, 20, 2, 49, 4, 1),
(3393, 141, 21, 2, 46, 4, 1),
(3394, 141, 22, 2, 44, 4, 1),
(3395, 141, 23, 2, 33, 4, 1),
(3396, 141, 24, 2, 40, 4, 1),
(3397, 142, 1, 1, 0, 4, 1),
(3398, 142, 2, 1, 2, 4, 1),
(3399, 142, 3, 1, 4, 4, 1),
(3400, 142, 4, 1, 6, 4, 1),
(3401, 142, 5, 1, 9, 4, 1),
(3402, 142, 6, 1, 11, 4, 1),
(3403, 142, 7, 1, 13, 4, 1),
(3404, 142, 8, 1, 15, 4, 1),
(3405, 142, 9, 1, 16, 4, 1),
(3406, 142, 10, 1, 18, 4, 1),
(3407, 142, 11, 1, 20, 4, 1),
(3408, 142, 12, 1, 22, 4, 1),
(3409, 142, 13, 2, 62, 4, 1),
(3410, 142, 14, 2, 60, 4, 1),
(3411, 142, 15, 2, 58, 4, 1),
(3412, 142, 16, 2, 56, 4, 1),
(3413, 142, 17, 2, 55, 4, 1),
(3414, 142, 18, 2, 53, 4, 1),
(3415, 142, 19, 2, 51, 4, 1),
(3416, 142, 20, 2, 49, 4, 1),
(3417, 142, 21, 2, 46, 4, 1),
(3418, 142, 22, 2, 44, 4, 1),
(3419, 142, 23, 2, 42, 4, 1),
(3420, 142, 24, 2, 40, 4, 1),
(3421, 143, 1, 1, 0, 4, 1),
(3422, 143, 2, 1, 2, 4, 1),
(3423, 143, 3, 1, 4, 4, 1),
(3424, 143, 4, 1, 6, 4, 1),
(3425, 143, 5, 1, 9, 4, 1),
(3426, 143, 6, 1, 11, 4, 1),
(3427, 143, 7, 1, 13, 4, 1),
(3428, 143, 8, 1, 15, 4, 1),
(3429, 143, 9, 1, 26, 4, 1),
(3430, 143, 10, 1, 18, 4, 1),
(3431, 143, 11, 1, 20, 4, 1),
(3432, 143, 12, 1, 22, 4, 1),
(3433, 143, 13, 2, 62, 4, 1),
(3434, 143, 14, 2, 60, 4, 1),
(3435, 143, 15, 2, 58, 4, 1),
(3436, 143, 16, 2, 56, 4, 1),
(3437, 143, 17, 2, 55, 4, 1),
(3438, 143, 18, 2, 53, 4, 1),
(3439, 143, 19, 2, 51, 4, 1),
(3440, 143, 20, 2, 49, 4, 1),
(3441, 143, 21, 2, 46, 4, 1),
(3442, 143, 22, 2, 44, 4, 1),
(3443, 143, 23, 2, 34, 4, 1),
(3444, 143, 24, 2, 40, 4, 1),
(3445, 145, 1, 1, 0, 4, 1),
(3446, 145, 2, 1, 2, 4, 1),
(3447, 145, 3, 1, 4, 4, 1),
(3448, 145, 4, 1, 6, 4, 1),
(3449, 145, 5, 1, 9, 4, 1),
(3450, 145, 6, 1, 11, 4, 1),
(3451, 145, 7, 1, 13, 4, 1),
(3452, 145, 8, 1, 15, 4, 1),
(3453, 145, 9, 1, 16, 4, 1),
(3454, 145, 10, 1, 18, 4, 1),
(3455, 145, 11, 1, 20, 4, 1),
(3456, 145, 12, 1, 22, 4, 1),
(3457, 145, 13, 2, 62, 4, 1),
(3458, 145, 14, 2, 60, 4, 1),
(3459, 145, 15, 2, 58, 4, 1),
(3460, 145, 16, 2, 56, 4, 1),
(3461, 145, 17, 2, 55, 4, 1),
(3462, 145, 18, 2, 53, 4, 1),
(3463, 145, 19, 2, 51, 4, 1),
(3464, 145, 20, 2, 49, 4, 1),
(3465, 145, 21, 2, 46, 4, 1),
(3466, 145, 22, 2, 44, 4, 1),
(3467, 145, 23, 2, 33, 4, 1),
(3468, 145, 24, 2, 40, 4, 1),
(3469, 146, 1, 1, 0, 4, 1),
(3470, 146, 2, 1, 2, 4, 1),
(3471, 146, 3, 1, 4, 4, 1),
(3472, 146, 4, 1, 6, 4, 1),
(3473, 146, 5, 1, 9, 4, 1),
(3474, 146, 6, 1, 11, 4, 1),
(3475, 146, 7, 1, 13, 4, 1),
(3476, 146, 8, 1, 15, 4, 1),
(3477, 146, 9, 1, 16, 4, 1),
(3478, 146, 10, 1, 18, 4, 1),
(3479, 146, 11, 1, 20, 4, 1),
(3480, 146, 12, 1, 22, 4, 1),
(3481, 146, 13, 2, 62, 4, 1),
(3482, 146, 14, 2, 60, 4, 1),
(3483, 146, 15, 2, 58, 4, 1),
(3484, 146, 16, 2, 56, 4, 1),
(3485, 146, 17, 2, 55, 4, 1),
(3486, 146, 18, 2, 53, 4, 1),
(3487, 146, 19, 2, 51, 4, 1),
(3488, 146, 20, 2, 49, 4, 1),
(3489, 146, 21, 2, 46, 4, 1),
(3490, 146, 22, 2, 44, 4, 1),
(3491, 146, 23, 2, 33, 4, 1),
(3492, 146, 24, 2, 40, 4, 1),
(3493, 147, 1, 1, 0, 4, 1),
(3494, 147, 2, 1, 2, 4, 1),
(3495, 147, 3, 1, 4, 4, 1),
(3496, 147, 4, 1, 25, 4, 1),
(3497, 147, 5, 1, 9, 4, 1),
(3498, 147, 6, 1, 11, 4, 1),
(3499, 147, 7, 1, 13, 4, 1),
(3500, 147, 8, 1, 15, 4, 1),
(3501, 147, 9, 1, 16, 4, 1),
(3502, 147, 10, 1, 18, 4, 1),
(3503, 147, 11, 1, 20, 4, 1),
(3504, 147, 12, 1, 22, 4, 1),
(3505, 147, 13, 2, 62, 4, 1),
(3506, 147, 14, 2, 60, 4, 1),
(3507, 147, 15, 2, 58, 4, 1),
(3508, 147, 16, 2, 56, 4, 1),
(3509, 147, 17, 2, 55, 4, 1),
(3510, 147, 18, 2, 53, 4, 1),
(3511, 147, 19, 2, 51, 4, 1),
(3512, 147, 20, 2, 49, 4, 1),
(3513, 147, 21, 2, 46, 4, 1),
(3514, 147, 22, 2, 44, 4, 1),
(3515, 147, 23, 2, 42, 4, 1),
(3516, 147, 24, 2, 40, 4, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_game_request`
--

DROP TABLE IF EXISTS `tbl_game_request`;
CREATE TABLE IF NOT EXISTS `tbl_game_request` (
  `id` mediumint(9) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `game_type_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL,
  `lastStatusChangeAt_date` date DEFAULT NULL,
  `lastStatusChangeAt_time` time DEFAULT NULL
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_game_request`
--

INSERT INTO `tbl_game_request` (`id`, `sender_id`, `receiver_id`, `game_type_id`, `status_id`, `lastStatusChangeAt_date`, `lastStatusChangeAt_time`) VALUES
(1, 1, 5, 1, 1, '2015-03-01', '17:17:32'),
(2, 1, 5, 1, 1, '2015-03-01', '17:17:55'),
(3, 1, 5, 3, 1, '2015-03-01', '17:33:04'),
(4, 5, 1, 1, 3, '2015-03-04', '13:10:44');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_log_stuff`
--

DROP TABLE IF EXISTS `tbl_log_stuff`;
CREATE TABLE IF NOT EXISTS `tbl_log_stuff` (
  `id` int(11) NOT NULL,
  `stuff` varchar(4000) DEFAULT NULL
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_adstatus`
--

DROP TABLE IF EXISTS `tbl_lookup_adstatus`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_adstatus` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_adstatus`
--

INSERT INTO `tbl_lookup_adstatus` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 0, 0, 'active'),
(2, 0, 0, 'disabled');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_boardtype`
--

DROP TABLE IF EXISTS `tbl_lookup_boardtype`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_boardtype` (
  `id` mediumint(9) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_boardtype`
--

INSERT INTO `tbl_lookup_boardtype` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 0, 0, 'single square board'),
(2, 0, 0, 'single square board with square gap in middle'),
(3, 0, 0, 'double square board'),
(4, 0, 0, 'spherical');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_competitioncompetitor`
--

DROP TABLE IF EXISTS `tbl_lookup_competitioncompetitor`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_competitioncompetitor` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_competitioncompetitor`
--

INSERT INTO `tbl_lookup_competitioncompetitor` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 25, 1, 'person v person'),
(2, 25, 2, 'team v team');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_competitionperiod`
--

DROP TABLE IF EXISTS `tbl_lookup_competitionperiod`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_competitionperiod` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_competitionperiod`
--

INSERT INTO `tbl_lookup_competitionperiod` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 24, 1, 'daily'),
(2, 24, 2, 'weekly'),
(3, 24, 3, 'monthly'),
(4, 24, 4, 'annual'),
(5, 24, 5, 'not repeating');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_competitionsignuptype`
--

DROP TABLE IF EXISTS `tbl_lookup_competitionsignuptype`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_competitionsignuptype` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_competitionsignuptype`
--

INSERT INTO `tbl_lookup_competitionsignuptype` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 26, 1, 'all house in automatically'),
(2, 26, 2, 'opt in');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_competitiontype`
--

DROP TABLE IF EXISTS `tbl_lookup_competitiontype`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_competitiontype` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_competitiontype`
--

INSERT INTO `tbl_lookup_competitiontype` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 23, 1, 'knock out'),
(2, 23, 2, 'league');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_competition_participanttype`
--

DROP TABLE IF EXISTS `tbl_lookup_competition_participanttype`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_competition_participanttype` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_competition_participanttype`
--

INSERT INTO `tbl_lookup_competition_participanttype` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 28, 1, 'competitor'),
(2, 28, 2, 'organiser');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_emailstatus`
--

DROP TABLE IF EXISTS `tbl_lookup_emailstatus`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_emailstatus` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_emailstatus`
--

INSERT INTO `tbl_lookup_emailstatus` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 0, 0, 'queued'),
(2, 0, 0, 'sent');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_emailtype`
--

DROP TABLE IF EXISTS `tbl_lookup_emailtype`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_emailtype` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_emailtype`
--

INSERT INTO `tbl_lookup_emailtype` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 0, 0, 'change password'),
(2, 0, 0, 'new user authenticate'),
(3, 0, 0, 'scheduled news'),
(4, 0, 0, 'news update'),
(5, 0, 0, 'change username');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_gamerequest_status`
--

DROP TABLE IF EXISTS `tbl_lookup_gamerequest_status`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_gamerequest_status` (
  `id` mediumint(9) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_gamerequest_status`
--

INSERT INTO `tbl_lookup_gamerequest_status` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 10, 1, 'requested'),
(2, 10, 2, 'rejected'),
(3, 10, 3, 'accepted');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_gamestatus`
--

DROP TABLE IF EXISTS `tbl_lookup_gamestatus`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_gamestatus` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_gamestatus`
--

INSERT INTO `tbl_lookup_gamestatus` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 11, 1, 'waiting for human'),
(2, 11, 2, 'over'),
(3, 11, 3, 'waiting for computer'),
(4, 11, 4, 'processing');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_gametypes`
--

DROP TABLE IF EXISTS `tbl_lookup_gametypes`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_gametypes` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_gametypes`
--

INSERT INTO `tbl_lookup_gametypes` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 0, 0, 'chess'),
(2, 0, 0, 'draughts');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_housestatus`
--

DROP TABLE IF EXISTS `tbl_lookup_housestatus`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_housestatus` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_housestatus`
--

INSERT INTO `tbl_lookup_housestatus` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 13, 1, 'active'),
(2, 13, 2, 'deactive');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_html_element`
--

DROP TABLE IF EXISTS `tbl_lookup_html_element`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_html_element` (
  `id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_html_element`
--

INSERT INTO `tbl_lookup_html_element` (`id`, `description`) VALUES
(1, 'main menu'),
(2, 'login menu'),
(3, 'screen new game'),
(4, 'tblgametype'),
(5, 'tblpiecetype'),
(7, 'send request'),
(8, 'screen user settings'),
(11, 'tbl_lookup_gamestatus '),
(10, 'tbl_lookup_gamerequest_status '),
(9, 'tbl_lookup_boardtype'),
(12, 'tbl_lookup_gametypes '),
(13, 'tbl_lookup_housestatus '),
(14, 'tbl_lookup_membership_type '),
(15, 'tbl_lookup_move_type '),
(16, 'tbl_lookup_piececolour '),
(17, 'tbl_lookup_userstatus '),
(18, 'screen user settings houses'),
(19, 'screen user settings houses details'),
(20, 'screen user settings details'),
(21, 'tbl_lookup_userRights'),
(22, 'news'),
(23, 'tbl_lookup_competitionType'),
(24, 'tbl_lookup_competitionPeriod'),
(25, 'tbl_lookup_competitionCompetitor'),
(26, 'tbl_lookup_competitionSignupType'),
(27, 'tbl_lookup_competition_participantType'),
(28, 'tbl_lookup_competition_participantType'),
(29, 'email - forgot pwd'),
(30, 'email - forgot pwd (title)');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_language`
--

DROP TABLE IF EXISTS `tbl_lookup_language`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_language` (
  `id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL,
  `displayOrder` int(11) NOT NULL,
  `hasGui` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_language`
--

INSERT INTO `tbl_lookup_language` (`id`, `description`, `displayOrder`, `hasGui`) VALUES
(1, 'English (UK)', 1, 0),
(2, 'Deutsch', 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_membership_type`
--

DROP TABLE IF EXISTS `tbl_lookup_membership_type`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_membership_type` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_membership_type`
--

INSERT INTO `tbl_lookup_membership_type` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 14, 1, 'Owner'),
(2, 14, 2, 'Standard'),
(3, 14, 3, 'Temporary Guest');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_move_type`
--

DROP TABLE IF EXISTS `tbl_lookup_move_type`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_move_type` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(1024) DEFAULT NULL
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_move_type`
--

INSERT INTO `tbl_lookup_move_type` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 0, 0, 'no piece type change'),
(2, 0, 0, 'taking'),
(3, 0, 0, 'change piece type'),
(4, 0, 0, 'start position');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_piececolour`
--

DROP TABLE IF EXISTS `tbl_lookup_piececolour`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_piececolour` (
  `id` mediumint(9) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_piececolour`
--

INSERT INTO `tbl_lookup_piececolour` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 0, 0, 'white'),
(2, 0, 0, 'black');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_serverprocess_status`
--

DROP TABLE IF EXISTS `tbl_lookup_serverprocess_status`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_serverprocess_status` (
  `id` mediumint(9) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_serverprocess_status`
--

INSERT INTO `tbl_lookup_serverprocess_status` (`id`, `description`) VALUES
(1, 'unassigned'),
(2, 'processing'),
(3, 'completed'),
(4, 'failed');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_serverprocess_type`
--

DROP TABLE IF EXISTS `tbl_lookup_serverprocess_type`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_serverprocess_type` (
  `id` mediumint(9) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_serverprocess_type`
--

INSERT INTO `tbl_lookup_serverprocess_type` (`id`, `description`) VALUES
(1, 'return all possible next moves'),
(2, 'return bots next move and humans all possible next moves'),
(3, 'send email');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_userrights`
--

DROP TABLE IF EXISTS `tbl_lookup_userrights`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_userrights` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_userrights`
--

INSERT INTO `tbl_lookup_userrights` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 21, 1, 'super user'),
(2, 21, 2, 'language expert');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_lookup_userstatus`
--

DROP TABLE IF EXISTS `tbl_lookup_userstatus`;
CREATE TABLE IF NOT EXISTS `tbl_lookup_userstatus` (
  `id` int(11) NOT NULL,
  `language_element_id` int(11) NOT NULL,
  `txt_id` int(11) NOT NULL,
  `description` varchar(256) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_lookup_userstatus`
--

INSERT INTO `tbl_lookup_userstatus` (`id`, `language_element_id`, `txt_id`, `description`) VALUES
(1, 17, 1, 'Active'),
(2, 17, 2, 'Disabled'),
(4, 17, 3, 'Blocked');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sessions`
--

DROP TABLE IF EXISTS `tbl_sessions`;
CREATE TABLE IF NOT EXISTS `tbl_sessions` (
  `id` int(11) NOT NULL,
  `sessions_id` varchar(1024) NOT NULL,
  `ip` varchar(256) NOT NULL,
  `token` varchar(1024) NOT NULL,
  `user_id` int(11) NOT NULL,
  `now_day` date NOT NULL,
  `now_time` time NOT NULL,
  `under_construction_read` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM AUTO_INCREMENT=142 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_settings`
--

DROP TABLE IF EXISTS `tbl_settings`;
CREATE TABLE IF NOT EXISTS `tbl_settings` (
  `id` int(11) NOT NULL,
  `txt` varchar(1024) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_settings`
--

INSERT INTO `tbl_settings` (`id`, `txt`) VALUES
(1, 'http://www.slave-to-the-board.com');

-- --------------------------------------------------------

--
-- Table structure for table `temp_competitiontemplate`
--

DROP TABLE IF EXISTS `temp_competitiontemplate`;
CREATE TABLE IF NOT EXISTS `temp_competitiontemplate` (
  `id` int(11) NOT NULL,
  `house_id` int(11) DEFAULT NULL,
  `house_name` varchar(256) DEFAULT NULL,
  `participant_type_id` int(11) DEFAULT NULL,
  `participant_type_text` varchar(256) DEFAULT NULL,
  `type_id` int(11) NOT NULL,
  `type_text` varchar(256) DEFAULT NULL,
  `period_type_id` int(11) NOT NULL,
  `period_type_text` varchar(256) DEFAULT NULL,
  `competitor_type_id` int(11) NOT NULL,
  `competitor_type_text` varchar(256) DEFAULT NULL,
  `signup_type_id` int(11) NOT NULL,
  `signup_type_text` varchar(256) DEFAULT NULL,
  `game_type_id` int(11) NOT NULL,
  `game_type_text` varchar(256) DEFAULT NULL,
  `name` varchar(256) NOT NULL,
  `description` varchar(1024) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `error_log`
--
ALTER TABLE `error_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tblcrossref_competitionuser`
--
ALTER TABLE `tblcrossref_competitionuser`
  ADD PRIMARY KEY (`id`), ADD KEY `user_id` (`user_id`), ADD KEY `competition_id` (`competition_id`), ADD KEY `user_competition` (`user_id`,`competition_id`);

--
-- Indexes for table `tblcrossref_gametypepiecetype`
--
ALTER TABLE `tblcrossref_gametypepiecetype`
  ADD PRIMARY KEY (`id`), ADD KEY `piecetype_id` (`piecetype_id`), ADD KEY `gametype_id` (`gametype_id`);

--
-- Indexes for table `tblcrossref_gametyperulegame`
--
ALTER TABLE `tblcrossref_gametyperulegame`
  ADD PRIMARY KEY (`id`), ADD KEY `gametype_id` (`gametype_id`), ADD KEY `rule_id` (`rule_id`);

--
-- Indexes for table `tblcrossref_gametyperulepiece`
--
ALTER TABLE `tblcrossref_gametyperulepiece`
  ADD PRIMARY KEY (`id`), ADD KEY `gametype_id` (`gametype_id`), ADD KEY `piecetype_id` (`piecetype_id`), ADD KEY `gametype_id_2` (`gametype_id`,`piecetype_id`), ADD KEY `rule_id` (`rule_id`), ADD KEY `gametype_id_3` (`gametype_id`,`piecetype_id`,`rule_id`);

--
-- Indexes for table `tblcrossref_userhouse`
--
ALTER TABLE `tblcrossref_userhouse`
  ADD PRIMARY KEY (`id`), ADD KEY `userid` (`userid`), ADD KEY `houseid` (`houseid`), ADD KEY `userid_2` (`userid`,`houseid`);

--
-- Indexes for table `tblcrossref_userplaysgametype`
--
ALTER TABLE `tblcrossref_userplaysgametype`
  ADD PRIMARY KEY (`id`), ADD KEY `userId` (`userId`), ADD KEY `gameTypeId` (`gameTypeId`), ADD KEY `userId_2` (`userId`,`gameTypeId`);

--
-- Indexes for table `tblgametype`
--
ALTER TABLE `tblgametype`
  ADD PRIMARY KEY (`id`), ADD KEY `language_element_id` (`language_element_id`), ADD KEY `name_txt_id` (`name_txt_id`);

--
-- Indexes for table `tblhouse`
--
ALTER TABLE `tblhouse`
  ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `idxHouse_housename` (`housename`);

--
-- Indexes for table `tblpiecestartposition`
--
ALTER TABLE `tblpiecestartposition`
  ADD PRIMARY KEY (`id`), ADD KEY `gameType_id` (`gameType_id`);

--
-- Indexes for table `tblpiecetype`
--
ALTER TABLE `tblpiecetype`
  ADD PRIMARY KEY (`id`), ADD KEY `piece_type_id` (`piece_type_id`), ADD KEY `language_element_id` (`language_element_id`), ADD KEY `name_txt_id` (`name_txt_id`);

--
-- Indexes for table `tblrule_game`
--
ALTER TABLE `tblrule_game`
  ADD PRIMARY KEY (`id`), ADD KEY `language_element_id` (`language_element_id`), ADD KEY `name_txt_id` (`name_txt_id`), ADD KEY `language_element_id_2` (`language_element_id`,`name_txt_id`), ADD KEY `description_txt_id` (`description_txt_id`), ADD KEY `language_element_id_3` (`language_element_id`,`description_txt_id`);

--
-- Indexes for table `tblserverprocesses_main`
--
ALTER TABLE `tblserverprocesses_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tblserverprocesses_possiblemoves`
--
ALTER TABLE `tblserverprocesses_possiblemoves`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbltext`
--
ALTER TABLE `tbltext`
  ADD PRIMARY KEY (`id`), ADD KEY `id_language` (`id_language`), ADD KEY `id_html_element` (`id_html_element`), ADD KEY `id_text` (`id_text`), ADD KEY `id_language_2` (`id_language`,`id_html_element`), ADD KEY `id_language_3` (`id_language`,`id_html_element`,`id_text`);

--
-- Indexes for table `tbluser`
--
ALTER TABLE `tbluser`
  ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `idxUser_username` (`username`), ADD KEY `idxUser_email` (`email`);

--
-- Indexes for table `tbl_ads`
--
ALTER TABLE `tbl_ads`
  ADD PRIMARY KEY (`id`), ADD KEY `idx_ads_user` (`user_id`), ADD KEY `idx_ads_posted_date` (`posted_date`), ADD KEY `idx_ads_status` (`status_id`);

--
-- Indexes for table `tbl_ads_game_types`
--
ALTER TABLE `tbl_ads_game_types`
  ADD PRIMARY KEY (`id`), ADD KEY `idx_ads_game_type_ads` (`ads_id`), ADD KEY `idx_ads_game_type_game_type` (`game_type_id`), ADD KEY `idx_ads_game_type_all` (`ads_id`,`game_type_id`);

--
-- Indexes for table `tbl_ads_houses`
--
ALTER TABLE `tbl_ads_houses`
  ADD PRIMARY KEY (`id`), ADD KEY `idx_ads_houses_ads` (`ads_id`), ADD KEY `idx_ads_houses_houses` (`house_id`), ADD KEY `idx_ads_houses_all` (`ads_id`,`house_id`);

--
-- Indexes for table `tbl_authentication_strings`
--
ALTER TABLE `tbl_authentication_strings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_captcha`
--
ALTER TABLE `tbl_captcha`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_captcharequests`
--
ALTER TABLE `tbl_captcharequests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_competition`
--
ALTER TABLE `tbl_competition`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_competitiontemplate`
--
ALTER TABLE `tbl_competitiontemplate`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_email`
--
ALTER TABLE `tbl_email`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_games`
--
ALTER TABLE `tbl_games`
  ADD PRIMARY KEY (`id`), ADD KEY `idxGames_WhitePlayerId` (`player_white_id`), ADD KEY `idxGames_BlackPlayerId` (`player_black_id`), ADD KEY `idxGames_GameType` (`game_type`), ADD KEY `idxGames_startedAt_date` (`startedAt_date`), ADD KEY `idxGames_endedAt_date` (`endedAt_date`), ADD KEY `idxGames_status` (`status_id`);

--
-- Indexes for table `tbl_game_all_moves`
--
ALTER TABLE `tbl_game_all_moves`
  ADD PRIMARY KEY (`id`), ADD KEY `idx_game_all_moves_game_id` (`game_id`);

--
-- Indexes for table `tbl_game_current_positions`
--
ALTER TABLE `tbl_game_current_positions`
  ADD PRIMARY KEY (`id`), ADD KEY `idx_game_curr_pos_game_id` (`game_id`), ADD KEY `idx_game_curr_pos_piece_id` (`piece_id`), ADD KEY `idx_game_curr_pos_game_id_piece_id` (`game_id`,`piece_id`), ADD KEY `idx_game_curr_pos_square_no` (`square_no`);

--
-- Indexes for table `tbl_game_request`
--
ALTER TABLE `tbl_game_request`
  ADD PRIMARY KEY (`id`), ADD KEY `idx_game_request_sender` (`sender_id`), ADD KEY `idx_game_request_receiver` (`receiver_id`), ADD KEY `idx_game_request_status` (`status_id`), ADD KEY `idx_game_request_lastStatusChangeAt_date` (`lastStatusChangeAt_date`);

--
-- Indexes for table `tbl_log_stuff`
--
ALTER TABLE `tbl_log_stuff`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_adstatus`
--
ALTER TABLE `tbl_lookup_adstatus`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_boardtype`
--
ALTER TABLE `tbl_lookup_boardtype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_competitioncompetitor`
--
ALTER TABLE `tbl_lookup_competitioncompetitor`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_competitionperiod`
--
ALTER TABLE `tbl_lookup_competitionperiod`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_competitionsignuptype`
--
ALTER TABLE `tbl_lookup_competitionsignuptype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_competitiontype`
--
ALTER TABLE `tbl_lookup_competitiontype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_competition_participanttype`
--
ALTER TABLE `tbl_lookup_competition_participanttype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_emailstatus`
--
ALTER TABLE `tbl_lookup_emailstatus`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_emailtype`
--
ALTER TABLE `tbl_lookup_emailtype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_gamerequest_status`
--
ALTER TABLE `tbl_lookup_gamerequest_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_gamestatus`
--
ALTER TABLE `tbl_lookup_gamestatus`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_gametypes`
--
ALTER TABLE `tbl_lookup_gametypes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_housestatus`
--
ALTER TABLE `tbl_lookup_housestatus`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_html_element`
--
ALTER TABLE `tbl_lookup_html_element`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_language`
--
ALTER TABLE `tbl_lookup_language`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_membership_type`
--
ALTER TABLE `tbl_lookup_membership_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_move_type`
--
ALTER TABLE `tbl_lookup_move_type`
  ADD PRIMARY KEY (`id`), ADD KEY `idx_lkup_move_status_description` (`description`(333));

--
-- Indexes for table `tbl_lookup_piececolour`
--
ALTER TABLE `tbl_lookup_piececolour`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_serverprocess_status`
--
ALTER TABLE `tbl_lookup_serverprocess_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_serverprocess_type`
--
ALTER TABLE `tbl_lookup_serverprocess_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_userrights`
--
ALTER TABLE `tbl_lookup_userrights`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_lookup_userstatus`
--
ALTER TABLE `tbl_lookup_userstatus`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_sessions`
--
ALTER TABLE `tbl_sessions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_settings`
--
ALTER TABLE `tbl_settings`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `error_log`
--
ALTER TABLE `error_log`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tblcrossref_competitionuser`
--
ALTER TABLE `tblcrossref_competitionuser`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tblcrossref_gametypepiecetype`
--
ALTER TABLE `tblcrossref_gametypepiecetype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `tblcrossref_gametyperulegame`
--
ALTER TABLE `tblcrossref_gametyperulegame`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tblcrossref_gametyperulepiece`
--
ALTER TABLE `tblcrossref_gametyperulepiece`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `tblcrossref_userhouse`
--
ALTER TABLE `tblcrossref_userhouse`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `tblcrossref_userplaysgametype`
--
ALTER TABLE `tblcrossref_userplaysgametype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `tblgametype`
--
ALTER TABLE `tblgametype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `tblhouse`
--
ALTER TABLE `tblhouse`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `tblpiecestartposition`
--
ALTER TABLE `tblpiecestartposition`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=85;
--
-- AUTO_INCREMENT for table `tblpiecetype`
--
ALTER TABLE `tblpiecetype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tblrule_game`
--
ALTER TABLE `tblrule_game`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `tblserverprocesses_main`
--
ALTER TABLE `tblserverprocesses_main`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=86;
--
-- AUTO_INCREMENT for table `tblserverprocesses_possiblemoves`
--
ALTER TABLE `tblserverprocesses_possiblemoves`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=81;
--
-- AUTO_INCREMENT for table `tbltext`
--
ALTER TABLE `tbltext`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=281;
--
-- AUTO_INCREMENT for table `tbluser`
--
ALTER TABLE `tbluser`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1989;
--
-- AUTO_INCREMENT for table `tbl_ads`
--
ALTER TABLE `tbl_ads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `tbl_ads_game_types`
--
ALTER TABLE `tbl_ads_game_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_ads_houses`
--
ALTER TABLE `tbl_ads_houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_authentication_strings`
--
ALTER TABLE `tbl_authentication_strings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `tbl_captcha`
--
ALTER TABLE `tbl_captcha`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `tbl_captcharequests`
--
ALTER TABLE `tbl_captcharequests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT for table `tbl_competition`
--
ALTER TABLE `tbl_competition`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbl_competitiontemplate`
--
ALTER TABLE `tbl_competitiontemplate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbl_email`
--
ALTER TABLE `tbl_email`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `tbl_games`
--
ALTER TABLE `tbl_games`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=148;
--
-- AUTO_INCREMENT for table `tbl_game_all_moves`
--
ALTER TABLE `tbl_game_all_moves`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=254;
--
-- AUTO_INCREMENT for table `tbl_game_current_positions`
--
ALTER TABLE `tbl_game_current_positions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3517;
--
-- AUTO_INCREMENT for table `tbl_game_request`
--
ALTER TABLE `tbl_game_request`
  MODIFY `id` mediumint(9) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `tbl_log_stuff`
--
ALTER TABLE `tbl_log_stuff`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=38;
--
-- AUTO_INCREMENT for table `tbl_lookup_adstatus`
--
ALTER TABLE `tbl_lookup_adstatus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_lookup_boardtype`
--
ALTER TABLE `tbl_lookup_boardtype`
  MODIFY `id` mediumint(9) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `tbl_lookup_competitioncompetitor`
--
ALTER TABLE `tbl_lookup_competitioncompetitor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_lookup_competitionperiod`
--
ALTER TABLE `tbl_lookup_competitionperiod`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `tbl_lookup_competitionsignuptype`
--
ALTER TABLE `tbl_lookup_competitionsignuptype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `tbl_lookup_competitiontype`
--
ALTER TABLE `tbl_lookup_competitiontype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_lookup_competition_participanttype`
--
ALTER TABLE `tbl_lookup_competition_participanttype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_lookup_emailstatus`
--
ALTER TABLE `tbl_lookup_emailstatus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_lookup_emailtype`
--
ALTER TABLE `tbl_lookup_emailtype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `tbl_lookup_gamerequest_status`
--
ALTER TABLE `tbl_lookup_gamerequest_status`
  MODIFY `id` mediumint(9) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `tbl_lookup_gamestatus`
--
ALTER TABLE `tbl_lookup_gamestatus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `tbl_lookup_gametypes`
--
ALTER TABLE `tbl_lookup_gametypes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_lookup_housestatus`
--
ALTER TABLE `tbl_lookup_housestatus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_lookup_html_element`
--
ALTER TABLE `tbl_lookup_html_element`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=31;
--
-- AUTO_INCREMENT for table `tbl_lookup_language`
--
ALTER TABLE `tbl_lookup_language`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_lookup_membership_type`
--
ALTER TABLE `tbl_lookup_membership_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `tbl_lookup_move_type`
--
ALTER TABLE `tbl_lookup_move_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `tbl_lookup_piececolour`
--
ALTER TABLE `tbl_lookup_piececolour`
  MODIFY `id` mediumint(9) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_lookup_serverprocess_status`
--
ALTER TABLE `tbl_lookup_serverprocess_status`
  MODIFY `id` mediumint(9) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `tbl_lookup_serverprocess_type`
--
ALTER TABLE `tbl_lookup_serverprocess_type`
  MODIFY `id` mediumint(9) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `tbl_lookup_userrights`
--
ALTER TABLE `tbl_lookup_userrights`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_lookup_userstatus`
--
ALTER TABLE `tbl_lookup_userstatus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `tbl_sessions`
--
ALTER TABLE `tbl_sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=142;
--
-- AUTO_INCREMENT for table `tbl_settings`
--
ALTER TABLE `tbl_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
