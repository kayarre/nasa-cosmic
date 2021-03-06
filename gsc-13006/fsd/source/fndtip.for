      SUBROUTINE FNDTIP
C
      IMPLICIT REAL*8(A-H,O-Z)
C
      COMMON/DEBUG2/IOUT,JOUT,KLUGE
C
      COMMON/ITWWRK/NKB,NTW,NTT,ILK,ILLK
C
      COMMON/TWWORK/FM(3,3),A(3),AD(3),B(3),BD(3),C(3),CD(3),ZL,RO
     1             ,RSQT(3),W2,W3,EIM,ED2,ED3,EDP,GJ,HKT(3)
C
      COMMON/TWWRK1/XX(3,3),XXD(3,3),XXDD(3),XXA(3,3,3),XXB(3,3,3)
     1             ,XXC(3,3,3),XDXA(3,3),XDXB(3,3),XDXC(3,3),XDDXA(3)
     2             ,XDDXB(3),XDDXC(3),XAX(3,3),XBX(3,3),XCX(3,3)
     3             ,DLAA(3,3),DLAB(3,3),DLAC(3,3),DLBB(3,3),DLBC(3,3)
     4             ,DLCC(3,3),VIFA(3),VIFB(3),VIFC(3)
C
C
      COMMON/TPWORK/XIP(3),BETL(3)
C
      DIMENSION DK(3,3),DKD(3,3),DKDD(3,3),DKU2(3,3),DKU3(3,3),DKT(3,3)
C
      DIMENSION II(3),JJ(3),OMT(3),HTIP(3)
C
      DATA DZERO/0.0D0/,II/2,3,1/,JJ/3,1,2/
C
C     ZERO OUT BASIC QUANTITIES
C
      U1P=1.0D0
      U2P=DZERO
      U3P=DZERO
      F=0.5D0
      U1PD=DZERO
      U2PD=DZERO
      U3PD=DZERO
      FD  =DZERO
      U1PDD=DZERO
      FDD  =DZERO
      U1PU2=DZERO
      FU2  =DZERO
      U1PU3=DZERO
      FU3  =DZERO
      W22=DZERO
      W23=DZERO
      W33=DZERO
      WD22=DZERO
      WD23=DZERO
      WD33=DZERO
      WDD22=DZERO
      WDD23=DZERO
      WDD33=DZERO
C
C     BASIC BENDING TERMS FOR TIP MASS INERTIAS
C
      IF(NKB.EQ.0) GO TO 5
C
      DO 2 I=1,NKB
      WS=XIP(I)/ZL
      U2P=U2P+A(I)*WS
      U3P=U3P+B(I)*WS
      U2PD=U2PD+AD(I)*WS
      U3PD=U3PD+BD(I)*WS
    2 CONTINUE
C
      W22=U2P*U2P
      W23=U2P*U3P
      W33=U3P*U3P
C
      U1P=1.0D0-W22-W33
      IF(U1P.LT.DZERO) U1P=DZERO
      U1P=DSQRT(U1P)
C
      WD22=2.0D0*U2P*U2PD
      WD23=U2P*U3PD+U3P*U2PD
      WD33=2.0D0*U3P*U3PD
C
      U1PD=-(WD22+WD33)/2.0D0
      U1PD=U1PD/U1P
C
      WDD22=2.0D0*U2PD*U2PD
      WDD23=2.0D0*U2PD*U3PD
      WDD33=2.0D0*U3PD*U3PD
C
      U1PDD=-(WDD22+WDD33)/2.0D0-U1PD*U1PD
      U1PDD=U1PDD/U1P
C
      U1PU2=-U2P/U1P
      U1PU3=-U3P/U1P
C
      F=1.0D0/(1.0D0+U1P)
      F2=F*F
      FD=-U1PD*F2
      FDD=-U1PDD*F2-2.0D0*U1PD*FD*F
C
      FU2=-U1PU2*F2
      FU3=-U1PU3*F2
C
C
    5 CONTINUE
C
C
      TWI=DZERO
      TWID=DZERO
C
      IF(NTW.EQ.0) GO TO 7
C
      DO 6 I=1,NTW
      TWI=TWI+C(I)*BETL(I)
      TWID=TWID+CD(I)*BETL(I)
    6 CONTINUE
C
C
    7 CONTINUE
C
C
      ST=DSIN(TWI)
      CT=DCOS(TWI)
C
C     CONSTRUCT TIP TRANSFORMATION MATRIX
C
      DK(1,1)=U1P
      DK(2,1)=U2P
      DK(3,1)=U3P
      DK(1,2)=-U3P*ST-U2P*CT
      DK(1,3)=U2P*ST-U3P*CT
C
      WS1=W23*F
      WS2=1.0D0-W22*F
      WS3=1.0D0-W33*F
C
      DK(2,2)=-WS1*ST+WS2*CT
      DK(3,2)=WS3*ST-WS1*CT
      DK(2,3)=-WS2*ST-WS1*CT
      DK(3,3)=WS1*ST+WS3*CT
C
      OMT(1)=TWID
      OMT(2)=-U3PD
      OMT(3)=U2PD
C
      HTIP(1)=RO*ZL*OMT(1)*(RSQT(2)+RSQT(3))
      HTIP(2)=RO*ZL*OMT(2)*(RSQT(3)+RSQT(1))
      HTIP(3)=RO*ZL*OMT(3)*(RSQT(1)+RSQT(2))
C
C     ZERO OUT REMAINING ARRAYS
C
      DO 10 I=1,3
      HKT(I)=DK(I,1)*HTIP(1)+DK(I,2)*HTIP(2)+DK(I,3)*HTIP(3)
      DO 9 J=1,3
      DKD(I,J)=DZERO
      DKDD(I,J)=DZERO
      DKU2(I,J)=DZERO
      DKU3(I,J)=DZERO
      DKT(I,J)=DZERO
    9 CONTINUE
   10 CONTINUE
C
      ITEST=NKB+NTW
      IF(ITEST.EQ.0) GO TO 50
C
C     CONSTRUCT DERIVATIVE MATRICES
C
      DKD(1,1)=U1PD
      DKD(2,1)=U2PD
      DKD(3,1)=U3PD
      DKD(1,2)=-U3PD*ST-U2PD*CT+TWID*(-U3P*CT+U2P*ST)
      DKD(1,3)=U2PD*ST-U3PD*CT+TWID*(U2P*CT+U3P*ST)
C
      WSD1=WD23*F+W23*FD
      WSD2=-WD22*F-W22*FD
      WSD3=-WD33*F-W33*FD
C
      WSDD1=WDD23*F+2.0D0*WD23*FD+W23*FDD
      WSDD2=-WDD22*F-2.0D0*WD22*FD-W22*FDD
      WSDD3=-WDD33*F-2.0D0*WD33*FD-W33*FDD
C
      DKD(2,2)=-WSD1*ST+WSD2*CT+TWID*(-WS1*CT-WS2*ST)
      DKD(2,3)=-WSD2*ST-WSD1*CT+TWID*(-WS2*CT+WS1*ST)
      DKD(3,2)=WSD3*ST-WSD1*CT+TWID*(WS3*CT+WS1*ST)
      DKD(3,3)=WSD1*ST+WSD3*CT+TWID*(WS1*CT-WS3*ST)
C
      DKDD(1,1)=U1PDD
      DKDD(1,2)=2.0D0*TWID*(-U3PD*CT+U2PD*ST)
      DKDD(1,3)=2.0D0*TWID*(U2PD*CT+U3PD*ST)
      DKDD(2,2)=-WSDD1*ST+WSDD2*CT+2.0D0*TWID*(-WSD1*CT-WSD2*ST)
      DKDD(2,3)=-WSDD2*ST-WSDD1*CT+2.0D0*TWID*(-WSD2*CT+WSD1*ST)
      DKDD(3,2)=WSDD3*ST-WSDD1*CT+2.0D0*TWID*(WSD3*CT+WSD1*ST)
      DKDD(3,3)=WSDD1*ST+WSDD3*CT+2.0D0*TWID*(WSD1*CT-WSD3*ST)
C
      IF(NKB.EQ.0) GO TO 40
C
      DKU2(1,1)=U1PU2
      DKU2(2,1)=1.0D0
      DKU2(1,2)=-CT
      DKU2(1,3)=ST
C
      WU21=U3P
      WU22=-2.0D0*U2P
C
      DKU2(2,2)=(-WU21*F-W23*FU2)*ST+(WU22*F-W22*FU2)*CT
      DKU2(2,3)=(-WU22*F-W22*FU2)*ST-(WU21*F+W23*FU2)*CT
      DKU2(3,2)=-W33*FU2*ST-(WU21*F+W23*FU2)*CT
      DKU2(3,3)=(WU21*F+W23*FU2)*ST-W33*FU2*CT
C
C
C
      DKU3(1,1)=U1PU3
      DKU3(3,1)=1.0D0
      DKU3(1,2)=-ST
      DKU3(1,3)=-CT
C
      WU31=U2P
      WU33=-2.0D0*U3P
C
      DKU3(2,2)=(-WU31*F-W23*FU3)*ST-W22*FU3*CT
      DKU3(2,3)=W22*FU3*ST-(WU31*F+W23*FU3)*CT
      DKU3(3,2)=(WU33*F-W33*FU3)*ST-(WU31*F+W23*FU3)*CT
      DKU3(3,3)=(WU31*F+W23*FU3)*ST+(WU33*F-W33*FU3)*CT
C
      IF(NTW.EQ.0) GO TO 50
C
C
   40 CONTINUE
C
C
      DKT(1,2)=-U3P*CT+U2P*ST
      DKT(1,3)=U2P*CT+U3P*ST
      DKT(2,2)=-WS1*CT-WS2*ST
      DKT(2,3)=-WS2*CT+WS1*ST
      DKT(3,2)=WS3*CT+WS1*ST
      DKT(3,3)=WS1*CT-WS3*ST
C
C
   50 CONTINUE
C
C
C     CONSTRUCT SYSTEM MATRICES FOR THIS ELEMENT
C
      DO 54 I=1,3
      I1=II(I)
      J1=JJ(I)
      DO 53 J=1,3
      XXDD(I)=XXDD(I)+RSQT(J)*(DKDD(I1,J)*DK(J1,J)-DKDD(J1,J)*DK(I1,J))
      DO 52 M=1,3
      XX(I,J)=XX(I,J)+RSQT(M)*DK(I,M)*DK(J,M)
      XXD(I,J)=XXD(I,J)+RSQT(M)*DK(I,M)*DKD(J,M)
   52 CONTINUE
   53 CONTINUE
   54 CONTINUE
C
      IF(IOUT.EQ.1) GO TO 55
      WRITE(6,6000)
      WRITE(6,6001) DK,DKD,DKDD,DKU2,DKU3,DKT
 6000 FORMAT('0',10X,'DEBUGGING OUTPUT FROM FNDTIP'/)
 6001 FORMAT(' ',1P9E14.6)
   55 CONTINUE
C
      IF(ITEST.EQ.0) GO TO 100
C
C
      XAXA=DZERO
      XAXB=DZERO
      XAXC=DZERO
      XBXB=DZERO
      XBXC=DZERO
      XCXC=DZERO
      XDDA=DZERO
      XDDB=DZERO
      XDDC=DZERO
C
      DO 58 I=1,3
      WAA=DZERO
      WAB=DZERO
      WAC=DZERO
      WBB=DZERO
      WBC=DZERO
      WCC=DZERO
      WDDA=DZERO
      WDDB=DZERO
      WDDC=DZERO
      DO 57 J=1,3
      WAA=WAA+DKU2(J,I)*DKU2(J,I)
      WAB=WAB+DKU2(J,I)*DKU3(J,I)
      WAC=WAC+DKU2(J,I)*DKT(J,I)
      WBB=WBB+DKU3(J,I)*DKU3(J,I)
      WBC=WBC+DKU3(J,I)*DKT(J,I)
      WCC=WCC+DKT(J,I)*DKT(J,I)
      WDDA=WDDA+DKDD(J,I)*DKU2(J,I)
      WDDB=WDDB+DKDD(J,I)*DKU3(J,I)
      WDDC=WDDC+DKDD(J,I)*DKT(J,I)
   57 CONTINUE
      WS=RSQT(I)
      XAXA=XAXA+WS*WAA
      XAXB=XAXB+WS*WAB
      XAXC=XAXC+WS*WAC
      XBXB=XBXB+WS*WBB
      XBXC=XBXC+WS*WBC
      XCXC=XCXC+WS*WCC
      XDDA=XDDA+WS*WDDA
      XDDB=XDDB+WS*WDDB
      XDDC=XDDC+WS*WDDC
   58 CONTINUE
C
C
      IF(NKB.EQ.0) GO TO 80
C
      DO 70 L=1,NKB
      WX=XIP(L)/ZL
C
      DO 64 I=1,3
      I1=II(I)
      J1=JJ(I)
      DO 63 J=1,3
      WS=RSQT(J)*WX
      XDXA(L,I)=XDXA(L,I)+WS*(DKD(I1,J)*DKU2(J1,J)-DKD(J1,J)*DKU2(I1,J))
      XDXB(L,I)=XDXB(L,I)+WS*(DKD(I1,J)*DKU3(J1,J)-DKD(J1,J)*DKU3(I1,J))
      DO 62 M=1,3
      WT=RSQT(M)*WX*DK(I,M)
      XXA(L,I,J)=XXA(L,I,J)+WT*DKU2(J,M)
      XXB(L,I,J)=XXB(L,I,J)+WT*DKU3(J,M)
C
   62 CONTINUE
   63 CONTINUE
C
   64 CONTINUE
      DO 65 I=1,3
      I1=II(I)
      J1=JJ(I)
      XAX(L,I)=XXA(L,I1,J1)-XXA(L,J1,I1)
      XBX(L,I)=XXB(L,I1,J1)-XXB(L,J1,I1)
C
   65 CONTINUE
C
      DO 66 I=1,NKB
      WS=WX*XIP(I)/ZL
      DLAA(L,I)=WS*XAXA
      DLAB(L,I)=WS*XAXB
      DLBB(L,I)=WS*XBXB
   66 CONTINUE
C
      IF(NTW.EQ.0) GO TO 70
C
      DO 67 I=1,NTW
      WS=WX*BETL(I)
      DLAC(L,I)=WS*XAXC
      DLBC(L,I)=WS*XBXC
   67 CONTINUE
C
      XDDXA(L)=WX*XDDA
      XDDXB(L)=WX*XDDB
C
   70 CONTINUE
C
      IF(NTW.EQ.0) GO TO 100
C
   80 CONTINUE
C
      DO 90 L=1,NTW
      WX=BETL(L)
      DO 84 I=1,3
      I1=II(I)
      J1=JJ(I)
      DO 83 J=1,3
      WS=RSQT(J)*WX
      XDXC(L,I)=XDXC(L,I)+WS*(DKD(I1,J)*DKT(J1,J)-DKD(J1,J)*DKT(I1,J))
      DO 82 M=1,3
      WT=RSQT(M)*DK(I,M)*WX
      XXC(L,I,J)=XXC(L,I,J)+WT*DKT(J,M)
C
   82 CONTINUE
C
   83 CONTINUE
C
   84 CONTINUE
C
      DO 85 I=1,3
      I1=II(I)
      J1=JJ(I)
      XCX(L,I)=XXC(L,I1,J1)-XXC(L,J1,I1)
   85 CONTINUE
C
      DO 86 I=1,NTW
      WS=BETL(I)*WX
      DLCC(L,I)=WS*XCXC
   86 CONTINUE
C
      XDDXC(L)=WX*XDDC
C
   90 CONTINUE
C
  100 CONTINUE
C
      RETURN
C
      END
