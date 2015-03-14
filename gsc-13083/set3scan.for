      SUBROUTINE SET3SCAN(PARMNAME,LUPROMPT,LUCNTL,
     *      VALUE1,DELVALUE,NVALUES,FACTOR,IEND)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C SET3SCAN IS A HANDY WAY TO HAVE PROGRAMS PROMPT THE USER FOR PARAMETER
C CONTROLS WHERE A PARAMETER IS TO VARY IN EQUAL INCREMENTS OVER A RANGE
C
C EXAMPLE:
C
C    A PROGRAM NEEDS TO DO COMPUTATIONS INVOLVING A SET OF EQUALLY
C    SPACED LONGITUDES. INSTEAD OF WRITING CODE TO PROMPT FOR AND READ 
C    THE LONGITUDE RANGE, THE CALLER DOES --
C
C   CALL SET3SCAN('LONGITUDE RANGE',6,5,ALONG1,DLONG,NLONG,DEGRAD,IEND)
C
C    THIS ROUTINE WILL PROMPT FOR THE FIRST VALUE, INCREMENT, AND NUMBER
C    OF VALUES WANTED. THESE WILL BE OUTPUT TO THE CALLER THROUGH THE
C    CALLING SEQUENCE VIA VARIABLES ALONG1, DLONG, NLONG AFTER 
C    CONVERTING FROM DEGREES(THE USER'S INPUT UNITS) TO RADIANS(THE
C    CALLER'S WORKING UNITS).
C
C
C VARIABLE DIM TYPE I/O DESCRIPTION
C -------- --- ---- --- -----------
C
C PARMNAME  1 CH*(*) I  TEXT TO BE PART OF THE PROMPT MESSAGE. USEFUL
C                       WHEN MORE THAN ONE SET OF CONTROLS ARE USED BY
C                       THE CALLER. THE TEXT WILL BE INSERTED IN A
C                       LINE OF PROMPT TEXT AS FOLLOWS:
C
C                              <<< parmname CONTROLS >>>
C
C LUPROMPT  1  I*4   I  THE FORTRAN UNIT NUMBER TO WHICH THE PROMPT
C                       MESSAGE IS WRITTEN. IF ZERO OR NEGATIVE, NO
C                       PROMPT IS WRITTEN.
C
C LUCNTL    1  I*4   I  THE FORTRAN UNIT NUMBER FROM WHICH THE DATA IS
C                       TO BE READ.
C
C VALUE1    1  R*8  I/O THE FIRST VALUE IN THE RANGE OF PARAMETER VALUES
C
C                       INPUT: THE VALUE THAT WILL BE OUTPUT UNLESS THE
C                              USER OVERRIDES IT. INPUT UNITS ARE THE
C                              SAME AS OUTPUT UNITS.
C
C                       OUTPUT: THE VALUE RETURNED TO THE CALLER.
C
C DELVALUE  1  R*8  I/O THE INCREMENT BETWEEN PARAMETER VALUES.
C
C                       INPUT/OUTPUT IS AS DESCRIBED UNDER VALUE1.
C
C NVALUES   1  I*4  I/O THE NUMBER OF PARAMETER VALUES. 
C
C                       INPUT/OUTPUT IS AS DESCRIBED UNDER VALUE1.
C
C FACTOR    1  R*8   I  A FACTOR BY WHICH THE USER'S INPUT VALUE1 AND 
C                       DELVALUE ARE TO BE DIVIDED BEFORE THEY ARE
C                       RETURNED TO THE CALLER. IF FACTOR = 0.D0, THEN
C                       1.D0 IS USED.
C
C IEND      1  I*4   O  AN END-OF-FILE RETURN FLAG.
C
C                       = 0, NO END OF FILE WAS SENSED. OUTPUT ITEMS
C                            ARE AS THE USER HAS SPECIFIED.
C                       = 1, END OF FILE WAS SENSED FOR UNIT LUCNTL. IN
C                            THIS CASE, VALUE1, DELVALUE, AND NVALUES 
C                            ARE UNCHANGED.
C
C***********************************************************************
C
C BY C PETRUZZO, 6/84.
C    MODIFIED....
C
C***********************************************************************
C
      CHARACTER*(*) PARMNAME
C
C INITIALIZATION
C
      IEND = 1   ! WILL BE RESET TO ZERO IF NO END-FILE IS ENCOUNTERED
      FAC = FACTOR
      IF(FAC.EQ.0.D0) FAC=1.D0
      V1 = VALUE1*FAC
      DELV = DELVALUE*FAC
      NVAL = NVALUES
C
C PROMPT
C
      IF(LUPROMPT.GT.0) WRITE(LUPROMPT,100) PARMNAME,V1,DELV,NVAL
  100 FORMAT(/,
     * ' <<< ',A,' CONTROLS >>>'//,
     * '   FIRST VALUE = ',G19.12/,
     * '   INCREMENT =   ',G19.12/,
     * '   NUM VALUES =  ',I10//,
     * '   ENTER NEW CONTROLS -----> ',$)
C
C READ OVERRIDES
C
      READ(LUCNTL,*,END=999) V1,DELV,NVAL
      IEND = 0
C
C REPORT ON VALUES ENTERED
C
      IF(LUPROMPT.GT.0) WRITE(LUPROMPT,101) V1,DELV,NVAL
  101 FORMAT(/,'   ENTERED --> ',2G20.12,1X,I6/)
C
C SET OUTPUT VARIABLES
C
      NVALUES = NVAL
      VALUE1 = V1/FAC
      DELVALUE = DELV/FAC
C 
  999 CONTINUE
      RETURN
      END