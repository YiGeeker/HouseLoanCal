        option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include         win64.inc
include		user32.inc
includelib	user32.lib
include         kernel32.inc
includelib      kernel32.lib
include         msvcrt.inc
includelib      msvcrt.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                .data?
hStdIn          dq      ?
hStdOut         dq      ?
qwBytesWrite    dq      ?
qwBytesRead	dq	?
szRead		db	16 dup (?)
szBuffer	db	1024 dup (?)
bLoanMethod	db	?
bPayMethod	db	?
r8TotalLoan	Real8	?
r8TotalLoanBank	Real8	?
r8TotalLoanFund	Real8	?
qwPayMonths	dq	?
r8LoanRate	Real8	?
r8BankRate	Real8	?
r8FundRate	Real8	?
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
dwRateTimes	dd	100	; one hundred
dwLoanTimes	dd	10000	; ten thousand
dwMonthsAYear	dd	12
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                .code
OUTPUT	macro 	_lpszOutput, _qwSize
	sub	rsp, 38h
	mov	qword ptr [rsp+20h], 0
	lea	r9, qwBytesWrite
	mov	r8, _qwSize
	mov	rdx, _lpszOutput
	mov	rcx, hStdOut
	call	WriteConsole
	add	rsp, 38h
	endm
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INPUT	macro
	sub	rsp, 38h
	mov	rdx, sizeof szRead
	lea	rcx, szRead
	call	RtlZeroMemory
	mov	qword ptr [rsp+20h], 0
	lea	r9, qwBytesRead
	mov	r8, sizeof szRead
	lea	rdx, szRead
	mov	rcx, hStdIn
	call	ReadConsole
	add	rsp, 38h
	endm
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
PROMPT	macro 	_lpszPrompt, _qwSize
	OUTPUT	_lpszPrompt, _qwSize
	INPUT
	endm
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Check the input is a valid integer or floating number
_CheckNumValid	proc	uses rsi _lpszBuffer:qword, _qwIsInt:qword
		local	@dwDotExist:qword

		mov	@dwDotExist, 0
		cld
		mov	rsi, rcx
		sub	rsp, 18h
		call	lstrlen
		add	rsp, 18h
		sub	rax, 2
		mov	rcx, rax
		mov	rax, rdx
		or	rax, rax
		jz	_la_float_cnv
_la_int_cnv:	lodsb		; for integer
		cmp	al, '0'
		jb	_la_fail_cnv
		cmp	al, '9'
		ja	_la_fail_cnv
		loop 	_la_int_cnv
		mov	rax, TRUE
		jmp	_la_end_cnv
_la_float_cnv: 	lodsb		; for floating number
		cmp	al, '0'
		jb	_la_dot_cnv
		cmp	al, '9'
		ja	_la_dot_cnv
		loop	_la_float_cnv
		mov	rax, TRUE
		jmp	_la_end_cnv
_la_dot_cnv:	cmp	al, '.'
		jne	_la_fail_cnv
		mov	rax, @dwDotExist
		or	rax, rax ; decimal point can only appear once
		jnz	_la_fail_cnv
		mov	@dwDotExist, TRUE
		loop	_la_float_cnv
		mov	rax, TRUE
		jmp	_la_end_cnv
_la_fail_cnv:	xor	rax, rax
_la_end_cnv:	ret
_CheckNumValid	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_CtrlHandler	proc	_dwCtrlType
		mov	eax, _dwCtrlType
		cmp	eax, CTRL_C_EVENT
		je	_la_right_ch
		cmp	eax, CTRL_BREAK_EVENT
		jne	_la_end_ch
_la_right_ch:	sub	rsp, 18h
		mov	rcx, hStdIn
		call	CloseHandle
		add	rsp, 18h
_la_end_ch:	mov	rax, TRUE
		ret
_CtrlHandler	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Read the loan method
_GetLoanMethod	proc
		sub	rsp, 18h		
		lea	rcx, szLoanMethodP
		call	lstrlen
        	PROMPT	offset szLoanMethodP, rax
		; Make sure that the input is 1, 2 or 3
		; The last is 0dh, 0ah, so qwBytesRead is 3
_la_loop1_glm:	mov   	rax, qwBytesRead
		cmp	rax, 3
		jne	_la_prompt_glm
		mov	al, szRead[0]
		cmp	al, '1'
		je	_la_right1_glm
		cmp	al, '2'
		je	_la_right2_glm
		cmp	al, '3'
		je	_la_right3_glm
_la_prompt_glm:	PROMPT	offset szLoanMethodQ, sizeof szLoanMethodQ
		jmp	_la_loop1_glm
_la_right1_glm:	lea	rcx, szLoanMethodA1
		call	lstrlen
		OUTPUT	offset szLoanMethodA1, rax
		mov	bLoanMethod, '1'
		jmp	_la_end_glm
_la_right2_glm:	lea	rcx, szLoanMethodA2
		call	lstrlen
		OUTPUT	offset szLoanMethodA2, rax
		mov	bLoanMethod, '2'
		jmp	_la_end_glm
_la_right3_glm:	lea	rcx, szLoanMethodA3
		call	lstrlen
		OUTPUT	offset szLoanMethodA3, rax
		mov	bLoanMethod, '3'
_la_end_glm:	add	rsp, 18h
		ret
_GetLoanMethod	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Get total loan
_GetTotalLoan	proc
		sub	rsp, 38h
		mov	al, bLoanMethod
		cmp	al, '1'
		je	_la_single_gtl
		cmp	al, '2'
		jne	_la_multi_gtl
_la_single_gtl:	PROMPT  offset szTotalLoanP1, sizeof szTotalLoanP1
_la_loop1_gtl:	mov	rdx, TRUE
		lea	rcx, szRead
		call	_CheckNumValid
		or	rax, rax
		jnz	_la_float1_gtl
_la_prompt1_gtl:PROMPT	offset szTotalLoanQ1, sizeof szTotalLoanQ1
		jmp	_la_loop1_gtl
_la_float1_gtl: lea	rcx, szRead
		call	vc_atof
		movq	r8TotalLoan, xmm0
		fld	r8TotalLoan
		; Make sure that the input is a number above 0
		ftst
		fstsw	ax
		sahf
		jle	_la_prompt1_gtl
		mov	r8, r8TotalLoan
		lea	rdx, szTotalLoanA1
		lea	rcx, szBuffer
		call	vc_sprintf
		lea	rcx, szBuffer
		call	lstrlen
		OUTPUT  offset szBuffer, rax
		finit
		fld	r8TotalLoan
		fimul	dwLoanTimes
		fstp	r8TotalLoan
		jmp	_la_end_gtl
_la_multi_gtl:	PROMPT  offset szTotalLoanP2, sizeof szTotalLoanP2
_la_loop2_gtl:	xor	rdx, rdx
		lea	rcx, szRead
		call	_CheckNumValid
		or	rax, rax
		jnz	_la_float2_gtl
_la_prompt2_gtl:PROMPT	offset szTotalLoanQ2, sizeof szTotalLoanQ2
		jmp	_la_loop2_gtl
_la_float2_gtl: lea	rcx, szRead
		call	vc_atof
		movq	r8TotalLoanBank, xmm0
		fld	r8TotalLoanBank
		ftst
		fstsw	ax
		sahf
		jle	_la_prompt2_gtl
		PROMPT  offset szTotalLoanP3, sizeof szTotalLoanP3
_la_loop3_gtl:	xor	rdx, rdx
		lea	rcx, szRead
		call	_CheckNumValid
		or	rax, rax
		jnz	_la_float3_gtl
_la_prompt3_gtl:PROMPT	offset szTotalLoanQ3, sizeof szTotalLoanQ3
		jmp	_la_loop3_gtl
_la_float3_gtl: lea	rcx, szRead
		call	vc_atof
		movq	r8TotalLoanFund, xmm0
		fld	r8TotalLoanFund
		ftst
		fstsw	ax
		sahf
		jle	_la_prompt3_gtl
		finit
		fld	r8TotalLoanBank
		fadd	r8TotalLoanFund
		fst	r8TotalLoan
		mov	rax, r8TotalLoan
		mov	qword ptr [rsp+20h], rax
		mov	r9, r8TotalLoanFund
		mov	r8, r8TotalLoanBank
		lea	rdx, szTotalLoanA2
		lea	rcx, szBuffer
		call	vc_sprintf
		lea	rcx, szBuffer
		call	lstrlen
		OUTPUT  offset szBuffer, rax
		finit
		fld	r8TotalLoanBank
		fimul	dwLoanTimes
		fstp	r8TotalLoanBank
		fld	r8TotalLoanFund
		fimul	dwLoanTimes
		fstp	r8TotalLoanFund
_la_end_gtl:	add	rsp, 38h
		ret
_GetTotalLoan	endp
; ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ; Read payment method
_GetPaymentMethod	proc
			sub	rsp,18h
			lea	rcx, szPayMethodP
			call	lstrlen
			PROMPT	offset szPayMethodP, rax
_la_loop_gpm:		mov	rax, qwBytesRead
			cmp	rax, 3
			jne	_la_prompt_gpm
			mov	al, szRead[0]
			; Make sure that the input is 1 or 2
			cmp	al, '1'
			je	_la_right1_gpm
			cmp	al, '2'
			je	_la_right2_gpm
_la_prompt_gpm:		PROMPT	offset szPayMethodQ, sizeof szPayMethodQ
			jmp	_la_loop_gpm
_la_right1_gpm:		lea	rcx, szPayMethodA1
			call	lstrlen
			OUTPUT	offset szPayMethodA1, rax
			mov	bPayMethod, '1'
			jmp	_la_end_gpm
_la_right2_gpm:		lea	rcx, szPayMethodA2
			call	lstrlen
			OUTPUT	offset szPayMethodA2, rax
			mov	bPayMethod, '2'
_la_end_gpm:		add	rsp, 18h
			ret
_GetPaymentMethod	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_GetPayMonths	proc
		local	@qwPayYears:qword

		sub	rsp, 28h
		PROMPT	offset szPayMonthP, sizeof szPayMonthP
_la_loop_gpm:	mov	rdx, TRUE
		lea	rcx, szRead
		call	_CheckNumValid
		or	rax, rax
		jnz	_la_int_gpm
_la_prompt_gpm:	PROMPT	offset szPayMonthQ, sizeof szPayMonthQ
		jmp	_la_loop_gpm
_la_int_gpm:	lea	rcx, szRead
		call	vc_atoi
		; Make sure that the input is a integer and between 1 and 30
		cmp	eax, 1
		jl	_la_prompt_gpm
		cmp	eax, 30
		jg	_la_prompt_gpm
		lea	rcx, szRead
		call	vc_atoi
		mov	@qwPayYears, rax
		mov	rdx, 12
		mul	rdx
		mov	qwPayMonths, rax
		mov	r9, qwPayMonths
		mov	r8, @qwPayYears
		lea	rdx, szPayMonthA
		lea	rcx, szBuffer
		call	wsprintf
		lea	rcx, szBuffer
		call	lstrlen
		OUTPUT  offset szBuffer, rax
		add	rsp, 28h
		ret
_GetPayMonths	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Read loan interest rate according to the loan method
_GetLoanRate	proc
		sub	rsp, 28h
		mov	al, bLoanMethod
		cmp	al, '1'
		jne	_la_fund_glr
		lea	rcx, szLoanRateP1
		call	lstrlen
		PROMPT	offset szLoanRateP1, rax
		; make sure that the input is a number above 0 below 100
_la_loop1_glr:	xor    rdx, rdx
		lea    rcx, szRead
		call   _CheckNumValid
		or     rax, rax
		jnz	_la_float1_glr
_la_prompt1_glr:PROMPT	offset szLoanRateQ1, sizeof szLoanRateQ1
		jmp	_la_loop1_glr
_la_float1_glr: lea	rcx, szRead
		call	vc_atof
		movq	r8LoanRate, xmm0
		fld	r8LoanRate
		ftst
		fstsw	ax
		sahf
		jle	_la_prompt1_glr ;signed
		ficom	dwRateTimes
		fstsw	ax
		sahf
		jae	_la_prompt1_glr ;unsigned
		mov	r8, r8LoanRate
		lea	rdx, szLoanRateA1
		lea	rcx, szBuffer
		call	vc_sprintf
		lea	rcx, szBuffer
		call	lstrlen
		OUTPUT  offset szBuffer, rax
		finit
		fld	r8LoanRate
		fidiv	dwRateTimes
		fst	r8LoanRate
		jmp	_la_end_glr
_la_fund_glr:	cmp	al, '2'
		jne	_la_combine_glr
		lea	rcx, szLoanRateP2
		call	lstrlen
		PROMPT	offset szLoanRateP2, rax
_la_loop2_glr:	xor	rdx, rdx
		lea	rcx, szRead
		call	_CheckNumValid
		or	rax, rax
		jnz	_la_float2_glr
_la_prompt2_glr:PROMPT	offset szLoanRateQ2, sizeof szLoanRateQ2
		jmp	_la_loop2_glr
_la_float2_glr: lea	rcx, szRead
		call	vc_atof
		movq	r8LoanRate, xmm0
		fld	r8LoanRate
		ftst
		fstsw	ax
		sahf
		jle	_la_prompt2_glr ;signed
		ficom	dwRateTimes
		fstsw	ax
		sahf
		jae	_la_prompt2_glr ;unsigned
		mov	r8, r8LoanRate
		lea	rdx, szLoanRateA2
		lea	rcx, szBuffer
		call	vc_sprintf
		lea	rcx, szBuffer
		call	lstrlen
		OUTPUT  offset szBuffer, rax
		finit
		fld	r8LoanRate
		fidiv	dwRateTimes
		fst	r8LoanRate
		jmp	_la_end_glr
_la_combine_glr:lea	rcx, szLoanRateP1
		call	lstrlen
		PROMPT	offset szLoanRateP1, rax
_la_loop3_glr:	xor	rdx, rdx
		lea	rcx, szRead
		call	_CheckNumValid
		or	rax, rax
		jnz	_la_float3_glr
_la_prompt3_glr:PROMPT	offset szLoanRateQ1, sizeof szLoanRateQ1
		jmp	_la_loop3_glr
_la_float3_glr: lea	rcx, szRead
		call	vc_atof
		movq	r8BankRate, xmm0
		fld	r8BankRate
		ftst
		fstsw	ax
		sahf
		jle	_la_prompt3_glr ;signed
		ficom	dwRateTimes
		fstsw	ax
		sahf
		jae	_la_prompt3_glr ;unsigned
		lea	rcx, szLoanRateP2
		call	lstrlen
		PROMPT	offset szLoanRateP2, rax
_la_loop4_glr:	xor	rdx, rdx
		lea	rcx, szRead
		call	_CheckNumValid
		or	rax, rax
		jnz	_la_float4_glr
_la_prompt4_glr:PROMPT	offset szLoanRateQ2, sizeof szLoanRateQ2
		jmp	_la_loop4_glr
_la_float4_glr: lea	rcx, szRead
		call	vc_atof
		movq	r8FundRate, xmm0
		fld	r8FundRate
		ftst
		fstsw	ax
		sahf
		jle	_la_prompt4_glr ;signed
		ficom	dwRateTimes
		fstsw	ax
		sahf
		jae	_la_prompt4_glr ;unsigned
		mov	r9, r8FundRate
		mov	r8, r8BankRate
		lea	rdx, szLoanRateA3
		lea	rcx, szBuffer
		call	vc_sprintf
		lea	rcx, szBuffer
		call	lstrlen
		OUTPUT  offset szBuffer, rax
		finit
		fld	r8BankRate
		fidiv	dwRateTimes
		fstp	r8BankRate
		fld	r8FundRate
		fidiv	dwRateTimes
		fst	r8FundRate
_la_end_glr:	add	rsp, 28h		
		ret
_GetLoanRate	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Get payment every month by the way of average captial plus interest
_AveCapPlus	proc	_r8TotalLoan:Real8, _r8InterestRate:Real8
		local	@r8MonthLoan:Real8

		mov	rcx, qwPayMonths
		dec	rcx
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
		fstp	@r8MonthLoan
		movq	xmm0, @r8MonthLoan
		ret
_AveCapPlus	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Get payment of uMonth month by the way of average captial
_AveCap	proc	_r8TotalLoan:Real8, _r8InterestRate:Real8, _qwMonth:qword
	local	@r8MonthLoan:Real8

	mov	rax, qwPayMonths
	sub	rax, _qwMonth
	mov	_qwMonth, rax
	finit
	fld	_r8InterestRate
	fimul 	dword ptr _qwMonth
	fld1
	fadd
	fld	_r8TotalLoan
	fidiv	dword ptr qwPayMonths
	fmul
	fstp	@r8MonthLoan
	movq	xmm0, @r8MonthLoan
	ret
_AveCap	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
main	proc
	local	@r8MonthLoan:Real8
	local	@r8TotalPay:Real8, @r8TotalInterest:Real8

	sub	rsp, 38h	
	mov	rcx, STD_INPUT_HANDLE
        call	GetStdHandle
        mov     hStdIn, rax
	mov	rcx, STD_OUTPUT_HANDLE
        call	GetStdHandle
        mov     hStdOut, rax
	lea	rcx, szTitle
	call	SetConsoleTitle
	mov	rdx, ENABLE_LINE_INPUT or ENABLE_ECHO_INPUT\
		     or ENABLE_PROCESSED_INPUT
	mov	rcx, hStdIn
	call	SetConsoleMode
	mov	rdx, TRUE
	lea	rcx, _CtrlHandler
	call	SetConsoleCtrlHandler
	call	_GetLoanMethod
	call	_GetTotalLoan
	call	_GetPaymentMethod
	call	_GetPayMonths
	call	_GetLoanRate
	mov	al, bPayMethod
	cmp	al, '1'
	jne	_la_method2_m
	mov	al, bLoanMethod
	cmp	al, '1'
	je	_la_method1_single_m
	cmp	al, '2'
	jne	_la_method1_multi_m
_la_method1_single_m:
	push	r8LoanRate
	push	r8TotalLoan
	call	_AveCapPlus
	add	rsp, 10h
	movq	@r8MonthLoan, xmm0
	finit
	fld	@r8MonthLoan
	fimul	dword ptr qwPayMonths
	fidiv	dwLoanTimes
	fst	@r8TotalPay
	fld	r8TotalLoan
	fidiv	dwLoanTimes
	fst	r8TotalLoan
	fsub
	fst	@r8TotalInterest
	jmp	_la_method1_show_m
_la_method1_multi_m:
	; bank payment every month
	push	r8BankRate
	push	r8TotalLoanBank
	call	_AveCapPlus
	add	rsp, 10h
	movq	@r8MonthLoan, xmm0
	; provident fund payment every month
	push	r8FundRate
	push	r8TotalLoanFund
	call	_AveCapPlus
	add	rsp, 10h
	addsd	xmm0, @r8MonthLoan
	movq	@r8MonthLoan, xmm0
	finit
	fld	@r8MonthLoan
	fimul	dword ptr qwPayMonths
	fidiv	dwLoanTimes
	fst	@r8TotalPay
	fld	r8TotalLoanBank
	fidiv	dwLoanTimes
	fst	r8TotalLoanBank
	fld	r8TotalLoanFund
	fidiv	dwLoanTimes
	fst	r8TotalLoanFund
	fadd
	fst	r8TotalLoan
	fsub
	fst	@r8TotalInterest
_la_method1_show_m:
	mov	rax, r8TotalLoan
	mov	qword ptr [rsp+28h], rax
	mov	rax, @r8TotalInterest
	mov	qword ptr [rsp+20h], rax
	mov	r9, @r8TotalPay
	mov	r8, @r8MonthLoan
	lea	rdx, szFinalA1
	lea	rcx, szBuffer
	call	vc_sprintf
	lea	rcx, szBuffer
	call	lstrlen
	OUTPUT  offset szBuffer, rax
	jmp	_la_end_m
_la_method2_m:
	mov	@r8TotalPay, 0
	mov	rcx, qwPayMonths
	mov	al, bLoanMethod
	cmp	al, '1'
	je	_la_method2_single_m
	cmp	al, '2'
	jne	_la_method2_multi_m
_la_method2_single_m:
	finit
	fld	r8LoanRate
	fidiv	dwMonthsAYear
	fstp	r8LoanRate	
	xor	r8, r8
@@:	push	r8
	push	r8LoanRate
	push	r8TotalLoan
	call	_AveCap
	add	rsp, 18h
	movq	@r8MonthLoan, xmm0
	fld	@r8MonthLoan
	fadd	@r8TotalPay
	fst	@r8TotalPay
	inc	r8
	loop	@B
	fidiv	dwLoanTimes
	fst	@r8TotalPay
	fld	r8TotalLoan
	fidiv	dwLoanTimes
	fsub
	fstp	@r8TotalInterest
	jmp	_la_method2_show_m
_la_method2_multi_m:
	finit
	fld	r8BankRate
	fidiv	dwMonthsAYear
	fstp	r8BankRate
	fld	r8FundRate
	fidiv	dwMonthsAYear
	fstp	r8FundRate
	xor	r8, r8
@@:	push	r8
	push	r8BankRate
	push	r8TotalLoanBank
	call	_AveCap
	add	rsp, 18h
	movq	@r8MonthLoan, xmm0
	push	r8
	push	r8FundRate
	push	r8TotalLoanFund
	call	_AveCap
	add	rsp, 18h
	addsd	xmm0, @r8MonthLoan
	movq	@r8MonthLoan, xmm0
	fld	@r8MonthLoan
	fadd	@r8TotalPay
	fst	@r8TotalPay
	inc	r8
	loop	@B
	fidiv	dwLoanTimes
	fst	@r8TotalPay
	fld	r8TotalLoanBank
	fadd	r8TotalLoanFund
	fidiv	dwLoanTimes
	fsub
	fstp	@r8TotalInterest
_la_method2_show_m:
	mov	rax, r8TotalLoan
	mov	[rsp+20h], rax
	mov	r9, @r8TotalInterest
	mov	r8, @r8TotalPay
	lea	rdx, szFinalA2
	lea	rcx, szBuffer
	call	vc_sprintf
	lea	rcx, szBuffer
	call	lstrlen
	OUTPUT  offset szBuffer, rax
_la_end_m:
	lea	rcx, szPause
	call	vc_system
	mov	rcx, NULL
        call	ExitProcess
	ret
main	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        end
