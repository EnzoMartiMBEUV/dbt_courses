# dbt courses training, exercices and setup

In this repo I will try to _carefully_ follow all [dbt courses](https://courses.getdbt.com/collections) with their main points, exercices (and setups) !

## Environment

I think I will, for now, use BigQuery and dbt (maybe some Python later ?).

### Fastest BiqQuery setup

There are [various data platforms](https://docs.getdbt.com/docs/supported-data-platforms) but in my case (and based on my experience) I will use BigQuery.

Based on the [documentation](https://cloud.google.com/bigquery/docs/sandbox?hl=fr), we can access a *10 GB of active storage and 1 TB of processed query data each month* **sandbox**.

Once logged in, just create a new project named *dbt-courses*. One thing that we can directly do, since we are connected, is to retrieve the **service account** JSON file.

By using the left drop-down menu we can click on :\
**IAM & administration -> Service account**.\
Then we need to give it a name and a role (*mmmmmh sa.json with owner rights*).

**IN THIS REPOSITORY WE WILL CONSIDER OUR _sa.json_ AT THE ROOT OF THE PROJECT - excluded by .gitignore**

### About Service Account

The main idea is that there is one Service Account per BQ project.\
But, we can also [c/c our already created Service Account to another project](https://youtu.be/ptkcjy4c-0g?t=316):\
**Select the new project -> IAM & administration -> Grant Access (top left) -> paste email of the SA**.\

### Others ressources for BQ

- [Quickstart for dbt Cloud and BigQuery](https://docs.getdbt.com/quickstarts/bigquery?step=1)


## Mmmmmh

I do not know how to do it yet, but I will try to centralize every exercices, dbt projects, bigquery tables and setup in this repo but I am not sure how ...\
"*when the objective meets the demand*"\
"*do I really need to create file and folder naming convention ??*"\
"*number here, underscore there, 48h pause, rethink everything*"\
\
**SOUNDS LIKE A PLAN**\
\
Beginning of an answer : \
- [How can we work with multiple DBT projects](https://stackoverflow.com/questions/67000794/how-can-we-work-with-multiple-dbt-projects)
	- *Surely I should reorganise my project.*

## First steps

- Create a dbt account
- Configure connection to database
	- Pretty much straightforward with the SA but something's off : they ask about *Development Credentials* with the following instructions : "*Enter your personal development credentials here (not your deployment credentials!). dbt will use these credentials to connect to your database on your behalf. When you're ready to deploy your dbt project to production, you'll be able to supply your production credentials separately.*"
	- There is something by default but my idea here is to create a first dataset in BQ with a non-specific name and see what happened next (Does it go by default ? I might be able to specify the dataset later in `dbt_project.yml` or in `model` config.)

## First project

For the sake of this project (*DBT Fundamentals / Models*), instead of using Snowflake's dataset I found one on BQ : **gdelt-bq.extra**.
This dataset contains info regarding countries such as *iso, fips, area, population, domains, ...* within the tables `countryinfo2` and `sourcesbycountry`.
The model, based on the same dynamics as the one from the course, is named `dim_countries.sql`.\

The commands used to run this model are :
`dbt run`
`dbt run --select dim_countries``

### Modularity

Simply implemented the modularity concept : divided our main file into numerous files.
`stg_countries` and `stg_sources` which concern a select from BQ public datasets.

### Reorganise

By creating folders and subfolders, we can now organise more clearly our project and models and apply business logic here.
We also implemented *materialization* setup at top-level - within `dbt_project.yml`.

### Pratice

TODO

But tips : *"When dbt run is executing, dbt is wrapping the select statement in the correct DDL/DML to build that model as a table/view. If that model already exists in the data warehouse, dbt will automatically drop that table or view before building the new database object. Note: If you are on BigQuery, you may need to run dbt run --full-refresh for this to take effect."*


### Freshness

For things like sources freshness or tests, I am not currently using *production type environment* raw sources.
Thus I can only implement some code but not test it out.
But from what I understand, we must specify, in our *source yml / specifications file*, under our source model name : `loaded_at_field: _etl_loaded_at` and then specify our freshness thresholds.

### Testing

- It might not be the most relevant singular test but instead of writing in comment generic tests I did implement it in my workflow.
*However*, it's the same thing as writing `not_null` in my yml file.

- Not sur if I understood everything but in order to run our tests the commands are, for example :
    - `dbt test --select stg_countries` to test a **singular test** done on a specific model.
        - How is this linked ? Is it because in our test we are loading data from this particular model ? Think so
    - `dbt test --select source:gdelt-bq_extra` if we want to run our generic tests. In this case I must specify that I want to focus on my sources.
        - Once again, is this linked thanks to our calls from our sources ? It is also the YML file where we specify our sources infos
        - So this is the name of my file based on the name of this source (*does this make sense ?*)


#### The `build` command

We often run theses commands in that particular order :
```dbt run dbt test```
So it first create our models based on our DAG (stg -> dim -> agg -> ...) and then we test them (same DAG but we are adding our sources).
What if there is an error during the execution of one of our stg models ? There could be a big issue if it concerns something like the primary key being null for example.
**This is a problem**.

A new way to run these commands is to use `dbt build`. It will go like that : 
*test source -> run stg -> test stg -> run dim -> test dim -> ...*

Like that, we are sure that **we are not building our downstream marts on top of models having failing tests.**


### Documentation

We can documente our models column by column directly in ou yml files (`stg_gdbelt-bq_extra.yml` in our case). 
By adding a *`description`* line, we can add a small description to our model and/or ou column.

But we can also deep-dive into this description part and create a dedicated _.md_ file.
To do so, once the file is created and named (based on what we want to specify - `countries_currency_code.md` here), we can add the jinja line :
`{% docs given_name_of_doc_block %}` and then write in markdown our specifications.

Once done, to link our description to our column / model we must, in our **.yml file**, specify our link like this:
`description: '{{ doc("given_name_of_doc_block") }}'

The example is on our staging models but obviously we can specify and documente any tables (source, final, ...)


### Deployment

To configure our deployment we must follow these steps:
`(On dbt Cloud interface) Deploy > Environement (Development created by default) > Create Environment`

About the specs of our new environment:
- Name: Deployment
- Deployment Credentials: fulfil with the info from our *specific* service account *dedicated* to the production environment + specify the schema
    - For example I've been working on the `crash_dataset` schema the whole time, but I can create a new one that will correspond to my _production environment_.
    - This is not the best practice, more an efficient one if we stay with the _sandbox dynamics_

Then we can created jobs.