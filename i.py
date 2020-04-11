quantity = input()

putStrike = 19
putPrice = 2
putQuantity = 0 
putProfit = 0
putMargin = 0

cs = 0
cf = 0
cq = 0
callProfit = 0
callMargin = 0

sp = 0
sq = 0
stockProfit = 0
stockMargin = 0

putQuantity = q if pq == 0 else pq
cq = q if cq == 0 else cq
sq = q if sq == 0 else sq

putFee = putPrice * putQuantity
cft = cf * cq

referencePrice = 0
if sp > 0:
    referencePrice = sp
elif cs > 0:
    referencePrice = cs
else:
    referencePrice = putStrike

step = 0
if referencePrice < 4:
    step = 0.01
elif referencePrice < 10:
    step = 0.1
else:
    step = 1

price = 0
while price <= referencePrice * 1.5:
    putProfit = (putStrike - price) * putQuantity - putFee
    putMargin = ((putProfit - putFee) / putFee) * 100
    priceVSputStrike = ((price - putStrike) / ps) * 100

    callProfit = (price - cs) * cq - cft
    callMargin = ((callProfit - cft) / cft) * 100 if cs > 0 else 0
    priceVScs = ((price - cs) / cs) * 100 if cs > 0 else 0

    stockProfit = (price - sp) * sq
    stockmargin = (price - sp) / sp * 100
    
    print(
        str(callProfit) + " " + str(callMargin) + "% " + str(priceVScs) + "%"
        + " | " + str(price) + " | "
        + str(priceVSputStrike) + "% " + str(putMargin) + "% " + str(putProfit)
        + " || " + " -- " if sp == 0 else str(stockProfit) + " " + str(stockMargin) + "%"
    )
    price += step
