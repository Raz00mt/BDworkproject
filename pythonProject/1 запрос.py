import psycopg2
import matplotlib.pyplot as plt

selectic1 = """select count(bd_shops.shops.id), bd_shops.shops.city 
from bd_shops.shops
group by bd_shops.shops.city """
def get_data():
    connect = psycopg2.connect(database="postgres", host="localhost", port=5432, user="postgres", password="123")
    cursor = connect.cursor()
    cursor.execute(selectic1)
    return cursor.fetchall()

data = get_data()
numofshops = []
city = []

for row in data:
    numofshops.append(row[0])
    city.append(row[1])

fig1, ax1 = plt.subplots()
colors_2 = ["red", "blue", "green", "pink", "gold", "purple", "black", "orange"]
ax1.pie(numofshops, labels=city, colors=colors_2, shadow=True)
fig1.savefig('pie1.png')
