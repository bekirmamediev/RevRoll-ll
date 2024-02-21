/*
Question #1: 
Return the percentage of users who have posted more than 10 times rounded to 3 decimals.

Expected column names: more_than_10_posts
*/

-- q1 solution:

SELECT 
	COUNT(post_id) as char_limit_posts
FROM posts
WHERE LENGTH(content) = 25;

/*

Question #2: 
Recommend posts to user 888 by finding posts liked by users who have liked a post 
user 888 has also liked more than one time.

The output should adhere to the following requirements: 

- User 888 should not be recommend posts that they have already liked.
- Of the posts that meet the criteria above, return only the three most popular posts 
(by number of likes).
- Return the post_ids in descending order.

Expected column names: post_id
*/

-- q2 solution:

WITH cte AS(
  SELECT 
  p.post_date
	, SUM(CASE WHEN u.user_name = 'JamesTiger8285' THEN 1 ELSE 0 END) as james_post 
	, SUM(CASE WHEN u.user_name = 'RobertMermaid7605' THEN 1 ELSE 0  END) as robert_post
FROM posts p
INNER JOIN users u ON p.user_id=u.user_id
GROUP BY 1 
)

SELECT 
	post_date 
FROM cte 
WHERE ABS(james_post - robert_post) > 2;

/*
Question #3: 
Vibestream wants to track engagement at the user level. 
When a user makes their first post, 
the team wants to begin tracking the cumulative sum of posts over time for the user.

Return a table showing the date and the total number of posts user 888 has made to date.
The time series should begin at the date of 888’s first post 
and end at the last available date in the posts table.

Expected column names: post_date, posts_made
*/

-- q3 solution:

SELECT 
	follower_id 
FROM follows
WHERE followee_id IN (  SELECT 
                            follower_id 
                        FROM follows
                        WHERE followee_id IN (  SELECT 
                                                    follower_id 
                                                FROM follows
                                                WHERE followee_id IN (  SELECT 
                                                                            follower_id 
                                                                        FROM follows
                                                                        WHERE followee_id IN (  SELECT 
                                                                                                    user_id
                                                                                                FROM users
                                                                                                WHERE user_name = 'WilliamEagle6815'
                                                                                              )
                                                                      )
                                              )
                      )
GROUP BY follower_id 
ORDER BY follower_id
LIMIT 10; 

/*
Question #4: 
The Vibestream feed algorithm updates with user preferences every day. 
Every update is independent of the previous update. 
Sometimes the update fails because Vibestreams systems are unreliable. 

Write a query to return the update state for each continuous interval of days 
in the period from 2023-01-01 to `023-12-30.

the algo_update is failed if tasks in a date interval failed 
and succeeded if tasks in a date interval succeeded. 
every interval has a  start_date and an end_date.

Return the result in ascending order by start_date.

Expected column names: algo_update, start_date, end_date
*/

-- q4 solution:

WITH top_poster AS(
    SELECT 
        post_date
        , user_id 
    , COUNT(post_id) as posts 
    , DENSE_RANK()OVER(ORDER BY COUNT(post_id) DESC) as rk 
    FROM posts
    WHERE post_date IN ('2023-11-30', '2023-12-01')
    GROUP BY 1,2
)
SELECT 
	post_date
  , user_id
  , posts
FROM top_poster
WHERE rk in (1, 2)
ORDER BY 1, 2;
