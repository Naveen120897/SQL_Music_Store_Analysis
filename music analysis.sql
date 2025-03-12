/* Q1: Who is the senior most employee based on job title? */

  select concat(first_name, ' ',last_name) as 'Name' from employee order by levels desc limit 1 ;

/* Q2: Which countries have the most Invoices? */

 select billing_country as most_invoices_country,count(invoice_id) as total_invoices from invoice group by billing_country order by total_invoices desc limit 1 ;

/* Q3: What are top 3 values of total invoice? */

 select invoice_id, sum(total) as total from invoice group by invoice_id order by total desc limit 3 ;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

 select billing_city, sum(total) as total from invoice group by billing_city order by total desc limit 1 ;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

 select customer.customer_id, concat(customer.first_name, ' ',customer.last_name) as customer_name  , sum(invoice.total) as total 
from invoice 
join customer  on invoice.customer_id = customer.customer_id
group by invoice.customer_id , customer_name order by total desc limit 1 ;


/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

select c.customer_id  , concat(c.first_name, ' ',c.last_name) as 'Name', c.email , count(i1.track_id) as  no_of_songs from customer c
join invoice i  on i.customer_id = c.customer_id
join invoice_line i1 on i1.invoice_id = i.invoice_id 
join track t  on t.track_id = i1.track_id
join genre g on g.genre_id = t.genre_id
where g.name = 'rock'
group by c.customer_id, c.first_name, c.last_name, c.email
order by no_of_songs desc ;


/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select artist.name, artist.artist_id, count(artist.artist_id) as total_songs from track 
join album2 on album2.album_id = track.album_id
join artist on artist.artist_id = album2.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name = 'rock'
group by artist.name,artist.artist_id
order by total_songs desc limit 10 ;

/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name, milliseconds
from track
where  milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc limit 10 ;

/* Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS CustomerName, 
    ar.name AS ArtistName, 
    ROUND(SUM(il.unit_price * il.quantity), 2) AS TotalSpent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album2 al ON t.album_id = al.album_id
JOIN artist ar ON al.artist_id = ar.artist_id
GROUP BY c.first_name,c.last_name, ar.name
ORDER BY TotalSpent DESC ;

/* Q10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */


  with most_popular_genre as (
select ROUND(SUM(i1.unit_price * i1.quantity), 2) AS TotalSpent, c.country, g.name, count(t.track_id) as total_songs,
row_number() over(partition by c.country order by SUM(i1.unit_price * i1.quantity) desc) as genre_rank
 from  customer c
join invoice i on i.customer_id = c.customer_id
join invoice_line i1 on i1.invoice_id = i.invoice_id 
join track t on t.track_id = i1.track_id
join genre g on g.genre_id = t.genre_id
group by c.country, g.name
order by genre_rank ) 

select country, TotalSpent, name from most_popular_genre
where genre_rank = 1
order by TotalSpent desc ;

/* Q11: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

  with cte as (select CONCAT(c.first_name, ' ', c.last_name) AS CustomerName, ROUND(SUM(i1.unit_price * i1.quantity), 2) AS TotalSpent, c.country,
row_number() over(partition by c.country order by SUM(i1.unit_price * i1.quantity) desc) as country_rank
from  customer c
join invoice i on i.customer_id = c.customer_id
join invoice_line i1 on i1.invoice_id = i.invoice_id 
group by c.country, c.first_name,  c.last_name) 
select CustomerName, Totalspent, country from cte 
where country_rank = 1
order by TotalSpent desc ;















