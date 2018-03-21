# Database-SchoolIdolFestivalDB
This is the project me and @PozzaMarco made for Database course exam, during the second year of university. It's a MySQL database, that stores various data about a smartphone game, called Love Live School Idol Festival (LLSIF). More information about the project can be found in the file _relazione.pdf_ (in italian).

# Getting started 
Make sure you have myslq installed, then clone this repository and enter the right path 

```
git clone https://github.com/gcoro/Database-SchoolIdolFestivalDB.git 
cd Database-SchoolIdolFestivalDB 
```

Connect to mysql, and enter your password if asked

```
mysql -u root -p
``` 

Create the database in which you'll import the project 

```
create database project;
use project;
```

Import schemas, instances and views 
```
source SchoolIdolFestivalDB.sql;
```
  
Now the database is loaded, enjoy! You can find some example of queries to test it in the last chapter of the file _relazione.pdf_.
