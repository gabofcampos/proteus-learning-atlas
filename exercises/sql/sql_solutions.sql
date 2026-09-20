----
-- sql 1: number of event type during august 2026 ordered from most frequent to least
WITH events_with_expanded_timestamp AS (
    SELECT
        *
        , EXTRACT(month FROM event_timestamp) as event_month
        , EXTRACT(year FROM event_timestamp) as event_year
    FROM
        events
)
SELECT 
    event_type
    , count(*) as num_events
FROM events_with_expanded_timestamp
WHERE
    event_year = 2026 
    AND event_month = 08
ORDER BY 
    num_events DESC;

---- better version: more efficient if timestamp is being used for partitioning/indexing
SELECT 
    event_type
    , count(*) as num_events
FROM events_with_expanded_timestamp
WHERE
    event_timestamp >= '2026-08-01'
    AND event_timestamp < '2026-09-01'
ORDER BY 
    num_events DESC;


----
-- sql2: all users who generated more than 100 search events during August 2026.
SELECT 
    user_id
    , count(*) as search_count
FROM
    events_with_expanded_timestamp
WHERE 
    event_type = 'search'
    AND event_timestamp >= '2026-08-01'
    AND event_timestamp < '2026-09-01'
GROUP BY
    user_id
HAVING
    count(*) > 100;


----
-- sql3: for each user their most recent event.
--       return complete event record.
--       if multiple most recent return all
WITH ranked_events AS (
    SELECT
        event_id
        , user_id
        , event_type
        , event_timestamp
        , domain
        , country
        , ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY event_timestamp DESC   -- latest timestamp first
        ) AS row_num
    FROM events
)
SELECT
    event_id
    , user_id
    , event_type
    , event_timestamp
    , domain
    , country
FROM 
    ranked_events
WHERE row_num = 1;


----
-- sql4: 
--
WITH ranked_events AS (
    SELECT
        event_id
        , user_id
        , event_type
        , event_timestamp
        , domain
        , country
        , ROW_NUMBER() OVER (
            PARTITION BY event_id
            ORDER BY event_timestamp DESC 
        ) AS row_num
    FROM events
)
SELECT
    event_id
    , user_id
    , event_type
    , event_timestamp
    , domain
    , country
FROM 
    ranked_events
WHERE row_num = 1;