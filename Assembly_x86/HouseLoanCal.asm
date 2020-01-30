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
szTitle         db      '房贷计算程序', 0
szLoanMethodP   db      '请选择您的贷款方式', 0dh, 0ah
                db      09h, '1、商业贷款', 0dh, 0ah
                db      09h, '2、公积金贷款', 0dh, 0ah
                db      09h, '3、组合贷款', 0dh, 0ah
                db      '请输入对应序号（1-3）：', 0
szLoanMethodQ	db	'请输入有效对应序号（1-3）：', 0
szLoanMethodA1	db	'您选择的贷款方式为商业贷款', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szLoanMethodA2	db	'您选择的贷款方式为公积金贷款', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szLoanMethodA3	db	'您选择的贷款方式为组合贷款', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szTotalLoanP1	db	'请输入您的贷款总额（万）：', 0
szTotalLoanP2	db	'请输入您的商业贷款总额（万）：', 0
szTotalLoanP3	db	'请输入您的公积金贷款总额（万）：', 0
szTotalLoanQ1	db	'请输入有效贷款总额（万）：', 0
szTotalLoanQ2	db	'请输入有效商业贷款总额（万）：', 0
szTotalLoanQ3	db	'请输入有效公积金贷款总额（万）：', 0
szTotalLoanA1	db	'您的总贷款金额为%f万元', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szTotalLoanA2	db	'您的商业贷款金额为%f万元', 0dh, 0ah
		db	'您的公积金贷款金额为%f万元', 0dh, 0ah
		db	'总贷款金额为%f万元', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szPayMethodP	db	'请选择您的还款方式', 0dh, 0ah
		db	09h, '1、等额本息（每月等额还款）', 0dh, 0ah
		db	09h, '2、等额本金（每月递减还款）', 0dh, 0ah
		db	'请输入对应序号（1-2）：', 0
szPayMethodQ	db	'请输入有效对应序号（1-2）：', 0
szPayMethodA1	db	'您选择的还款方式为等额本息', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szPayMethodA2	db	'您选择的还款方式为等额本金', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szPayMonthP	db	'请输入还款年数（1-30）：', 0
szPayMonthQ	db	'请输入有效还款年数（1-30）：', 0
szPayMonthA	db	'您的还款年数为%d年，共%d个月', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szLoanRateP1	db	'请输入银行贷款利率，截止2019年末，银行贷款利率如下', 0dh, 0ah
		db	09h, '7折（3.43%）', 0dh, 0ah
		db	09h, '8折（3.92%）', 0dh, 0ah
		db	09h, '8.3折（4.067%）', 0dh, 0ah
		db	09h, '8.5折（4.165%）', 0dh, 0ah
		db	09h, '8.8折（4.312%）', 0dh, 0ah
		db	09h, '9折（4.41%）', 0dh, 0ah
		db	09h, '9.5折（4.655%）', 0dh, 0ah
		db	09h, '基准利率（4.9%）', 0dh, 0ah
		db	09h, '1.05倍（5.145%）', 0dh, 0ah
		db	09h, '1.1倍（5.39%）', 0dh, 0ah
		db	09h, '1.15倍（5.635%）', 0dh, 0ah
		db	09h, '1.2倍（5.88%）', 0dh, 0ah
		db	09h, '1.25倍（6.125%）', 0dh, 0ah
		db	09h, '1.3倍（6.37%）', 0dh, 0ah
		db	09h, '1.35倍（6.615%）', 0dh, 0ah
		db	09h, '1.4倍（6.86%）', 0dh, 0ah
		db	'请输入具体数值（%）：', 0
szLoanRateP2	db	'请输入公积金贷款利率，截止2019年末，公积金贷款利率如下', 0dh, 0ah
		db	09h, '基准利率（3.25%）', 0dh, 0ah
		db	09h, '1.1倍（3.575%）', 0dh, 0ah
		db	09h, '1.2倍（3.9%）', 0dh, 0ah
		db	'请输入具体数值（%）：', 0
szLoanRateQ1	db	'请输入有效银行贷款利率（%）：', 0
szLoanRateQ2	db	'请输入有效公积金贷款利率（%）：', 0
szLoanRateA1	db	'您的银行贷款利率为%.3f%%', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szLoanRateA2	db	'您的公积金贷款利率为%.3f%%', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szLoanRateA3	db	'您的银行贷款利率为%.3f%%，公积金贷款利率为%.3f%%', 0dh, 0ah
		db	'>>>>>>>>>>>>>>>', 0dh, 0ah, 0
szFinalA1	db	'每月需还款%.2f元', 0dh, 0ah
		db	09h, '还款总额%.6f万', 0dh, 0ah
		db	09h, '支付利息%.6f万', 0dh, 0ah
		db	09h, '贷款总额%.6f万', 0dh, 0ah, 0
szFinalA2	db	'还款总额%.6f万', 0dh, 0ah
		db	'支付利息%.6f万', 0dh, 0ah
		db	'贷款总额%.6f万', 0dh, 0ah, 0
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
_CheckNumValid	proc	uses ecx esi _lpszBuffer:dword, _dwIsInt:dword
		local	@dwDotExist:dword

		invoke	lstrlen, _lpszBuffer
		sub	eax, 2
		mov	ecx, eax
		mov	@dwDotExist, 0
		cld
		mov	esi, _lpszBuffer
		mov	eax, _dwIsInt
		or	eax, eax
		jz	_la_float_cnv
_la_int_cnv:	lodsb		; for integer
		cmp	al, '0'
		jb	_la_fail_cnv
		cmp	al, '9'
		ja	_la_fail_cnv
		loop 	_la_int_cnv
		mov	eax, TRUE
		jmp	_la_end_cnv
_la_float_cnv: 	lodsb		; for floating number
		cmp	al, '0'
		jb	_la_dot_cnv
		cmp	al, '9'
		ja	_la_dot_cnv
		loop	_la_float_cnv
		mov	eax, TRUE
		jmp	_la_end_cnv
_la_dot_cnv:	cmp	al, '.'
		jne	_la_fail_cnv
		mov	eax, @dwDotExist
		or	eax, eax ; decimal point can only appear once
		jnz	_la_fail_cnv
		mov	@dwDotExist, TRUE
		loop	_la_float_cnv
		mov	eax, TRUE
		jmp	_la_end_cnv
_la_fail_cnv:	xor	eax, eax
_la_end_cnv:	ret
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
_la_loop1_gtl:		invoke	_CheckNumValid, offset szRead, 0
			or	eax, eax
			jnz	_la_float1_gtl
_la_prompt1_gtl:	PROMPT	offset szTotalLoanQ1, sizeof szTotalLoanQ1
			jmp	_la_loop1_gtl
_la_float1_gtl:		invoke	crt_sscanf, offset szRead, offset szAtof,\
				offset r8TotalLoan
			fld	r8TotalLoan
			; Make sure that the input is a number above 0
			ftst
			fstsw	ax
			sahf
			jle	_la_prompt1_gtl
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
_la_loop2_gtl:		invoke	_CheckNumValid, offset szRead, 0
			or	eax, eax
			jnz	_la_float2_gtl
_la_prompt2_gtl:	PROMPT	offset szTotalLoanQ2, sizeof szTotalLoanQ2
			jmp	_la_loop2_gtl
_la_float2_gtl:		invoke	crt_sscanf, offset szRead, offset szAtof,\
				offset r8TotalLoanBank
			fld	r8TotalLoanBank
			ftst
			fstsw	ax
			sahf
			jle	_la_prompt2_gtl
			PROMPT  offset szTotalLoanP3, sizeof szTotalLoanP3
_la_loop3_gtl:		invoke	_CheckNumValid, offset szRead, 0
			or	eax, eax
			jnz	_la_float3_gtl
_la_prompt3_gtl:	PROMPT	offset szTotalLoanQ3, sizeof szTotalLoanQ3
			jmp	_la_loop3_gtl
_la_float3_gtl:		invoke	crt_sscanf, offset szRead, offset szAtof,\
				offset r8TotalLoanFund
			fld	r8TotalLoanFund
			ftst
			fstsw	ax
			sahf
			jle	_la_prompt3_gtl
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
_GetPayMonths	proc
		local	@dwPayYears:dword

		PROMPT	offset szPayMonthP, sizeof szPayMonthP
_la_loop_gpm:	invoke	_CheckNumValid, offset szRead, TRUE
		or	eax, eax
		jnz	_la_int_gpm
_la_prompt_gpm:	PROMPT	offset szPayMonthQ, sizeof szPayMonthQ
		jmp	_la_loop_gpm
_la_int_gpm:	invoke	crt_atoi, offset szRead
		; Make sure that the input is a integer and between 1 and 30
		cmp	eax, 1
		jl	_la_prompt_gpm
		cmp	eax, 30
		jg	_la_prompt_gpm
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
_la_loop1_glr:	     	invoke	_CheckNumValid, offset szRead, 0
			or	eax, eax
			jnz	_la_float1_glr
_la_prompt1_glr:	PROMPT	offset szLoanRateQ1, sizeof szLoanRateQ1
			jmp	_la_loop1_glr
_la_float1_glr:		invoke	crt_sscanf, offset szRead, offset szAtof,\
				offset r8LoanRate
			fld	r8LoanRate
			ftst
			fstsw	ax
			sahf
			jle	_la_prompt1_glr ;signed
			ficom	dwRateTimes
			fstsw	ax
			sahf
			jae	_la_prompt1_glr ;unsigned
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
_la_loop2_glr:		invoke	_CheckNumValid, offset szRead, 0
			or	eax, eax
			jnz	_la_float2_glr
_la_prompt2_glr:	PROMPT	offset szLoanRateQ2, sizeof szLoanRateQ2
			jmp	_la_loop2_glr
_la_float2_glr:		invoke	crt_sscanf, offset szRead, offset szAtof,\
				offset r8LoanRate
			fld	r8LoanRate
			ftst
			fstsw	ax
			sahf
			jle	_la_prompt2_glr ;signed
			ficom	dwRateTimes
			fstsw	ax
			sahf
			jae	_la_prompt2_glr ;unsigned
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
_la_loop3_glr:		invoke	_CheckNumValid, offset szRead, 0
			or	eax, eax
			jnz	_la_float3_glr
_la_prompt3_glr:	PROMPT	offset szLoanRateQ1, sizeof szLoanRateQ1
			jmp	_la_loop3_glr
_la_float3_glr:		invoke	crt_sscanf, offset szRead, offset szAtof,\
				offset r8BankRate
			fld	r8BankRate
			ftst
			fstsw	ax
			sahf
			jle	_la_prompt3_glr ;signed
			ficom	dwRateTimes
			fstsw	ax
			sahf
			jae	_la_prompt3_glr ;unsigned
			invoke	lstrlen, offset szLoanRateP2
			PROMPT	offset szLoanRateP2, eax
_la_loop4_glr:		invoke	_CheckNumValid, offset szRead, 0
			or	eax, eax
			jnz	_la_float4_glr
_la_prompt4_glr:	PROMPT	offset szLoanRateQ2, sizeof szLoanRateQ2
			jmp	_la_loop4_glr
_la_float4_glr:		invoke	crt_sscanf, offset szRead, offset szAtof,\
				offset r8FundRate
			fld	r8FundRate
			ftst
			fstsw	ax
			sahf
			jle	_la_prompt4_glr ;signed
			ficom	dwRateTimes
			fstsw	ax
			sahf
			jae	_la_prompt4_glr ;unsigned
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
		mov	ecx, dwPayMonths
		; for commercial or provident fund loan method
		.if	bLoanMethod == '1' || bLoanMethod == '2'
			finit
			fld	r8LoanRate
			fidiv	dwMonthsAYear
			fstp	r8LoanRate	
			xor	edx, edx
@@:			invoke	_AveCap, r8TotalLoan, r8LoanRate, edx
			fld	r8MonthLoan
			fadd	r8TotalPay
			fst	r8TotalPay
			inc	edx
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
			xor	edx, edx
@@:			invoke	_AveCap, r8TotalLoanBank, r8BankRate, edx
			fld	r8MonthLoan
			fadd	r8TotalPay
			fst	r8TotalPay
			invoke	_AveCap, r8TotalLoanFund, r8FundRate, edx
			fld	r8MonthLoan
			fadd	r8TotalPay
			fst	r8TotalPay
			inc	edx
			loop	@B
			fidiv	dwLoanTimes
			fst	r8TotalPay
			fld	r8TotalLoanBank
			fadd	r8TotalLoanFund
			fidiv	dwLoanTimes
			fsub
			fstp	r8TotalInterest
		.endif
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
