ps = 19
pf = 2
pq = 5000

cs = 0
cf = 0
cq = 0

sp = 0
sq = 0

referencePrice = 0
if sp > 0:
    referencePrice = sp
elif cs > 0:
    referencePrice = cs
else:
    referencePrice = ps

step = 0
if referencePrice < 4:
    step = 0.01
elif referencePrice < 10:
    step = 0.1
else:
    step = 1

price = 0
while price <= referencePrice * 1.5:
    putProfit = (ps - price - pf) * pq if ps >= price else "--"
    putString = str(putProfit)
    print(" -- | " + str(price) + " | " + putString)
    price += step
