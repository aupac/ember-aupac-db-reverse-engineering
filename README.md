# ember-aupac-db-reverse-engineering

Reverse engineer your database and create your `ember-data` models and `ember-cli-mirage` factories automatically.
- Change you database structure and regenerate you models to ensure they are always in sync.
- Regenerate safely at any time without loosing your customisations.
- Get up and running quickly and stop wasting time on boilerplate.

## Requirements

- A recent version of [JAVA JRE](http://www.oracle.com/technetwork/java/javase/downloads/index.html) installed on your development system (this is for development purposes only and it not required on your hosting server!).
- ember-cli >= 1.13.9 (yet to be released!)

## Operating Systems Supported 
This is for development only - the server hosting you app can run any OS you like.

- Window
- Linux running bash shell
- Mac ??? (needs to be tested)

## Installing
```bash
ember install ember-aupac-db-reverse-engineering
```

## Features
- automatic creation of ember-data models.
- automatic creation of ember-cli-mirage factories and routes.

### Setup

When you install `ember-aupac-db-reverse-engineering` a new folder will appear in your applications root directory `yourapp/db-reverse-engineering`.  This folder contains configuration specific to this addon.

#### Step 1 - Get your JDBC Driver

You need to download the JDBC driver specific to your database vendor and version.

- [MySql driver](http://dev.mysql.com/downloads/connector/j/)
- [PostgreSQL driver](https://jdbc.postgresql.org/)
- [Oracle driver](http://www.oracle.com/technetwork/database/features/jdbc/index-091264.html)
- [SQLServer driver](https://www.microsoft.com/en-us/download/details.aspx?displaylang=en&id=11774) 

Once downloaded, copy the `.jar` file to  `db-reverse-engineering/drvers/` in your project.

* I Will accept pull requests to update/add driver links.

#### Step 2 - Setup your database connection

Open the file `db-reverse-engineering/hibernate.properties`.  You need to fill out the fields with the appropriate connection information.

##### MySQL Example
```
hibernate.connection.username=YOUR_USER
hibernate.connection.password=YOUR_PASSWORD
hibernate.connection.url=jdbc:mysql://localhost:3306/YOUR_DATABASE_NAME
hibernate.connection.driver_class=com.mysql.jdbc.Driver
hibernate.dialect=org.hibernate.dialect.MySQLDialect
```

##### PostgreSQL Example
```
TODO
```

##### Oracle Example
```
TODO
```

##### SQLServer Example
```
TODO
```

#### Step 3 - Define Custom Mappings (Not Required)

Sometimes the reverse engineering strategy does not interpolate your database the way your would expect/want.  For example, you might want single character database fields `CHAR(1)` with values of `Y/N` interpolated as booleans instead of single character strings in your ember-models. 

You are able to fine tune they way it works via the `db-reverse-engineering/hibernate.reveng.xml` file.

More information can be found in the [hibernate documentations](http://docs.jboss.org/tools/latest/en/hibernatetools/html/reverseengineering.html).

* If you find some useful strategies that others might be able to use, submit an issue and we can include in in the documentation somewhere.

### Commands

The first time you run any of the following command it will take some time because a number of dependencies need to be downloaded.  This only needs to happen once per project and future runs will be much faster.

#### Generate ember-data models 
From within your project run:

```bash
ember db-reverse-engineer emberData 
```

`app/models/gen` - contains the generated models. These are replaced every time you run the command and should never be edited manually!
`app/models` - contains the ember-data models used in your application. Once created, these are never replaced so feel free to customise them as you wish.

#### Generate ember-cli-mirage factories & routes
From within your project run:

```
ember db-reverse-engineer emberCliMirage
```

`app/mirage/gen` - contains the generated factories and routes.js file. These are replaced every time you run the command and should never be edited manually!
`app/mirage/factories` - contains the factories used in your application. Once created, these are never replaced so feel free to customise them as you wish.

The routes are generated in a files called `app/mirage/gen/routes.js`.  You can copy/paste these into your `app/mirage/config.js` file but a better way is to import it - that way you get route updates automatically.

```javascript
//app/mirage/config.js
import routes from './gen/routes';
 
export default function() { 

  //Add this in the existing exported function
  routes.apply(this, arguments);
}
```

## Customising the Templates

If the templates we have supplied do not suite your requirements; feel free to change them at `app/db-referse-engineering/templates`.

The templating language is called [freemarker](http://freemarker.org/docs/index.html).

## Questions

- Should the db-reverse-engineering folder be included in version control? ANSWER: Yes - except for the `tmp/` and `.gradle` folders.  For git users there is already a `.gitignore` file excluding these folders.

# Contributing

## Installation

* `git clone` this repository
* `npm install`
* `bower install`

## Running

* `ember server`
* Visit your app at http://localhost:4200.

## Running Tests

* `ember test`
* `ember test --server`

## Building

* `ember build`

For more information on using ember-cli, visit [http://www.ember-cli.com/](http://www.ember-cli.com/).
