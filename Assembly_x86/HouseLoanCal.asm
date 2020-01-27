	.386
        .model flat, stdcall
        option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include         windows.inc
include		user32.inc
includelib	user32.lib
include         kernel32.inc
includelib      kernel32.lib
include         msvcrt.inc
includelib      msvcrt.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                .data?
hStdIn          dd      ?
hStdOut         dd      ?
dwBytesWrite    dd      ?
dwBytesRead	dd	?
szRead		db	16 dup (?)
szBuffer	db	1024 dup (?)
bLoanMethod	db	?
bPayMethod	db	?
r8TotalLoan	Real8	?
r8TotalLoanBank	Real8	?
r8TotalLoanFund	Real8	?
dwPayMonths	dd	?
r8LoanRate	Real8	?
r8BankRate	Real8	?
r8FundRate	Real8	?
r8MonthLoan	Real8	?
r8MonthLoanB	Real8	?
r8TotalPay	Real8	?
r8TotalInterest	Real8	?
r8TotalPayB	Real8	?
r8TotalInstB	Real8	?
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                .const
szTitle         db      '�����������', 0
szLoanMethodP   db      '��ѡ�����Ĵ��ʽ', 0dh, 0ah
                db      09h, '1����ҵ����', 0dh, 0ah
                db      09h, '2�����������', 0dh, 0ah
                db      09h, '3����ϴ���', 0dh, 0ah
                db      '�������Ӧ��ţ�1-3����', 0
szLoanMethodQ	db	'��������Ч��Ӧ��ţ�1-3����', 0
szLoanMethodA1	db	'��ѡ��Ĵ��ʽΪ��ҵ����', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szLoanMethodA2	db	'��ѡ��Ĵ��ʽΪ���������', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szLoanMethodA3	db	'��ѡ��Ĵ��ʽΪ��ϴ���', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szTotalLoanP1	db	'���������Ĵ����ܶ�򣩣�', 0
szTotalLoanP2	db	'������������ҵ�����ܶ�򣩣�', 0
szTotalLoanP3	db	'���������Ĺ���������ܶ�򣩣�', 0
szTotalLoanQ1	db	'��������Ч�����ܶ�򣩣�', 0
szTotalLoanQ2	db	'��������Ч��ҵ�����ܶ�򣩣�', 0
szTotalLoanQ3	db	'��������Ч����������ܶ�򣩣�', 0
szTotalLoanA1	db	'�����ܴ�����Ϊ%f��Ԫ', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szTotalLoanA2	db	'������ҵ������Ϊ%f��Ԫ', 0dh, 0ah
		db	'���Ĺ����������Ϊ%f��Ԫ', 0dh, 0ah
		db	'�ܴ�����Ϊ%f��Ԫ', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szPayMethodP	db	'��ѡ�����Ļ��ʽ', 0dh, 0ah
		db	09h, '1���ȶϢ��ÿ�µȶ�', 0dh, 0ah
		db	09h, '2���ȶ��ÿ�µݼ����', 0dh, 0ah
		db	'�������Ӧ��ţ�1-2����', 0
szPayMethodQ	db	'��������Ч��Ӧ��ţ�1-2����', 0
szPayMethodA1	db	'��ѡ��Ļ��ʽΪ�ȶϢ', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szPayMethodA2	db	'��ѡ��Ļ��ʽΪ�ȶ��', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szPayMonthP	db	'�����뻹��������1-30����', 0
szPayMonthQ	db	'��������Ч����������1-30����', 0
szPayMonthA	db	'���Ļ�������Ϊ%d�꣬��%d����', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szLoanRateP1	db	'���������д������ʣ���ֹ2019��ĩ�����д�����������', 0dh, 0ah
		db	09h, '7�ۣ�3.43%��', 0dh, 0ah
		db	09h, '8�ۣ�3.92%��', 0dh, 0ah
		db	09h, '8.3�ۣ�4.067%��', 0dh, 0ah
		db	09h, '8.5�ۣ�4.165%��', 0dh, 0ah
		db	09h, '8.8�ۣ�4.312%��', 0dh, 0ah
		db	09h, '9�ۣ�4.41%��', 0dh, 0ah
		db	09h, '9.5�ۣ�4.655%��', 0dh, 0ah
		db	09h, '��׼���ʣ�4.9%��', 0dh, 0ah
		db	09h, '1.05����5.145%��', 0dh, 0ah
		db	09h, '1.1����5.39%��', 0dh, 0ah
		db	09h, '1.15����5.635%��', 0dh, 0ah
		db	09h, '1.2����5.88%��', 0dh, 0ah
		db	09h, '1.25����6.125%��', 0dh, 0ah
		db	09h, '1.3����6.37%��', 0dh, 0ah
		db	09h, '1.35����6.615%��', 0dh, 0ah
		db	09h, '1.4����6.86%��', 0dh, 0ah
		db	'�����������ֵ��%����', 0
szLoanRateP2	db	'�����빫����������ʣ���ֹ2019��ĩ�������������������', 0dh, 0ah
		db	09h, '��׼���ʣ�3.25%��', 0dh, 0ah
		db	09h, '1.1����3.575%��', 0dh, 0ah
		db	09h, '1.2����3.9%��', 0dh, 0ah
		db	'�����������ֵ��%����', 0
szLoanRateQ1	db	'��������Ч���д������ʣ�%����', 0
szLoanRateQ2	db	'��������Ч������������ʣ�%����', 0
szLoanRateA1	db	'�������д�������Ϊ%.3f%%', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szLoanRateA2	db	'���Ĺ������������Ϊ%.3f%%', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szLoanRateA3	db	'�������д�������Ϊ%.3f%%���������������Ϊ%.3f%%', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szFinalA1	db	'ÿ���軹��%.2fԪ', 0dh, 0ah
		db	09h, '�����ܶ�%.6f��', 0dh, 0ah
		db	09h, '֧����Ϣ%.6f��', 0dh, 0ah
		db	09h, '�����ܶ�%.6f��', 0dh, 0ah, 0
szFinalA2	db	'�����ܶ�%.6f��', 0dh, 0ah
		db	'֧����Ϣ%.6f��', 0dh, 0ah
		db	'�����ܶ�%.6f��', 0dh, 0ah, 0
szDebug		db	'%d', 0dh, 0ah, 0
szPause         db      'pause', 0
szAtof		db	'%lf', 0
dwRateTimes	dd	100	; one hundred
dwLoanTimes	dd	10000	; ten thousand
dwMonthsAYear	dd	12
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                .code
OUTPUT	macro 	_lpszOutput, _dwSize
	invoke  WriteConsole, hStdOut, _lpszOutput,\
                _dwSize, offset dwBytesWrite, NULL
	endm
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INPUT	macro
	invoke  RtlZeroMemory, offset szRead, sizeof szRead ;must
	invoke	ReadConsole, hStdIn, offset szRead,
		sizeof szRead, offset dwBytesRead, NULL
	endm
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
PROMPT	macro 	_lpszPrompt, _dwSize
	OUTPUT	_lpszPrompt, _dwSize
	INPUT
	endm
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Check the input is a valid integer or floating number
_CheckNumValid	proc	uses ecx edx _lpszBuffer:dword, _dwIsInt:dword
		local	@dwDotExist:dword

		invoke	lstrlen, _lpszBuffer
		sub	eax, 2
		mov	ecx, eax
		mov	@dwDotExist, 0
		mov	edx, _lpszBuffer
		mov	eax, _dwIsInt
		or	eax, eax
		jz	Float_Check
Int_Check:	mov	al, [edx] ; for integer
		cmp	al, '0'
		jb	Fail_Check
		cmp	al, '9'
		ja	Fail_Check
		inc 	edx
		loop 	Int_Check
		mov	eax, TRUE
		jmp	End_Check
Float_Check: 	mov	al, [edx] ; for floating number
		cmp	al, '0'
		jb	Dot_Check
		cmp	al, '9'
		ja	Dot_Check
		inc	edx
		loop	Float_Check
		mov	eax, TRUE
		jmp	End_Check
Dot_Check:	cmp	al, '.'
		jne	Fail_Check
		mov	eax, @dwDotExist
		or	eax, eax ; decimal point can only appear once
		jnz	Fail_Check
		mov	@dwDotExist, TRUE
		inc	edx
		loop	Float_Check
		mov	eax, TRUE
		jmp	End_Check
Fail_Check:	xor	eax, eax
End_Check:	ret
_CheckNumValid	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_CtrlHandler	proc	_dwCtrlType
		pushad
		mov	eax, _dwCtrlType
		.if	eax ==	CTRL_C_EVENT || eax ==	CTRL_BREAK_EVENT
			invoke	CloseHandle, hStdIn
		.endif
		popad
		mov	eax, TRUE
		ret
_CtrlHandler	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Read the loan method
_GetLoanMethod	proc
		invoke  lstrlen, offset szLoanMethodP
        	PROMPT	offset szLoanMethodP, eax
		mov	al, szRead[0]
		; Make sure that the input is 1, 2 or 3
		; The last is 0dh, 0ah, so dwBytesRead is 3
		.while	dwBytesRead != 3 || (al != '1' && al != '2'\
			&& al != '3')
			PROMPT	offset szLoanMethodQ, sizeof szLoanMethodQ
			mov	al, szRead[0]
		.endw
		mov	bLoanMethod, al
		.if	al == '1'
			invoke	lstrlen, offset szLoanMethodA1
			OUTPUT	offset szLoanMethodA1, eax
		.elseif	al == '2'
			invoke	lstrlen, offset szLoanMethodA2
			OUTPUT	offset szLoanMethodA2, eax
		.elseif	al == '3'
			invoke	lstrlen, offset szLoanMethodA3
			OUTPUT	offset szLoanMethodA3, eax
		.endif
		ret
_GetLoanMethod	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Get total loan
_GetTotalLoan	proc
		.if	bLoanMethod == '1' || bLoanMethod == '2'
			PROMPT  offset szTotalLoanP1, sizeof szTotalLoanP1
_Loop1:			invoke	_CheckNumValid, offset szRead, 0
			or	eax, eax
			jnz	_Float1
_Prompt1:		PROMPT	offset szTotalLoanQ1, sizeof szTotalLoanQ1
			jmp	_Loop1
_Float1:		invoke	crt_sscanf, offset szRead, offset szAtof,\
				offset r8TotalLoan
			fld	r8TotalLoan
			; Make sure that the input is a number above 0
			ftst
			fstsw	ax
			sahf
			jle	_Prompt1
			invoke	crt_sprintf, offset szBuffer,\
				offset szTotalLoanA1, r8TotalLoan
			invoke	lstrlen, offset szBuffer
			OUTPUT  offset szBuffer, eax
			finit
			fld	r8TotalLoan
			fimul	dwLoanTimes
			fstp	r8TotalLoan
		.else
			PROMPT  offset szTotalLoanP2, sizeof szTotalLoanP2
_Loop2:			invoke	_CheckNumValid, offset szRead, 0
			or	eax, eax
			jnz	_Float2
_Prompt2:		PROMPT	offset szTotalLoanQ2, sizeof szTotalLoanQ2
			jmp	_Loop2
_Float2:		invoke	crt_sscanf, offset szRead, offset szAtof,\
				offset r8TotalLoanBank
			fld	r8TotalLoanBank
			ftst
			fstsw	ax
			sahf
			jle	_Prompt2
			PROMPT  offset szTotalLoanP3, sizeof szTotalLoanP3
_Loop3:			invoke	_CheckNumValid, offset szRead, 0
			or	eax, eax
			jnz	_Float3
_Prompt3:		PROMPT	offset szTotalLoanQ3, sizeof szTotalLoanQ3
			jmp	_Loop3
_Float3:		invoke	crt_sscanf, offset szRead, offset szAtof,\
				offset r8TotalLoanFund
			fld	r8TotalLoanFund
			ftst
			fstsw	ax
			sahf
			jle	_Prompt3
			finit
			fld	r8TotalLoanBank
			fadd	r8TotalLoanFund
			fst	r8TotalLoan
			invoke	crt_sprintf, offset szBuffer,\
				offset szTotalLoanA2, r8TotalLoanBank,\
				r8TotalLoanFund, r8TotalLoan
			invoke	lstrlen, offset szBuffer
			OUTPUT  offset szBuffer, eax
			finit
			fld	r8TotalLoanBank
			fimul	dwLoanTimes
			fstp	r8TotalLoanBank
			fld	r8TotalLoanFund
			fimul	dwLoanTimes
			fstp	r8TotalLoanFund
		.endif
		ret
_GetTotalLoan	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Read payment method
_GetPaymentMethod	proc
			invoke	lstrlen, offset szPayMethodP
			PROMPT	offset szPayMethodP, eax
			mov	al, szRead[0]
			; Make sure that the input is 1 or 2
			.while	dwBytesRead != 3 || (al != '1' && al != '2')
				PROMPT	offset szPayMethodQ,\
					sizeof szPayMethodQ
				mov	al, szRead[0]
			.endw
			mov	bPayMethod, al
			.if	al == '1'
				invoke	lstrlen, offset szPayMethodA1
				OUTPUT	offset szPayMethodA1, eax
			.elseif	al == '2'
				invoke	lstrlen, offset szPayMethodA2
				OUTPUT	offset szPayMethodA2, eax
			.endif
			ret			
_GetPaymentMethod	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Get payment months
_GetPayMonths	proc	uses edx
		local	@dwPayYears:dword

		PROMPT	offset szPayMonthP, sizeof szPayMonthP
_Loop4:		invoke	_CheckNumValid, offset szRead, TRUE
		or	eax, eax
		jnz	_Int1
_Prompt4:	PROMPT	offset szPayMonthQ, sizeof szPayMonthQ
		jmp	_Loop4
_Int1:		invoke	crt_atoi, offset szRead
		; Make sure that the input is a integer and between 1 and 30
		cmp	eax, 1
		jl	_Prompt4
		cmp	eax, 30
		jg	_Prompt4
		invoke	crt_atoi, offset szRead
		mov	@dwPayYears, eax
		mov	edx, 12
		mul	edx
		mov	dwPayMonths, eax
		invoke	wsprintf, offset szBuffer, offset szPayMonthA,\
			@dwPayYears, dwPayMonths
		invoke	lstrlen, offset szBuffer
		OUTPUT  offset szBuffer, eax
		ret
_GetPayMonths	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Read loan interest rate according to the loan method
_GetLoanRate	proc
		.if	bLoanMethod == '1'
			invoke	lstrlen, offset szLoanRateP1
			PROMPT	offset szLoanRateP1, eax
; make sure that the input is a number above 0 below 100
_Loop5:			invoke	_CheckNumValid, offset szRead, 0
			or	eax, eax
			jnz	_Float4
_Prompt5:		PROMPT	offset szLoanRateQ1, sizeof szLoanRateQ1
			jmp	_Loop5
_Float4:		invoke	crt_sscanf, offset szRead, offset szAtof,\
				offset r8LoanRate
			fld	r8LoanRate
			ftst
			fstsw	ax
			sahf
			jle	_Prompt5 ;signed
			ficom	dwRateTimes
			fstsw	ax
			sahf
			jae	_Prompt5 ;unsigned
			invoke	crt_sprintf, offset szBuffer,\
				offset szLoanRateA1, r8LoanRate
			invoke	lstrlen, offset szBuffer
			OUTPUT  offset szBuffer, eax
			finit
			fld	r8LoanRate
			fidiv	dwRateTimes
			fst	r8LoanRate
		.elseif bLoanMethod == '2'
			invoke	lstrlen, offset szLoanRateP2
			PROMPT	offset szLoanRateP2, eax
_Loop6:			invoke	_CheckNumValid, offset szRead, 0
			or	eax, eax
			jnz	_Float5
_Prompt6:		PROMPT	offset szLoanRateQ2, sizeof szLoanRateQ2
			jmp	_Loop6
_Float5:		invoke	crt_sscanf, offset szRead, offset szAtof,\
				offset r8LoanRate
			fld	r8LoanRate
			ftst
			fstsw	ax
			sahf
			jle	_Prompt6 ;signed
			ficom	dwRateTimes
			fstsw	ax
			sahf
			jae	_Prompt6 ;unsigned
			invoke	crt_sprintf, offset szBuffer,\
				offset szLoanRateA2, r8LoanRate
			invoke	lstrlen, offset szBuffer
			OUTPUT  offset szBuffer, eax
			finit
			fld	r8LoanRate
			fidiv	dwRateTimes
			fst	r8LoanRate
		.else
			invoke	lstrlen, offset szLoanRateP1
			PROMPT	offset szLoanRateP1, eax
_Loop7:			invoke	_CheckNumValid, offset szRead, 0
			or	eax, eax
			jnz	_Float6
_Prompt7:		PROMPT	offset szLoanRateQ1, sizeof szLoanRateQ1
			jmp	_Loop7
_Float6:		invoke	crt_sscanf, offset szRead, offset szAtof,\
				offset r8BankRate
			fld	r8BankRate
			ftst
			fstsw	ax
			sahf
			jle	_Prompt7 ;signed
			ficom	dwRateTimes
			fstsw	ax
			sahf
			jae	_Prompt7 ;unsigned
			invoke	lstrlen, offset szLoanRateP2
			PROMPT	offset szLoanRateP2, eax
_Loop8:			invoke	_CheckNumValid, offset szRead, 0
			or	eax, eax
			jnz	_Float7
_Prompt8:		PROMPT	offset szLoanRateQ2, sizeof szLoanRateQ2
			jmp	_Loop8
_Float7:		invoke	crt_sscanf, offset szRead, offset szAtof,\
				offset r8FundRate
			fld	r8FundRate
			ftst
			fstsw	ax
			sahf
			jle	_Prompt8 ;signed
			ficom	dwRateTimes
			fstsw	ax
			sahf
			jae	_Prompt8 ;unsigned
			invoke	crt_sprintf, offset szBuffer,\
				offset szLoanRateA3, r8BankRate, r8FundRate
			invoke	lstrlen, offset szBuffer
			OUTPUT  offset szBuffer, eax
			finit
			fld	r8BankRate
			fidiv	dwRateTimes
			fstp	r8BankRate
			fld	r8FundRate
			fidiv	dwRateTimes
			fst	r8FundRate
		.endif
		ret
_GetLoanRate	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Get payment every month by the way of average captial plus interest
_AveCapPlus	proc	uses ecx _r8TotalLoan:Real8, _r8InterestRate:Real8
		mov	ecx, dwPayMonths
		dec	ecx
		finit
		fld	_r8InterestRate
		fidiv	dwMonthsAYear
		fld	st(0)
		fld1
		fadd
		fld	st(0)
@@:		fld	st(1)
		fmul
		loop	@B
		fld	st(0)
		fld	st(3)
		fmul
		fld	_r8TotalLoan
		fmul
		fld	st(1)
		fld1
		fsub
		fdiv
		fstp	r8MonthLoan
		ret
_AveCapPlus	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Get payment of uMonth month by the way of average captial
_AveCap	proc	_r8TotalLoan:Real8, _r8InterestRate:Real8, _dwMonth:dword
	mov	eax, dwPayMonths
	sub	eax, _dwMonth
	mov	_dwMonth, eax
	finit
	fld	_r8InterestRate
	fimul 	_dwMonth
	fld1
	fadd
	fld	_r8TotalLoan
	fidiv	dwPayMonths
	fmul
	fstp	r8MonthLoan
	ret
_AveCap	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
start:
        invoke  GetStdHandle, STD_INPUT_HANDLE
        mov     hStdIn, eax
        invoke  GetStdHandle, STD_OUTPUT_HANDLE
        mov     hStdOut, eax
	invoke  SetConsoleTitle, offset szTitle
	invoke  SetConsoleMode, hStdIn, ENABLE_LINE_INPUT or\
		ENABLE_ECHO_INPUT or ENABLE_PROCESSED_INPUT
	invoke	SetConsoleCtrlHandler, offset _CtrlHandler, TRUE
	call	_GetLoanMethod
	call	_GetTotalLoan
	call	_GetPaymentMethod
	call	_GetPayMonths
	call	_GetLoanRate
	.if	bPayMethod == '1' ; for average capital plus interest method
		; for commercial or provident fund loan method
		.if 	bLoanMethod == '1' || bLoanMethod == '2'
		    	invoke  _AveCapPlus, r8TotalLoan, r8LoanRate
			finit
			fld	r8MonthLoan
			fimul	dwPayMonths
			fidiv	dwLoanTimes
			fst	r8TotalPay
			fld	r8TotalLoan
			fidiv	dwLoanTimes
			fst	r8TotalLoan
			fsub
			fst	r8TotalInterest
		.else	; for syndicated loan method
			; bank payment every month
			invoke  _AveCapPlus, r8TotalLoanBank, r8BankRate
			finit
			fld	r8MonthLoan
			fst	r8MonthLoanB
			fimul	dwPayMonths
			fidiv	dwLoanTimes
			fst	r8TotalPayB
			fld	r8TotalLoanBank
			fidiv	dwLoanTimes
			fst	r8TotalLoanBank
			fsub
			fst	r8TotalInstB
			; provident fund payment every month
			invoke  _AveCapPlus, r8TotalLoanFund, r8FundRate
			finit
			fld	r8MonthLoan
			fimul	dwPayMonths
			fidiv	dwLoanTimes
			fadd	r8TotalPayB
			fst	r8TotalPay
			fld	r8TotalLoanFund
			fidiv	dwLoanTimes
			fadd	r8TotalLoanBank
			fst	r8TotalLoan
			fsub
			fst	r8TotalInterest
			fld	r8MonthLoan
			fadd	r8MonthLoanB
			fst	r8MonthLoan
		.endif
		invoke	crt_sprintf, offset szBuffer,\
			offset szFinalA1, r8MonthLoan, r8TotalPay,\
			r8TotalInterest, r8TotalLoan
		invoke	lstrlen, offset szBuffer
		OUTPUT  offset szBuffer, eax
	.else	; for average capital method
		mov	dword ptr r8TotalPay, 0
		mov	dword ptr r8TotalPay+4, 0
		push	ecx
		mov	ecx, dwPayMonths
		; for commercial or provident fund loan method
		.if	bLoanMethod == '1' || bLoanMethod == '2'
			finit
			fld	r8LoanRate
			fidiv	dwMonthsAYear
			fstp	r8LoanRate	
			xor	eax, eax
@@:			push	eax
			invoke	_AveCap, r8TotalLoan, r8LoanRate, eax
			pop	eax
			fld	r8MonthLoan
			fadd	r8TotalPay
			fst	r8TotalPay
			inc	eax
			loop	@B
			fidiv	dwLoanTimes
			fst	r8TotalPay
			fld	r8TotalLoan
			fidiv	dwLoanTimes
			fsub
			fstp	r8TotalInterest
		.else	; for syndicated loan method
			finit
			fld	r8BankRate
			fidiv	dwMonthsAYear
			fstp	r8BankRate
			fld	r8FundRate
			fidiv	dwMonthsAYear
			fstp	r8FundRate
			xor	eax, eax
@@:			push	eax
			invoke	_AveCap, r8TotalLoanBank, r8BankRate, eax
			pop	eax
			fld	r8MonthLoan
			fadd	r8TotalPay
			fst	r8TotalPay
			push	eax
			invoke	_AveCap, r8TotalLoanFund, r8FundRate, eax
			pop	eax
			fld	r8MonthLoan
			fadd	r8TotalPay
			fst	r8TotalPay
			inc	eax
			loop	@B
			fidiv	dwLoanTimes
			fst	r8TotalPay
			fld	r8TotalLoanBank
			fadd	r8TotalLoanFund
			fidiv	dwLoanTimes
			fsub
			fstp	r8TotalInterest
		.endif
		pop	ecx
		invoke	crt_sprintf, offset szBuffer,\
			offset szFinalA2, r8TotalPay,\
			r8TotalInterest, r8TotalLoan
		invoke	lstrlen, offset szBuffer
		OUTPUT  offset szBuffer, eax
	.endif
	invoke  crt_system, offset szPause
        invoke  ExitProcess, NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        end     start
