CDECK  ID>, DIORD.
      SUBROUTINE DIORD

C-    Prepare for the re-ordering to operate on "old" updated by
C-    the cradle generated by DICRAD to give "new"; this must
C-    be done before "lost" decks from foreign patches are linked.
C.    started 18-june-94

      COMMON /QUNIT/ IQREAD,IQPRNT, IQTTIN,IQTYPE, IQOFFL,IQRTTY,IQRSAV
     +,              IQRFD,IQRRD,IQRSIZ, NQLPAT,NQUSED,NQLLBL, NQINIT
      PARAMETER      (NEWLN=10, NCHNEWL=1)
      PARAMETER      (NSIZEQ=100000, NSIZELN=100000)
      PARAMETER      (NSIZETX=40*NSIZELN)
                     CHARACTER    TEXT(NSIZETX)*1
                     DIMENSION    LQ(NSIZEQ), IQ(NSIZEQ), MLIAD(NSIZELN)
                     EQUIVALENCE (LQ,IQ,LQGARB), (MLIAD(1),LQ(NSIZEQ))
                     EQUIVALENCE (TEXT(1), MLIAD(NSIZELN))
      COMMON //      IQUEST(100),LQGARB,LQHOLD,LQARRV,LQKEEP,LQPREP
     +,         LEXP,LLPAST,LQPAST, LQUSER(4), LHASM,LRPAM,LPAM, LQINCL
     +,         LACRAD,LARRV, LPCRA,LDCRAB, LEXD,LDECO, LCRP,LCRD, LSERV
     +, INCRAD, IFLGAR, JANSW, IFMODIF, IFALTN
     +, JDKNEX,JDKTYP, JSLZER,NSLORG,JSLORG
     +, MOPTIO(34), MOPUPD, NCLASH, IFLMERG,IFLDISP, NSLFRE,NTXFRE
     +, NVGAP(4), NVGARB(6), NVIMAT(4), NVUTY(4),  LASTWK
C--------------    End CDE              --------------------------------


C--       ordering the patches of this PAM

      LFI = LQUSER(2)
      CALL DIORDX (LFI)

      LPNEW = LFI - 3
   24 LPNEW = LQ(LPNEW-1)
      IF (LPNEW.EQ.0)              GO TO 27
      LPOLD = LQ(LPNEW-2)
      IF (LPOLD.EQ.0)              GO TO 24

C--       ordering the decks of this patch

      CALL DIORDX (LPNEW)
      GO TO 24

   27 CONTINUE
      RETURN
      END
