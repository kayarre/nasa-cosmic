      SUBROUTINE SETGRD(SYMHLD,PLTPRM)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C  --------------- SETGRD / LOCGRD / PRTGRD ---------------------------
C
C  THIS ROUTINE AND ENTRY POINTS ARE USED TO PRODUCE PRINTER PLOTS
C  OF ANGLE QUANTITIES( EX- RACN/DECL, EL/AZ,...). THE PLOT IS 
C  ALWAYS 180x360 DEGREES. 
C 
C  USAGE----  1) CALL SETGRD ONCE TO INTIALIZE SYMHLD AND INTERNAL
C                VARIABLES.
C             2) CALL LOCGRD MANY TIMES TO PLACE ANGLE PAIRS ON THE
C                GRID. ONE CALL FOR EACH PAIR PLACED.
C             3) CALL PRTGRD TO PRINT THE GRID.
C
C
C*********************************************************
C
C   CODED BY CHARLIE PETRUZZO   2/81.
C
C   MODIFIED....
C      CJP 4/81  ADDED PLTPRM. 
C      CJP 6/81  COMMENT CHANGES. NO CODE CHANGED.
C      CJP 12/81   LABELS MOVED TO OUTSIDE OF GRID.
C      CJP  6/82   IN LOCGRD, SET LEFT AND RIGHT SYMBOLS THE SAME.
C
C*********************************************************
C
C
C//////////////////////////////////////////////////////////////////////
C
C     STANDARD ARRAYS FOR PETRUZZO'S PRINTER PLOT ROUTINES FOR ANGLES.
C
      LOGICAL*1 SYMHLD(61,121)
      REAL*4 PLTPRM(19)
      INTEGER BOTTOM,RIGHT
      REAL*8 XSEG,YSEG,WEST,SHIFT,DX,DY
C
C/////////////////////////////////////////////////////////////////////
C
C
      LOGICAL*1 SYMBOL
      LOGICAL*1 VERT/'I'/,HORIZ/'-'/,BLANK/' '/,EQUATR/'E'/
      CHARACTER*131 XLABEL(2)
      CHARACTER*4 YLABEL(61,2)
      CHARACTER*1 SYM
      CHARACTER*3 I4CHAR,I4CH
      CHARACTER*121 PLOTLINE
      LOGICAL*1 L1LINE(121)
      EQUIVALENCE (L1LINE(1),PLOTLINE)
C
      REAL*8 HALFPI/ 1.570796326794897D0 /
      REAL*8 PI/ 3.141592653589793D0 /
      REAL*8 TWOPI/ 6.283185307179586D0 /
      REAL*8 DEGRAD/ 57.29577951308232D0 /
      REAL*4 R4BOTT,R4RGHT,R4IEWL,R4ILAB,R4IGRD,R4IEQT,R4IOPT
      EQUIVALENCE (R4BOTT,BOTTOM),(R4RGHT,RIGHT),(R4IEWL,IEWLBL),
     1    (R4ILAB,ILABEL),(R4IGRD,IGRID),(R4IEQT,IEQATR),(R4IOPT,IOPTN)
      REAL*4 TEMP4(2)
      REAL*8 TEMP8
      EQUIVALENCE (TEMP4(1),TEMP8)
C
C  ************************** SETGRD **********************************
C
C  THIS ROUTINE SETS UP A GRID FOR SUBSEQUENT USE IN
C  CREATING PRINTER PLOTS OF QUANTITIES EXPRESSED IN
C  LAT/LONG, DECL/RACN, EL/AZ,.....
C
C  THE ARRAY SYMHLD IS FIRST FILLED WITH BLANK CHARACTERS.
C  THEN THE 1ST AND RIGHT'TH COLUMNS AND 1ST AND BOTTOM'TH ROWS ARE
C  FILLED WITH NON-BLANK CHARACTERS TO APPEAR AS A BORDER WHEN THE
C  ARRAY IS PRINTED LATER.
C  THEN ROWS AND COLUMNS OF THE ARRAY ARE FILLED SO
C  THAT THE PRINTOUT WILL LOOK LIKE MERIDIANS AND PARALLELS
C  HAVE BEEN DRAWN.
C
C  THE ARRAY IS RETURNED TO THE CALLER READY TO HAVE OTHER
C  ELEMENTS FILLED SHOWING THE LOCATION ON THE GRID OF THE
C  QUANTITIES PLOTTED.
C
C
C * * * * * * * * * *  CALLING SEQUENCE INFO * * * * * * * * * * *
C
C  SEE ANGPL1(ENTRY IN ANGPLT) FOR CALLING SEQUENCE DESCRIPTION.
C
C * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
C
C
C     SET UP INTERNAL CONTROLS FROM PLTPRM.
      TEMP4(1)=PLTPRM(1)
      TEMP4(2)=PLTPRM(2)
      XSEG=TEMP8
      TEMP4(1)=PLTPRM(3)
      TEMP4(2)=PLTPRM(4)
      YSEG=TEMP8
      TEMP4(1)=PLTPRM(5)
      TEMP4(2)=PLTPRM(6)
      WEST=TEMP8
      R4BOTT=PLTPRM(13)
      R4RGHT=PLTPRM(14)
      R4IEWL=PLTPRM(15)
      R4ILAB=PLTPRM(16)
      R4IGRD=PLTPRM(17)
      R4IEQT=PLTPRM(18)
      R4IOPT=PLTPRM(19)
C
C
C     IXTIC TELLS THE ROUTINE WHICH COLUMNS OF SYMHLD WILL
C     HAVE THE MERIDIAN LINE INDICATOR SET.
      IXTIC=XSEG/(TWOPI/(RIGHT-1))+0.5D0
C     IYTIC TELLS THE ROUTINE WHICH ROWS OF SYMHLD WILL HAVE
C     THE PARALLELS INDICATOR SET.
      IYTIC=YSEG/(PI/(BOTTOM-1))+0.5D0
C     DX IS THE NUMBER OF RADIANS COVERED BY ONE COLUMN.
      DX=TWOPI/(RIGHT-1)
C     DY IS THE NUMBER OF RADIANS COVERED BY ONE ROW.
      DY=PI/(BOTTOM-1)
C
C     BLANK OUT SYMHLD
      DO 50 IX=1,RIGHT
      DO 50 IY=1,BOTTOM
   50 SYMHLD(IY,IX)=BLANK
C
C     MARK THE TOP AND BOTTOM BORDER.
      DO 125 IX=1,RIGHT
      SYMHLD(1,IX)=HORIZ
  125 SYMHLD(BOTTOM,IX)=HORIZ
C
C     MARK THE LEFT AND RIGHT SIDES.
      DO 100 IY=1,BOTTOM
      SYMHLD(IY,1)=VERT
  100 SYMHLD(IY,RIGHT)=VERT
C
      IF(IGRID.EQ.0) GO TO 210
C     MARK THE LATITUDE LINES.(I.E.- THE PARALLELS)
      DO 150 IY=1,BOTTOM,IYTIC
      DO 150 IX=1,RIGHT
  150 SYMHLD(IY,IX)=HORIZ
C
C     MARK THE LONGITIDE LINES.(I.E.- THE MERIDIANS)
      DO 200 IX=1,RIGHT,IXTIC
      DO 200 IY=1,BOTTOM
  200 SYMHLD(IY,IX)=VERT
  210 CONTINUE
C
      IF(IEQATR.EQ.0) GO TO 176
C     MARK THE EQUATOR.
      IY=(BOTTOM+1)/2
      DO 175 IX=1,RIGHT
  175 SYMHLD(IY,IX)=EQUATR
  176 CONTINUE
C
C     SET XWEST TO BE IN THE 0 TO TWOPI RANGE.
      XWEST=DSIGN( DMOD(DABS(WEST),TWOPI),WEST)
      XWEST=DMOD(XWEST+TWOPI,TWOPI)
C
C
C  NOW SAVE PARAMETERS NEEDED BY LOCGRD(ENTRY POINT BELOW).
C
      SHIFT=TWOPI-XWEST
      DX=TWOPI/(RIGHT-1)
      DY=PI/(BOTTOM-1)
      TEMP8=SHIFT
      PLTPRM(7)=TEMP4(1)
      PLTPRM(8)=TEMP4(2)
      TEMP8=DX
      PLTPRM(9)=TEMP4(1)
      PLTPRM(10)=TEMP4(2)
      TEMP8=DY
      PLTPRM(11)=TEMP4(1)
      PLTPRM(12)=TEMP4(2)
C
      RETURN
C
C  ************************** LOCGRD ********************************
C
      ENTRY LOCGRD(ANG1,ANG2,SYMHLD,PLTPRM,SYMBOL)
C
C     THIS CODE TELLS THE CALLER WHERE AN ANGLE PAIR ANG1,ANG2 IS 
C     LOCATED IN SYMHLD. SETGRD MUST BE CALLED BEFORE CALLING LOCGRD.
C
C  SEE ANGPL2(ENTRY IN ANGPLT) FOR CALLING SEQUENCE DESCRIPTION.
C
      TEMP4(1)=PLTPRM(7)
      TEMP4(2)=PLTPRM(8)
      SHIFT=TEMP8
      TEMP4(1)=PLTPRM(9)
      TEMP4(2)=PLTPRM(10)
      DX=TEMP8
      TEMP4(1)=PLTPRM(11)
      TEMP4(2)=PLTPRM(12)
      DY=TEMP8
      IROW=JIDNNT(  (HALFPI-ANG1)/DY+1.D0  )
      TEMP=DSIGN( DMOD(DABS(ANG2),TWOPI),ANG2)
      ICOL=JIDNNT(  DMOD(TEMP+TWOPI+SHIFT,TWOPI)/DX+1.D0  )
      SYMHLD(IROW,ICOL)=SYMBOL
C     SINCE THE FIRST AND LAST COLUMNS REPRESENT THE SAME ANGLE
C     VALUE, IF ONE IS SET HERE, THEN SET THE OTHER.
      IF(ICOL.EQ.1) SYMHLD(IROW,RIGHT)=SYMBOL
      IF(ICOL.EQ.RIGHT) SYMHLD(IROW,1)=SYMBOL
      RETURN
C
C
C  *************************** PRTGRD ***********************************
C
      ENTRY PRTGRD(SYMHLD,PLTPRM,IPRINT)
C
C     THIS CODE PRINTS THE GRID. 
C
C  SEE ANGPL3(ENTRY IN ANGPLT) FOR CALLING SEQUENCE DESCRIPTION.
C
C     SET UP INTERNAL CONTROLS FROM PLTPRM.
      TEMP4(1)=PLTPRM(1)
      TEMP4(2)=PLTPRM(2)
      XSEG=TEMP8
      TEMP4(1)=PLTPRM(3)
      TEMP4(2)=PLTPRM(4)
      YSEG=TEMP8
      TEMP4(1)=PLTPRM(5)
      TEMP4(2)=PLTPRM(6)
      WEST=TEMP8
      R4BOTT=PLTPRM(13)
      R4RGHT=PLTPRM(14)
      DX=TWOPI/(RIGHT-1)
      DY=PI/(BOTTOM-1)
      R4IEWL=PLTPRM(15)
      R4ILAB=PLTPRM(16)
C     IXTIC TELLS THE ROUTINE WHICH COLUMNS OF SYMHLD 
C     HAVE THE MERIDIAN LINE INDICATOR SET.
      IXTIC=XSEG/DX+0.5D0
C     IYTIC TELLS THE ROUTINE WHICH ROWS OF SYMHLD WILL HAVE
C     THE PARALLELS INDICATOR SET.
      IYTIC=YSEG/DY+0.5D0
C  SET UP LABELS FOR HORIZONTAL AXIS.
      XLABEL(1)(1:131)=' '
      XLABEL(2)(1:131)=' '
      IF(ILABEL.EQ.0) GO TO 247
      NSEGS=(RIGHT-1)/IXTIC+1
      DO 233 ISEG=1,NSEGS
      VAL=DMOD(WEST+(ISEG-1)*IXTIC*DX+TWOPI,TWOPI)
      IF(IEWLBL.LT.1 .AND. VAL.GT.PI) VAL=VAL-TWOPI
      IVAL=JIDNNT(VAL*DEGRAD)
      IF(IVAL.EQ.360) IVAL=0
      I4CH=I4CHAR(IABS(IVAL),3,IDUM)
      IX1=(ISEG-1)*IXTIC+3
      IX2=IX1+2
      XLABEL(1)(IX1:IX2)=I4CH(1:3)
      SYM='E'
      IF(IVAL.LT.0) SYM='W'
      IF(IVAL.EQ.0 .OR. IABS(IVAL).EQ.180) SYM=' '
      XLABEL(1)(IX2+1:IX2+1)=SYM
      XLABEL(2)(IX2:IX2)='*'
  233 CONTINUE
  247 CONTINUE
C  SET UP LABELS FOR VERTICAL AXIS.
      DO 234 IY=1,BOTTOM
      YLABEL(IY,2)(1:4)=' '
  234 YLABEL(IY,1)(1:4)=' '
      IF(ILABEL.EQ.0) GO TO 248
      NSEGS=(BOTTOM-1)/IYTIC+1
      DO 243 ISEG=1,NSEGS
      ILOC=(ISEG-1)*IYTIC+1
      VAL=HALFPI-(ILOC-1)*DY
      IVAL=JIDNNT(VAL*DEGRAD)
      I4CH=I4CHAR(IABS(IVAL),3,IDUM)
      YLABEL(ILOC,1)(1:2)=I4CH(2:3)
      YLABEL(ILOC,1)(3:3)='N'
      IF(IVAL.LT.0) YLABEL(ILOC,1)(3:3)='S'
      YLABEL(ILOC,1)(4:4)='*'
      YLABEL(ILOC,2)(1:1)='*'
      YLABEL(ILOC,2)(2:4)=YLABEL(ILOC,1)(1:3)
  243 CONTINUE
  248 CONTINUE
C
C
      WRITE(IPRINT,3333) XLABEL(1)(1:RIGHT+5),XLABEL(2)(1:RIGHT+5)
 3333 FORMAT('1',A/,1X,A)
      DO 600 IY=1,BOTTOM
      DO 601 IX=1,RIGHT
  601 L1LINE(IX)=SYMHLD(IY,IX)
      WRITE(IPRINT,4444) YLABEL(IY,1),PLOTLINE(1:RIGHT),
     1     YLABEL(IY,2)
 4444 FORMAT(1X,A,A,A)
  600 CONTINUE
      WRITE(IPRINT,3344) XLABEL(2)(1:RIGHT+5),XLABEL(1)(1:RIGHT+5)
 3344 FORMAT(1X,A/1X,A)
C
C
      RETURN
      END
