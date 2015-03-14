      SUBROUTINE QUIKVIS5A2B
      IMPLICIT REAL*8 (A-H,O-Z)
C
C THIS ROUTINE IS PART OF THE QUIKVIS PROGRAM.  IT WRITES THE DATA
C RECORDS FOR THE XYPLOT DATA FILES.
C
C***********************************************************************
C
C BY C PETRUZZO/GFSC/742.   2/86.
C       MODIFIED.... 9/86. CJP. DELETED TAREQMT ARRAY;  ADDED CALL TO
C                               QV5READ(ENTRY IN QUIKVIS5U) AND DELETED
C                               READ STATEMENT FOR LUSCR1; SET
C                               XYDATA(3)=99.D0 WHEN TIME NOT INVOLVED;
C
C***********************************************************************
C
      INCLUDE 'QUIKVIS.INC'
C
C
      REAL*8 VISTIMES(MAXNODES)
C
      REAL*8 XYDATA(3)
      CHARACTER*16 CH16NAME
      CHARACTER*20 CH20
      CHARACTER*21 CHYMD
      CHARACTER*3 MINMAX(2)/'MIN','MAX'/
C
      IBUG = 0
      LUBUG = 19
C
C
C GENERATE PLOT FILE CONTAINING DURATION -VS- RAAN, ONE DATA GROUP FOR
C EACH TARGET/DATE PAIR.
C
      IF(.NOT.DOXYPLOT1) GO TO 2000
C
      DO ITIME=1,NUMTIMES
C
        CALL QV5READ(ITIME,
     *       T50,KDUM,ID,CH16NAME,
     *       FIRSTNODE,DELNODE,FIRSTMST,DELMST,NUMNODES,
     *       .FALSE.,DUM, .TRUE.,VISTIMES, .FALSE.,DUM)
C
        IF(NEEDTIME) THEN
          CALL PAKT50CH(T50,CH20)
          CHYMD = 'Y/M/D= ' // CH20(1:8)
          K2CHYMD = 15
        ELSE   ! DATE IS IRRELEVANT, SO ELIMINATE THE DATE REFERENCE.
          CHYMD = ' '
          K2CHYMD = 1
          END IF
C
C      IDENTIFY TARG AND DATE WITH WHICH SUBSEQUENT DATA IS ASSOCIATED
        WRITE(LUXYPLOT1,502) ID,CHYMD(1:K2CHYMD)
C
C      WRITE DATA TRIPLETS. (RAAN, AVAILABILITY TIME, MEAN SOLAR TIME)
        DO INODE=1,NUMNODES
          XYDATA(1) = EQVANG((FIRSTNODE+(INODE-1)*DELNODE))*DEGRAD
          XYDATA(2) = VISTIMES(INODE)/60.D0
          XYDATA(3) =
     *           DMOD( (FIRSTMST+(INODE-1)*DELMST)/3600.D0,24.D0 )
          WRITE(LUXYPLOT1,503) XYDATA
          END DO  ! END INODE LOOP
C
C      XYPLOTTER PGM READS IN A LIST-DIRECTED MANNER. END THE DATA
C      WITH A SLASH(/).
        WRITE(LUXYPLOT1,504)
C
        END DO    ! END ITIME LOOP
C
 2000 CONTINUE
C
C
C PLOT FILE CONTAINING MIN/MAX DURATION -VS- DATE, TWO DATA GROUPS FOR
C EACH TARGET.  ONE GROUP IS FOR MAX DURATIONS, THE OTHER FOR MIN.  THE
C FILE IS ORGANIZED THIS WAY BECAUSE ONE MAY WISH TO PLOT MAX AND MIN ON
C THE SAME PLOT AND TO DO SO, THE XYPLOTTER PROGRAM REQUIRES THAT THE
C DATA BE IN SEPARATE GROUPS.
C
      IF(.NOT.DOXYPLOT2) GO TO 9999
C
      DO IPASS=1,2
C
        DO ITIME=1,NUMTIMES
C
          CALL QV5READ(ITIME,
     *           T50,KDUM,ID,CH16NAME,
     *           FIRSTNODE,DELNODE,FIRSTMST,DELMST,NUMNODES,
     *           .FALSE.,DUM, .TRUE.,VISTIMES, .FALSE.,DUM)
C
          IF(ITIME.EQ.1) THEN
C          IDENTIFY TARG WITH WHICH SUBSEQUENT DATA IS ASSOCIATED
            WRITE(LUXYPLOT2,602) MINMAX(IPASS),ID
            END IF
C
C        WRITE DATA PAIRS. (DATE, MIN OR MAX AVAILABILITY TIME)
          IF(IPASS.EQ.1) THEN
            TDATA =  1.D10
          ELSE
            TDATA = -1.D10
            END IF
          DO INODE=1,NUMNODES
            IF(IPASS.EQ.1) THEN
              TDATA = DMIN1(TDATA,VISTIMES(INODE))
            ELSE
              TDATA = DMAX1(TDATA,VISTIMES(INODE))
              END IF
            END DO  ! END INODE LOOP
          WRITE(LUXYPLOT2,503) (T50-TSTART)/86400.D0,TDATA/60.D0
C
          END DO    ! END ITIME LOOP
C
C      XYPLOTTER PGM READS IN A LIST-DIRECTED MANNER. END THE DATA
C      WITH A SLASH(/).
        WRITE(LUXYPLOT2,504)
C
        END DO      ! END IPASS LOOP
C
 9999 CONTINUE
      RETURN
C
C***********************************************************************
C
C
C**** INITIALIZATION CALL. PUT GLOBAL PARAMETER VALUES INTO THIS
C     ROUTINE'S LOCAL VARIABLES.
C
      ENTRY QVINIT5A2B
C
      CALL QUIKVIS999(-1,R8DATA,I4DATA,L4DATA)
      RETURN
C
C***********************************************************************
C
  502 FORMAT(' ID=',I5,2X,A)
  602 FORMAT(1X,A,' DURATION, TARG ID=',I5)
  503 FORMAT( 9999( 3(2X,3(F7.3,','))/ ) )
  603 FORMAT( 9999( 2(2X,3(F7.3,','))/ ) )
  504 FORMAT('   /')
      END