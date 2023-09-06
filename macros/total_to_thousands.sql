{% macro total_to_thousands(column_name, decimal_place=2) -%}
concat( round( 1.0 * {{ column_name }} / 100, {{ decimal_place }}), 'k')
{%- endmacro %}