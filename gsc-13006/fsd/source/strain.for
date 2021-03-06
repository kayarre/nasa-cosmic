      SUBROUTINE STRAIN(ZLK,SE,K,KX,M)
C
C     'STRAIN' EVALUATES THE STRAIN ENERGY DUE TO BENDING FOR
C      EACH ANTENNA ELEMENT.
C
      IMPLICIT REAL * 8 (A-H,O-Z)
      INTEGER * 4 P,Q,R
C
      COMMON/CCMBNZ/ CMRK(10),Z01(4),Z02(4),Z03(4),Z04(4),Z11(12),
     .               Z12(12),Z13(12),Z14(12),Z15(12),Z16(12),Z21(36),
     .               Z22(36),Z23(36),Z24(36),Z25(36),Z26(36),Z27(36),
     .               Z28(36),Z31(108),Z32(108),Z33(108),Z34(108),
     .               Z35(108),Z41(324),Z42(324),Z43(324),ZK21(18),
     .               ZK22(18),ZK23(18),ZK31(54),ZK32(54),ZK33(54),
     .               ZK34(54),ZK35(54),ZK36(54),ZK41(162),ZK42(162),
     .               ZK43(162),ZK44(162),ZK45(162),ZK46(162),ZK47(162),
     .               ZK48(162),ZS01(2),ZS02(2),ZS11(6),ZS12(6),ZS13(6),
     .               ZS21(18),ZS22(18),ZS23(18),ZS24(18),ZS31(54),
     .               ZS32(54),ZS41(162),ZT21(108),ZT22(108),STAO(18),
     .               STA1(18),STA2(18),STBO(18),STB1(18),STB2(18),
     .               Z2S01(2),Z2S12(6),Z2S23(18)
C
      COMMON/CSOLAR/ SAO(10),SKA(9),SKB(9),SKOA(10,3),SKOB(10,3),
     .               STMK(10),SKAA(10,9),SKBB(10,9)
C
      COMMON/DEBUG3/ISWTCH
C
      COMMON/IPOOL1/ IGRAV,IDAMP,IK,K1,ITIM,IAB,IAPS,IBB,IBPS,NK(10),
     .               LK(10),LLK(10)
C
      DIMENSION  ZLK(10),SE(10),SE2(3),SE3(4),SE4(5)
C
C
      I2=0
      I3=0
      I4=0
      IF(LLK(K).EQ.1) GO TO 2
      I2=9
      I3=27
      I4=81
    2 CONTINUE
      SE21N=0.0D0
      SE22N=0.0D0
      SE23N=0.0D0
C
      SE31N=0.0D0
      SE32N=0.0D0
      SE33N=0.0D0
      SE34N=0.0D0
C
      SE41N=0.0D0
      SE42N=0.0D0
      SE43N=0.0D0
      SE44N=0.0D0
      SE45N=0.0D0
C
      DO 40 N=1,M
C
      SE21P=0.0D0
      SE22P=0.0D0
      SE23P=0.0D0
C
      SE31P=0.0D0
      SE32P=0.0D0
      SE33P=0.0D0
      SE34P=0.0D0
C
      SE41P=0.0D0
      SE42P=0.0D0
      SE43P=0.0D0
      SE44P=0.0D0
      SE45P=0.0D0
C
      DO 30 P=1,M
C
      SE31Q=0.0D0
      SE32Q=0.0D0
      SE33Q=0.0D0
      SE34Q=0.0D0
C
      SE41Q=0.0D0
      SE42Q=0.0D0
      SE43Q=0.0D0
      SE44Q=0.0D0
      SE45Q=0.0D0
C
      DO 20 Q=1,M
C
      SE41R=0.0D0
      SE42R=0.0D0
      SE43R=0.0D0
      SE44R=0.0D0
      SE45R=0.0D0
C
      DO 10 R=1,M
C
      A1=FUNA(K,KX,R) - OFFSTA(K,KX,R)
      B1=FUNB(K,KX,R) - OFFSTB(K,KX,R)
C
      IR=I4+27*(N-1)+9*(P-1)+3*(Q-1)+R
      SE41R=SE41R+A1*ZK41(IR)
      SE42R=SE42R+B1*ZK42(IR)
      SE43R=SE43R+B1*ZK43(IR)
      SE44R=SE44R+B1*ZK44(IR)
      SE45R=SE45R+B1*ZK48(IR)
      IF(ISWTCH.NE.0) GO TO 10
      WRITE(6,10011) K,N,P,Q,R
      WRITE(6,10000) R,A1,B1
      WRITE(6,10001) ZK41(IR),ZK42(IR),ZK43(IR),ZK44(IR),ZK48(IR)
      WRITE(6,10002) SE41R,SE42R,SE43R,SE44R,SE45R
   10 CONTINUE
C
      A1=FUNA(K,KX,Q) - OFFSTA(K,KX,Q)
      B1=FUNB(K,KX,Q) - OFFSTB(K,KX,Q)
      IQ=I3+9*(N-1)+3*(P-1)+Q
C
      SE31Q=SE31Q+A1*ZK31(IQ)
      SE32Q=SE32Q+B1*ZK32(IQ)
      SE33Q=SE33Q+B1*ZK33(IQ)
      SE34Q=SE34Q+B1*ZK36(IQ)
C
      SE41Q=SE41Q + A1*SE41R
      SE42Q=SE42Q + A1*SE42R
      SE43Q=SE43Q + B1*SE43R
      SE44Q=SE44Q + B1*SE44R
      SE45Q=SE45Q + B1*SE45R
      IF(ISWTCH.NE.0) GO TO 20
      WRITE(6,10011) K,N,P,Q,R
      WRITE(6,10000) Q,A1,B1
      WRITE(6,10003) ZK31(IQ),ZK32(IQ),ZK33(IQ),ZK36(IQ)
      WRITE(6,10004) SE31Q,SE32Q,SE33Q,SE34Q
      WRITE(6,10002) SE41Q,SE42Q,SE43Q,SE44Q,SE45Q
   20 CONTINUE
C
      A1=FUNA(K,KX,P) - OFFSTA(K,KX,P)
      B1=FUNB(K,KX,P) - OFFSTB(K,KX,P)
      IP=I2+3*(N-1)+P
C
      SE21P=SE21P+A1*ZK21(IP)
      SE22P=SE22P+B1*ZK22(IP)
      SE23P=SE23P+B1*ZK23(IP)
C
      SE31P=SE31P + A1*SE31Q
      SE32P=SE32P + A1*SE32Q
      SE33P=SE33P + B1*SE33Q
      SE34P=SE34P + B1*SE34Q
C
      SE41P=SE41P + A1*SE41Q
      SE42P=SE42P + A1*SE42Q
      SE43P=SE43P + A1*SE43Q
      SE44P=SE44P + B1*SE44Q
      SE45P=SE45P + B1*SE45Q
      IF(ISWTCH.NE.0) GO TO 30
      WRITE(6,10011) K,N,P,Q,R
      WRITE(6,10000) P,A1,B1
      WRITE(6,10005) ZK21(IP),ZK22(IP),ZK23(IP)
      WRITE(6,10006) SE21P,SE22P,SE23P
      WRITE(6,10004) SE31P,SE32P,SE33P,SE34P
      WRITE(6,10002) SE41P,SE42P,SE43P,SE44P,SE45P
   30 CONTINUE
C
      A1=FUNA(K,KX,N) - OFFSTA(K,KX,N)
      B1=FUNB(K,KX,N) - OFFSTB(K,KX,N)
C
      SE21N=SE21N + A1*SE21P
      SE22N=SE22N + A1*SE22P
      SE23N=SE23N + B1*SE23P
C
      SE31N=SE31N + A1*SE31P
      SE32N=SE32N + A1*SE32P
      SE33N=SE33N + A1*SE33P
      SE34N=SE34N + B1*SE34P
C
      SE41N=SE41N + A1*SE41P
      SE42N=SE42N + A1*SE42P
      SE43N=SE43N + A1*SE43P
      SE44N=SE44N + A1*SE44P
      SE45N=SE45N + B1*SE45P
      IF(ISWTCH.NE.0) GO TO 40
      WRITE(6,10011) K,N,P,Q,R
      WRITE(6,10000) N,A1,B1
      WRITE(6,10006) SE21N,SE22N,SE23N
      WRITE(6,10004) SE31N,SE32N,SE33N,SE34N
      WRITE(6,10002) SE41N,SE42N,SE43N,SE44N,SE45N
   40 CONTINUE
C
      ZLK3=ZLK(K)**3
      ZLK4=ZLK(K)*ZLK3
      ZLK5=ZLK(K)*ZLK4
C
      SE2(1)=(SKAA(K,1)/ZLK3)*SE21N
      SE2(2)=(SKAA(K,2)/ZLK3)*SE22N
      SE2(3)=(SKBB(K,2)/ZLK3)*SE23N
C
      SE3(1)=(SKAA(K,3)/ZLK4)*SE31N
      SE3(2)=(SKAA(K,4)/ZLK4)*SE32N
      SE3(3)=(SKAA(K,5)/ZLK4)*SE33N
      SE3(4)=(SKBB(K,5)/ZLK4)*SE34N
C
      SE4(1)=(SKAA(K,6)/ZLK5)*SE41N
      SE4(2)=(SKAA(K,7)/ZLK5)*SE42N
      SE4(3)=(SKAA(K,8)/ZLK5)*SE43N
      SE4(4)=(SKAA(K,9)/ZLK5)*SE44N
      SE4(5)=(SKBB(K,9)/ZLK5)*SE45N
C
      SE(K)=SE2(1)/2 + SE2(2) + SE2(3)/2
     .     +SE3(1)/3 + SE3(2)/2 + SE3(3) + SE3(4)/3
     .     +SE4(1)/4 + SE4(2)/3 + SE4(3)/2 + SE4(4) + SE4(5)/4
C
      IF(ISWTCH.NE.0) RETURN
      WRITE(6,10007) ZLK(K),ZLK3,ZLK4,ZLK5
      WRITE(6,10008) (SE2(I),I=1,3)
      WRITE(6,10009) (SE3(I),I=1,4)
      WRITE(6,10010) (SE4(I),I=1,5)
      RETURN
C
C
10000 FORMAT('0',5X,'INDEX ',I2,' A1 ',F9.2,' B1 ',F9.2)
C
10001 FORMAT('0',2X,'ZK41 ',G20.13,' ZK42 ',G20.13,' ZK43 ',G20.13/3X,
     .              'ZK44 ',G20.13,' ZK48 ',G20.13)
C
10002 FORMAT('0',2X,'SE41 ',G20.13,' SE42 ',G20.13,' SE43 ',G20.13/3X,
     .              'SE44 ',G20.13,' SE45 ',G20.13)
C
10003 FORMAT('0',2X,'ZK31 ',G20.13,' ZK32 ',G20.13,' ZK33 ',G20.13/3X,
     .              'ZK36 ',G20.13)
C
10004 FORMAT('0',2X,'SE31 ',G20.13,' SE32 ',G20.13,' SE33 ',G20.13/3X,
     .              'SE34 ',G20.13)
C
10005 FORMAT('0',2X,'ZK21 ',G20.13,' ZK22 ',G20.13,' ZK23 ',G20.13)
C
10006 FORMAT('0',2X,'SE21 ',G20.13,' SE22 ',G20.13,' SE23 ',G20.13)
C
10007 FORMAT('0',2X,'ZLK(K) ',G20.13,' ZLK3 ',G20.13,' ZLK4 ',G20.13/3X,
     .              'ZLK5 ',G20.13)
C
10008 FORMAT('0',2X,'SE2(I),I=1,3 ',3(G20.13,2X))
C
10009 FORMAT('0',2X,'SE3(I),I=1,4 ',4(G20.13,2X))
C
10010 FORMAT('0',2X,'SE(I),I=1,5 ',5(G20.13,2X))
C
10011 FORMAT('0',2X,'K N P Q R'/2X,5I2)
C
      END
