      SUBROUTINE TAVISPAK3B(ANGREQ,UTARG,ORBDATA,EABEGIN,EACEASE,
     *             KVISFLAG,LUERR,IERR)
      IMPLICIT REAL*8(A-H, O-Z)
C
C THIS ROUTINE IS PART OF THE TAVISPAK SUBROUTINE SET. IT COMPUTES THE
C ECCENTRIC ANOMALY ANGLES AT WHICH THE ZENITH SEPARATION REQUIREMENT IS
C FIRST AND LAST SATISFIED. IT DIFFERS FROM TAVISPAK3A1 AND TAVISPAK3A2
C IN THAT THOSE ARE PART OF AN ITERATION PROCESS.  THIS ROUTINE PRODUCES
C THE ANGLES WITHOUT ITERATING.
C
C
C VARIABLE DIM TYPE I/O DESCRIPTION
C -------- --- ---- --- -----------
C
C ANGREQ    1   R*8  I  SAME DESCRIPTION AS IN TAVISPAK.
C
C UTARG     1   R*8  I  SAME DESCRIPTION AS IN TAVISPAK.
C
C EABEGIN   1   R*8  O  THE ECCENTRIC ANOMALY ANGLE AT WHICH THE ZENITH
C                       SEPARATION REQUIREMENT IS FIRST SATISFIED.
C
C EACEASE   1   R*8  O  THE ECCENTRIC ANOMALY ANGLE AT WHICH THE ZENITH
C                       SEPARATION REQUIREMENT IS LAST SATISFIED.
C
C ORBDATA   *   R*8  I  VALUES OF QUANTITES NEEDED TO COMPUTE RAMFCN.
C                       SET IN TAVISPAK. SEE TAVISPAK FOR DIMENSION.
C
C KVISFLAG  1   I*4  O  FLAG INDICATING NEVER/SOMETIMES/ALWAYS NATURE
C                       OF THE TARGET'S AVAILABILITY.
C                       = -1, NEVER AVAILABLE.
C                       =  0, SOMETIMES AVAILABLE, SOMETIMES NOT.
C                       =  1, ALWAYS AVAILABLE.
C
C IERR      1   I*4  O  ERROR RETURN FLAG.
C                       = 0, NO ERRORS.
C                       = 7, ANGREQ OUTSIDE OF 0 TO PI RANGE.
C
C***********************************************************************
C
C  CODED BY H SWARTWOOD AND C PETRUZZO, GSFC/742, 1/86.
C    MODIFIED....
C
C***********************************************************************
C
      REAL*8 POS(3),P(3),Q(3),UTARG(3),ORBDATA(20),SOLN(2),ANGOLD/1.D10/
      REAL*8 HALFPI / 1.570796326794897D0 /
      REAL*8 PI     / 3.141592653589793D0 /
      REAL*8 DEGRAD / 57.29577951308232D0 /
      REAL*8 TOLER/1.D-5/
C
      IBUG = 0
      LUBUG = 19
C
      IF(IBUG.NE.0) WRITE(LUBUG,9001) ANGREQ*DEGRAD,UTARG,ORBDATA
 9001 FORMAT(' TAVISPAK3B. DEBUG. ENTRY INFO. ANGREQ=',G16.8/,
     *  '    UTARG=',3G16.8/,'    ORBDATA=',(T15,4G16.8))
C
C INITIALIZE
C
      IERR =  0
      SMA =   ORBDATA( 1)
      ECC =   ORBDATA( 2)
      P(1) =  ORBDATA( 3)
      P(2) =  ORBDATA( 4)
      P(3) =  ORBDATA( 5)
      Q(1) =  ORBDATA( 6)
      Q(2) =  ORBDATA( 7)
      Q(3) =  ORBDATA( 8)
      TERM3 = ORBDATA(11)
C
      IF(ANGREQ.NE.ANGOLD) THEN
        COSREQ = DCOS(ANGREQ)
        ANGOLD = ANGREQ
        END IF
C
C COMPUTE COEFFICIENTS A,B,C OF ZENITH FUNCTION.  THE ZENITH FUNCTION
C CAN BE EXPRESSED(NOT AN APPROXIMATION) AS
C       FCN = A*DCOS(ECCANOM) + B*DSIN(ECCANOM) - C
C
      SDOTP = DOT(UTARG,P)
      SDOTQ = DOT(UTARG,Q)
      A = SDOTP * SMA + SMA * ECC * COSREQ
      B = SDOTQ * TERM3
      C = SDOTP * SMA * ECC + SMA * COSREQ
C
      IF(IBUG.NE.0) WRITE(LUBUG,9002) SDOTP,SDOTQ,A,B,C
 9002 FORMAT(' TAVISPAK3B DEBUG. SDOTP,SDOTQ=',2G16.8/,
     *       '    A,B,C=',3G16.8)
C
C SOLVE FOR THE ZEROS OF THE ZENITH FUNCTION.
C
      CALL TAVISPAK99(A,B,C,SOLN,KVISFLAG,LUERR,IERR)
      IF(IERR.NE.0) GO TO 9999
C
      EABEGIN = SOLN(1)
      EACEASE = SOLN(2)
C
 9999 CONTINUE
      RETURN
      END
