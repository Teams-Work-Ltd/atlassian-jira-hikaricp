#!/bin/bash

echo "Generating context.xml using environment variables..."

echo "Using ATL_DB_EXTENSIONS: ${ATL_DB_EXTENSIONS}"

cat <<EOF > /opt/atlassian/jira/conf/context.xml
<Context>
  <Resource name="jdbc/JiraDS"
            auth="Container"
            type="javax.sql.DataSource"
            factory="com.zaxxer.hikari.HikariJNDIFactory"
            driverClassName="${ATL_JDBC_DRIVER:-org.postgresql.Driver}"
            jdbcUrl="${ATL_JDBC_URL}"
            username="${ATL_JDBC_USER}"
            password="${ATL_JDBC_PASSWORD}"
            poolName="HikariCPJiraPool"
            minimumIdle="${ATL_DB_POOLMINSIZE:-5}"
            maximumPoolSize="${ATL_DB_POOLMAXSIZE:-30}"
            connectionTimeout="${ATL_DB_MAXWAITMILLIS:-30000}"
            registerMbeans="true"
            ${ATL_DB_EXTENSIONS:-} />
</Context>
EOF

echo "context.xml generated:"
cat /opt/atlassian/jira/conf/context.xml

echo "Generating dbconfig.xml using environment variables..."

case "${ATL_DB_TYPE}" in
  mssql)
    SCHEMA_NAME="dbo"
    ;;
  postgres72|postgresaurora96)
    SCHEMA_NAME="public"
    ;;
  *)
    SCHEMA_NAME=""
    ;;
esac

if [ -n "${ATL_DB_SCHEMA_NAME}" ]; then
  SCHEMA_NAME="${ATL_DB_SCHEMA_NAME}"
fi

cat <<EOF > "${JIRA_HOME:-/var/atlassian/application-data/jira}/dbconfig.xml"
<?xml version="1.0" encoding="UTF-8"?>
<jira-database-config>
  <name>defaultDS</name>
  <delegator-name>default</delegator-name>
  <database-type>${ATL_DB_TYPE}</database-type>
  <schema-name>${SCHEMA_NAME}</schema-name>
  <jndi-datasource>
    <jndi-name>java:comp/env/jdbc/JiraDS</jndi-name>
  </jndi-datasource>
</jira-database-config>
EOF

echo "Writing dbconfig.xml to ${JIRA_HOME:-/var/atlassian/application-data/jira}"

# Ensure Jira can write to dbconfig.xml
chown jira:jira "${JIRA_HOME:-/var/atlassian/application-data/jira}/dbconfig.xml"
echo "dbconfig.xml permissions: $(ls -l "${JIRA_HOME:-/var/atlassian/application-data/jira}/dbconfig.xml")"

# Delegate to the default Atlassian entrypoint
exec /entrypoint.py "$@"
