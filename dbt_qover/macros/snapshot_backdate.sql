{% macro snapshot_backdate(table_name) %}

/* goal is to help backdate the valid_from field when we first run the snapshot */
declare x int64;
set x = (
    select count(distinct dbt_updated_at)
    from {{ table_name }}
);

if (x = 1) then 
    begin transaction;
        update {{ table_name }} set dbt_valid_from = '2000-01-01 00:00:00' where 1=1;
    commit transaction;
end if;
                
{% endmacro %}