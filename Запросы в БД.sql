--первый запрос
select id, "Name", salary, departament
from employers
;

--второй запрос
select  product_name, shop_id, revizion_date, (count*price_sale_out) as total_price
from product 
where (count*price_sale_out) > 5000
;

--третий запрос
select shop_id, revizion_date
from product 
where (count*price_sale_out) = (select max(count*price_sale_out) from product)
;

--четвёртый запрос
SELECT employers."Name", employers.salary, t3.base_cost
FROM employers 
left join (select shops.id, t2.size_name, t2.base_cost
from shops 
left join (select market_board.size_name, market_board.base_cost, t1.min_square, t1.max_square
from market_board 
left join (select *, coalesce(squares, 100000) as max_square
from (select *, lead(min_square) over (order by min_square) as squares
from market_size)) as t1
on market_board.size_name = t1.size_name) as t2
on shops.square > t2.min_square and shops.square < t2.max_square) as t3
on employers.shop_id = t3.id
;

--пятый запрос
select visits.id, visits.visit_date, visits.shop_id, employers.years_exp, employers.departament
from visits 
left join employers 
on visits.shop_id = employers.shop_id
;

--шестой запрос
select *,
case 
	when t4.salary > avg_salary then 'переплата'
	else 'зп по рынку'
end as salary_status
from(select employers."Name", t3.base_cost, employers.salary, avg(employers.salary) over (partition by t3.size_name) as avg_salary
from employers
left join (select shops.id, t2.size_name, t2.base_cost
from shops 
left join (select market_board.size_name, market_board.base_cost, t1.min_square, t1.max_square
from market_board 
left join (select *, coalesce(squares, 100000) as max_square
from (select *, lead(min_square) over (order by min_square) as squares
from market_size)) as t1
on market_board.size_name = t1.size_name) as t2
on shops.square > t2.min_square and shops.square < t2.max_square) as t3
on employers.shop_id = t3.id) as t4
;

--седьмой запрос
select mb.size_name, t4.avg_salary, mb.base_cost
from market_board mb 
left join (select t3.size_name, avg(employers.salary) as avg_salary
from employers
left join (select shops.id, t2.size_name, t2.base_cost
from shops 
left join (select market_board.size_name, market_board.base_cost, t1.min_square, t1.max_square
from market_board 
left join (select *, coalesce(squares, 100000) as max_square
from (select *, lead(min_square) over (order by min_square) as squares
from market_size)) as t1
on market_board.size_name = t1.size_name) as t2
on shops.square > t2.min_square and shops.square < t2.max_square) as t3
on employers.shop_id = t3.id
group by t3.size_name) as t4
on mb.size_name = t4.size_name

create or replace function avg_salary_mb() 
returns void
as
$$
CREATE table if not exists bd_shops.table7 (
	size_name varchar(50) NOT NULL,
	avg_salary float8 null,
	base_cost money null
);

insert into table7(
select mb.size_name, t4.avg_salary, mb.base_cost
from market_board mb 
left join (select t3.size_name, avg(employers.salary) as avg_salary
from employers
left join (select shops.id, t2.size_name, t2.base_cost
from shops 
left join (select market_board.size_name, market_board.base_cost, t1.min_square, t1.max_square
from market_board 
left join (select *, coalesce(squares, 100000) as max_square
from (select *, lead(min_square) over (order by min_square) as squares
from market_size)) as t1
on market_board.size_name = t1.size_name) as t2
on shops.square > t2.min_square and shops.square < t2.max_square) as t3
on employers.shop_id = t3.id
group by t3.size_name) as t4
on mb.size_name = t4.size_name)
$$
language sql;

--восьмой запрос
select product.revizion_date, count(product_deliv.vendor_id) as vendors_number
from product
join product_deliv 
on product.id = product_deliv.product_id
group by revizion_date
;