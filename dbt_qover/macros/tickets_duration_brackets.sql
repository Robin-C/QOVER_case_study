{% macro tickets_duration_brackets(duration_day, is_aggregated=false) %}
    {% if is_aggregated is sameas true %}

        case
            when sum({{ duration_day }}) is null then null
            when sum({{ duration_day }}) >= 0 and sum({{ duration_day }}) < 10 then '[0,10['
            when sum({{ duration_day }}) >= 10 and sum({{ duration_day }}) < 20 then '[10,20['
            when sum({{ duration_day }}) >= 20 and sum({{ duration_day }}) < 30 then '[20,30['
            when sum({{ duration_day }}) >= 30 and sum({{ duration_day }}) < 40 then '[30,40['
            when sum({{ duration_day }}) >= 40 and sum({{ duration_day }}) < 50 then '[40,50['
            when sum({{ duration_day }}) >= 50 then '[50,∞['
        end
    {% else %}
        case
            when {{ duration_day }} is null then null
            when {{ duration_day }} >= 0 and {{ duration_day }} < 10 then '[0,10['
            when {{ duration_day }} >= 10 and {{ duration_day }} < 20 then '[10,20['
            when {{ duration_day }} >= 20 and {{ duration_day }} < 30 then '[20,30['
            when {{ duration_day }} >= 30 and {{ duration_day }} < 40 then '[30,40['
            when {{ duration_day }} >= 40 and {{ duration_day }} < 50 then '[40,50['
            when {{ duration_day }} >= 50 then '[50,∞['
        end
    {% endif %}
{% endmacro %}