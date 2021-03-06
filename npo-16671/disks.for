      SUBROUTINE DISKS(RHO,TH,PH,EPS,FV)
      DOUBLE PRECISION RP(3),ALI(3,3),PHII(3,3),AI(3,3),PLI(3,3),RI(3),
     1ALPT(3,3),FV(3),CO,    RM2,AI1,AKI,SKI,AT,H,V,FM(3,3),VF(3)
      DOUBLE PRECISION TH, PH, EPS, U, RHO, RC, COM(1), THRAD, PHRAD,
     1 RCOS, DLCO, PLCO, RMAI,UI,A,PHI,DL,RH
      COMMON /PRAM/ NMAS, NHARM, NDISK
      COMMON RC,U,COM
      DATA CO /.1745329251994430D-1/
COMMENTS ABOUT CHANGES TO STATEMENT FUNCTIONS:
C... I1 - REPRESENTS THE COUNTER VARIABLE I IN LOOP 100
C... I2 - REPRESENTS THE NUMBER OF DISKS(NDISK) TO PROCESS
C... I3 - REPRESENTS THE ACTUAL ADDRESS IN THE COM ARRAY
C
       UI(I1,I3)=COM(I1+I3)
       A(I1,I2,I3)=COM(I1+I2+I3)
       PHI(I1,I2,I3)=COM(I1+2*I2+I3)
       DL(I1,I2,I3)=COM(I1+3*I2+I3)
       RH(I1,I2,I3)=COM(I1+4*I2+I3)
      IA = 4*NMAS
      ID = IA + 2*NHARM**2 + NHARM
      THRAD = TH*CO
      PHRAD = PH*CO
      RCOS = RHO*DCOS(THRAD)
      RP(1) = RCOS*DCOS(PHRAD)
      RP(2) = RCOS*DSIN(PHRAD)
      RP(3) = RHO*DSIN(THRAD)
      DO 1 I=1,3
      FV(I)=0.D0
      DO 1 J=1,3
      ALI(I,J)=0.D0
      PHII(I,J)=0.D0
    1 AI(I,J)=0.D0
      PHII(2,2)=1.D0
      ALI(3,3)=1.D0
      DO 100 I=1,NDISK
      DLCO = DL(I,NDISK,ID)*CO
      ALI(1,1) = DCOS(DLCO)
      ALI(2,2)=ALI(1,1)
      ALI(1,2) = DSIN(DLCO)
      ALI(2,1)=-ALI(1,2)
      PLCO = PHI(I,NDISK,ID)*CO
      PHII(1,1) = DSIN(PLCO)
      PHII(3,3)=PHII(1,1)
      PHII(3,1) = DCOS(PLCO)
      PHII(1,3)=-PHII(3,1)
      CALL MATMUL(PHII,ALI,3,3,3,PLI)
      CALL MATVEC(PLI,RP,3,3,RI)
      RI(3)=RI(3)-RH(I,NDISK,ID)
      RM2=RI(1)*RI(1)+RI(2)*RI(2)+RI(3)*RI(3)
      IF(RM2/UI(I,ID).GT.EPS)GO TO 100
      AI1 = 1.0D0/A(I,NDISK,ID)**2
      RMAI = RM2*AI1 - 1.0D0
      AKI = (RMAI + DSQRT(RMAI**2 + 4.0D0*RI(3)**2*AI1))*0.5D0
      SKI=DSQRT(AKI)
      AT=DATAN(1.D0/SKI)
      H=AT-SKI/(1.D0+AKI)
      V=2.D0/SKI-2.D0*AT
      AI(1,1)=H
      AI(2,2)=H
      AI(3,3)=V
      DO 2 J=1,3
      DO 2 K=1,3
    2 ALPT(J,K)=PLI(K,J)
      CALL MATMUL(ALPT,AI,3,3,3,FM)
      CALL MATVEC(FM,RI,3,3,VF)
      DO 3 J=1,3
    3 FV(J)=VF(J)*3.D0*U*UI(I,ID)*AI1/(2.D0*A(I,NDISK,ID))+FV(J)
  100 CONTINUE
      RETURN
      END
