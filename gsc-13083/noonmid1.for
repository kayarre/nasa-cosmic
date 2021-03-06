      SUBROUTINE NOONMID1(T50,POS,VEL,KCOORD,
     *    TPNOON,TPMIDNT,TNNOON,TNMIDNT,KALGOR,NOWSTAT,LUERR,IERR)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C GIVEN A TIME AND A S/C STATE VECTOR, THIS ROUTINE COMPUTES THE 
C TIMES OF THE PREVIOUS AND NEXT NOON AND MIDNIGHT. ANALYTICAL
C EXPRESSIONS ARE USED WITH THE SUN FIXED AT T50 AND KEPLERIAN MOTION
C ASSUMED.
C
C
C VARIABLE DIM TYPE I/O DESCRIPTION
C -------- --- ---- --- -----------
C
C T50       1   R*8  I  THE TIME FOR WHICH THE S/C STATE IS SUPPLIED.
C                       IN SECONDS SINCE 1/1/50, 0.0 HRS
C
C                       'PREVIOUS' NOON/MIDNIGHT MEANS EARLIER THAN T50,
C                       'NEXT' MEANS AFTER.
C
C POS       3   R*8  I  THE S/C POSITION VECTOR AT TIME T50. IN KM.
C
C VEL       3   R*8  I  THE S/C VELOCITY VECTOR AT TIME T50. IN KM.
C
C KCOORD    1   I*4  I  FLAG INDICATING THE COORDINATE SYSTEM IN WHICH
C                       POS AND VEL ARE EXPRESSED.
C
C                        = 1, GEOCENTRIC, MEAN EQTR AND EQNX OF 1950.0
C                        = 2, GEOCENTRIC, MEAN EQTR AND EQNX OF DATE
C                        = 3, GEOCENTRIC, TRUE EQTR AND EQNX OF DATE
C                        = OTHERWISE, ERROR. IERR = 1 IS SET.
C
C TPNOON    1  R*8   O  TIME OF THE PREVIOUS NOON. IN SECONDS SINCE
C                       1/1/50, 0.0 HRS.
C
C TPMIDNT   1  R*8   O  TIME OF THE PREVIOUS MIDNIGHT. IN SECONDS SINCE
C                       1/1/50, 0.0 HRS.
C
C TNNOON    1  R*8   O  TIME OF THE NEXT NOON. IN SECONDS SINCE
C                       1/1/50, 0.0 HRS.
C
C TNMIDNT   1  R*8   O  TIME OF THE NEXT MIDNIGHT. IN SECONDS SINCE
C                       1/1/50, 0.0 HRS.
C
C KALGOR    1  I*4   I  FLAG DEFINING THE MEANING OF NOON AND MIDNIGHT.
C
C                       =1, NOON IS HALFWAY IN TIME BETWEEN SUNRISE
C                           AND SUNSET. MIDNIGHT IS HALFWAY IN TIME
C                           BETWEEN SUNSET AND SUNRISE.
C                       = OTHERWISE, ERROR. AUTOMATIC PROGRAM STOP.
C
C NOWSTAT   1  I*4   O  DAY/NIGHT STATUS AT TIME T50.
C
C                       = 1, IN FULL SUN OR PENUMBRA(=PART SHADOW)
C                       = 2, IN UMBRA(=FULL SHADOW)
C
C LUERR     1  I*4   I  FORTRAN UNIT NUMBER FOR ERROR MESSAGES.
C
C IERR      1  I*4   O  ERROR RETURN FLAG.
C
C                       = 0, NO ERROR.
C
C                       =-1, MINOR ERROR. S/C DOES NOT HAVE ORBIT NIGHT,
C                            AT LEAST NOT WITHIN ONE ORBITAL PERIOD OF
C                            T50. OUTPUT TIMES SET TO T50.
C
C                       = 1, MAJOR ERROR. DO NOT USE RESULTS. ALL OTHER
C                            OUTPUT QUANTITIES SET TO ZERO.
C
C***********************************************************************
C
C BY C PETRUZZO, GSFC/742. 5/85
C      MODIFIED.....
C
C***********************************************************************
C
      REAL*8 POS(3),VEL(3)
C
      IBUG = 0
      LUBUG = 19
C
C THERE IS ONLY ONE DEFINITION CURRENTLY AVAILABLE FOR NOON AND
C MIDNIGHT. FUTURE MODS WILL ALLOW OTHER DEFINITIONS.
C
      IF(KALGOR.NE.1) STOP 'NOONMID1 ERROR END. SEE CODE.'
C
C
C INITIALIZE
C
      IERR = 0
      ERTHMU = CONST(56)
      PD = PERIOD(ERTHMU,POS,VEL)
C
C
C GET THE APPROX TIMES OF THE PREVIOUS AND NEXT SUNRISES AND 
C SUNSETS, AND THE DAY/NIGHT STATUS AT T50. THE SUN POSITION IS FIXED
C AT TIME T50.
C
      CALL TSHADOW1(T50,POS,VEL,KCOORD,
     *       TPRISE,TPSET,TNRISE,TNSET,NOWSTAT,LUERR,IER1)
      IF(IER1.NE.0) THEN  ! -1= NO ORBIT NIGHT, +1= MAJOR ERROR.
        IERR = IER1
        IF(IERR.EQ.1) THEN
          IF(LUERR.GT.0) WRITE(LUERR,1001)
 1001     FORMAT(/,' NOONMID1. ERROR RETURN FROM TSHADOW1.')
          END IF
        GO TO 9999
        END IF
C
C
C SET THE OUTPUT TIMES.
C
      IF(KALGOR.EQ.1) THEN
        IF(NOWSTAT.EQ.1) THEN   ! IN ORBIT DAY
          TNMIDNT = (TNSET + TNRISE) / 2.D0
          TPMIDNT = (TPSET + TPRISE) / 2.D0
          TEMP = (TPRISE + TNSET) / 2.D0
          IF(T50.LT.TEMP) THEN
            TNNOON = TEMP
            TPNOON = TNNOON - PD
          ELSE
            TPNOON = TEMP
            TNNOON = TPNOON + PD
            END IF
        ELSE                    ! IN ORBIT NIGHT
          TNNOON = (TNRISE + TNSET) / 2.D0
          TPNOON = (TPRISE + TPSET) / 2.D0
          TEMP = (TPSET + TNRISE) / 2.D0
          IF(T50.LT.TEMP) THEN
            TNMIDNT = TEMP
            TPMIDNT = TEMP - PD
          ELSE
            TPMIDNT = TEMP
            TNMIDNT = TEMP + PD
            END IF
          END IF
        END IF
C
C
 9999 CONTINUE
C
C WRAP IT UP
C
      IF(IERR.EQ.0) THEN             ! NO ERRORS
        CONTINUE
      ELSE IF(IERR.EQ.-1) THEN       ! NO ORBIT NIGHT
        NOWSTAT = 1
        TPNOON =  T50
        TPMIDNT = T50
        TNNOON =  T50
        TPMIDNT = T50
      ELSE IF(IERR.EQ.1) THEN        ! MAJOR ERROR
        NOWSTAT = 0
        TPNOON =  0.D0
        TPMIDNT = 0.D0
        TNNOON =  0.D0
        TPMIDNT = 0.D0
      ELSE
        STOP 'NOONMID1 CODING ERROR. BAD IERR VALUE. STOP.'
        END IF
C
      RETURN
      END
