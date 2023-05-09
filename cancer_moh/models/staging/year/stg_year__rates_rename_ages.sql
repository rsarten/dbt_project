{% set column_names = dbt_utils.get_filtered_columns_in_relation(from=ref('stg_year__rates_cleaned')) %}

with
final as (
    select 
        {% for column in column_names %}
            {%- if '.' in column -%}
                {% set new_col = column.split('.')[0] %}
                "{{ column }}" as {{ new_col }}
            {%- else -%}
                "{{ column }}"
            {%- endif -%}
        {% if not loop.last %},{% endif %}{% endfor %}
    from {{ ref('stg_year__rates_cleaned')}}
)

select * from final
