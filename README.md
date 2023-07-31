# dbt courses training, exercices and setup

In this repo I will try to _carefully_ follow all [dbt courses](https://courses.getdbt.com/collections) with their main points, exercices (and setups) !

## Environment

I think I will, for now, use BigQuery and dbt (maybe some Python later ?).

### Fastest BiqQuery setup

Based on the [documentation](https://cloud.google.com/bigquery/docs/sandbox?hl=fr), we can access a *10 GB of active storage and 1 TB of processed query data each month* **sandbox**.

Once logged in, just create a new project named *dbt-courses*. One thing that we can directly do, since we are connected, is to retrieve the **service account** JSON file.

By using the left drop-down menu we can click on :\
**IAM & administration -> Service account**.\
Then we need to give it a name and a role (*mmmmmh sa.json with owner rights*).

**IN THIS REPOSITORY WE WILL CONSIDER OUR _sa.json_ AT THE ROOT OF THE PROJECT - excluded by .gitignore**


Mhhhh typos 