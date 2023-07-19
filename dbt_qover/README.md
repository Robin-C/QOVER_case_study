# dbt guidelines

For this dbt project to continue working and scaling, some guidelines need to be followed.

## Project wide conventions

Materialization default type is set in the `dbt_project.yaml` file at the root for each of the 4 folders. These might be overwritten directly in the model.

Note that the database side localization might be different depending on the target sets in the `profiles.yaml` file.

## Model conventions

The models directory is split in 4 folders.
- 1_source
- 2_stg
- 3_gold
- 4_business

Each folder has its purpose, let's go over them.

In each sub folder, there is a `_schema.yaml` file. This is where we find information regarding the models, a quick description of the **why** we created this model and/or **what major modelization happened**, their columns as well as **tests**.

### 1_source

Each sub folder represents a source. There might be several models per sub folder.

`_source.yaml` at the root is where we define the sources and their database side localization (database, schema, table name)

The following transformations may be done at this stage:
- data type casting
- column renaming (x_id for id columns, timestamp_at for timestamp columns)
- basic data cleaning (`case when` to clean up typos...)

The following transformations should **NOT** be done here:
- any kind of join
- any business logic

Models naming follow the following logic `src_source-name_what-is-it`. Eg. for contracts data coming from the core source, we get `src_core_contracts`. 

### 2_stg

This folder is split into 2 sub folders. One common thing they have is this is where the capture data change is setup (incremental modelization etc..).

- dims

This is where we'll find dimensions. See [Kimball's methodology](https://www.educba.com/kimball-methodology/) for more information.

Models naming follow this logic `stg_dim_what-is-it`.

This is the stage where we perform cleaning, some basic data enrichment. We usually join here to enrich the dimension. For example, a policyholder might have revelant information coming from several sources: core but also our CRM etc... Data is still very granular.

- facts

This is where we'll find fact tables. Refer to Kimball if this notion is not clear for you.

You can use several models if you think that makes sense. If you do, make sure to prepend with the step number. For example, `stg_dim_risk_carriers_1.sql` and `stg_dim_risk_carriers_2.sql` where `stg_dim_risk_carriers_2.sql` is downstream from `stg_dim_risk_carriers_1.sql`.

You can also use ephemeral models as to not clutter the database.

This is where we will add simple business logic such as `case when` as well as insert scd surrogate keys when appropriate.

### 3_gold

This is the most important stage in the sense that this is where the business finally appears.

Each sub folder represents a `business process`. For example, the customer support team deals with tickets daily. They open, answer and close them.

It does not mean that only one team intervenes on a specific business process. For contracts, a lot of people will join in on that process, from sales, marketing, accounting etc...

Naming is also very important. Models prepended with an underscore `_` are granular models enriched with data coming from other models (finally joins!). These models often be modified as new sources come in and it makes sense to join them too.

You can think of these models as `operationnal reports`. They will give a lot of info on very specific things such as a specific contract lifecycle.

Models **not** prepended with `_` are models **derived from the underscored model**. They are modelized to respond to specific metrics (more on that later). For example, `gold_contracts_status_by_month` is a crossjoin modelization of `_gold_contracts_enriched` because to calculate the churn rate, we need to know the number of ongoing and churned contracts for each month.

### 4_business

This folder **does not** contain models. Only metrics.

Each sub folder is the **owner** of the metrics contained inside. This is the team that will be responsible for testing that the metrics give out the correct figures.

It does **not** mean they will be the ONLY recipient of the metrics. Someone from sales might be interested in how features usage is year to date.

Metrics prepended by a number eg. `1_` are the main metrics. There might be a handful of them for each team. Metrics not prepended by a number are usually less important metrics and/or metrics that are part of the formula of more important ones (things such as ratio).

