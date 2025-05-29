# Atlassian Jira with HikariCP Connection Pooling

This project provides a customized Docker image for Atlassian Jira that replaces the default connection pooling with HikariCP, a high-performance JDBC connection pool. The image also includes support for multiple database types and is configured for both AMD64 and ARM64 architectures.

## Features

- 🚀 **HikariCP Integration**: Replaces the default Jira connection pool with HikariCP for better performance and reliability
- 🐋 **Multi-architecture Support**: Pre-built images available for both AMD64 and ARM64
- 🗃️ **Multi-Database Support**: Includes JDBC drivers for:
  - PostgreSQL
  - MySQL
  - Microsoft SQL Server
  - Oracle
  - AWS Aurora (PostgreSQL and MySQL)
- 🔧 **Customizable Connection Pooling**: Configure min/max pool sizes and connection timeouts via environment variables
- 🔒 **Secure by Default**: Proper file permissions and security practices implemented

## Prerequisites

- Docker 20.10+ and Docker Compose (for local development)
- Access to a supported database (PostgreSQL, MySQL, SQL Server, or Oracle)
- Sufficient system resources (at least 4GB RAM recommended for Jira)

## Quick Start

1. Clone this repository
2. Run the following command, you can adjust the docker compose file as you like to play with various configurations:

```bash
docker-compose up -d
```

Jira will be available at `http://localhost:8080`

## Configuration

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `ATL_DB_TYPE` | Database type (postgres72, mysql, mssql, oracle) | - | Yes |
| `ATL_DB_SCHEMA_NAME` | Database schema name | public | No |
| `ATL_JDBC_URL` | JDBC connection URL | - | Yes |
| `ATL_JDBC_USER` | Database username | - | Yes |
| `ATL_JDBC_PASSWORD` | Database password | - | Yes |
| `ATL_JDBC_DRIVER` | JDBC driver class | org.postgresql.Driver | No |
| `ATL_DB_POOLMINSIZE` | Minimum number of connections | 5 | No |
| `ATL_DB_POOLMAXSIZE` | Maximum number of connections | 30 | No |
| `ATL_DB_MAXWAITMILLIS` | Maximum wait time for connection (ms) | 30000 | No |
| `ATL_DB_EXTENSIONS` | Additional HikariCP properties | - | No |

### Database Configuration Examples

#### PostgreSQL
```
ATL_DB_TYPE=postgres72
ATL_JDBC_DRIVER=org.postgresql.Driver
ATL_JDBC_URL=jdbc:postgresql://db-host:5432/jiradb
ATL_JDBC_USER=jirauser
ATL_JDBC_PASSWORD=yourpassword
```

#### MySQL
```
ATL_DB_TYPE=mysql
ATL_JDBC_DRIVER=com.mysql.cj.jdbc.Driver
ATL_JDBC_URL=jdbc:mysql://db-host:3306/jiradb?useSSL=false&useUnicode=true&characterEncoding=UTF-8&sessionVariables=default_storage_engine=InnoDB
ATL_JDBC_USER=jirauser
ATL_JDBC_PASSWORD=yourpassword
```

## Building the Image

To build the image locally:

```bash
docker build -t your-org/atlassian-jira-hikaricp:10.3.4 .
```

## Deployment


### Docker Compose

Edit the `docker-compose.yml` file to match your environment and run:

```bash
docker-compose up -d
```

## Monitoring

HikariCP exposes JMX metrics that can be monitored using tools like Prometheus and Grafana. 
Jira will need to have JMX enabled to expose these metrics. Check this out: https://thejiraguy.com/2021/07/28/end-to-end-datadog-monitoring-of-jira/ 



## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgements

- [HikariCP](https://github.com/brettwooldridge/HikariCP)
- [Atlassian Jira](https://www.atlassian.com/software/jira)
- [Docker](https://www.docker.com/)

## Support

For support, please open an issue in the repository.
