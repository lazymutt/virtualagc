### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	GROUND_TRACKING_DETERMINATION_PROGRAM.agc
## Purpose:	Part of the source code for Colossus, build 249.
##		It is part of the source code for the Command Module's (CM)
##		Apollo Guidance Computer (AGC), for Apollo 9.
## Assembler:	yaYUL
## Reference:	pp. 449-451.
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo.
## Mod history:	08/11/04 RSB.	Began transcribing.
##		2017-01-06 RSB	Page numbers now agree with those on the
##				original harcopy, as opposed to the PDF page
##				numbers in 1701.pdf.
##
## The contents of the "Colossus249" files, in general, are transcribed 
## from a scanned copy of the program listing.  Notations on this
## document read, in part:
##
##	Assemble revision 249 of AGC program Colossus by NASA
##	2021111-041.  October 28, 1968.  
##
##	This AGC program shall also be referred to as
##				Colossus 1A
##
##	Prepared by
##			Massachusetts Institute of Technology
##			75 Cambridge Parkway
##			Cambridge, Massachusetts
##	under NASA contract NAS 9-4065.
##
## Refer directly to the online document mentioned above for further information.
## Please report any errors (relative to the scanned pages) to info@sandroid.org.
##
## In some cases, where the source code for Luminary 131 overlaps that of 
## Colossus 249, this code is instead copied from the corresponding Luminary 131
## source file, and then is proofed to incorporate any changes.

## Page 449
# GROUND TRACKING DETERMINATION PROGRAM -- P21
#
# PROGRAM DESCRIPTION
#	MOD NO -- 1
#	MOD BY -- N. M. NEVILLE
#
# FUNCTIONAL DESCRIPTION --
#	TO PROVIDE THE ASTRONAUT DETAILS OF THE LM OR CSM GROUND TRACK WITHOUT
#	THE NEED FOR GROUND COMMUNICATION (REQUESTED BY DSKY).
#
# CALLING SEQUENCE --
#	ASTRONAUT REQUEST THROUGH DSKY V37E21E
#
# SUBROUTINES CALLED --
#	GOPERF4
#	GOFLASH
#	THISPREC
#	OTHPREC
#	LAT-LONG
#
# NORMAL EXIT MODES --
#	ASTRONAUT REQUEST THROUGH DSKY TO TERMINATE PROGRAM V34E
#
# ALARM OR ABORT EXIT MODES --
#	NONE
#
# OUTPUT --
#	OCTAL DISPLAY OF OPTION CODE AND VEHICLE WHOSE GROUND TRACK IS TO BE
#	COMPUTED
#		OPTION CODE	00002
#		THIS		00001
#		OTHER		00002
#	DECIMAL DISPLAY OF TIME TO BE INTEGRATED TO HOURS, MINUTES, SECONS
#	DECIMAL DISPLAY OF LAT,LONG,ALT
#
# ERASABLE INITIALIZATION REQUIRED
#	AX0	2DEC	4.652459653 E-5 RADIANS
#	-AY0	2DEC	2.147535898 E-5 RADIANS
#	AZ0	2DEC	.7753206164	REVOLUTIONS
# 	FOR LUNAR ORBITS 504LM VECTOR IS NEEDED:
#	504LM	2DEC	-2.700340600 E-5 RADIANS
#	504LM+2	2DEC	-7.514128400 E-4 RADIANS
#	504LM+4	2DEC	 2.553198641 E-4 RADIANS
#	NONE
#
# DEBRIS
## Page 450
#	CENTRALS -- A,Q,L
#	OTHER -- THOSE USED BY THE ABOVE LISTED SUBROUTINES
#	SEE LEMPREC, LAT-LONG

		SBANK=	LOWSUPER	# FOR LOW 2CADR'S.

		BANK	33
		SETLOC	P20S
		BANK

		EBANK=	P21TIME
		COUNT	24/P21
		
PROG21		CAF	ONE
		TS	OPTION2		# ASSUMED VEHICLE IS LM, R2 = 00001
		CAF	BIT2		# OPTION 2
		TC	BANKCALL
		CADR	GOPERF4
		TC	GOTOP00H	# TERMINATE
		TC	+2		# PROCEED VALUE OF ASSUMED VEHICLE OK
		TC	-5		# R2 LOADED THROUGH DSKY
P21PROG1	CAF	V6N34		# LOAD DESIRED TIME OF LAT-LONG.
		TC	BANKCALL
		CADR	GOFLASH
		TC	GOTOP00H	# TERM
		TC	+2		# PROCEED VALUES OK
		TC	-5		# TIME LOADED THROUGH DSKY
		TC	INTPRET
		DLOAD	
			DSPTEM1
		STORE	P21TIME
		SLOAD	DSU
			OPTION2
			P21ONENN
		BHIZ	DLOAD
			P21PROG2	# VEHICLE TO BE INTEGRATED IS LEM
			P21TIME		# VEHICLE TO BE INTEGRATED IS CSM
		STCALL	TDEC1		# INTEGRATE TO TIME SPECIFIED IN TDEC1
			OTHPREC		# ADJUST UNITS FOR LAT-LONG ROUTINE
P21PROGA	SLOAD	BHIZ
			X2
			P21PROG3
		VLOAD	SETGO
			RATT
			LUNAFLAG
			P21PROG4
P21PROG2	DLOAD
			P21TIME
		STCALL	TDEC1
			THISPREC
## Page 451
		GOTO
			P21PROGA
P21PROG3	VLOAD	CLEAR
			RATT
			LUNAFLAG
P21PROG4	STODL	ALPHAV
			TAT
		CLEAR	CALL
			ERADFLAG
			LAT-LONG
		EXIT
		CAF	V06N43		# DISPLAY LAT,LONG,ALT
		TC	BANKCALL	# LAT,LONG = 1/2 REVS B0
		CADR	GOFLASH		# ALT = KM B14
		TC	GOTOP00H	# TERM
		TC	GOTOP00H
		TC	INTPRET		# V32E RECYCLE
		DLOAD	DAD
			P21TIME
			600SEC		# 600 SECONDS OR 10 MIN
		STORE	DSPTEM1
		RTB	
			P21PROG1
	
600SEC		2DEC	60000		# 10 MIN
P21ONENN	OCT	00001		# NEEDED TO DETERMINE VEHICLE
		OCT	00000		# TO BE INTEGRATED

V06N43		VN	00643
V6N34		VN	00634

