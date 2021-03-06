       PROGRAM EXAMP3DH
C *** LAST REVISED ON 14-AUG-1987 16:18:32.76
C *** SOURCE FILE: [DL.GRAPHICS.LONGLIB]EXAMP3DH.FOR
C
C ******************************************************************************
C
C THIS PROGRAM DEMONSTRATES THE HIDDEN LINE ROUTINES OF THE LONGLIB GRAPHICS
C PACKAGE.  FROM A DATA FILE A SERIES OF SHAPES ARE DRAWN WITH THE HIDDEN
C LINES REMOVED.  THIS PROGRAM IS FORTRAN 77 COMPATIBLE
C
C ******************************************************************************
C
       DIMENSION X(8),Y(8),Z(8)
C
C       DEFINE WORK SPACE FOR HIDDEN LINE PACKAGE (SEE COMMENTS BELOW)
C
       COMMON/GO/ICORE,WORK(10000)
C
C        INITIALIZE PLOT PACKAGE WITH PROMPT FOR SCREEN GRAPHICS DEVICE
C        BUT WITH FILE OUTPUT TO UNIT 3.
C
       CALL FRAME(3,0,3.,3.,.5)
       CALL SYMBOL(-2.5,-2.5,.2,'EXAMP3DH',0.,8,-1)
       CALL CTERM(1)
       DV=9999
       MNE=6
       MNH=0
       PSI=20.
       PHI=10.
       THETA=3.
C
C       INITIALIZE 3DH PACKAGE
C
       CALL INIT3DH(0.,0.,0.,PSI,PHI,THETA,1.,DV,MNE,MNH)
C
C        MNP=MNE+2+2*NMH
C        ICORE=(25+5*MNE+4*MNP)*NELEM
C        IN THIS CASE,NELEM=8,MNP=8 AND MNE=6.
C        THE TOTAL NUMBER OF SETS ARE 8.
C
       ICORE=10000
       ICNT=0
  100  CONTINUE
C
C        READ IN X,Y,Z TRIPLETS
C        CALCULATE NUMBER OF TRIPLETS (NTRP)
C
       CALL READARY(X,Y,Z,NTRP,NC,IFLAG)
       IF (IFLAG.EQ.2) GOTO 103
       DO 101 I=1,NTRP
C
C        CHANGE SIZE OF THE X DIMENSION
C
       X(I)=X(I)*.2
       IF (ICNT.EQ.2) Y(I)=Y(I)+.3 
 101   CONTINUE
C
       CALL CTERM(-1) 
       NCC=NC
       IF (NC.EQ.1.AND.ICNT.EQ.1) NCC=0
       CALL SKETCH(X,Y,Z,NTRP,NCC)
       CALL CTERM(1)

       IF (IFLAG .EQ. 0) GOTO 100
C
C       PLOT VISIBLE LABEL
C
       CALL CTERM(-1)
       CALL SYM3DH(0.,0.,0.,20.,10.,0.,.5,'Testing',7,0)
       PSI=-50.
       PHI=-50.
       THETA=20.0
       ICNT=ICNT+1
C
C        POSITION PLOTTER FOR NEXT PLOT
C
       CALL CTERM(-1)
       CALL PLOT(0.0,0.0,3)
       CALL CTERM(1)
       CALL INIT3DH(0.,0.,0.,PSI,PHI,THETA,1.,DV,MNE,MNH)
       REWIND(5)
       IF (ICNT.LT.2) GO TO 100
C
C        CLOSE PLOT PACKAGE
C
  103  CALL PLOT(0.,0.,3)
       CALL CTERM(2)
       CALL PLOTND
       STOP
       END
C
      SUBROUTINE READARY(X,Y,Z,NTRP,NC,IFLAG)
      DIMENSION X(1),Y(1),Z(1)
      IFLAG=0
      NX=1
      OPEN(UNIT=5,NAME='HIDE.DAT;1',READONLY,FORM='FORMATTED',
     $   STATUS='OLD')
   10 CONTINUE
      NZ=NX+3
      READ(5,1,ERR=2) (X(N),Y(N),Z(N),N=NX,NZ)
    1 FORMAT(12F5.0)
    3 CONTINUE
      NC=0
      DO 5 J=NX,NZ
       IF(X(J) .EQ. 9998.) GOTO 7
       IF(X(J) .EQ. 9999.) GOTO 6
       GOTO 5
    6  NC=1
    7  NTRP=J-1
       IFLAG=NC
       RETURN
    5 CONTINUE
      NX=NX+4
      GOTO 10
    2 IFLAG=2
      RETURN
      END
