#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Get input as string to prevent overstep the boundary */
int GetInputAsString(char *_lpstrInput, unsigned int _uSize) {
  int _iResult;
  char _strFormat[5] = "%";
  char _strSize[3];

  itoa(_uSize - 1, _strSize, 10);
  strcat(_strFormat, _strSize);
  strcat(_strFormat, "s"); /* Get the format string "%ns", n indicates the
                              number of characters to read */
  _iResult = scanf(_strFormat, _lpstrInput);
  fflush(stdin);

  return _iResult;
}

/* Check the input is a valid integer or floating number */
bool CheckNumValid(char *_lpstrInputstring, bool _bIsInt) {
  unsigned int _uLength = strlen(_lpstrInputstring);
  unsigned int i;
  bool _bDotExist = false;

  if (_bIsInt) { /* for integer */
    for (i = 0; i < _uLength; i++) {
      if (_lpstrInputstring[i] < '0' || _lpstrInputstring[i] > '9')
        return false;
    }
  } else { /* for floating number */
    for (i = 0; i < _uLength; i++) {
      if (_lpstrInputstring[i] < '0' || _lpstrInputstring[i] > '9') {
        if (!_bDotExist && _lpstrInputstring[i] ==
                               '.') /* decimal point can only appear once */
          _bDotExist = true;
        else
          return false;
      }
    }
  }

  return true;
}

/* Read the loan method */
char GetLoanMethod() {
  char _strLoanMethod[3];

  printf("请选择您的贷款方式\n\t1、商业贷款\n\t2、公积金贷款\n\t3、组合贷款\n请"
         "输入对应序号（1-3）：");
  GetInputAsString(_strLoanMethod, sizeof _strLoanMethod);

  /* Make sure that the input is 1, 2 or 3 */
  while (1) {
    if (strlen(_strLoanMethod) == 1) {
      if (_strLoanMethod[0] >= '1' && _strLoanMethod[0] <= '3')
        break;
    }

    printf("请输入有效对应序号（1-3）：");
    GetInputAsString(_strLoanMethod, sizeof _strLoanMethod);
    fflush(stdin);
  }

  if (_strLoanMethod[0] == '1')
    printf("您选择的贷款方式为商业贷款\n>>>>>>>>>>>>>>>\n");
  else if (_strLoanMethod[0] == '2')
    printf("您选择的贷款方式为公积金贷款\n>>>>>>>>>>>>>>>\n");
  else
    printf("您选择的贷款方式为组合贷款\n>>>>>>>>>>>>>>>\n");

  return _strLoanMethod[0];
}

/* Get total loan according to loan method */
double *GetTotalLoan(char _loanMethod) {
  char _strTotalLoan[16];
  static double _fTotalLoan[2];

  if (_loanMethod == '1' || _loanMethod == '2') {
    printf("请输入您的贷款总额（万）：");
    GetInputAsString(_strTotalLoan, sizeof _strTotalLoan);

    /* Make sure that the input is a number above 0 */
    while (1) {
      if (CheckNumValid(_strTotalLoan, false)) {
        _fTotalLoan[0] = atof(_strTotalLoan);
        if (_fTotalLoan[0] > 0)
          break;
      }

      printf("请输入有效贷款总额（万）：");
      GetInputAsString(_strTotalLoan, sizeof _strTotalLoan);
    }

    printf("您的总贷款金额为%f万元\n>>>>>>>>>>>>>>>\n", _fTotalLoan[0]);
    _fTotalLoan[0] = _fTotalLoan[0] * 10000;
    _fTotalLoan[1] = 0;
  } else {
    printf("请输入您的商业贷款总额（万）：");
    GetInputAsString(_strTotalLoan, sizeof _strTotalLoan);

    while (1) {
      if (CheckNumValid(_strTotalLoan, sizeof _strTotalLoan)) {
        _fTotalLoan[0] = atof(_strTotalLoan);
        if (_fTotalLoan[0] > 0)
          break;
      }

      printf("请输入有效商业贷款总额（万）：");
      GetInputAsString(_strTotalLoan, sizeof _strTotalLoan);
    }

    printf("请输入您的公积金贷款总额（万）：");
    GetInputAsString(_strTotalLoan, sizeof _strTotalLoan);

    while (1) {
      if (CheckNumValid(_strTotalLoan, sizeof _strTotalLoan)) {
        _fTotalLoan[1] = atof(_strTotalLoan);
        if (_fTotalLoan[1] > 0)
          break;
      }

      printf("请输入有效公积金贷款总额（万）：");
      GetInputAsString(_strTotalLoan, sizeof _strTotalLoan);
    }

    printf("您的商业贷款金额为%f万元\n您的公积金贷款金额为%f万元\n总贷款金额为%"
           "f万元\n>>>>>>>>>>>>>>>\n",
           _fTotalLoan[0], _fTotalLoan[1], (_fTotalLoan[0] + _fTotalLoan[1]));
    _fTotalLoan[0] = _fTotalLoan[0] * 10000; /* bank total loan */
    _fTotalLoan[1] = _fTotalLoan[1] * 10000; /* provident total loan */
  }

  return _fTotalLoan;
}

/* Read payment method */
char GetPaymentMethod() {
  char _strPaymentMethod[3];

  printf("请选择您的还款方式\n\t1、等额本息（每月等额还款）\n\t2、等额本金（每"
         "月递减还款）\n请输入对应序号（1-2）：");
  GetInputAsString(_strPaymentMethod, sizeof _strPaymentMethod);

  /* Make sure that the input is 1 or 2 */
  while (1) {
    if (strlen(_strPaymentMethod) == 1) {
      if (_strPaymentMethod[0] == '1' || _strPaymentMethod[0] == '2')
        break;
    }

    printf("请输入有效对应序号（1-2）：");
    GetInputAsString(_strPaymentMethod, sizeof _strPaymentMethod);
  }

  if (_strPaymentMethod[0] == '1')
    printf("您选择的还款方式为等额本息\n>>>>>>>>>>>>>>>\n");
  else
    printf("您选择的还款方式为等额本金\n>>>>>>>>>>>>>>>\n");

  return _strPaymentMethod[0];
}

/* Get payment months */
unsigned int GetPaymentMonths() {
  char _strPaymentYears[4];
  unsigned int _uPaymentYears;

  printf("请输入还款年数（1-30）：");
  GetInputAsString(_strPaymentYears, sizeof _strPaymentYears);

  /* Make sure that the input is a integer and between 1 and 30 */
  while (1) {
    if (CheckNumValid(_strPaymentYears, true)) {
      _uPaymentYears = (unsigned int)atoi(_strPaymentYears);
      if (_uPaymentYears >= 1 && _uPaymentYears <= 30) {
        break;
      }
    }

    printf("请输入有效还款年数（1-30）：");
    GetInputAsString(_strPaymentYears, sizeof _strPaymentYears);
  }
  printf("您的还款年数为%u年，共%u个月\n>>>>>>>>>>>>>>>\n", _uPaymentYears,
         _uPaymentYears * 12);

  return _uPaymentYears * 12;
}

/* Read loan interest rate according to the loan method */
float *GetLoanInterestRate(char _cLoanMethod) {
  char _strLoanInterestRate[8];
  static float _fLoanInterestRate[2];

  if (_cLoanMethod == '1') {
    printf("请输入贷款利率，截止2019年末，银行贷款利率如下\n\t7折（3.43%"
           "）\n\t8折（3.92%）\n\t8.3折（4.067%）\n\t8.5折（4.165%）\n\t8."
           "8折（4.312%）\n\t9折（4.41%）\n\t9.5折（4.655%）\n\t基准利率（4.9%"
           "）\n\t1.05倍（5.145%）\n\t1.1倍（5.39%）\n\t1.15倍（5.635%）\n\t1."
           "2倍（5.88%）\n\t1.25倍（6.125%）\n\t1.3倍（6.37%）\n\t1.35倍（6."
           "615%）\n\t1.4倍（6.86%）\n请输入具体数值（%%）：");
    GetInputAsString(_strLoanInterestRate, sizeof _strLoanInterestRate);

    /* Make sure that the input is a number above 0 below 100 */
    while (1) {
      if (CheckNumValid(_strLoanInterestRate, false)) {
        _fLoanInterestRate[0] = atof(_strLoanInterestRate);
        if (_fLoanInterestRate[0] > 0 && _fLoanInterestRate[0] < 100)
          break;
      }

      printf("请输入有效贷款利率：");
      GetInputAsString(_strLoanInterestRate, sizeof _strLoanInterestRate);
    }

    printf("您的贷款利率为%.3f%%\n>>>>>>>>>>>>>>>\n", _fLoanInterestRate[0]);
    _fLoanInterestRate[0] /= 100;
    _fLoanInterestRate[1] = 0;
  } else if (_cLoanMethod == '2') {
    printf(
        "请输入公积金贷款利率，截止2019年末，公积金贷款利率如下\n\t基准利率（3."
        "25%）\n\t1.1倍（3.575%）\n\t1.2倍（3.9%）\n请输入具体数值（%%）：");
    GetInputAsString(_strLoanInterestRate, sizeof _strLoanInterestRate);

    while (1) {
      if (CheckNumValid(_strLoanInterestRate, false)) {
        _fLoanInterestRate[0] = atof(_strLoanInterestRate);
        if (_fLoanInterestRate[0] > 0 && _fLoanInterestRate[0] < 100)
          break;
      }

      printf("请输入有效公积金贷款利率：");
      GetInputAsString(_strLoanInterestRate, sizeof _strLoanInterestRate);
    }

    printf("您的公积金贷款利率为%.3f%%\n>>>>>>>>>>>>>>>\n",
           _fLoanInterestRate[0]);
    _fLoanInterestRate[0] /= 100;
    _fLoanInterestRate[1] = 0;
  } else if (_cLoanMethod == '3') {
    printf("请输入贷款利率，截止2019年末，银行贷款利率如下\n\t7折（3.43%"
           "）\n\t8折（3.92%）\n\t8.3折（4.067%）\n\t8.5折（4.165%）\n\t8."
           "8折（4.312%）\n\t9折（4.41%）\n\t9.5折（4.655%）\n\t基准利率（4.9%"
           "）\n\t1.05倍（5.145%）\n\t1.1倍（5.39%）\n\t1.15倍（5.635%）\n\t1."
           "2倍（5.88%）\n\t1.25倍（6.125%）\n\t1.3倍（6.37%）\n\t1.35倍（6."
           "615%）\n\t1.4倍（6.86%）\n请输入具体数值（%%）：");
    GetInputAsString(_strLoanInterestRate, sizeof _strLoanInterestRate);

    while (1) {
      if (CheckNumValid(_strLoanInterestRate, false)) {
        _fLoanInterestRate[0] = atof(_strLoanInterestRate);
        if (_fLoanInterestRate[0] > 0 && _fLoanInterestRate[0] < 100)
          break;
      }

      printf("请输入有效银行贷款利率：");
      GetInputAsString(_strLoanInterestRate, sizeof _strLoanInterestRate);
    }

    printf(
        "请输入公积金贷款利率，截止2019年末，公积金贷款利率如下\n\t基准利率（3."
        "25%）\n\t1.1倍（3.575%）\n\t1.2倍（3.9%）\n请输入具体数值（%%）：");
    GetInputAsString(_strLoanInterestRate, sizeof _strLoanInterestRate);

    while (1) {
      if (CheckNumValid(_strLoanInterestRate, false)) {
        _fLoanInterestRate[1] = atof(_strLoanInterestRate);
        if (_fLoanInterestRate[1] > 0 && _fLoanInterestRate[1] < 100)
          break;
      }

      printf("请输入有效公积金贷款利率：");
      GetInputAsString(_strLoanInterestRate, sizeof _strLoanInterestRate);
    }

    printf(
        "您的银行贷款利率为%.3f%%，公积金贷款利率为%.3f%%\n>>>>>>>>>>>>>>>\n",
        _fLoanInterestRate[0], _fLoanInterestRate[1]);
    _fLoanInterestRate[0] /= 100; /* bank loan interest rate */
    _fLoanInterestRate[1] /= 100; /* provident fund loan interest rate */
  }

  return _fLoanInterestRate;
}

/* Get payment every month by the way of average captial plus interest */
float AverageCaptialPlusInterest(double _fTotalLoan, unsigned int _uMonths,
                                 float _fInterestRate) {
  float _fMonthRate = _fInterestRate / 12;

  return _fTotalLoan * _fMonthRate * pow(1 + _fMonthRate, _uMonths) /
         (pow(1 + _fMonthRate, _uMonths) - 1);
}

/* Get payment of _uMonth month by the way of average captial */
float AverageCaptial(double _fTotalLoan, unsigned int _uMonths,
                     float _fInterestRate, unsigned int _uMonth) {
  float _fMonthRate = _fInterestRate / 12;

  return _fTotalLoan / _uMonths * (1 + (_uMonths - _uMonth) * _fMonthRate);
}

int main(int argc, char *argv[]) {
  char _cLoanMethod, _cPaymentMethod;
  float *_lpfLoanInterestRate;
  double *_lpfTotalLoan;
  unsigned int _uPaymentMonths, m;
  float _fMonthPayment[2] = {0, 0};
  double _fTotalPayment = 0, _fTotalInterest;

  _cLoanMethod = GetLoanMethod();
  _lpfTotalLoan = GetTotalLoan(_cLoanMethod);
  _cPaymentMethod = GetPaymentMethod();
  _uPaymentMonths = GetPaymentMonths();
  _lpfLoanInterestRate = GetLoanInterestRate(_cLoanMethod);

  if (_cPaymentMethod == '1') { /* for average capital plus interest method */
    if (_cLoanMethod == '1' ||
        _cLoanMethod ==
            '2') { /* for commercial or provident fund loan method */
      _fMonthPayment[0] = AverageCaptialPlusInterest(
          _lpfTotalLoan[0], _uPaymentMonths, _lpfLoanInterestRate[0]);
      _fTotalPayment = _fMonthPayment[0] * _uPaymentMonths;
      _fTotalInterest = _fTotalPayment - _lpfTotalLoan[0];
      printf("每月需还款%.2f元\n\t还款总额%.6f万\n\t支付利息%.6f万\n\t贷款总额%"
             ".6f万\n",
             _fMonthPayment[0], _fTotalPayment / 10000, _fTotalInterest / 10000,
             _lpfTotalLoan[0] / 10000);
    } else { /* for syndicated loan method */
      _fMonthPayment[0] = AverageCaptialPlusInterest(
          _lpfTotalLoan[0], _uPaymentMonths,
          _lpfLoanInterestRate[0]); /* bank payment every month */
      _fMonthPayment[1] = AverageCaptialPlusInterest(
          _lpfTotalLoan[1], _uPaymentMonths,
          _lpfLoanInterestRate[1]); /* provident fund payment every month */
      _fTotalPayment =
          (_fMonthPayment[0] + _fMonthPayment[1]) * _uPaymentMonths;
      _fTotalInterest = _fTotalPayment - (_lpfTotalLoan[0] + _lpfTotalLoan[1]);
      printf("每月需还款%.2f元\n\t还款总额%.6f万\n\t支付利息%.6f万\n\t贷款总额%"
             ".6f万\n",
             (_fMonthPayment[0] + _fMonthPayment[1]), _fTotalPayment / 10000,
             _fTotalInterest / 10000,
             (_lpfTotalLoan[0] + _lpfTotalLoan[1]) / 10000);
    }
  } else { /* for average capital method */
    if (_cLoanMethod == '1' ||
        _cLoanMethod ==
            '2') { /* for commercial or provident fund loan method */
      for (m = 0; m < _uPaymentMonths; m++) {
        _fTotalPayment += AverageCaptial(_lpfTotalLoan[0], _uPaymentMonths,
                                         _lpfLoanInterestRate[0], m);
      }
      _fTotalInterest = _fTotalPayment - _lpfTotalLoan[0];
      printf("还款总额%.6f万\n支付利息%.6f万\n贷款总额%.6f万\n",
             _fTotalPayment / 10000, _fTotalInterest / 10000,
             _lpfTotalLoan[0] / 10000);
    } else { /* for syndicated loan method */
      for (m = 0; m < _uPaymentMonths; m++) {
        _fTotalPayment += (AverageCaptial(_lpfTotalLoan[0], _uPaymentMonths,
                                          _lpfLoanInterestRate[0], m) +
                           AverageCaptial(_lpfTotalLoan[1], _uPaymentMonths,
                                          _lpfLoanInterestRate[1], m));
      }
      _fTotalInterest = _fTotalPayment - (_lpfTotalLoan[0] + _lpfTotalLoan[1]);
      printf("还款总额%.6f万\n支付利息%.6f万\n贷款总额%.6f万\n",
             _fTotalPayment / 10000, _fTotalInterest / 10000,
             (_lpfTotalLoan[0] + _lpfTotalLoan[1]) / 10000);
    }
  }

  system("pause");
  return 0;
}
