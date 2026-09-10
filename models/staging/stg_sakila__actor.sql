{{ config(materialized='view') }}

with source as (
    select * from {{ source('sakila_raw', 'v_stg_actor') }}
),

renamed as (
    select
        cast(actor_id as INT64) as actor_id,
        initcap(first_name) as first_name,
        initcap(last_name) as last_name,
        last_update,
        read_timestamp as ingested_at
    from source
)

select * from renamed