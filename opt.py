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
            "["
            + "S = " + str(strike)
            + ", F = " + str(fee) + " * " + str(quantity) + " = " + str(fee * quantity)
            + "] "
            + "Price = " + str(price)
            + " (" + str(round(((price - strike) / strike) * 100, 1)) + "%)"
            + " -> Profit = " + str(round(profit, 1)) + " (" + str(round(profit / (fee * quantity) * 100, 1)) + "%)"
        )
    price += step
