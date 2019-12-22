"""Calculate house loan script verson 1."""
import re
import time


def GetLoanMethod():
    """Get loan methon, 1 for commercial loan, 2 for provident fund loan and 3 for syndicated loan."""
    loanMethod = input("请选择您的贷款方式\n\t1、商业贷款\n\t2、公积金贷款\n\t3、组合贷款\n请输入对应序号（1-3）：")
    # Make sure that the input is between 1 and 3
    reMatch = re.match('[1-3]$', loanMethod)
    while reMatch is None:
        loanMethod = input("请输入有效对应序号（1-3）：")
        reMatch = re.match('[1-3]$', loanMethod)

    if loanMethod == '1':
        print("您选择的贷款方式为商业贷款\n"+">"*15)
    elif loanMethod == '2':
        print("您选择的贷款方式为公积金贷款\n"+">"*15)
    else:
        print("您选择的贷款方式为组合贷款\n"+">"*15)

    return int(loanMethod)


def GetTotalLoan(loan_method):
    """Get total loan accroding to method."""
    if loan_method == 1 or loan_method == 2:
        totalLoan = input("请输入您的贷款总额（万）：")
        reMatch = re.match(r'\d+\.?\d*$', totalLoan)
        while True:
            if reMatch is not None:
                totalLoan = float(totalLoan)
                if totalLoan > 0:
                    break

            totalLoan = input("请输入有效贷款总额（万）：")
            reMatch = re.match(r'\d+\.?\d*$', totalLoan)

        print("您的总贷款金额为{}万元\n".format(totalLoan)+">"*15)
        totalLoan *= 10000

        return (totalLoan, 0)
    else:
        commercialLoan = input("请输入您的商业贷款总额（万）：")
        reMatch = re.match(r'\d+\.?\d*$', commercialLoan)
        while True:
            if reMatch is not None:
                commercialLoan = float(commercialLoan)
                if commercialLoan > 0:
                    break

            commercialLoan = input("请输入有效商业贷款总额（万）：")
            reMatch = re.match(r'\d+\.?\d*$', commercialLoan)

        providentFundLoan = input("请输入您的公积金贷款总额（万）：")
        reMatch = re.match(r'\d+\.?\d*$', providentFundLoan)
        while True:
            if reMatch is not None:
                providentFundLoan = float(providentFundLoan)
                if providentFundLoan > 0:
                    break
            providentFundLoan = input("请输入有效公积金贷款总额（万）：")
            reMatch = re.match(r'\d+\.?\d*$', providentFundLoan)

        print("您的商业贷款金额为{}万元\n您的公积金贷款金额为{}万元\n总贷款金额为{}万元\n".format(commercialLoan, providentFundLoan, commercialLoan+providentFundLoan)+">"*15)

        commercialLoan *= 10000
        providentFundLoan *= 10000

        return (commercialLoan, providentFundLoan)


def GetPaymentMethod():
    """Get payment method."""
    paymentMethod = input("请选择您的还款方式\n\t1、等额本息（每月等额还款）\n\t2、等额本金（每月递减还款）\n请输入对应序号（1-2）：")
    # Make sure that the input is between 1 and 2
    reMatch = re.match('[12]$', paymentMethod)
    while reMatch is None:
        paymentMethod = input("请输入有效对应序号（1-2）：")
        reMatch = re.match('[12]$', paymentMethod)

    if paymentMethod == '1':
        print("您选择的还款方式为等额本息\n"+">"*15)
    else:
        print("您选择的还款方式为等额本金\n"+">"*15)

    return int(paymentMethod)


def GetPaymentMonths():
    """Get payment months."""
    paymentYears = input("请输入还款年数（1-30）：")
    # Make sure that the input is between 1 and 30
    reMatch = re.match(r'[1-9]$|[12]\d$|30$', paymentYears)
    while reMatch is None:
        paymentYears = input("请输入有效还款年数（1-30）：")
        reMatch = re.match(r'[1-9]$|[12]\d$|30$', paymentYears)

    paymentMonths = int(paymentYears)*12
    print("您的还款年数为{}年，共{}个月\n".format(paymentYears, paymentMonths)+">"*15)
    return paymentMonths


def GetStartDate():
    """Get payment start date."""
    startDate = input("请输入首次还款日期（格式为yyyy-mm-dd，如2019年6月30日为2019-6-30）：")
    # Make sure that the input date is correct
    while True:
        try:
            structDate = time.strptime(startDate, "%Y-%m-%d")
            break
        except ValueError:
            startDate = input("请输入有效首次还款日期（格式为yyyy-mm-dd）：")

    print("您的首次还款日期为{}年{}月{}日\n".format(structDate[0], structDate[1], structDate[2])+">"*15)
    return structDate


def GetLoanInterestRate(loan_method):
    """Get loan interest rate according to loan method."""
    if loan_method == 1:
        loanInterestRate = input("请输入贷款利率，截止2019年末，银行贷款利率如下\n\t7折（3.43%）\n\t8折（3.92%）\n\t8.3折（4.067%）\n\t8.5折（4.165%）\n\t8.8折（4.312%）\n\t9折（4.41%）\n\t9.5折（4.655%）\n\t基准利率（4.9%）\n\t1.05倍（5.145%）\n\t1.1倍（5.39%）\n\t1.15倍（5.635%）\n\t1.2倍（5.88%）\n\t1.25倍（6.125%）\n\t1.3倍（6.37%）\n\t1.35倍（6.615%）\n\t1.4倍（6.86%）\n请输入具体数值（%）：")
        reMatch = re.match(r'\d+\.?\d*$', loanInterestRate)
        while True:
            if reMatch is not None:
                loanInterestRate = float(loanInterestRate)
                if loanInterestRate > 0 and loanInterestRate < 100:
                    break

            loanInterestRate = input("请输入有效贷款利率：")
            reMatch = re.match(r'\d+\.?\d*$', loanInterestRate)

        print("您的贷款利率为{}%\n".format(loanInterestRate)+">"*15)
        loanInterestRate /= 100

        return (loanInterestRate, 0)
    elif loan_method == 2:
        loanInterestRate = input("请输入公积金贷款利率，截止2019年末，公积金贷款利率如下\n\t基准利率（3.25%）\n\t1.1倍（3.575%）\n\t1.2倍（3.9%）\n请输入具体数值（%）：")
        reMatch = re.match(r'\d+\.?\d*$', loanInterestRate)
        while True:
            if reMatch is not None:
                loanInterestRate = float(loanInterestRate)
                if loanInterestRate > 0 and loanInterestRate < 100:
                    break

            loanInterestRate = input("请输入有效公积金贷款利率：")
            reMatch = re.match(r'\d+\.?\d*$', loanInterestRate)

        print("您的公积金贷款利率为{}%\n".format(loanInterestRate)+">"*15)
        loanInterestRate /= 100

        return (loanInterestRate, 0)
    else:
        bankInterestRate = input("请输入银行贷款利率，截止2019年末，银行贷款利率如下\n\t7折（3.43%）\n\t8折（3.92%）\n\t8.3折（4.067%）\n\t8.5折（4.165%）\n\t8.8折（4.312%）\n\t9折（4.41%）\n\t9.5折（4.655%）\n\t基准利率（4.9%）\n\t1.05倍（5.145%）\n\t1.1倍（5.39%）\n\t1.15倍（5.635%）\n\t1.2倍（5.88%）\n\t1.25倍（6.125%）\n\t1.3倍（6.37%）\n\t1.35倍（6.615%）\n\t1.4倍（6.86%）\n请输入具体数值（%）：")
        reMatch = re.match(r'\d+\.?\d*$', bankInterestRate)
        while True:
            if reMatch is not None:
                bankInterestRate = float(bankInterestRate)
                if bankInterestRate > 0 and bankInterestRate < 100:
                    break

            bankInterestRate = input("请输入有效贷款利率：")
            reMatch = re.match(r'\d+\.?\d*$', bankInterestRate)

        fundInterestRate = input("请输入公积金贷款利率，截止2019年末，公积金贷款利率如下\n\t基准利率（3.25%）\n\t1.1倍（3.575%）\n\t1.2倍（3.9%）\n请输入具体数值（%）：")
        reMatch = re.match(r'\d+\.?\d*$', fundInterestRate)
        while True:
            if reMatch is not None:
                fundInterestRate = float(fundInterestRate)
                if fundInterestRate > 0 and fundInterestRate < 100:
                    break

            fundInterestRate = input("请输入有效公积金贷款利率：")
            reMatch = re.match(r'\d+\.?\d*$', fundInterestRate)

        print("您的银行贷款利率为{}%，公积金贷款利率为{}%\n".format(bankInterestRate, fundInterestRate)+">"*15)
        bankInterestRate /= 100
        fundInterestRate /= 100

        return (bankInterestRate, fundInterestRate)


def AverageCapitalPlusInterest(total_loan, months, interest_rate, start_date):
    """Calculate every month payment for average capital plus interest."""
    m_interest_rate = interest_rate/12  # month rate
    m_loan = total_loan*m_interest_rate*(1+m_interest_rate)**months/((1+m_interest_rate)**months-1)
    return m_loan


def AverageCapital(total_loan, months, interest_rate, start_date, month):
    """Calcuate nth month payment for average capital."""
    m_interest_rate = interest_rate/12  # month rate
    m_loan = total_loan/months*(1+(months-month)*m_interest_rate)
    return m_loan


loanMethod = GetLoanMethod()
totalLoan = GetTotalLoan(loanMethod)
paymentMethod = GetPaymentMethod()
paymentMonths = GetPaymentMonths()
startDate = GetStartDate()
loanInterestRate = GetLoanInterestRate(loanMethod)

if paymentMethod == 1:          # for average capital plus interest method
    if loanMethod == 1 or loanMethod == 2:  # for commercial or provident fund loan method
        monthPayment = AverageCapitalPlusInterest(totalLoan[0], paymentMonths, loanInterestRate[0], startDate)
        totalPayment = monthPayment*paymentMonths
        totalInterest = totalPayment - totalLoan[0]
        print("每月需还款{:.2f}元\n\t还款总额{:.6f}万\n\t支付利息{:.6f}万\n\t贷款总额{:.6f}万".format(monthPayment, totalPayment/10000, totalInterest/10000, totalLoan[0]/10000))
    else:                       # for syndicated loan method
        bankMonthPayment = AverageCapitalPlusInterest(totalLoan[0], paymentMonths, loanInterestRate[0], startDate)
        fundMonthPayment = AverageCapitalPlusInterest(totalLoan[1], paymentMonths, loanInterestRate[1], startDate)
        totalPayment = (bankMonthPayment+fundMonthPayment)*paymentMonths
        totalInterest = totalPayment - (totalLoan[0]+totalLoan[1])
        print("每月需还款{:.2f}元\n\t还款总额{:.6f}万\n\t支付利息{:.6f}万\n\t贷款总额{:.6f}万".format((bankMonthPayment+fundMonthPayment), totalPayment/10000, totalInterest/10000, (totalLoan[0]+totalLoan[1])/10000))
else:                           # for average capital method
    if loanMethod == 1 or loanMethod == 2:  # for commercial or provident fund loan method
        totalPayment = 0
        for m in range(0, paymentMonths):
            monthPayment = AverageCapital(totalLoan[0], paymentMonths, loanInterestRate[0], startDate, m)
            totalPayment += monthPayment

        totalInterest = totalPayment - totalLoan[0]
        print("还款总额{:.6f}万\n\t支付利息{:.6f}万\n\t贷款总额{:.6f}万".format(totalPayment/10000, totalInterest/10000, totalLoan[0]/10000))
    else:                       # for syndicated loan method
        totalPayment = 0
        for m in range(0, paymentMonths):
            bankMonthPayment = AverageCapital(totalLoan[0], paymentMonths, loanInterestRate[0], startDate, m)
            fundMonthPayment = AverageCapital(totalLoan[1], paymentMonths, loanInterestRate[1], startDate, m)
            totalPayment += (bankMonthPayment+fundMonthPayment)

        totalInterest = totalPayment - (totalLoan[0]+totalLoan[1])
        print("还款总额{:.6f}万\n\t支付利息{:.6f}万\n\t贷款总额{:.6f}万".format(totalPayment/10000, totalInterest/10000, (totalLoan[0]+totalLoan[1])/10000))
