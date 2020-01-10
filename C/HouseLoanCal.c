#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Get input as string to prevent overstep the boundary */
int GetInputAsString(char *lpszInput, unsigned int uSize) {
	int iResult;
	char szFormat[5] = "%";
	char szSize[3];

	itoa(uSize - 1, szSize, 10);
	strcat(szFormat, szSize);
	strcat(szFormat, "s"); /* Get the format string "%ns", n indicates the
								number of characters to read */
	iResult = scanf(szFormat, lpszInput);
	fflush(stdin);

	return iResult;
}

/* Check the input is a valid integer or floating number */
bool CheckNumValid(char *lpszInputstring, bool bIsInt) {
	unsigned int uLength = strlen(lpszInputstring);
	unsigned int i;
	bool bDotExist = false;

	if (bIsInt) { /* for integer */
		for (i = 0; i < uLength; i++) {
			if (lpszInputstring[i] < '0' || lpszInputstring[i] > '9') return false;
		}
	} else { /* for floating number */
		for (i = 0; i < uLength; i++) {
			if (lpszInputstring[i] < '0' || lpszInputstring[i] > '9') {
				if (!bDotExist && lpszInputstring[i] == '.') /* decimal point can only appear once */
					bDotExist = true;
				else return false;
			}
		}
	}

	return true;
}

/* Read the loan method */
char GetLoanMethod() {
	char szLoanMethod[3];

	printf("请选择您的贷款方式\n\t1、商业贷款\n\t2、公积金贷款\n\t3、组合贷款\n请输入对应序号（1-3）：");
	GetInputAsString(szLoanMethod, sizeof szLoanMethod);

	/* Make sure that the input is 1, 2 or 3 */
	while (1) {
		if (strlen(szLoanMethod) == 1) {
			if (szLoanMethod[0] >= '1' && szLoanMethod[0] <= '3') break;
		}

		printf("请输入有效对应序号（1-3）：");
		GetInputAsString(szLoanMethod, sizeof szLoanMethod);
		fflush(stdin);
	}

	if (szLoanMethod[0] == '1')
		printf("您选择的贷款方式为商业贷款\n>>>>>>>>>>>>>>>\n");
	else if (szLoanMethod[0] == '2')
		printf("您选择的贷款方式为公积金贷款\n>>>>>>>>>>>>>>>\n");
	else
		printf("您选择的贷款方式为组合贷款\n>>>>>>>>>>>>>>>\n");

	return szLoanMethod[0];
}

/* Get total loan according to loan method */
double *GetTotalLoan(char loanMethod) {
	char szTotalLoan[16];
	static double fTotalLoan[2];

	if (loanMethod == '1' || loanMethod == '2') {
		printf("请输入您的贷款总额（万）：");
		GetInputAsString(szTotalLoan, sizeof szTotalLoan);

		/* Make sure that the input is a number above 0 */
		while (1) {
			if (CheckNumValid(szTotalLoan, false)) {
				fTotalLoan[0] = atof(szTotalLoan);
				if (fTotalLoan[0] > 0) break;
			}

			printf("请输入有效贷款总额（万）：");
			GetInputAsString(szTotalLoan, sizeof szTotalLoan);
		}

		printf("您的总贷款金额为%f万元\n>>>>>>>>>>>>>>>\n", fTotalLoan[0]);
		fTotalLoan[0] = fTotalLoan[0] * 10000;
		fTotalLoan[1] = 0;
	} else {
		printf("请输入您的商业贷款总额（万）：");
		GetInputAsString(szTotalLoan, sizeof szTotalLoan);

		while (1) {
			if (CheckNumValid(szTotalLoan, sizeof szTotalLoan)) {
				fTotalLoan[0] = atof(szTotalLoan);
				if (fTotalLoan[0] > 0) break;
			}

			printf("请输入有效商业贷款总额（万）：");
			GetInputAsString(szTotalLoan, sizeof szTotalLoan);
		}

		printf("请输入您的公积金贷款总额（万）：");
		GetInputAsString(szTotalLoan, sizeof szTotalLoan);

		while (1) {
			if (CheckNumValid(szTotalLoan, sizeof szTotalLoan)) {
				fTotalLoan[1] = atof(szTotalLoan);
				if (fTotalLoan[1] > 0) break;
			}

			printf("请输入有效公积金贷款总额（万）：");
			GetInputAsString(szTotalLoan, sizeof szTotalLoan);
		}

		printf("您的商业贷款金额为%f万元\n您的公积金贷款金额为%f万元\n总贷款金额为%f万元\n>>>>>>>>>>>>>>>\n", fTotalLoan[0], fTotalLoan[1], (fTotalLoan[0] + fTotalLoan[1]));
		fTotalLoan[0] = fTotalLoan[0] * 10000; /* bank total loan */
		fTotalLoan[1] = fTotalLoan[1] * 10000; /* provident total loan */
	}

	return fTotalLoan;
}

/* Read payment method */
char GetPaymentMethod() {
	char szPaymentMethod[3];

	printf("请选择您的还款方式\n\t1、等额本息（每月等额还款）\n\t2、等额本金（每月递减还款）\n请输入对应序号（1-2）：");
	GetInputAsString(szPaymentMethod, sizeof szPaymentMethod);

	/* Make sure that the input is 1 or 2 */
	while (1) {
		if (strlen(szPaymentMethod) == 1)
			if (szPaymentMethod[0] == '1' || szPaymentMethod[0] == '2') break;

		printf("请输入有效对应序号（1-2）：");
		GetInputAsString(szPaymentMethod, sizeof szPaymentMethod);
	}

	if (szPaymentMethod[0] == '1')
		printf("您选择的还款方式为等额本息\n>>>>>>>>>>>>>>>\n");
	else
		printf("您选择的还款方式为等额本金\n>>>>>>>>>>>>>>>\n");

	return szPaymentMethod[0];
}

/* Get payment months */
unsigned int GetPaymentMonths() {
	char szPaymentYears[4];
	unsigned int uPaymentYears;

	printf("请输入还款年数（1-30）：");
	GetInputAsString(szPaymentYears, sizeof szPaymentYears);

	/* Make sure that the input is a integer and between 1 and 30 */
	while (1) {
		if (CheckNumValid(szPaymentYears, true)) {
			uPaymentYears = (unsigned int)atoi(szPaymentYears);
			if (uPaymentYears >= 1 && uPaymentYears <= 30) break;
		}

		printf("请输入有效还款年数（1-30）：");
		GetInputAsString(szPaymentYears, sizeof szPaymentYears);
	}
	printf("您的还款年数为%u年，共%u个月\n>>>>>>>>>>>>>>>\n", uPaymentYears, uPaymentYears * 12);

	return uPaymentYears * 12;
}

/* Read loan interest rate according to the loan method */
float *GetLoanInterestRate(char cLoanMethod) {
	char szLoanInterestRate[8];
	static float fLoanInterestRate[2];

	if (cLoanMethod == '1') {
		printf("请输入贷款利率，截止2019年末，银行贷款利率如下\n\t7折（3.43%%）\n\t8折（3.92%%）\n\t8.3折（4.067%%）\n\t8.5折（4.165%%）\n\t8.8折（4.312%%）\n\t9折（4.41%%）\n\t9.5折（4.655%%）\n\t基准利率（4.9%%）\n\t1.05倍（5.145%%）\n\t1.1倍（5.39%%）\n\t1.15倍（5.635%%）\n\t1.2倍（5.88%%）\n\t1.25倍（6.125%%）\n\t1.3倍（6.37%%）\n\t1.35倍（6.615%%）\n\t1.4倍（6.86%%）\n请输入具体数值（%%）：");
		GetInputAsString(szLoanInterestRate, sizeof szLoanInterestRate);

		/* make sure that the input is a number above 0 below 100 */
		while (1) {
			if (CheckNumValid(szLoanInterestRate, false)) {
				fLoanInterestRate[0] = atof(szLoanInterestRate);
				if (fLoanInterestRate[0] > 0 && fLoanInterestRate[0] < 100) break;
			}

			printf("请输入有效贷款利率：");
			GetInputAsString(szLoanInterestRate, sizeof szLoanInterestRate);
		}

		printf("您的贷款利率为%.3f%%\n>>>>>>>>>>>>>>>\n", fLoanInterestRate[0]);
		fLoanInterestRate[0] /= 100;
		fLoanInterestRate[1] = 0;
	} else if (cLoanMethod == '2') {
		printf("请输入公积金贷款利率，截止2019年末，公积金贷款利率如下\n\t基准利率（3.25%%）\n\t1.1倍（3.575%%）\n\t1.2倍（3.9%%）\n请输入具体数值（%%）：");
		GetInputAsString(szLoanInterestRate, sizeof szLoanInterestRate);

		while (1) {
			if (CheckNumValid(szLoanInterestRate, false)) {
				fLoanInterestRate[0] = atof(szLoanInterestRate);
				if (fLoanInterestRate[0] > 0 && fLoanInterestRate[0] < 100) break;
			}

			printf("请输入有效公积金贷款利率：");
			GetInputAsString(szLoanInterestRate, sizeof szLoanInterestRate);
		}

		printf("您的公积金贷款利率为%.3f%%\n>>>>>>>>>>>>>>>\n", fLoanInterestRate[0]);
		fLoanInterestRate[0] /= 100;
		fLoanInterestRate[1] = 0;
	} else if (cLoanMethod == '3') {
		printf("请输入贷款利率，截止2019年末，银行贷款利率如下\n\t7折（3.43%%）\n\t8折（3.92%%）\n\t8.3折（4.067%%）\n\t8.5折（4.165%%）\n\t8.8折（4.312%%）\n\t9折（4.41%%）\n\t9.5折（4.655%%）\n\t基准利率（4.9%%）\n\t1.05倍（5.145%%）\n\t1.1倍（5.39%%）\n\t1.15倍（5.635%%）\n\t1.2倍（5.88%%）\n\t1.25倍（6.125%%）\n\t1.3倍（6.37%%）\n\t1.35倍（6.615%%）\n\t1.4倍（6.86%%）\n请输入具体数值（%%）：");
		GetInputAsString(szLoanInterestRate, sizeof szLoanInterestRate);

		while (1) {
			if (CheckNumValid(szLoanInterestRate, false)) {
				fLoanInterestRate[0] = atof(szLoanInterestRate);
				if (fLoanInterestRate[0] > 0 && fLoanInterestRate[0] < 100) break;
			}

			printf("请输入有效银行贷款利率：");
			GetInputAsString(szLoanInterestRate, sizeof szLoanInterestRate);
		}

		printf("请输入公积金贷款利率，截止2019年末，公积金贷款利率如下\n\t基准利率（3.25%%）\n\t1.1倍（3.575%%）\n\t1.2倍（3.9%%）\n请输入具体数值（%%）：");
		GetInputAsString(szLoanInterestRate, sizeof szLoanInterestRate);

		while (1) {
			if (CheckNumValid(szLoanInterestRate, false)) {
				fLoanInterestRate[1] = atof(szLoanInterestRate);
				if (fLoanInterestRate[1] > 0 && fLoanInterestRate[1] < 100) break;
			}

			printf("请输入有效公积金贷款利率：");
			GetInputAsString(szLoanInterestRate, sizeof szLoanInterestRate);
		}

		printf("您的银行贷款利率为%.3f%%，公积金贷款利率为%.3f%%\n>>>>>>>>>>>>>>>\n",fLoanInterestRate[0], fLoanInterestRate[1]);
		fLoanInterestRate[0] /= 100; /* bank loan interest rate */
		fLoanInterestRate[1] /= 100; /* provident fund loan interest rate */
	}

	return fLoanInterestRate;
}

/* Get payment every month by the way of average captial plus interest */
float AverageCaptialPlusInterest(double fTotalLoan, unsigned int uMonths, float fInterestRate) {
  float fMonthRate = fInterestRate / 12;

  return fTotalLoan * fMonthRate * pow(1 + fMonthRate, uMonths) /
         (pow(1 + fMonthRate, uMonths) - 1);
}

/* Get payment of uMonth month by the way of average captial */
float AverageCaptial(double fTotalLoan, unsigned int uMonths, float fInterestRate, unsigned int uMonth) {
	float fMonthRate = fInterestRate / 12;

	return fTotalLoan / uMonths * (1 + (uMonths - uMonth) * fMonthRate);
}

int main(int argc, char *argv[]) {
	char cLoanMethod, cPaymentMethod;
	float *lpfLoanInterestRate;
	double *lpfTotalLoan;
	unsigned int uPaymentMonths, m;
	float fMonthPayment[2] = {0, 0};
	double fTotalPayment = 0, fTotalInterest;

	cLoanMethod = GetLoanMethod();
	lpfTotalLoan = GetTotalLoan(cLoanMethod);
	cPaymentMethod = GetPaymentMethod();
	uPaymentMonths = GetPaymentMonths();
	lpfLoanInterestRate = GetLoanInterestRate(cLoanMethod);

	if (cPaymentMethod == '1') { /* for average capital plus interest method */
		if (cLoanMethod == '1' || cLoanMethod == '2') { /* for commercial or provident fund loan method */
			fMonthPayment[0] = AverageCaptialPlusInterest(lpfTotalLoan[0], uPaymentMonths, lpfLoanInterestRate[0]);
			fTotalPayment = fMonthPayment[0] * uPaymentMonths;
			fTotalInterest = fTotalPayment - lpfTotalLoan[0];
			printf("每月需还款%.2f元\n\t还款总额%.6f万\n\t支付利息%.6f万\n\t贷款总额%.6f万\n", fMonthPayment[0], fTotalPayment / 10000, fTotalInterest / 10000, lpfTotalLoan[0] / 10000);
		} else { /* for syndicated loan method */
			fMonthPayment[0] = AverageCaptialPlusInterest(lpfTotalLoan[0], uPaymentMonths, lpfLoanInterestRate[0]); /* bank payment every month */
			fMonthPayment[1] = AverageCaptialPlusInterest(lpfTotalLoan[1], uPaymentMonths, lpfLoanInterestRate[1]); /* provident fund payment every month */
			fTotalPayment = (fMonthPayment[0] + fMonthPayment[1]) * uPaymentMonths;
			fTotalInterest = fTotalPayment - (lpfTotalLoan[0] + lpfTotalLoan[1]);
			printf("每月需还款%.2f元\n\t还款总额%.6f万\n\t支付利息%.6f万\n\t贷款总额%.6f万\n", (fMonthPayment[0] + fMonthPayment[1]), fTotalPayment / 10000, fTotalInterest / 10000, (lpfTotalLoan[0] + lpfTotalLoan[1]) / 10000);
		}
	} else { /* for average capital method */
		if (cLoanMethod == '1' || cLoanMethod == '2') { /* for commercial or provident fund loan method */
			for (m = 0; m < uPaymentMonths; m++) {
				fTotalPayment += AverageCaptial(lpfTotalLoan[0], uPaymentMonths, lpfLoanInterestRate[0], m);
			}
			fTotalInterest = fTotalPayment - lpfTotalLoan[0];
			printf("还款总额%.6f万\n支付利息%.6f万\n贷款总额%.6f万\n", fTotalPayment / 10000, fTotalInterest / 10000, lpfTotalLoan[0] / 10000);
		} else { /* for syndicated loan method */
			for (m = 0; m < uPaymentMonths; m++) {
				fTotalPayment += (AverageCaptial(lpfTotalLoan[0], uPaymentMonths, lpfLoanInterestRate[0], m) + AverageCaptial(lpfTotalLoan[1], uPaymentMonths, lpfLoanInterestRate[1], m));
			}
			fTotalInterest = fTotalPayment - (lpfTotalLoan[0] + lpfTotalLoan[1]);
			printf("还款总额%.6f万\n支付利息%.6f万\n贷款总额%.6f万\n", fTotalPayment / 10000, fTotalInterest / 10000, (lpfTotalLoan[0] + lpfTotalLoan[1]) / 10000);
		}
	}

	system("pause");
	return 0;
}
