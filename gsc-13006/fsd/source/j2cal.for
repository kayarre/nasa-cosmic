      SUBROUTINE J2CAL(ZBZK,CKMAT,XX,ZF,ZZT)
C
C     'J2CAL' CALCULATES THE TOTAL MOMENT OF INERTIA OF THE LIBRATION
C     DAMPER IN THE DAMPER FRAME.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
C
      DIMENSION ZBZK(3),CKMAT(3,3),XX(3,3),ZZO(3,3),ZZOF(3,3),ZZFF(3,3),
     .          CT(3,3),ZZT(3,3),ZF(3),DUM(3,3)
C
C
      DO 10 I=1,3
      DO 10 J=1,3
      ZZO(I,J)=ZBZK(I)*ZBZK(J)
   10 ZZOF(I,J)=ZBZK(I)*ZF(J)
C
      CALL MULTM(CKMAT,XX,DUM,3,3,3)
      CALL MATRAN(CKMAT,CT,3,3)
      CALL MULTM(DUM,CT,ZZFF,3,3,3)
C
      DO 20 I=1,3
      DO 20 J=1,3
   20 ZZT(I,J)=ZZO(I,J) + ZZOF(I,J) + ZZOF(J,I) + ZZFF(I,J)
C
      RETURN
      END
