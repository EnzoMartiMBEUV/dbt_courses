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
