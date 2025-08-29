%let pgm=utl-creating-a-report-and-sas-table-from-proc-tabulate-listing-using-sas-proc-import;

%stop_summssion;

Creating a report and sas table from proc tabulate listing using sas proc import

IN ADDITION TO THE TABULATE LISTING
==================================

------------------------------------------
|Pet |  Tot     |    F       |    M      |
|    |----------+------------+-----------|
|    |N   |n|%  |N   |n| %   |N   |n| %  |
|----+----+-+---+----+-+-----+----+-+----|
|CAT |5.00|3|60%|2.00|0|  0% |3.00|3|100%|
|----+----+-+---+----+-+-----+----+-+----|
|DOG |5.00|3|60%|2.00|2|100% |3.00|1| 33%|
|----+----+-+---+----+-+-----+----+-+----|
|BIRD|5.00|3|60%|2.00|2|100% |3.00|1| 33%|
------------------------------------------

GET THIS SAS DATASET WORK.WANT
==============================

PET TOT_OBS NUM_1 PCT_1 M_OBS M_1 M_PCT_1 F_OBS F_1 F_PCT_1

CAT    5      3    60%    2    0   0%       3    3   100%
DOG    5      3    60%    2    2   100%     3    1   33%
BIRD   5      3    60%    2    2   100%     3    1   33%

CONTENTS
     1 usual listing
     2 sas table output
       Bartosz Jablonski
       yabwon@gmail.com

sas communities
https://tinyurl.com/4c46e698
https://communities.sas.com/t5/SAS-Programming/Multiple-response-variable-analysis-According-to-Total-and-Sex/m-p/757516#M239123

/**************************************************************************************************************************/
/* INPUT                  | PROCESS                                 | OUTPUT                                              */
/* =====                  | =======                                 | ======                                              */
/* ID SEX CAT DOG BIRD    | 1 USUAL LISTING                         | ------------------------------------------          */
/*                        | ===============                         | |Pet |  Tot     |    F       |    M      |          */
/* 01  M   1   0    1     |                                         | |    |----------+------------+-----------|          */
/* 02  F   0   1    1     | options                                 | |    |N   |n|%  |N   |n| %   |N   |n| %  |          */
/* 03  M   1   1    0     |  formchar='|----|+|---+=|-/\<>*' ;      | |----+----+-+---+----+-+-----+----+-+----|          */
/* 04  F   0   1    1     | ods listing;                            | |CAT |5.00|3|60%|2.00|0|  0% |3.00|3|100%|          */
/* 05  M   1   0    0     | proc tabulate data=have;                | |----+----+-+---+----+-+-----+----+-+----|          */
/*                        |  class sex ;                            | |DOG |5.00|3|60%|2.00|2|100% |3.00|1| 33%|          */
/*                        |  var cat dog bird;                      | |----+----+-+---+----+-+-----+----+-+----|          */
/* data have;             |  table cat dog bird,                    | |BIRD|5.00|3|60%|2.00|2|100% |3.00|1| 33%|          */
/* input id$ cat          |    (all='Total' Sex=' ')                | ------------------------------------------          */
/* dog bird sex$ ;        |     *(n='N' sum='n'                     |                                                     */
/* datalines;             |     *f=best5. mean='%'*f=percent7.)     |                                                     */
/* 01 1 0 1 m             |   /box='Pet' rts=8;                     |                                                     */
/* 02 0 1 1 f             | run;quit;                               |                                                     */
/* 03 1 1 0 m             |                                         |                                                     */
/* 04 0 1 1 f             |-----------------------------------------------------------------------------------------------*/
/* 05 1 0 0 m             | 2 SAS TABLE OUTPUT                      |                                                     */
/* ;;;;                   | ==================                      |  WORK.WANT                                          */
/* run;quit;              |                                         |                                                     */
/*                        | options formchar="," ;                  |       T                  M         F                */
/*                        | ods listing                             |       O                  _         _                */
/*                        |   file="d:/txt/tab.txt";                |       T  N    P   M      P   F     P                */
/*                        |                                         |       _  U    C   _      C   _     C                */
/*                        | proc tabulate data=have;                |    P  O  M    T   O  M   T   O F   T                */
/*                        |  title                                  |    E  B  _    _   B  _   _   B _   _                */
/*                        |  ,pet,Tot_obs,Num_1,pct_1,m_obs         |    T  S  1    1   S  1   1   S 1   1                */
/*                        |  ,m_1,m_pct_1,f_obs,f_1,f_pct_1,"));    |                                                     */
/*                        |  class sex ;                            |  CAT  5  3  60%   2  0 0%    3 3 100%               */
/*                        |  var cat dog bird;                      |  DOG  5  3  60%   2  2 100%  3 1 33%                */
/*                        |  table cat dog bird,                    |  BIRD 5  3  60%   2  2 100%  3 1 33%                */
/*                        |    (all='Total' Sex=' ')                |                                                     */
/*                        |    *(n='N' sum='n' *f=best5.            |                                                     */
/*                        |    mean='%'*f=percent7.)                |                                                     */
/*                        |   /box='Pet' rts=8;                     |                                                     */
/*                        | run;quit;                               |                                                     */
/*                        | ods listing;                            |                                                     */
/*                        |                                         |                                                     */
/*                        |                                         |                                                     */
/*                        | proc import                             |                                                     */
/*                        |  datafile="d:/txt/tab.txt"              |                                                     */
/*                        |  dbms=csv                               |                                                     */
/*                        |  out=want(drop=var:                     |                                                     */
/*                        |   where=(not missing(pet)))             |                                                     */
/*                        |  replace;                               |                                                     */
/*                        |  getnames=YES;                          |                                                     */
/*                        |  datarow=7;                             |                                                     */
/*                        | run;quit;                               |                                                     */
/*                        |                                         |                                                     */
/*                        | proc print data=want                    |                                                     */
/*                        |   heading=vertical;                     |                                                     */
/*                        | format _numeric_ 1.                     |                                                     */
/*                        |        _character_ $5.;                 |                                                     */
/*                        | run;quit;                               |                                                     */
/*                        |                                         |                                                     */
/*                        | options formchar=                       |                                                     */
/*                        |   '|----|+|---+=|-/\<>*' ;              |                                                     */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/


data have;
input id$ cat
dog bird sex$ ;
datalines;
01 1 0 1 m
02 0 1 1 f
03 1 1 0 m
04 0 1 1 f
05 1 0 0 m
;;;;
run;quit;

/**************************************************************************************************************************/
/*  ID    CAT    DOG    BIRD    SEX                                                                                       */
/*                                                                                                                        */
/* 01     1      0       1      m                                                                                         */
/* 02     0      1       1      f                                                                                         */
/* 03     1      1       0      m                                                                                         */
/* 04     0      1       1      f                                                                                         */
/* 05     1      0       0      m                                                                                         */
/**************************************************************************************************************************/

options
 formchar='|----|+|---+=|-/\<>*' ;
ods listing;
proc tabulate data=have;
 class sex ;
 var cat dog bird;
 table cat dog bird,
   (all='Total' Sex=' ')
    *(n='N' sum='n'
    *f=best5. mean='%'*f=percent7.)
  /box='Pet' rts=8;
run;quit;


/**************************************************************************************************************************/
/*  -----------------------------------------------------------------------------------------                             */
/* |Pet   |          Total           |            f             |            m             |                              */
/* |      |--------------------------+--------------------------+--------------------------|                              */
/* |      |     N      |  n  |   %   |     N      |  n  |   %   |     N      |  n  |   %   |                              */
/* |------+------------+-----+-------+------------+-----+-------+------------+-----+-------|                              */
/* |CAT   |        5.00|    3|   60% |        2.00|    0|    0% |        3.00|    3|  100% |                              */
/* |------+------------+-----+-------+------------+-----+-------+------------+-----+-------|                              */
/* |DOG   |        5.00|    3|   60% |        2.00|    2|  100% |        3.00|    1|   33% |                              */
/* |------+------------+-----+-------+------------+-----+-------+------------+-----+-------|                              */
/* |BIRD  |        5.00|    3|   60% |        2.00|    2|  100% |        3.00|    1|   33% |                              */
/* -----------------------------------------------------------------------------------------                              */
/**************************************************************************************************************************/

proc datasets lib=work
  nolist nodetails;
 delete want;
run;quit;

title;
footnote;

%utlfkil(d:/txt/tab.txt);

options formchar="," ;
ods listing
  file="d:/txt/tab.txt";

proc tabulate data=have;
 title
 ",pet,Tot_obs,Num_1,pct_1,m_obs
 ,m_1,m_pct_1,f_obs,f_1,f_pct_1,";
 class sex ;
 var cat dog bird;
 table cat dog bird,
   (all='Total' Sex=' ')
   *(n='N' sum='n' *f=best5.
   mean='%'*f=percent7.)
  /box='Pet' rts=8;
run;quit;
ods listing;


proc import
 datafile="d:/txt/tab.txt"
 dbms=csv
 out=want(drop=var:
  where=(not missing(pet)))
 replace;
 getnames=YES;
 datarow=7;
run;quit;

proc print data=want;
run;quit;

options formchar=
  '|----|+|---+=|-/\<>*' ;

/**************************************************************************************************************************/
/*  PET     TOT_OBS    NUM_1    PCT_1    M_OBS    M_1    M_PCT_1    F_OBS    F_1    F_PCT_1                               */
/*                                                                                                                        */
/* CAT        5         3       60%       2       0      0%          3       3      100%                                  */
/* DOG        5         3       60%       2       2      100%        3       1      33%                                   */
/* BIRD       5         3       60%       2       2      100%        3       1      33%                                   */
/**************************************************************************************************************************/


/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
