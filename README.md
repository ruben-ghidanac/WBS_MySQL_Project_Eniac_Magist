This is a Database project based on MySQL.
We are exploring the Magists database, based on the detail below.

----------------------------------------------------------------------------------------------------------

Eniac: the Spanish company

Eniac is an online marketplace specializing in Apple-compatible accessories. 
It was founded 10 years ago in Spain and since then it has grown and expanded to other neighboring countries.

Eniac’s Strategy:
To become global
Exploring an expansion to the Brazilian market.

----------------------------------------------------------------------------------------------------------

Magist: the Brazilian company 

Magist is a Brazilian Software as a Service company that offers a centralized 
order management system to connect small and medium-sized stores with the biggest Brazilian marketplaces.

----------------------------------------------------------------------------------------------------------

The economic conditions of the deal are already being discussed. But not everyone in the company is happy 
moving on with this. There are two main concerns:

1. Eniac’s catalog is 100% tech products, and heavily based on Apple-compatible accessories. 
It is not clear that the marketplaces Magist works with are a good place for these high-end tech products.

2. Among Eniac’s efforts to have happy customers, fast deliveries are key. The delivery fees resulting 
from Magist’s deal with the public Post Office might be cheap, but at what cost? Are deliveries fast enough?

----------------------------------------------------------------------------------------------------------

Explore the Magist tables
1. How many orders are there in the dataset?
2. Are orders actually delivered?
3. Is Magist having user growth?
4. How many products are there on the products table?
5. Which are the categories with the most products?
6. How many of those products were present in actual transactions? 
7. What’s the price for the most expensive and cheapest products?
8. What are the highest and lowest payment values?

Probably, these questions do not reveal anything extraordinary to you, but it is critical to get a sense 
of what the data holds in a broad sense.

----------------------------------------------------------------------------------------------------------

When you feel you have the big picture of the database, move to more specific business questions.
You should remember that the company has two main concerns. In summary:

1. Is Magist a good fit for high-end tech products?
2. Are orders delivered on time?

----------------------------------------------------------------------------------------------------------

Additionally to these big concerns, your manager has sent you a list of more concrete questions coming 
from different members of the company. For some of these questions, you will need to combine columns of 
different tables.

- In relation to the products:
01. What categories of tech products does Magist have?
02. How many products of these tech categories have been sold (within the time window of the database snapshot)? 
What percentage does that represent from the overall number of products sold?
03. What’s the average price of the products being sold?
04. Are expensive tech products popular? 

-----

- In relation to the sellers:
05. How many months of data are included in the magist database?
06. How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?
07. What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?
Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?

-----

- In relation to the delivery time:
08. What’s the average time between the order being placed and the product being delivered?
09. How many orders are delivered on time vs orders delivered with a delay?
10. Is there any pattern for delayed orders, e.g. big products being delayed more often?
