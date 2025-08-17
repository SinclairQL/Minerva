100 DEV_USE 7,DATAD$
110 QMake_out$="ram8_"
120 subver$="j3"
130 :
140 DEFine PROCedure make_minerva(v$)
150   lang$=""
160   IF v$(2)="." THEN lang$="english"
170   IF v$(2)=="g" THEN lang$="german"
180   IF lang$="" THEN PRINT "*** ERROR: No language associated with this version": STOP
190   PRINT#0;"Building Minerva..."
200   rom$="dev7_m_ROM_" & lang$ & "_bin"
210   DELETE rom$
220   map$=QMake_out$ & "m_ROM_map"
230   EW QMake;"\C " & "dev7_m_rom \B \0" & lang$
240   IF FTEST(map$)=0 THEN
250     COPY_O map$ TO "dev7_m_ROM_" & v$ & "_map"
260   END IF
270   PRINT\"Minerva ROM image is ";FLEN(\rom$);" bytes"
280   IF FLEN(\rom$) > 48*1024 THEN
290     PRINT\"*** ERROR: Minerva ROM image too large (>48K)": STOP
300   END IF
310 END DEFine make_minerva
320 :
330 DEFine PROCedure make_rom(v$)
340   make_minerva v$
350   IF FTEST(rom$)=0 THEN
360     base=ALCHP(48*1024): LBYTES rom$,base
370     minerva$="dev7_Minerva_" & v$ & "_bin"
380     SBYTES_O minerva$,base,48*1024
390     PRINT\"Saved 48K ROM image ";minerva$: RECHP base
400   ELSE
410     PRINT\"*** ERROR: Assembled ROM image not found"
420   END IF
430 END DEFine make_rom
440 :
450 DEFine PROCedure make_history
460   IF FTEST("dev7_m_hist_rext") <> 0 THEN
470     PRINT\"*** ERROR: file hist_rext not found, please copy it first from SMSQ/E source!": STOP
480   END IF
490   PRINT#0;"Building HISTORY..."
500   EW QMake;"\C dev7_m_hist \B"
510   IF FTEST(QMake_out$ & "m_hist_bin")=0 THEN
520     COPY_O QMake_out$ & "m_hist_bin" TO "dev7_m_hist_bin"
530   END IF
540   IF FTEST(QMake_out$ & "m_hist_map")=0 THEN
550     COPY_O QMake_out$ & "m_hist_map" TO "dev7_m_hist_map"
560   END IF
570 END DEFine make_history
580 :
590 DEFine PROCedure del(f$)
600   f$="dev7_" & f$
610   PRINT#logchan;"Deleting ";f$
620   DELETE f$
630 END DEFine del
640 :
650 DEFine PROCedure make_clean
660 LOCal d$,fnr,fnm$
670   logchan=FOP_OVER("ram1_make_log"): IF logchan < 0 THEN REPORT#0;logchan: RETurn
680   RESTORE
690   REPeat loop
700     IF EOF THEN EXIT loop
710     READ d$: d$=d$ & "_"
720     dirch=FOP_DIR("dev7_" & d$): IF dirch<0 THEN PRINT#0;"Error opening ";d$: REPORT#0;dirch: RETurn
730     fnr=-1
740     REPeat file_lp
750       fnr=fnr+1
760       GET#dirch\fnr*64: IF EOF(#dirch) THEN EXIT file_lp
770       GET#dirch\fnr*64+14;fnm$: IF fnm$="" THEN NEXT file_lp
780       IF fnm$(LEN(fnm$)-3 TO) == "_REL" THEN
790         del fnm$
800       END IF
810     END REPeat file_lp
820     CLOSE#dirch
830     del d$ & "lib"
840   END REPeat loop
850   del "m_ROM_english_bin": del "m_ROM_german_bin": del "extrarom_bin": del "hist_bin"
860   CLOSE#logchan
870 END DEFine make_clean
880 :
890 DEFine PROCedure Make
900   make_rom "1.98" & subver$: make_rom "1G98" & subver$: make_history
910 END DEFine Make
920 :
930 CLS: PRINT "*** Minerva Make program ***"
940 PRINT\"Options:"
950 PRINT\"make_rom [version]: Build Minerva ROM (1.98 or 1G98)"
960 PRINT "make_history      : Build HISTORY device for Minerva (dev7_hist_bin)"
970 PRINT "Make              : Build all"
980 PRINT "make_clean        : Cleanup assembled files (_REL, lib etc.)"
990 PRINT\"Required programs: Quanta assembler and linker (QMAC, QLINK or QJump Linker), QMake"
1000 PRINT "(see https://dilwyn.theqlforum.com/asm/index.html)"
1010 IF FTEST("dev7_m_") <> 0 THEN
1020   PRINT\"** ERROR: Source directory missing; have you set dev7_ correctly?"
1030 END IF
1040 IF FTEST(PROGD$ & "QMake") <> 0: PRINT\"** ERROR: QMake not found in your PROGD$ (";PROGD$;")!"
1050 DATA "m_bf","m_bp","m_bv","m_ca","m_cn","m_cs","m_dd","m_gw","m_ib","m_ii","m_io","m_ip","m_md"
1060 DATA "m_mm","m_mt","m_nd","m_od","m_pa","m_pf","m_q68","m_ri","m_sb","m_sd","m_ss","m_tb","m_ut"
1070 DATA "m_tb_english","m_tb_german","m_hist"
