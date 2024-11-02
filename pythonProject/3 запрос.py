import psycopg2
import matplotlib.pyplot as plt

selectic3 = """select sum(bd_shops.product."count" * bd_shops.product.price_sale_out), bd_shops.product.revizion_date
from bd_shops.product
where bd_shops.product.shop_id = 1
group by bd_shops.product.revizion_date
order by bd_shops.product.revizion_date asc"""
def get_data():
    connect = psycopg2.connect(database="postgres", host="localhost", port=5432, user="postgres", password="123")
    cursor = connect.cursor()
    cursor.execute(selectic3)
    return cursor.fetchall()

data = get_data()
price = []
rev_date = []

for row in data:
    price.append(row[0])
    rev_date.append(row[1])

fig3, ax3 = plt.subplots()
ax3.plot(rev_date, price)
fig3.savefig('plot3.png')
