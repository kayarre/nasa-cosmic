      PROGRAM EIGHTY
C*
C* CONVERT A LISTING FILE TO 80 COLUMNS
C*
C*
C* RECORD FORMAT IS DEFINED AS :
C*
C*    3 BYTE LENGTH, FIRST RECORD, 3 BYTE LENGTH, SECOND RECORD...
C*    PACKED INTO AN EIGHTY COLUMN OUTPUT FILE WITHOUT CARRIAGE CONTROL
C*
C*
C* VARIABLES IN COMMON :
C*
C*    IN   - 255 BYTE INPUT BUFFER
C*    OUT  - 80 BYTE OUTPUT BUFFER
C*    NOUT - LOCATION OF LAST BYTE PUT INTO 'OUT'
C*
C*    NIN  - LOCATION OF PRESENT BYTE IN 'IN'
C*
      CHARACTER *255 IN
      CHARACTER *80 OUT
      CHARACTER *3 CLEN
      COMMON / IO / IN, OUT, NOUT
C
      IN   = ' '
      OUT  = ' '
      NOUT = 0
C
C --- WARNING ---
C     "CARRIAGECONTROL='LIST'" IS VAX-SPECIFIC
C
      OPEN (UNIT=8, CARRIAGECONTROL='LIST', STATUS='NEW')
C
C --- READ LONG LINE
C
10    READ(7,900,END=1000) IN
C
C --- PUT LENGTH OF LINE TO OUTPUT FILE
C
      LI = LENGTH ( IN )
      WRITE (CLEN,910) LI
      CALL PACK ( CLEN(1:1))
      CALL PACK ( CLEN(2:2))
      CALL PACK ( CLEN(3:3))
C
C --- COPY INPUT LINE TO OUTPUT FILE 
C
      DO 30 NIN = 1, LI
         CALL PACK ( IN(NIN:NIN))
30       CONTINUE
      GO TO 10
C
C --- END-OF-FILE OF INPUT FILE, USE -01 TO SIGNAL END-OF-FILE
C
1000  CALL PACK ( '-' )
      CALL PACK ( '0' )
      CALL PACK ( '1' )
C
C --- CHECK TO SEE IF OUTPUT BUFFER IS PARTIALLY FULL.  IF SO, WRITE IT.
C
      IF (NOUT .NE. 0) THEN
          OUT(NOUT+1:80) = ' '
          WRITE(8,920) OUT
      ENDIF
      STOP
900   FORMAT(A)
910   FORMAT(I3.3)
920   FORMAT(A80)
      END
C
C---END EIGHTY
C
      SUBROUTINE PACK ( C )
      CHARACTER *1 C
      COMMON / IO / IN, OUT, NOUT
      CHARACTER *80 OUT
      CHARACTER *255 IN
C
      NOUT = NOUT + 1
      OUT(NOUT:NOUT) = C
C
C --- IF BUFFER IS FULL, WRITE THE LINE
C
      IF (NOUT .EQ. 80) THEN
         WRITE(8,900)OUT
         NOUT = 0
      ENDIF
      RETURN
900   FORMAT ( A80 )
      END
C
C---END PACK
C
