import sys #to accept arguments from terminal
import math

strike = float(sys.argv[1])
fee = float(sys.argv[2])
quantity = float(sys.argv[3])
d, i = math.modf(strike)
step = 10 ** (len(str(int(i))) - 1) / 100

print(i)
print(len(str(i)))
print(step)

price = 0
while price <= strike * 1.1:
    if price <= strike:
        profit = (strike - price - fee) * quantity
        print (
            "P = " + str(price)
            + ", Q = " + str(quantity)
            + ", S = " + str(strike)
            + ", F = " + str(fee)
            + ", change = " + str(round(((strike - price) / strike) * 100, 1)) + "%"
            + ", Profit = " + str(profit)
        )
    price += step
