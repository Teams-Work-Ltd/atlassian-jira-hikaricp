FROM atlassian/jira-software:latest

USER root

# Add custom entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

# Patch Atlassian entrypoint to skip dbconfig.xml generation
COPY patched_entrypoint.py /entrypoint.py
RUN chmod 755 /entrypoint.py

# Log placeholder for ATL_DB_EXTENSIONS usage
RUN echo "If set, ATL_DB_EXTENSIONS will be applied at runtime and logged by entrypoint.sh"

# Download and install HikariCP
RUN wget -O /opt/atlassian/jira/lib/HikariCP-6.3.0.jar https://repo1.maven.org/maven2/com/zaxxer/HikariCP/6.3.0/HikariCP-6.3.0.jar

# Download and install JDBC drivers
RUN wget -O /opt/atlassian/jira/lib/mssql-jdbc-12.6.1.jre11.jar https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/12.6.1.jre11/mssql-jdbc-12.6.1.jre11.jar \
 && wget -O /opt/atlassian/jira/lib/mysql-connector-j-8.3.0.jar https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.3.0/mysql-connector-j-8.3.0.jar \
 && wget -O /opt/atlassian/jira/lib/ojdbc11-23.2.0.0.jar https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc11/23.2.0.0/ojdbc11-23.2.0.0.jar \
 && wget -O /opt/atlassian/jira/lib/aws-advanced-jdbc-wrapper-2.5.6.jar https://repo1.maven.org/maven2/software/amazon/jdbc/aws-advanced-jdbc-wrapper/2.5.6/aws-advanced-jdbc-wrapper-2.5.6.jar

# Override entrypoint to run our script, then delegate to original entrypoint
ENTRYPOINT ["/entrypoint.sh"]
