{#
    generate_schema_name
    --------------------
    Overrides dbt's built-in schema naming.

    Production-style runs (prod or staging) write to the target schema
    directly, honouring any custom +schema config as-is with no prefix.

    Everything else (local dev, CI, ad-hoc targets) is namespaced with a
    <target.schema>_ prefix so developers don't collide with each other
    or with prod. This is the fallback, so any unexpected target name is
    treated as dev, which is the safe default.

    Environment is detected via DBT_CLOUD_ENVIRONMENT_TYPE (set on the
    dbt platform) OR the target name, so either signal is enough.

    NOTE: CI jobs should run in their own dedicated dbt platform
    environment. If CI shares an environment (and therefore target
    schema) with dev or prod, its runs will land in the same schemas and
    can overlap or clobber other work. A separate CI environment keeps
    each PR build isolated in its own namespace.

    Behaviour at a glance:

      is env prod/staging?
      (DBT_CLOUD_ENVIRONMENT_TYPE or target.name)
              |
      +-------+-------+
      |               |
     YES             NO  (dev / CI / anything else)
      |               |
      |               |
    custom          custom
    schema?         schema?
      |               |
   +--+--+         +--+--+
   |     |         |     |
  none  set       none  set
   |     |         |     |
   v     v         v     v
 target custom   target  target_custom
 schema schema   schema  (prefixed)

    Examples (target.schema = analytics, custom = marts):

      prod    + none    ->  analytics
      prod    + marts   ->  marts
      dev     + none    ->  analytics
      dev     + marts   ->  analytics_marts
#}
{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {#- prod/staging: no prefix, custom schema used verbatim -#}
    {%- if env_var('DBT_CLOUD_ENVIRONMENT_TYPE', '') in ['prod', 'staging'] or target.name in ['prod', 'staging'] -%}

        {%- if custom_schema_name is none -%}
            {#- no custom schema: fall back to target schema -#}
            {{ default_schema }}
        {%- else -%}
            {#- custom schema honoured on its own, no concatenation -#}
            {{ custom_schema_name | trim }}
        {%- endif -%}

    {#- everything else (dev/CI): prefix with target schema to namespace -#}
    {%- else -%}

        {%- if custom_schema_name is none -%}
            {#- no custom schema: just the namespaced target schema -#}
            {{ default_schema }}
        {%- else -%}
            {#- concatenate so custom schemas stay inside the dev namespace -#}
            {{ default_schema }}_{{ custom_schema_name | trim }}
        {%- endif -%}

    {%- endif -%}

{%- endmacro %}