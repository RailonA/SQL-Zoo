-- 1-How many stops are in the database.

SELECT COUNT(*) 
FROM stops

-- 2-Find the id value for the stop 'Craiglockhart'

SELECT id 
FROM stops 
WHERE name = 'Craiglockhart'

-- 3-Give the id and the name for the stops on the '4' 'LRT' service.

SELECT id, name 
FROM stops 
JOIN route 
ON stop = id 
WHERE num = '4' AND company = 'LRT'

-- 4-The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.

SELECT company, num, COUNT(*)
FROM route 
WHERE stop=149 OR stop=53
GROUP BY company, num HAVING COUNT(*) = 2

-- 5-Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop, b.stop
FROM route a 
JOIN route b 
ON (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop=149

-- 6-The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a 
JOIN route b 
ON (a.company=b.company AND a.num=b.num)
JOIN stops stopa ON (a.stop=stopa.id)
JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'AND stopb.name = 'London Road'

-- 7-Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

SELECT DISTINCT a.* FROM 
(SELECT company, num FROM route WHERE stop = 115) AS a
INNER JOIN
(SELECT company, num FROM route WHERE stop = 137) AS b
ON a.num = b.num

-- 8-Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

SELECT Craig.company, Craig.num FROM
(SELECT * FROM stops JOIN route ON stop = id WHERE name = 'Craiglockhart') as Craig
INNER JOIN
(SELECT * FROM stops JOIN route ON stop = id WHERE name = 'Tollcross') as Toll
ON Craig.num = Toll.num

-- 9-Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.

SELECT stops_table2.name, route_table2.company, route_table2.num
FROM route AS route_table1 JOIN route AS route_table2 ON
route_table1.company = route_table2.company AND route_table1.num = route_table2.num
JOIN stops AS stops_table1 ON route_table1.stop = stops_table1.id
JOIN stops AS stops_table2 ON route_table2.stop = stops_table2.id
WHERE stops_table1.name = 'Craiglockhart';


-- 10-Find the routes involving two buses that can go from Craiglockhart to Lochend.
-- Show the bus no. and company for the first bus, the name of the stop for the transfer,
-- and the bus no. and company for the second bus.

SELECT DISTINCT 1st.num AS first_bus, 1st.company AS first_company, 
                stops.name AS transfer, 
                2nd.num AS second_bus, 2nd.company AS second_company
FROM (
    SELECT a.company, a.num, b.stop
    -- first self-join
    FROM route a JOIN route b ON a.company = b.company AND a.num = b.num
    WHERE a.stop = (SELECT id FROM stops WHERE name = 'Craiglockhart')
) AS 1st
JOIN (
    SELECT a.company, a.num, b.stop
    -- second self-join
    FROM route a JOIN route b ON a.company = b.company AND a.num = b.num
    WHERE a.stop = (SELECT id FROM stops WHERE name = 'Lochend')
) AS 2nd
-- join the above two tables on their matching stops
ON 1st.stop = 2nd.stop
JOIN stops ON stops.id = 1st.stop
ORDER BY first_bus, transfer, second_bus;