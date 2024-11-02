import psycopg2
import matplotlib.pyplot as plt

selectic2 = """select avg(bd_shops.employers.salary), bd_shops.employers.departament 
from bd_shops.employers 
group by bd_shops.employers.departament"""
def get_data():
    connect = psycopg2.connect(database="postgres", host="localhost", port=5432, user="postgres", password="123")
    cursor = connect.cursor()
    cursor.execute(selectic2)
    return cursor.fetchall()

data = get_data()
department = []
salary = []

for row in data:
    salary.append(row[0])
    department.append(row[1])

fig2, ax2 = plt.subplots()
ax2.bar(department, salary)
fig2.savefig('bar2.png')

