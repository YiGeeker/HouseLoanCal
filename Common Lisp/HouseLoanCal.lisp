(defmacro prompt-read (prompt &rest plus)
  "Print prompt and read input."
  `(progn
     (format *query-io* ,prompt ,@plus)
     (force-output *query-io*)
     (read-line *query-io*)))

(defun check-number-valid (input integer-p)
  "Check the input is a valid integer or floating number."
  (if (or (string= input ".") (string= input ""))
      ;; exclude null string and a dot which will cause "dot context error"
      (return-from check-number-valid nil)
      (if integer-p
	  ;; for integer
	  (dotimes (pos (length input))
	    (if (not (digit-char-p (char input pos)))
		(return-from check-number-valid nil)))
	  ;; for floating number
	  (let (dot-contain)
	    (dotimes (pos (length input))
	      (if (not (digit-char-p (char input pos)))
		  (if (or dot-contain (char/= (char input pos) #\.))
		      (return-from check-number-valid nil)
		      (setf dot-contain t))))))) ;decimal point can only appear once
  (return-from check-number-valid t))

(defun get-loan-method ()
  "Get loan methon, 1 for commercial loan, 2 for provident fund loan and 3 for syndicated loan."
  (let ((loan-method (prompt-read "请选择您的贷款方式~%~t1、商业贷款~%~t2、公积金贷款~%~t3、组合贷款~%请输入对应序号（1-3）：")))
    ;; Make sure that the input is 1, 2 or 3
    (do ()
	((or (string= loan-method "1") (string= loan-method "2") (string= loan-method "3")))
      (setf loan-method (prompt-read "请输入有效对应序号（1-3）：")))
    (cond
    ((string= loan-method "1") (format *query-io* "您选择的贷款方式为商业贷款~%>>>>>>>>>>>>>>>~%"))
    ((string= loan-method "2") (format *query-io* "您选择的贷款方式为公积金贷款~%>>>>>>>>>>>>>>>~%"))
    ((string= loan-method "3") (format *query-io* "您选择的贷款方式为组合贷款~%>>>>>>>>>>>>>>>~%")))
    (parse-integer loan-method)))

(defun get-total-loan (loan-method)
  "Get total loan accroding to method."
  (if (or (eql loan-method 1) (eql loan-method 2))
      (let ((total-loan (prompt-read "请输入您的贷款总额（万）：")))
	;; Make sure that the input is a real number above 0
	(do ()
	    ((when (check-number-valid total-loan nil)
	       (setf total-loan (read-from-string total-loan))
	       (if (> total-loan 0) t)))
	  (setf total-loan (prompt-read "请输入有效贷款总额（万）：")))
	(format *query-io* "您的总贷款金额为~a万元~%>>>>>>>>>>>>>>>~%" total-loan)
	(list (* total-loan 1e4) 0))
      (let ((commercial-loan (prompt-read "请输入您的商业贷款总额（万）：")) provident-fund-loan)
	(do ()
	    ((when (check-number-valid commercial-loan nil)
	       (setf commercial-loan (read-from-string commercial-loan))
	       (if (> commercial-loan 0) t)))
	  (setf commercial-loan (prompt-read "请输入有效商业贷款总额（万）：")))
	(setf provident-fund-loan (prompt-read "请输入您的公积金贷款总额（万）："))
	(do ()
	    ((when (check-number-valid provident-fund-loan nil)
	       (setf provident-fund-loan (read-from-string provident-fund-loan))
	       (if (> provident-fund-loan 0) t)))
	  (setf provident-fund-loan (prompt-read "请输入有效公积金贷款总额（万）：")))
	(format *query-io* "您的商业贷款金额为~a万元~%您的公积金贷款金额为~a万元~%总贷款金额为~a万元\~%>>>>>>>>>>>>>>>~%" commercial-loan provident-fund-loan (+ commercial-loan provident-fund-loan))
	(list (* commercial-loan 1e4) (* provident-fund-loan 1e4)))))

(defun get-payment-method ()
  "Get payment method."
  (let ((payment-method (prompt-read "请选择您的还款方式~%~t1、等额本息（每月等额还款）~%~t2、等额本金（每月递减还款）~%请输入对应序号（1-2）：")))
    ;; Make sure that the input is  1 or 2
    (do ()
	((or (string= payment-method "1") (string= payment-method "2")))
      (setf payment-method (prompt-read "请输入有效对应序号（1-2）：")))
    (if (string= payment-method "1")
	(format t "您选择的还款方式为等额本息~%>>>>>>>>>>>>>>>~%")
	(format t "您选择的还款方式为等额本金~%>>>>>>>>>>>>>>>~%"))
    (parse-integer payment-method)))

(defun get-payment-months ()
  "Get payment months."
  (let ((payment-years (prompt-read "请输入还款年数（1-30）：")))
    ;; Make sure that the input is between 1 and 30
    (do ()
	((when (check-number-valid payment-years t)
	  (setf payment-years (read-from-string payment-years))
	  (if (and (>= payment-years 1) (<= payment-years 30)) t)))
      (setf payment-years (prompt-read "请输入有效还款年数（1-30）：")))
    (format *query-io* "您的还款年数为~a年，共~a个月~%>>>>>>>>>>>>>>>~%" payment-years (* payment-years 12))
    (* payment-years 12)))

(defun get-loan-interest-rate (loan-method)
  "Get loan interest rate according to loan method."
  (cond
    ((eql loan-method 1)
     (let ((bank-interest-rate (prompt-read "请输入贷款利率，截止2019年末，银行贷款利率如下~%~t7折（3.43%）~%~t8折（3.92%）~%~t8.3折（4.067%）~%~t8.5折（4.165%）~%~t8.8折（4.312%）~%~t9折（4.41%）~%~t9.5折（4.655%）~%~t基准利率（4.9%）~%~t1.05倍（5.145%）~%~t1.1倍（5.39%）~%~t1.15倍（5.635%）~%~t1.2倍（5.88%）~%~t1.25倍（6.125%）~%~t1.3倍（6.37%）~%~t1.35倍（6.615%）~%~t1.4倍（6.86%）~%请输入具体数值（%）：")))
       ;; Make sure that the input is a real number above 0 below 100
       (do ()
	   ((when (check-number-valid bank-interest-rate nil)
	      (setf bank-interest-rate (read-from-string bank-interest-rate))
	      (if (and (> bank-interest-rate 0) (< bank-interest-rate 100)) t)))
	 (setf bank-interest-rate (prompt-read "请输入有效贷款利率：")))
       (format *query-io* "您的贷款利率为~a%~%>>>>>>>>>>>>>>>~%" bank-interest-rate)
       (list (/ bank-interest-rate 100) 0)))
    ((eql loan-method 2)
     (let ((provident-fund-interest-rate (prompt-read "请输入公积金贷款利率，截止2019年末，公积金贷款利率如下~%~t基准利率（3.25%）~%~t1.1倍（3.575%）~%~t1.2倍（3.9%）~%请输入具体数值（%）：")))
       (do ()
	   ((when (check-number-valid provident-fund-interest-rate nil)
	      (setf provident-fund-interest-rate (read-from-string provident-fund-interest-rate))
	      (if (and (> provident-fund-interest-rate 0) (< provident-fund-interest-rate 100)) t)))
	 (setf provident-fund-interest-rate (prompt-read "请输入有效公积金贷款利率：")))
       (format *query-io* "您的公积金贷款利率为~a%~%>>>>>>>>>>>>>>>~%" provident-fund-interest-rate)
       (list (/ provident-fund-interest-rate 100) 0)))
    ((eql loan-method 3)
     (let ((bank-interest-rate (prompt-read "请输入贷款利率，截止2019年末，银行贷款利率如下~%~t7折（3.43%）~%~t8折（3.92%）~%~t8.3折（4.067%）~%~t8.5折（4.165%）~%~t8.8折（4.312%）~%~t9折（4.41%）~%~t9.5折（4.655%）~%~t基准利率（4.9%）~%~t1.05倍（5.145%）~%~t1.1倍（5.39%）~%~t1.15倍（5.635%）~%~t1.2倍（5.88%）~%~t1.25倍（6.125%）~%~t1.3倍（6.37%）~%~t1.35倍（6.615%）~%~t1.4倍（6.86%）~%请输入具体数值（%）："))
	   provident-fund-interest-rate)
       (do ()
	   ((when (check-number-valid bank-interest-rate nil)
	      (setf bank-interest-rate (read-from-string bank-interest-rate))
	      (if (and (> bank-interest-rate 0) (< bank-interest-rate 100)) t)))
	 (setf bank-interest-rate (prompt-read "请输入有效贷款利率：")))
       (setf provident-fund-interest-rate (prompt-read "请输入公积金贷款利率，截止2019年末，公积金贷款利率如下~%~t基准利率（3.25%）~%~t1.1倍（3.575%）~%~t1.2倍（3.9%）~%请输入具体数值（%）："))
       (do ()
	   ((when (check-number-valid provident-fund-interest-rate nil)
	      (setf provident-fund-interest-rate (read-from-string provident-fund-interest-rate))
	      (if (and (> provident-fund-interest-rate 0) (< provident-fund-interest-rate 100)) t)))
	 (setf provident-fund-interest-rate (prompt-read "请输入有效公积金贷款利率：")))
       (format *query-io* "您的银行贷款利率为~a%，公积金贷款利率为~a%~%>>>>>>>>>>>>>>>~%" bank-interest-rate provident-fund-interest-rate)
       (list (/ bank-interest-rate 100) (/ provident-fund-interest-rate 100))))))

(defun average-capital-plus-interest (total-loan months interest-rate)
  "Calculate every month payment for average capital plus interest."
  (let ((month-interest-rate (/ interest-rate 12))) ;month rate
    (/ (* total-loan (* month-interest-rate (expt (1+ month-interest-rate) months))) (1- (expt (1+ month-interest-rate) months)))))

(defun average-capital (total-loan months interest-rate month)
  "Calcuate nth month payment for average capital."
  (let ((month-interest-rate (/ interest-rate 12))) ;month rate
    (* (/ total-loan months) (1+ (* (- months month) month-interest-rate)))))

(let (loan-method total-loan payment-method payment-months interest-rate)
  (setf loan-method (get-loan-method))
  (setf total-loan (get-total-loan loan-method))
  (setf payment-method (get-payment-method))
  (setf payment-months (get-payment-months))
  (setf interest-rate (get-loan-interest-rate loan-method))

  (if (eql payment-method 1)
      ;; for average capital plus interest method
      (if (or (eql loan-method 1) (eql loan-method 2))
	  ;; for commercial or provident fund loan method
	  (let* ((month-payment (average-capital-plus-interest (car total-loan) payment-months (car interest-rate)))
		 (total-payment (* month-payment payment-months))
		 (total-interest (- total-payment (car total-loan))))
	    (format *query-io* "每月需还款~2$元~%~t还款总额~6$万~%~t支付利息~6$万~%~t贷款总额~a万" month-payment (/ total-payment 1e4) (/ total-interest 1e4) (/ (car total-loan) 1e4)))
	  ;; for syndicated loan method
	  (let* ((bank-month-payment (average-capital-plus-interest (car total-loan) payment-months (car interest-rate)))
		 (fund-month-payment (average-capital-plus-interest (car (cdr total-loan)) payment-months (car (cdr interest-rate))))
		 (total-payment (* (+ bank-month-payment fund-month-payment) payment-months))
		 (total-interest (- total-payment (+ (car total-loan) (car (cdr total-loan))))))
	    (format *query-io* "每月需还款~2$元~%~t还款总额~6$万~%~t支付利息~6$万~%~t贷款总额~a万" (+ bank-month-payment fund-month-payment) (/ total-payment 1e4) (/ total-interest 1e4) (/ (+ (car total-loan) (car (cdr total-loan))) 1e4))))
      ;; for average capital method
      (if (or (eql loan-method 1) (eql loan-method 2))
	  ;; for commercial or provident fund loan method
	  (let (month-payment (total-payment 0) total-interest)
	    (dotimes (month payment-months)
	      (setf month-payment (average-capital (car total-loan) payment-months (car interest-rate) month))
	      (setf total-payment (+ total-payment month-payment)))
	    (setf total-interest (- total-payment (car total-loan)))
	    (format *query-io* "还款总额~6$万~%支付利息~6$万~%贷款总额~a万" (/ total-payment 1e4) (/ total-interest 1e4) (/ (car total-loan) 1e4)))
	  ;; for syndicated loan method
	  (let (bank-month-payment fund-month-payment (total-payment 0) total-interest)
	    (dotimes (month payment-months)
	      (setf bank-month-payment (average-capital (car total-loan) payment-months (car interest-rate) month))
	      (setf fund-month-payment (average-capital (car (cdr total-loan)) payment-months (car (cdr interest-rate)) month))
	      (setf total-payment (+ total-payment bank-month-payment fund-month-payment)))
	    (setf total-interest (- total-payment (car total-loan) (car (cdr total-loan))))
	    (format *query-io* "还款总额~6$万~%支付利息~6$万~%贷款总额~a万" (/ total-payment 1e4) (/ total-interest 1e4) (+ (/ (car total-loan) 1e4) (/ (car (cdr total-loan)) 1e4)))))))
