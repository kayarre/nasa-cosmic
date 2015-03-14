

C      SOLAR SPACE POWER ANALYSIS  CODE
C     LATEST UPDATE ON 14 MARCH 1985
C
      DIMENSION ETASC(10),ETAES(10), ETAET(10),ETAPP(10),ETARH(10),
     1ETAEDI(10),ETATS(10),ETAHT(10),ETAPC(10),ETAHDI(10),UHREJ(10),
     2EKWRQ(5),TKWRQ(5),TREQ(5),SCDEG(5),REFDEG(5),STODEG(5),CONRAT(5)
C
C     LIST OF COMPONENTS OF OPTIONS UNDER STUDY
C
C     PV : PHOTOVOLTAIC PANELS
C     ES : ELECTRICITY STORAGE
C     ET : ELECTRICITY TRANSPORT
C     PP : POWER PROCESSING
C     RH : RESISTANCE HEATING
C     EDI: ELECTRIC PARABOLIC DISH
C     TS : THERMAL STORAGE
C     HT : HEAT TRANSPORT
C     HDI: HEAT PARABOLIC DISH
C     PC : POWER CONVERSION
C     RAD: RADIATOR
C     SCC:SOLAR CELL CONCENTRATOR
C
C     ******************************************************************
C     THIS PORTION IS FOR PERSONAL COMPUTER RUNS                       *
C                                                                      *
C     OPEN AN INPUT FILE                                               *
C     INPUT FILE NAME IS "INPUT.DAT"                                    *
C                                                                      *
      OPEN (5,FILE='INPUT.DAT')                                           *
C                                                                      *
C     OPEN AN OUTPUT FILE                                              *
C     OUTPUT FILE NAME IS "OUTPT.DAT"                                   *
C                                                                      *
      OPEN (6,FILE='OUTPT.DAT',STATUS='NEW')                            *
C                                                                      *
C     ******************************************************************
C
C     UNIT WEIGHTS OF COMPONENTS
C
      READ(5,13)UWSC,UWEDI,UWHDI,UWTS,UWHTS,UWES,UWEHS,UWET,UWRAD,UWRE,
     1UWPP,UWSCC,UWPC,UWHT
   13 FORMAT(4F5.1,10F6.1)
C
C     DESIGN AND PERFORMANCE REQUIREMENTS
C     BEAM INSOLATION ,DARK AND SUNLIT PERIODS FROM SUBROUTINE ORBIT
C
      DRKM=31.5
      SNLTM=58.5
C
C     TEMPERATURE REQUIRED
      TREQ(IJ)=1000.
C
C     DEGRADATION FACTORS
C     PRESENTLY NO DEGRADATION IS IS ASSUMED
C     CORRECT FOLLOWING FOUR STATEMENTS IF  ANY DEGRADATION IS PRESENT
      KIJ=1
C
      REFDEG(KIJ)=1.0
      SCDEG(KIJ)=1.0
      STODEG(KIJ)=1.0
C
C
C     SPECIFY THE FRACTION OF THE POWER PROCESSED
C
      PPF=1.
      UPPF=0.
C
C     DEFINE OPTIONS
C
      READ(5,17)OPTION,SLOER,DAU,ORIE
      WRITE(6,18)OPTION,SLOER,DAU,ORIE
   17 FORMAT(F5.0,3F5.1)
   18 FORMAT(1H1,'OPTION=',F5.0,' SLOP.ER.=',F5.1,' DIS.SUN.AU.=',F4.1,
     1' ARRAY ORIENT.=',F3.0,/)
      KOPT=OPTION
      MORIE =ORIE
      GO TO(20,69,20,69,69)KOPT
   20 GO TO(61,62,63,64,65,66,67)MORIE
C     SUN SYNCHRONOUS SPACE STATION CONFIGURATION FACTOR FOR PV ARRAY
   61 FORIE=1.
      WRITE(6,41)FORIE
      GO TO 69
C     SUN SYNCHRONOUS PV ARRAY CONFIGURATION FACTOR
   62 FORIE=1.
      WRITE(6,42)FORIE
      GO TO 69
C     ROTATING PV ARRAY CONFIGURATION FACTOR
   63 FORIE=1.45
      WRITE(6,43)FORIE
      GO TO 69
C     OSCILLATING-ARRAY GAMMA CONTROLLED CONFIGURATION FACTOR
   64 FORIE=1.85
      WRITE(6,44)FORIE
      GO TO 69
C     GAMMA ANGLE CONTROLLED CONFIGURATION FACTOR
   65 FORIE=1.95
      WRITE(6,45)FORIE
      GO TO 69
C     BETA ANGLE CONTROLLED CONFIGURATION FACTOR
   66 FORIE=2.07
      WRITE(6,46)FORIE
      GO TO 69
C     EARTH POINTING SPACE STATION CONFIGURATION FACTOR
67    FORIE=3.58
      WRITE(6,47)FORIE
   69 CONTINUE
   41 FORMAT(1X,'SUN ORIENT.STAT.AREA FACT.=',F5.2)
   42 FORMAT(1X,'SUN ORIENT.ARRAY AREA FACT.=',F5.2)
   43 FORMAT(1X,'ROTAT ARRAY AREA FC.=',F5.2,'CONRAT - ASCC INCORRCT')
   44 FORMAT(1X,'OSCIL ARY,GMA CNT,AREA FC.=',F5.2,'CONRAT-ASCC INCORC')
   45 FORMAT(1X,'GAMMA ANG CON AREA FACT.=',F5.2,'CONRAT-ASCC INCORRCT')
   46 FORMAT(1X,'BETA ANG CONT. AREA FC.=',F5.2,'CONRAT-ASCC INCORRCT')
   47 FORMAT(1X,'EARTH POINT STA AREA FC.=',F5.2,'CONRAT-ASCC INCORRCT')
C
      GO TO(71,72,73,74,75)KOPT
   71 WRITE(6,26)
      GO TO 77
   72 WRITE(6,27)
      GO TO 77
   73 WRITE(6,28)TREQ(IJ)
      GO TO 77
   74 WRITE(6,29)
      GO TO 77
   75 WRITE(6,30)TREQ(IJ)
   77 CONTINUE
C
   26 FORMAT(1X,'OPTION A PHOTOVOLTAIC PANELS ONLY',/)
   27 FORMAT(1X,'OPTION B ELECTRICTY  PARABOLIC DISH ONLY',/)
   28 FORMAT(1X,'OPTION C PHOTOVOLTAIC FOR ELECTRICITY DISH FOR HEAT',
     1'   HEAT DISH TEM.REQ=',F6.0,/)
   29 FORMAT(1X,'OPTION D DISH FOR ELECTRICITY SOME FOR HEAT ',/)
   30 FORMAT(1X,'OPTION E ONE DISH FOR ELECTRICITY ONE FOR HEAT',
     1'   HEAT DISH TEM.REQ=',F6.0,/)
C
   10 READ(5,11)PV,ES,ET,PP,RH,EDI,TS,HT,HDI,PC,RAD,SCC
   11 FORMAT(12F5.0)
C
C     DEFINE NUMBER OF LOOPS
      READ(5,31)NI,NJ,NK,NL,NM,NNX,NII,NJJ,NKK,NLL,NMM,NNN
      WRITE(6,31)NI,NJ,NK,NL,NM,NNX,NII,NJJ,NKK,NLL,NMM,NNN
   31 FORMAT(12I5)
C     PRINT OPTION DEFINITIONS
C
      WRITE(6,15)PV,ES,ET,PP,RH,EDI,TS,HT,HDI,PC,RAD,SCC
   15 FORMAT(1X,'PV=',F4.0,'ES=',F4.0,'ET=',F4.0,'PP=',F4.0,
     1'RH=',F4.0,'EDI=',F4.0,'TS=',F4.0,'HT=',F4.0,
     2'HDI=',F4.0,'PC=',F4.0,'RAD=',F4.0,'SCC=',F4.0)
C
C
C
C     PRINT INPUTS
C
      WRITE(6,83)UWSC,UWEDI,UWHDI,UWTS,UWHTS,UWES,UWEHS,UWET
   83 FORMAT(1X,' UWSC=',F5.1,' UWEDI=',F5.1,' UWHDI=',F5.1,
     1' UWTS=',F5.1,' UWHTS=',F5.1,' UWES=',F5.1,' UWEHS=',F5.1,' UWET='
     2,F5.1,/)
      WRITE(6,84)UWRAD,UWRE,UWPP,UWSCC,UWPC,UWHT
   84 FORMAT(1X,' UWRAD=',F5.1,' UWRE=',F5.1,' UWPP=',F5.1,
     1' UWSCC=',F5.0,' UWPC=',F5.0,' UWHT=',F5.1,/)
      WRITE(6,85)DRKM,SNLTM
   85 FORMAT(1X,' DARK MINUTES=',F5.1,'   SUNLIT MINUTES=',F5.1,/)
C
C     REPEAT RUNS FOR DIFFERENT  THERMEL /ELECTRICAL POWER LEVELS
      DO 5 IJ=1,5
      AIJ=IJ
C     ELECTRICAL POWER REQUIRED
      EKWRQ(IJ)=15.+15.*(AIJ-1.)
C
C     THERMAL POWER REQUIRED
      TKWRQ(IJ)=60.-15.*(AIJ-1.)
C
C
      WRITE(6,12)EKWRQ(IJ),TKWRQ(IJ),TREQ(IJ),REFDEG(KIJ),SCDEG(KIJ),
     1STODEG(KIJ)
   12 FORMAT(1X,'ELEC.KW.RQ=',F3.0,'THERM.KW.RQ=',F3.0,
     1'TEMP,RQ=',F5.0,'REF.DEG=',F4.2,'SC.DEG=',F4.2,'STO.DEG=',
     2 F4.2,/)
C     IF POWER PROCESSING IS USED FOR RESISTANCE HEATER PPF=1.
      PPF=1.
      UPPF=1.-PPF
C
C     PRINT FRACTIONS OF POWER PROCESSED
      WRITE(6,14) PPF,UPPF
14    FORMAT(1X,' PROCES POWER FAC=',F4.2,'  UNPROC.POW.FAC=',F4.2,/)
C
C
C     VARY PERFORMANCE CONDITIONS HERE
C
      DO 501 I=1,NI
      DO 502 J=1,NJ
      DO 503 K=1,NK
      DO 504 L=1,NL
      DO 505 M=1,NM
      DO 506 N=1,NNX
      DO 507 II=1,NII
      DO 508 JJ=1,NJJ
      DO 509 KK=1,NKK
      DO 510 LL=1,NLL
      DO 511 MM=1,NMM
      DO 512 NN=1,NNN
C
C
C      IDENTFY EACH OPTION AND PRINT TITLES
C
      GO TO(51,52,53,54,55)KOPT
      GO TO 60
C
C
   51 OPTION=1.
C
      CALL ORBIT(BEAM,DAU,DRK,SNLT,DRKM,SNLTM,TOTL,PEAKF)
      CALL PVPERF(ETASC,I)
      CALL ESTOR(ETAES,J)
      CALL ETRA(ETAET,K)
      CALL POWPR(ETAPP,L)
      CALL REHEA(ETARH,M)
      CALL SCCON(CONRAT,NN)
C     PRINT CALCULATED EFFICIENCIES
      WRITE(6,32)ETASC(I),ETAES(J),ETAET(K),ETAPP(L),ETARH(M),ETAEDI(N),
     1ETAHDI(II),UHREJ(JJ),ETATS(KK),ETAHT(LL),ETAPC(MM),CONRAT(NN)
   32 FORMAT(1X,'EF.SC=',F3.2,'ES=',F3.2,'ET=',F3.2,'PP=',F3.2,
     1'RH=',F3.2,'ED=',F3.2,'HD=',F3.2,' UH=',F4.2,'TS=',F3.2,'HT=',
     2F3.2,' PC=',F4.3,'CR=',F3.1)
      EKWET=EKWRQ(IJ)/ETAPP(L)+(TKWRQ(IJ)/ETARH(M))/(UPPF+
     1PPF*ETAPP(L))
C
C     GENERATED ELECTRIC POWER
      EKWGE=((EKWET/ETAET(K))/ETAES(J))*PEAKF
C
C     REFLECTOR DEGRADATION
C     SOLAR ARRAY AREA
C
      ASC=FORIE*EKWGE/(ETASC(I)*BEAM*SCDEG(KIJ)*CONRAT(NN))
      RHO=0.8
C     SOLAR CELL CONCENTRATOR AREA
      ASCC=ASC*SQRT(CONRAT(NN)**2-1.)*SCC/RHO
C
C     STORAGE BATTERY POWER
      EKWST=EKWGE/PEAKF
C     STORED KWH
C
      EKWHST=EKWST*DRK
      WRITE(6,91)ASC,ASCC,EKWGE,EKWST,EKWHST,EKWET
   91 FORMAT(1X,' ASC=',F6.0,' ASCC=',F6.0,' EKWGE=',F6.0,
     1' EKWST=',F6.0,' EKWHST=',F6.0,' EKWET=',F6.2)
C     CALCULATE COMPONENT WEIGHTS
      WTSC=UWSC*ASC
      WTSCC=UWSCC*ASCC
      WTES=UWES*EKWST+UWEHS*EKWHST
      WTET=UWET*EKWGE
      WTPP=UWPP*EKWGE
      WRITE(6,48)WTSC,WTSCC,WTES,WTET,WTPP
   48 FORMAT(1X,'WTSC=',F8.0,' WTSCC=',F8.0,' WTES=',F8.0,' WTET=',
     1F6.0,' WTPP=',F6.0)
C
C     CALCULATE OVERALL   SYSTEM WEIGHT
      WTOT=UWSC*ASC+UWES*EKWST+UWEHS*EKWHST+UWET*EKWGE+UWSCC*ASCC+UWPP
     1*EKWGE
C
      GO TO 60
C
   52 OPTION=2.
C
      CALL ORBIT(BEAM,DAU,DRK,SNLT,DRKM,SNLTM,TOTL,PEAKF)
      CALL POWPR(ETAPP,L)
      CALL REHEA(ETARH,M)
      CALL EDIPER(ETAEDI,N,SLOER,TRE)
      CALL THRSTO(ETATS,KK)
      CALL HETRN(ETAHT,LL)
      CALL HEREJ(UHREJ,JJ,TRAD)
      CALL POWCNV(ETAPC,MM,TRAD,TRE,TENG)
C
      WRITE(6,58)SLOER,ETAEDI(N)
   58 FORMAT(1X,'SLOPE ERROR IN MRAD=',F5.0,'  DISH EFF=',F4.3)
C
      EKWPC=EKWRQ(IJ)/ETAPP(L)+(TKWRQ(IJ)/ETARH(M))/
     1(UPPF+PPF*ETAPP(L))
      TKWHT=EKWPC/(ETAPC(MM)*ETAHT(LL))
C
      EKWGE=EKWPC
C     THERMAL POWER GENERATED
      TKWGE=(TKWHT/ETATS(KK))*PEAKF
C     THERMAL POWER REJECTED
      QRAD=(EKWPC/ETAPC(MM))*(1.-ETAPC(MM))
      ARAD=QRAD/UHREJ(JJ)
C
C
C     ELECTRICAL DISH AREA
C
      AEDI=TKWGE/(BEAM*ETAEDI(N)*REFDEG(KIJ))
C
C     THERMAL STORAGE CAPACITY
      TKWTS=(TKWGE/PEAKF)/STODEG(KIJ)
C     STORED ENERGY
      TKWHTS=TKWTS*DRK
      WRITE(6,92)EKWGE,TKWGE,QRAD,TKWTS,TKWHTS
   92 FORMAT(1X,'EKWGE=',F6.0,'TKWGE=',F6.0,'QRAD=',F6.0,'TKWTS=',
     1F6.0,'TKWHTS=',F6.0)
C
      WRITE(6,93)ARAD,AEDI,TRAD,TENG
   93 FORMAT(1X,'RAD.AR.=',F6.0,'EL.DSH.AR.=',F6.0,' TRAD=',F6.0,' TENG
     1=',F6.0)
C     PRINT CALCULATED EFFICIENCIES
      WRITE(6,32)ETASC(I),ETAES(J),ETAET(K),ETAPP(L),ETARH(M),ETAEDI(N),
     1ETAHDI(II),UHREJ(JJ),ETATS(KK),ETAHT(LL),ETAPC(MM),CONRAT(NN)
C     CALCULATE COMPONENT WEIGHTS
      WTEDI=UWEDI*AEDI
      WTRE=UWRE*TKWGE
      WTRAD=UWRAD*ARAD
      WTTS=UWTS*TKWTS+UWHTS*TKWHTS
      WTHT=UWHT*TKWGE
      WTPC=UWPC*EKWGE
      WTPP=UWPP*EKWGE
      WRITE (6,49)WTEDI,WTRE,WTRAD,WTTS,WTHT,WTPC,WTPP
49    FORMAT(1X,'WTEDI=',F6.0,' WTRE=',F6.0,' WTRAD=',F6.0,
     1'WTTS=',F6.0,'WTHT=',F5.0,' WTPC=',F5.0,' WTPP=',F5.0)
C
C     CALCULATE OVERALL   SYSTEM WEIGHT
      WTOT=UWEDI*AEDI+UWRE*TKWGE+UWRAD*ARAD+UWTS*TKWTS+UWHTS*TKWHTS+
     1UWHT*TKWGE+UWPC*EKWGE+UWPP*EKWGE
C
C
      GO TO 60
   53 OPTION=3.
C
      CALL ORBIT(BEAM,DAU,DRK,SNLT,DRKM,SNLTM,TOTL,PEAKF)
      CALL PVPERF(ETASC,I)
      CALL ESTOR(ETAES,J)
      CALL ETRA(ETAET,K)
      CALL POWPR(ETAPP,L)
      CALL HDIPER(ETAHDI,II,IJ,SLOER,TREH,TREQ)
      CALL THRSTO(ETATS,KK)
      CALL HETRN(ETAHT,LL)
      CALL SCCON(CONRAT,NN)
C
      WRITE(6,58)SLOER,ETAHDI(II)
      EKWET=EKWRQ(IJ)/(UPPF+PPF*ETAPP(LL))
      EKWGE=EKWRQ(IJ)*PEAKF/(ETAES(J)*ETAET(K)*(UPPF+PPF*ETAPP(L)))
      ASC=FORIE*EKWGE/(ETASC(I)*BEAM*SCDEG(KIJ)*CONRAT(NN))
C
C     SOLAR CELL CONCENTRATOR AREA
      RHO=0.8
      ASCC=ASC*SQRT(CONRAT(NN)**2-1.)*SCC/RHO
C
C     STORED ELECTRICAL ENERGY
      EKWST=EKWGE/PEAKF
      EKWHST=EKWST*DRK
C
      TKWGE=TKWRQ(IJ)*PEAKF/(ETAHT(LL)*ETATS(KK))
C     THERMAL STORAGE CAPACITY ( POWER)
      TKWTS=(TKWGE/PEAKF)/STODEG(KIJ)
C     ENERGY STORED
      TKWHTS=TKWTS*DRK
C
      AHDI=TKWGE/(ETAHDI(II)*BEAM*REFDEG(KIJ))
C
      WRITE(6,91)ASC,ASCC,EKWGE,EKWST,EKWHST,EKWET
      WRITE(6,94)AHDI,TKWGE,TKWTS,TKWHTS,TRE,TREH
C
   94 FORMAT(1X,' AHDI=',F6.0,' TKWGE=',F6.0,' TKWTS=',F6.0,
     1' TKWHTS=',F6.0,' TRE=',F6.0,' TREH=',F6.0)
C     PRINT CALCULATED EFFICIENCIES
      WRITE(6,32)ETASC(I),ETAES(J),ETAET(K),ETAPP(L),ETARH(M),ETAEDI(N),
     1ETAHDI(II),UHREJ(JJ),ETATS(KK),ETAHT(LL),ETAPC(MM),CONRAT(NN)
C     CALCULATE COMPONENT WEIGHTS
      WTSC=UWSC*ASC
      WTSCC=UWSCC*ASCC
      WTES=UWES*EKWST+UWEHS*EKWHST
      WTET=UWET*EKWGE
      WTPP=UWPP*EKWGE
      WRITE(6,48)WTSC,WTSCC,WTES,WTET,WTPP
C     CALCULATE COMPONENT WEIGHTS
      WTHDI=UWHDI*AHDI
      WTRE=UWRE*TKWGE
      WTTS=UWTS*TKWTS+UWHTS*TKWHTS
      WTHT=UWHT*TKWGE
C
C
C
      WRITE (6,49)WTEDI,WTRE,WTRAD,WTTS,WTHT,WTPC,WTPP
      WRITE(6,79)WTHDI
   79 FORMAT(1X,' TOTAL WEIGHT HEAT DISH=',F6.0)
C     CALCULATE OVERALL   SYSTEM WEIGHT
      WTOT=UWSC*ASC+UWRE*TKWGE+UWTS*TKWTS+UWHTS*TKWHTS+UWES*EKWST+UWEHS
     1*EKWHST+UWHDI*AHDI+UWET*EKWGE+UWHT*TKWGE+UWSCC*ASCC+UWPP*EKWGE
C
      GO TO 60
   54 OPTION=4.
C
      CALL ORBIT(BEAM,DAU,DRK,SNLT,DRKM,SNLTM,TOTL,PEAKF)
      CALL POWPR(ETAPP,L)
      CALL EDIPER(ETAEDI,N,SLOER,TRE)
      CALL THRSTO(ETATS,KK)
      CALL HETRN(ETAHT,LL)
      CALL HEREJ(UHREJ,JJ,TRAD)
      CALL POWCNV(ETAPC,MM,TRAD,TRE,TENG)
      WRITE(6,58)SLOER,ETAEDI(N)
      EKWGE=EKWRQ(IJ)/(UPPF+PPF*ETAPP(L))
C
      TKWGE=(PEAKF/ETATS(KK))*(TKWRQ(IJ)/ETAHT(LL)
     1+PEAKF*EKWRQ(IJ)/((UPPF+PPF*ETAPP(L))*ETAPC(MM)*ETATS(KK)*
     2ETAHT(LL)))
      AEDI=TKWGE/(BEAM*REFDEG(KIJ)*ETAEDI(N))
C
C     RADIATOR HEAT AND AREA
C
      QRAD=EKWGE*(1.-ETAPC(MM))/ETAPC(MM)
C
      ARAD=QRAD/UHREJ(JJ)
C
C     THERMAL STORAGE CAPACITY (POWER)
      TKWTS=(TKWGE/PEAKF)/STODEG(KIJ)
C     ENERGY STORED
      TKWHTS=TKWTS*DRK
      WRITE(6,95)AEDI,TKWGE,TKWTS,TKWHTS
   95 FORMAT(1X,'AEDI=',F8.0,'TKWGE=',F8.0,'TKWTS=',F8.0,
     1'TKWHTS=',F8.0)
      WRITE(6,96)ARAD,QRAD,TRAD,TENG
   96 FORMAT(1X,' RAD. AREA=',F6.0,' QRAD=',F6.0,' TRAD=',F6.0,' TENG=',
     1F6.0)
C     PRINT CALCULATED EFFICIENCIES
      WRITE(6,32)ETASC(I),ETAES(J),ETAET(K),ETAPP(L),ETARH(M),ETAEDI(N),
     1ETAHDI(II),UHREJ(JJ),ETATS(KK),ETAHT(LL),ETAPC(MM),CONRAT(NN)
C     CALCULATE COMPONENT WEIGHTS
      WTEDI=UWEDI*AEDI
      WTRE=UWRE*TKWGE
      WTRAD=UWRAD*ARAD
      WTTS=UWTS*TKWTS+UWHTS*TKWHTS
      WTHT=UWHT*TKWGE
      WTPC=UWPC*EKWGE
      WTPP=UWPP*EKWGE
      WRITE (6,49)WTEDI,WTRE,WTRAD,WTTS,WTHT,WTPC,WTPP
C
C     CALCULATE OVERALL   SYSTEM WEIGHT
      WTOT=UWEDI*AEDI+UWRE*TKWGE+UWRAD*ARAD+UWTS*TKWTS+UWHTS*TKWHTS+
     1UWHT*TKWGE+UWPC*EKWGE+UWPP*EKWGE
C
      GO TO 60
   55 OPTION=5.
      CALL ORBIT(BEAM,DAU,DRK,SNLT,DRKM,SNLTM,TOTL,PEAKF)
      CALL POWPR(ETAPP,L)
      CALL EDIPER(ETAEDI,N,SLOER,TRE)
      CALL HDIPER(ETAHDI,II,IJ,SLOER,TREH,TREQ)
      CALL THRSTO(ETATS,KK)
      CALL HETRN(ETAHT,LL)
      CALL HEREJ(UHREJ,JJ,TRAD)
      CALL POWCNV(ETAPC,MM,TRAD,TRE,TENG)
      WRITE(6,59)SLOER,ETAEDI(N),ETAHDI(II)
   59 FORMAT(1X,'SLOPE ERROR IN MRAD=',F5.0,' EL.DISH EFF=',F4.3,
     1' HEAT DSH.EFF=',F4.3)
      EDKWGE=EKWRQ(IJ)*PEAKF/(ETAPC(MM)*(UPPF+PPF*ETAPP(L))*
     1ETAHT(LL)*ETATS(KK))
C
      AEDI=EDKWGE/(BEAM*REFDEG(KIJ)*ETAEDI(N))
C
      TKWGE=TKWRQ(IJ)*PEAKF/(ETAHT(LL)*ETATS(KK))
C
      AHDI=TKWGE/(BEAM*REFDEG(KIJ)*ETAHDI(II))
C
C     RADIATOR HEAT REJECTED
C
      QRAD=EKWRQ(IJ)*(1.-ETAPC(MM))/((UPPF+PPF*ETAPP(L))*ETAPC(MM))
C
C      RADIATOR AREA
C
      ARAD=QRAD/UHREJ(JJ)
C
C     THERMAL STORAGE CAPACITY(POWER)
      TKWTS=((TKWGE+EDKWGE)/PEAKF)/STODEG(KIJ)
C     ENERGY STORED IN KWH
      TKWHTS=TKWTS*DRK
C
      WRITE(6,94)AHDI,TKWGE,TKWTS,TKWHTS,TRE,TREH
      WRITE(6,96)ARAD,QRAD,TRAD,TENG
      WRITE(6,97)EDKWGE,AEDI
   97 FORMAT(1X,' EL.DSH.KW GEN.=',F10.0,' EL.DSH.AREA=',F10.0)
C     PRINT CALCULATED EFFICIENCIES
      WRITE(6,32)ETASC(I),ETAES(J),ETAET(K),ETAPP(L),ETARH(M),ETAEDI(N),
     1ETAHDI(II),UHREJ(JJ),ETATS(KK),ETAHT(LL),ETAPC(MM),CONRAT(NN)
C     CALCULATE COMPONENT WEIGHTS
      WTEDI=UWEDI*AEDI
      WTRE=UWRE*(TKWGE+EDKWGE)
      WTRAD=UWRAD*ARAD
      WTTS=UWTS*TKWTS+UWHTS*TKWHTS
      WTHT=UWHT*(TKWGE+EDKWGE)
      WTPC=UWPC*EDKWGE
      WTPP=UWPP*EDKWGE
      WTHDI=UWHDI*AHDI
      WRITE (6,49)WTEDI,WTRE,WTRAD,WTTS,WTHT,WTPC,WTPP
      WRITE(6,79)WTHDI
C
C     CALCULATE OVERALL   SYSTEM WEIGHT
      WTOT=UWEDI*AEDI+UWRE*(TKWGE+EDKWGE)+UWRAD*ARAD+UWTS*TKWTS
     1+UWHTS*TKWHTS+UWHDI*AHDI+UWHT*(TKWGE+EDKWGE)+UWPC*EDKWGE+
     2UWPP*EDKWGE
C
C
   60 CONTINUE
C
C     CALCULATE TOTAL PLANT POWER
C
      PLPOW=EKWRQ(IJ)+TKWRQ(IJ)
C
C     PRINT WEIGHT  AND TOTAL OUTPUT OF THE PLANT
      WRITE(6,98)WTOT,PLPOW
   98 FORMAT(1X,'TOT.WEIGHT=',F8.0,' TOTAL PLANT POWER=',F4.0)
C
C
      WRITE(6,34)I,J,K,L,M,N,II,JJ,KK,LL,MM,NN
   34 FORMAT(1X,'IJKLMN IIJJKKLLMMNN=',12I5,/)
C
C
  512 CONTINUE
  511 CONTINUE
  510 CONTINUE
  509 CONTINUE
  508 CONTINUE
  507 CONTINUE
  506 CONTINUE
  505 CONTINUE
  504 CONTINUE
  503 CONTINUE
  502 CONTINUE
  501 CONTINUE
    5 CONTINUE
C     *****************************************************
C     THIS PORTION FOR PERSONAL COMPUTER RUNS
C
C     CLOSE INPUT FILE
C
      CLOSE (5)
C
C     CLOSE OUTPUT FILE
C
      CLOSE (6)
C     *****************************************************
      END
C  
      SUBROUTINE ORBIT(BEAM,DAU,DRK,SNLT,DRKM,SNLTM,TOTL,PEAKF)
C     SUBROUTINE ORBIT DETERMINES SUNLIT AND DARK DURATIONS
  100 BEAM=1.35/(DAU**2)
      DRK=DRKM/60.
      SNLT=SNLTM/60.
      TOTL=DRK+SNLT
      PEAKF=TOTL/SNLT
      RETURN
      END
C
C
      SUBROUTINE PVPERF(ETASC,I)
      DIMENSION ETASC(10)
C     SUBROUTINE PVPERF DEFINES PHOTOVOLTAIC PANEL PERFORMANCE
C     SOLAR CELL EFFICIENCY
  150 AI=I
      ETASC(I)=.09+0.03*(AI-1.)
      RETURN
      END
C
      SUBROUTINE ESTOR(ETAES,J)
C     SUBROUTINE ESTOR DEFINES ELECTRICITY STORAGE SYSTEM PERFORMANCE
C
      DIMENSION ETAES(10)
  200 AJ=J
      ETAES(J)=0.60+0.10*(AJ-1.)
      RETURN
      END
C
      SUBROUTINE ETRA(ETAET,K)
C     SUBROUTINE ETRA DEFINES ELECTRICITY TRANSPORT SYSTEM PERFORMANCE
C
      DIMENSION ETAET(10)
  250 AK=K
      ETAET(K)=0.97+0.01*(AK-1.)
      RETURN
      END
C
      SUBROUTINE POWPR(ETAPP,L)
C     SUBROUTINE POWPR DEFINES POWER PROCESSING EQUIPMENT PER.
C
      DIMENSION ETAPP(10)
  300 AL=L
      ETAPP(L)=0.85+0.05*(AL-1.)
      RETURN
      END
C
      SUBROUTINE REHEA(ETARH,M)
      DIMENSION ETARH(10)
C     SUBROUTINE REHEA  DEFINES RESISTANCE HEATER PERFORMANCE
C
  350 AM=M
      ETARH(M)=0.99+0.005*(AM-1.)
      RETURN
      END
C
      SUBROUTINE EDIPER(ETAEDI,N,SLOER,TRE)
      DIMENSION ETAEDI(10)
C     SUBROUTINE EDIPER DEFINES ELECTRICAL DISH PERFORMANCE
  400 AN=N
      TRE=400.+AN*200.
      IF(SLOER.GT.1.0.AND.SLOER.LT.3.0)GO TO 401
      IF(SLOER.GT.3.0.AND.SLOER.LT.7.0)GO TO 402
      IF(SLOER.GT.7.0.AND.SLOER.LT.12.0)GO TO 403
      IF(SLOER.LT.1.0.OR.SLOER.GT.12.0) GO TO 407
C     EFFICIENCY EQUATION FOR SLOPE ERROR OF 1 MRAD
  401 ETAEDI(N)=-7.812E-08*TRE**2+0.00006245*TRE+0.75
      GO TO 409
C     EFFICIENCY EQUATION FOR SLOPE ERROR OF 5 MRAD
  402 ETAEDI(N)=-1.875E-07*TRE**2-0.00005*TRE+0.8175
      GO TO 409
C     EFFICIENCY EQUATION FOR SLOPE ERROR OF 10 MRAD
  403 ETAEDI(N)=0.62-.000725*(TRE-600.)
      GO TO 409
  407 WRITE(6,415)
  415 FORMAT(1X,' SLOPE ERROR OUT OF RANGE',//)
  409 CONTINUE
      RETURN
      END
C
      SUBROUTINE HDIPER(ETAHDI,II,IJ,SLOER,TREH,TREQ)
      DIMENSION ETAHDI(10),TREQ(5)
C     SUBROUTINE HDIPER DEFINES HEAT DISH PERFORMANCE
C
  450 TREH=TREQ(IJ)+50.
  470 IF(SLOER.GT.1.0.AND.SLOER.LT.3.0)GO TO 451
      IF(SLOER.GT.3.0.AND.SLOER.LT.7.0)GO TO 452
      IF(SLOER.GT.7.0.AND.SLOER.LT.12.0)GO TO 453
      IF(SLOER.LT.1.0.OR.SLOER.GT.12.0) GO TO 457
C     EFFICIENCY EQUATION FOR SLOPE ERROR OF 1 MRAD
  451 ETAHDI(II)=-7.812E-08*TREH**2+0.00006245*TREH+0.75
      GO TO 459
C     EFFICIENCY EQUATION FOR SLOPE ERROR OF 5 MRAD
  452 ETAHDI(II)=-1.875E-07*TREH**2-0.00005*TREH+0.8175
      GO TO 459
C     EFFICIENCY EQUATION FOR SLOPE ERROR OF 10 MRAD
  453 ETAHDI(II)=0.62-.000725*(TREH-600.)
      GO TO 459
  457 WRITE(6,465)
  465 FORMAT(1X,' SLOPE ERROR OUT OF RANGE',//)
  459 CONTINUE
      RETURN
      END
C
      SUBROUTINE HEREJ(UHREJ,JJ,TRAD)
      DIMENSION UHREJ(10)
C     SUBROUTINE HEREJ DETERMINES RADIATOR PERFORMANCE
  500 SHP=0.9
      TSKY=100.
      EMISV=0.85
      AJJ=JJ
      TRAD=150.+AJJ*100.
      UHREJ(JJ)=SHP*EMISV*5.67E-11*(TRAD**4-TSKY**4)
      RETURN
      END
C
      SUBROUTINE THRSTO(ETATS,KK)
      DIMENSION ETATS(10)
C     SUBROUTINE THRSTO DEFINES THERMAL STORAGE SYSTEM PERF.
  550 AKK=KK
C
      ETATS(KK)=0.8+0.10*(AKK-1.)
      RETURN
      END
C
      SUBROUTINE HETRN(ETAHT,LL)
      DIMENSION ETAHT(10)
C     SUBROUTINE HETRN DEFINES HEAT TRANSPORT SYSTEM PERFOR.
  600 ALL=LL
C
      ETAHT(LL)=0.85+0.05*(ALL-1.)
      RETURN
      END
C
      SUBROUTINE POWCNV(ETAPC,MM,TRAD,TRE,TENG)
      DIMENSION ETAPC(10)
C     SUBROUTINE POWCNV DEFINES POWER CONV.(ENGINE) PERFOR.
C
  650 FCARNO=0.5
      TENG=TRE-30.
      ETAPC(MM)=FCARNO*(1.-TRAD/TENG)
      RETURN
      END
C
      SUBROUTINE SCCON(CONRAT,NN)
      DIMENSION CONRAT(5)
C     SUBROUTINE SCCON DEFINES SOLAR CELL CONCENTRATOR
  700 ANN=NN
C
      CONRAT(NN)=1.0+2.0*(ANN-1.)
      RETURN
      END
