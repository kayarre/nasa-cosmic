$ SET NOVERIFY
$ !
$ ! -------------------------------------------------------
$ !
$ !  BATCH BUGOUT                              BATCH BUGOUT
$ !
$ !         BUGOUT FORTRAN DEBUGGING PROGRAM...
$ !         SEE MERLIN:BUGOUT.DOC FOR DETAILS.
$ !
$ ! -------------------------------------------------------
$ !
$ ON ERROR THEN GOTO OUT
$ SET DEFAULT 'P3'
$ DIRECTORY/DATE/OUT='P1'.DRR 'P1'.FOR
$ ASSIGN 'P1'.DRR FOR002
$ !
$ ! CHECK FOR NON-DEFAULT OPTIONS
$ !
$ IF P4 .NES. "" THEN GOTO USER
$ ASSIGN MERLIN:OPTIONS.DAT FOR004
$ GOTO CONT
$USER:
$ ASSIGN 'P4' FOR004
$CONT:
$ !
$ ! CALLS STEP
$ !
$ ASSIGN 'P1'.FOR FOR005
$ ASSIGN 'P1'.CAS FOR010
$ ASSIGN 'P1'.CAB FOR006
$ RUN MERLIN:CALLS
$ !
$ ! TIME/TRACE STEP
$ !
$ ASSIGN BUGOUT.FOR FOR007
$ ASSIGN TRACE.LIS FOR006
$ RUN MERLIN:TRACER
$ !
$ ! FORT STEP
$ !
$ ON ERROR THEN GOTO CONTIN
$ FORTRAN/LIST/CROSS/CHECK=BOUNDS BUGOUT.FOR
$CONTIN:
$ ON ERROR THEN GOTO OUT
$ !
$ ! COMMON STEP
$ !
$ ASSIGN 'P1'.COB FOR006
$ ASSIGN BUGOUT.LIS FOR008
$ ASSIGN 'P1'.COS FOR010
$ RUN MERLIN:COMMON
$ !
$ ! VARIABLE CHECK STEP
$ !
$ ASSIGN 'P1'.VAS FOR010
$ ASSIGN 'P1'.VAB FOR006
$ RUN MERLIN:VARIABLE
$ !
$ DELETE BUGOUT.LIS;*
$OUT:
$ ON ERROR THEN GOTO OUT1
$ COPY MERLIN:BUGOUT. BUGOUT.
$ DELETE 'P1'.DRR;
$ PRINT/QUE=LPA0/DELETE BUGOUT.,'P1'.CAS,'P1'.CAB,TRACE.LIS,'P1'.COS,'P1'.COB, -
  'P1'.VAS,'P1'.VAB
$OUT1:
$ ON ERROR THEN EXIT
$ SEND 'P2' "Your BUGOUT run is complete."
