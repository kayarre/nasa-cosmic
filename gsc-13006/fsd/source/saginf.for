      SUBROUTINE SAGINF(AZIF)
C
      IMPLICIT REAL*8(A-H,O-Z)
C
      COMMON/SAINTF/ GMK1,GMK2,GMDMP,GMSTP
C
      COMMON/SAGOUT/ AZ,AZD
C
C
      WSA=0.0D0
      DENA=DABS(AZ)
      IF(DENA.GT.GMSTP) WSA=DENA-GMSTP
      IF(DENA.NE.0.0D0) WSA=WSA*AZ/DENA
      AZIF=GMK1*AZ+GMK2*WSA+GMDMP*AZD
C
C
      RETURN
C
C
      END
