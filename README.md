# Senior AWS Database Engineer Assessment
## Introduction
This repository contains Terra form and python code created for the interview emailed on 11-APR-2024. Assessment details and solution approaches are summarized below
## Assessment To Be Completed
Keeping aligned to the best practice referenced within AWS Well Architect ed Framework, please build a secure, fault tolerant, elastic database infrastructure that can serve a transactional application.  Use of IAC is encouraged but not mandatory.

Application function would need at minimum a Relational database, persistent Storage, Web presentation layer and optionally a caching mechanism that can speed up transactional throughput.
 
The most significant part of the objective would be the Database layer - its ability to sustain high load via scalability/load balancing and seamlessly perform failover and failback via automation.  In an event a node is taken out of operation due to failure or standard maintenance task such as vulnerability patching, the cluster operation needs to be able to promptly elect a new master or re-add a failed one back as slave. Not use of AWS native RDS PostgreSQL or RDS Aurora is not encouraged - intent is to assess your skillset and thought process resolving objectives by putting building blocks from scratch. 

No problem borrowing ideas from already existing GitHub posted projects which reflect the same requirement.

For the purpose of the assignment, please use PostgreSQL 15 or 16, deployed on EC2 instances. Use Linux operating system of your choice - Amazon Linux 2023 AARCH64 is preferred, but fine you go for Ubuntu for example.  

Application can be as simple as writing a value to Database in a transaction block and reading the same.

It's of paramount importance monitoring of infrastructure and application /in the context of DB function/ is handled effectively.  Please use CloudWatch metrics and an observability tool of your preference /Grafana, etc/.  Consider use of AWS X-Ray to provide application transactional tracing capability and timing of each component. Use custom SQL based metrics that report on application function /e.g. number of transactions last 10 minutes/.

Lastly, please document your assignment & produce a diagram on infra build out / application data flow.

Additional notes:
- Alarms are good to have but focus is building a robust fault tolerant and scalable Database cluster, based on PostgreSQL built on EC2 systems
- Comprehensive Logging at DB layer that enables query, plan and PostgreSQL system components monitoring and supports a fast incident analysis
- Use of a tool that analyzes DB log records over 24-hour period and reports on the same is desired
- Out of the box thinking when addressing challenges is a top scorer on this test, and not quantity of items built 
- Documentation should not be anything excessive 1-2 pages at most
## Architecture Diagram
![Alt Text](images/assessment.png)

## Architecture Principle 

- Use AWS well architected framework 
- Use Terraform for deployment 
- Use Python programming language for application and custom metric creation 
- Not to use RDS 
- Use Postgres15 

## Details of Implementation 
- Isolate complete application using VPC/subnet 
- Postgres on EC2 for both primary and standby 
- Installed PGPOOL2 for database load balancer , failover and failback 
- AWS lambda is used for custom SQL based metric alarm and display in dashboard 
- Event Bridge is used to trigger the custom metric collection Lambda
- CloudWatch Dashboard is used as observability tool 
- CloudWatch Metrics samples are used to showcase the monitoring
- Application extensive observability used AWS X-Raay service 
- A sample Python application is used make use of ElasticCache 
- KMS is used for security 
## Well-Architected Framework Application
### Operational Excellence
- Created the resources using IaC, Terraform for better control of the resource deployment and security apply 
- We can use CICD for automatic application of the GIT repo updates to resources 
- Each Pull Request can be controlled with review mechanism 
### Security
- Created separate VPC for this application 
- Each layer of the task is isolated into subnets. i.e. App layer in public subnet and db layer in private subnet 
- Used **The principle of the least privilege** in granting IAM policies to resources wherever necessary 
- All compute resources i.e. EC2, Lambda.. are secured with **Security Groups** with only ports and sources to be allowed to access
- To protect data at rest and in transit, KMS service is used 
- Logging is implemented and protected for all i.e. Lambda, EC2 and application using appropriate services (X-Ray, Cloud watch Log groups) 
### Reliability
- PGPOOL2 is used for PostgreSQL databases for automatic failover
- Scalability is achieved with this feature
- Used serverless AWS services for better reliability 
### Performance Efficiency
- Used serverless architecture where ever applicable i.e. Lambda
- DB performance is BAU 
- Application performance is depends on the type of application we use 
- Used ElasticCache for application performance improvement 
### Cost Optimization
- I used on demand EC2 machines for this demo, but we could consider the **Spot** instance for non prod workload 
- For a long term workload, we can purchase the reservation for cost benefits 
- Stop/Start the EC2 instances/database for non prod instances if business permits 
- Continuous evaluation of resource utilization and resize appropriately based on data. 

