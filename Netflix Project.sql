use neflix;
ALTER TABLE netflix
RENAME COLUMN `User ID` TO User_ID;
ALTER TABLE netflix
RENAME COLUMN `Monthly Revenue` TO Monthly_Revenue;
ALTER TABLE netflix
RENAME COLUMN `Join Date` TO Join_Date;
ALTER TABLE netflix
RENAME COLUMN `Last Payment Date` TO Last_Payment_Date;
ALTER TABLE netflix
RENAME COLUMN `Plan Duration` TO Plan_Duration;
alter table netflix
rename column `Subscription Type` to Subscription_Type;
set sql_safe_updates=0;
set autocommit = off;
commit;

select * from netflix;
update netflix
set Join_Date= Case
	When Join_Date like "%/%" Then date_format(str_to_date(Join_Date,"%d/%m/%Y"),"%Y-%m-%d")
	When Join_Date like"%-%" Then date_format(str_to_date(concat(substring_index(Join_Date,"-",2),"-",concat(20,substring_index(Join_Date,"-",-1))),"%d-%m-%Y"),"%Y-%m-%d")
    else null
end
Where Join_Date is not null;

alter table netflix
modify column Join_Date Date;
commit;

select * from netflix;
update netflix
set Last_Payment_Date= Case
	When Last_Payment_Date like "%/%" Then date_format(str_to_date(Last_Payment_Date,"%d/%m/%Y"),"%Y-%m-%d")
	When Last_Payment_Date like "%-%" Then date_format(str_to_date(concat(substring_index(Last_Payment_Date,"-",2),"-",concat(20,substring_index(Last_Payment_Date,"-",-1))),"%d-%m-%Y"),"%Y-%m-%d")
    else null
end
Where Last_Payment_Date is not null;
commit;

alter table netflix
modify column Last_Payment_Date Date;
commit;

### Phân tích đặc điểm người dùng
#phân bố người dùng theo độ tuổi và giới tính
select age, gender, count(user_id) as user_count
from netflix
group by age, gender
order by age, gender;

# phân bố người dùng theo quốc gia và thiết bị sử dụng
select country, device, count(user_id) as user_count
from netflix
group by country, device
order by country, device;

#tổng số lượng người dùng theo quốc gia và thiết bị sử dụng
select country, device, count(user_id) as user_count
from netflix
group by country, device
order by country, device;

### Đánh giá hiệu quả gói đăng ký và doanh thu

#tổng doanh thu hàng tháng từ các loại gói đăng ký 
select subscription_type, sum(monthly_revenue) as total_revenue
from netflix
group by subscription_type;

#tổng doanh thu và tỷ lệ phần trăm từng loại gói đăng ký
select 
    subscription_type,
    sum(monthly_revenue) as total_revenue,
    (sum(monthly_revenue) / (select sum(monthly_revenue) from netflix)) * 100 as revenue_percentage
from netflix
group by subscription_type;

# So sánh doanh thu từng quốc gia và số lượng người dùng ở mỗi quốc gia
select country, count(user_id) as user_count, sum(monthly_revenue) as total_revenue
from netflix
group by country
order by total_revenue desc;

###Đánh giá hiệu quả kinh doanh

#Tổng số người dùng Netflix hiện tại
select count(user_id) as total_users
from netflix;

#xu hướng gia nhập người dùng mới qua từng tháng/năm
select date_format(join_date, '%Y-%m') as join_month, count(user_id) as new_users
from netflix
group by join_month
order by join_month asc;

commit;
