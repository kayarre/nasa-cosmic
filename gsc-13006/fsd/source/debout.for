      SUBROUTINE DEBOUT
C
      IMPLICIT REAL*8(A-H,O-Z)
C
      COMMON/CSTAT /X(20),XDOT(20),CPARM(43)
C
      DATA I8/',A8,'/
C
      CALL SET('PTCH OUT',0,0,X(1),I8)
      CALL SET('ROLL OUT',0,0,X(6),I8)
      CALL SET('NUTD OUT',0,0,X(20),I8)
      CALL SET('COMP AMP',0,0,X(16),I8)
      CALL SET('TACH OUT',0,0,X(13),I8)
      CALL SET('TMOTOR  ',0,0,X(14),I8)
      CALL SET('WHL SPD ',0,0,X(15),I8)
C
      RETURN
C
      END
