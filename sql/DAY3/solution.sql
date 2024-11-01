select * from 

	(select car from footer where car is not null order by id desc limit 1) car
cross join	(select length from footer where length is not null order by id desc limit 1) length
cross join	(select width from footer where width is not null order by id desc limit 1) width
cross join	(select height from footer where height is not null order by id desc limit 1) height


-- solution 2
with cte as (
	select *
	,sum(case when car is not null then 1 else 0 end) over (order by id) as car_segment
	,sum(case when length is not null then 1 else 0 end) over (order by id) as length_segment
	,sum(case when width is not null then 1 else 0 end) over (order by id) as width_segment
	,sum(case when height is not null then 1 else 0 end) over (order by id) as height_segment
	from footer)

select  first_value(car) over (partition by car_segment order by id) as new_car
	,first_value(length) over (partition by length_segment order by id) as new_length
	,first_value(width) over (partition by width_segment order by id) as new_width
	,first_value(height) over (partition by height_segment order by id) as new_height
from cte
order by id desc
limit 1