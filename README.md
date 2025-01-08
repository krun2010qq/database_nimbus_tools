# database_nimbus_tools

### The Download Tool Usage

1) The script would directly ask you for the .REFRESH_TOKEN
2) The script would also try to detect if there is any .REFRESH_TOKEN token file. If it has the `.REFRESH_TOKEN` token file, then it would bypass the authentication and directly download the GPDB

Screenshot on how get the refresh token:
![image](https://github.com/user-attachments/assets/74242dd8-6f05-433e-99e2-4b4113969e8c)


### Example: 

```
[root@support14 database_nimbus_tools]# ./download.py
Available products:
1. VMware Tanzu Greenplum Command Center (gpdb-command-center)
2. VMware Tanzu Greenplum Data Copy Utility (gpdb-data-copy)
3. VMware Tanzu Greenplum Backup and Restore (greenplum-backup-restore)
4. VMware Tanzu Greenplum Streaming Server (greenplum-streaming-server)
5. VMware Tanzu Greenplum Upgrade (greenplum-upgrade)
6. VMware Tanzu for Postgres (pivotal-postgres)
7. VMware Tanzu RabbitMQ on Cloud Foundry (p-rabbitmq)
8. VMware Tanzu RabbitMQ on Kubernetes (p-rabbitmq-for-kubernetes)
9. VMware Tanzu RabbitMQ (rabbitmq)
10. VMware Tanzu for Postgres on Kubernetes (tanzu-sql-postgres)
11. VMware Tanzu Greenplum (vmware-greenplum)
12. VMware Tanzu for Postgres on Cloud Foundry (vmware-postgres-for-tas)
Enter the number of the product you want to download: 11

Available releases:
  #  Version    End of Support
---  ---------  ----------------
  1  7.3.3      2026-09-30
  2  6.28.1     2026-02-28
  3  7.3.2      2026-09-30
  4  6.27.4     2025-10-31
  5  6.26.7     2025-05-31
  6  7.3.1      2026-09-30
  7  6.28.0     2026-02-28
  8  7.3.0      2026-09-30
  9  6.26.6     2025-05-31
 10  6.27.3     2025-10-31
 11  6.26.5     2025-05-31
 12  6.27.2     2025-10-31
 13  7.2.0      2026-09-30
 14  6.25.5     2025-01-31
 15  6.27.1     2025-10-31
 16  5.30.0     2025-10-31
 17  6.27.0     2025-10-31
 18  6.26.4     2025-05-31
 19  6.25.4     2025-01-31
 20  6.26.3     2025-05-31
 21  7.1.0      2026-09-30
 22  6.26.2     2025-05-31
 23  6.26.1     2025-05-31
 24  6.26.0     2025-05-31
 25  6.25.3     2025-01-31
 26  7.0.0      2026-09-30
 27  6.25.2     2025-01-31
 28  5.29.12    2023-03-31
 29  6.22.3     2024-10-31
 30  6.25.1     2025-01-31
 31  6.24.6     2024-10-31
 32  6.24.5     2024-10-31
 33  6.24.4     2024-10-31
 34  5.29.11    2023-03-31
 35  6.24.3     2024-10-31
 36  6.23.5     2024-10-31
 37  6.23.4     2024-10-31
 38  6.23.3     2024-10-31
 39  6.23.1     2024-10-31
 40  6.23.0     2024-10-31
 41  6.22.2     2024-10-31
 42  6.21.3     2024-10-31
 43  5.29.10    2023-03-31
 44  6.22.1     2024-10-31
 45  6.22.0     2024-10-31
 46  5.29.8     2023-03-31
 47  6.21.2     2024-10-31
 48  6.21.1     2024-10-31
 49  5.29.7     2023-03-31
 50  6.21.0     2024-10-31
 51  6.20.5     2024-10-31
 52  6.20.4     2024-10-31
 53  5.29.6     2023-03-31
 54  6.20.3     2024-10-31
 55  6.20.1     2024-10-31
 56  6.20.0     2024-10-31
 57  6.19.4     2024-10-31
 58  5.29.5     2023-03-31
 59  6.19.3     2024-10-31
 60  5.29.4     2023-03-31
 61  6.19.2     2024-10-31
 62  6.19.1     2024-10-31
 63  5.29.3     2023-03-31
 64  5.29.2     2023-03-31
 65  6.19.0     2024-10-31
 66  6.18.2     2023-04-30
 67  5.29.1     2023-03-31
 68  6.18.1     2023-04-30
 69  6.18.0     2023-04-30
 70  6.17.7     2023-01-31
 71  5.29.0     2023-03-31
 72  6.17.6     2023-01-31
 73  6.17.5     2023-01-31
 74  6.17.4     2023-01-31
 75  6.17.3     2023-01-31
 76  6.17.2     2023-01-31
 77  6.17.1     2023-01-31
 78  6.17.0     2023-01-31
 79  6.16.3     2022-10-31
 80  6.16.2     2022-10-31
 81  6.16.1     2022-10-31
 82  6.16.0     2022-10-31
 83  6.15.0     2022-09-30
 84  6.14.1     2022-08-31
 85  6.14.0     2022-08-31
 86  6.13.0     2022-06-30
 87  6.12.1     2022-04-30
 88  6.12.0     2022-04-30
 89  6.11.2     2022-03-31
 90  6.11.1     2022-03-31
 91  6.11.0     2022-03-31
 92  6.10.1     2022-02-28
 93  6.10.0     2022-02-28
 94  6.9.1      2022-01-31
 95  6.9.0      2022-01-31
 96  6.8.1      2021-12-31
 97  6.8.0      2021-12-31
 98  6.7.1      2022-10-31
 99  6.7.0      2022-10-31
100  6.6.0      2022-10-31
101  6.5.0      2021-09-30
102  6.4.0      2021-08-31
103  6.3.0      2021-07-31
104  6.2.1      2021-06-30
105  6.1.0      2021-05-31
106  6.0.1      2022-09-30
107  6.0.0      2022-09-30
Enter the number of the release you want to download: 9

Available files:
1. Open Source Licenses for Greenplum Gemfire 3.6.1
2. Open Source Licenses for Greenplum Gemfire 4.0.1
3. Open Source Licenses for Greenplum Informatica Connector
4. Open Source Licenses for Greenplum 6.x Procedural Language Extensions
5. Open Source Licenses for PostGIS 2.1.5
6. Open Source Licenses for PostGIS 2.5.4+Pivotal.8
7. Open Source Licenses for GPDB 6.x
8. Open Source Licenses for PXF 6.10.1
9. Open Source Licenses for Greenplum Connector for Apache NiFi 1.0.0
10. Open Source Licenses for Greenplum Spark Connector 2.3.1 for Scala 2.11
11. Open Source Licenses for Greenplum Spark Connector 2.3.1 for Scala 2.12
12. Open Source Licenses for PXF 5.16.4
13. Open Source Disclosure Package for Greenplum 6 Database
14. Open Source Disclosure Package for Greenplum Spark Connector 2.3.1 for Scala 2.11
15. Open Source Disclosure Package for Greenplum Spark Connector 2.3.1 for Scala 2.12
16. Open Source Disclosure Package for Greenplum Connector for Apache NiFi 1.0.0
17. Open Source Disclosure Package for PostGIS 2.5.4+Pivotal.8
18. Open Source Disclosure Package for PXF 5.16.4
19. Open Source Disclosure Package for PXF 6.10.1
20. Data Science Package for Python 2.7 for Redhat 6
21. Data Science Package for Python 2.7 for Redhat 7
22. Data Science Package for Python 2.7 for Redhat 8
23. Data Science Package for Python 2.7 for Ubuntu 18.04
24. Data Science Package for Python 3.9 for Redhat 7
25. Data Science Package for Python 3.9 for Redhat 8
26. Data Science Package for Python 3.9 for Redhat 9
27. Data Science Package for Python 3.9 for Ubuntu 18.04
28. R Data Science Package for RHEL 6
29. R Data Science Package for RHEL 7
30. R Data Science Package for RHEL 8
31. R Data Science Package for RHEL 9
32. R Data Science Package for Ubuntu 18.04
33. Connector for Greenplum and Gemfire 3.6.1
34. Connector for Greenplum and Gemfire 4.0.1
35. Greenplum Connector for Apache NiFi 1.1.1
36. Greenplum Spark Connector 2.3.1 for Scala 2.11
37. Greenplum Spark Connector 2.3.1 for Scala 2.12
38. Greenplum Database 6.26.6 Installer for RHEL 6
39. Greenplum Database 6.26.6 Installer for RHEL 7
40. Greenplum Database 6.26.6 Installer for RHEL 8
41. Greenplum Database 6.26.6 Installer for RHEL 9
42. Greenplum Database 6.26.6 Installer for Ubuntu 18.04
43. Greenplum Clients for RHEL 6
44. Greenplum Clients for RHEL 7
45. Greenplum Clients for RHEL 8
46. Greenplum Clients for RHEL 9
47. Greenplum Clients for SLES 12
48. Greenplum Clients for Ubuntu 18.04
49. Greenplum Clients for Windows
50. Greenplum Disaster Recovery 1.0.1 for RHEL 7
51. Greenplum Disaster Recovery 1.0.1 for RHEL 8
52. Greenplum Disaster Recovery 1.0.1 for RHEL 9
53. GreenplumR 1.1.0
54. Greenplum Text 3.11.1 for RHEL 6
55. Greenplum Text 3.11.1 for RHEL 7
56. Greenplum Text 3.11.1 for RHEL 8
57. Greenplum Informatica Connector
58. MADlib 1.21.0+1 for RHEL 6
59. MADlib 1.21.0+1 for RHEL 7
60. MADlib 1.21.0+1 for RHEL 8
61. MADlib 1.21.0+1 for RHEL 9
62. MADlib 1.21.0+1 for Ubuntu 18
63. MADlib 2.1.0 for RHEL 8
64. MADlib 2.1.0 for RHEL 9
65. PL/Container for RHEL 7
66. PL/Container for RHEL 8
67. PL/Container for RHEL 9
68. PL/Container for Ubuntu 18.04
69. PL/Container 3.0.0-beta for RHEL 7
70. PL/Container 3.0.0-beta for Ubuntu 18.04
71. Pl/Container Image for Python3 2.4.0
72. Pl/Container Image for Python 2.1.3
73. Pl/Container Image for R 3.0.0-beta
74. PL/Java for RHEL 6
75. PL/Java for RHEL 7
76. PL/Java for RHEL 8
77. PL/Java for RHEL 9
78. PL/Java for Ubuntu 18.04
79. PL/R for RHEL 6
80. PL/R for RHEL 7
81. PL/R for RHEL 8
82. PL/R for RHEL 9
83. PL/R for Ubuntu 18.04
84. PostGIS 2.1.5+pivotal.3.build.3 for RHEL 6
85. PostGIS 2.1.5+pivotal.3.build.3 for RHEL 7
86. PostGIS 2.5.4+pivotal.8.build.2 for RHEL 7
87. PostGIS 2.5.4+pivotal.8.build.2 for RHEL 8
88. PostGIS 2.5.4+pivotal.8.build.2 for RHEL 9
89. Progress DataDirect Connect64 XE for ODBC for VMware Greenplum for AIX 64-bit
90. Progress DataDirect Connect64 XE for ODBC for VMware Greenplum for Linux 64-bit
91. Progress DataDirect Connect64 XE for ODBC for VMware Greenplum for Windows 64-bit
92. Progress DataDirect Connect XE for ODBC for VMware Greenplum for AIX 32-bit
93. Progress DataDirect Connect XE for ODBC for VMware Greenplum for Linux 32-bit
94. Progress DataDirect Connect XE for ODBC for VMware Greenplum for Windows 32-bit
95. Progress DataDirect JDBC Driver for VMware Greenplum
96. Greenplum Platform Extension Framework 5.16.4 for RHEL 7
97. Greenplum Platform Extension Framework 5.16.4 for Ubuntu 18.04
98. Greenplum Platform Extension Framework 6.10.1 for RHEL 7
99. Greenplum Platform Extension Framework 6.10.1 for RHEL 8
100. Greenplum Platform Extension Framework 6.10.1 for RHEL 9
101. Greenplum Platform Extension Framework 6.10.1 for Ubuntu 18.04
Enter the number of the file you want to download: 40
Downloading greenplum-db-6.26.6-rhel8-x86_64.rpm...
File downloaded to: /data/packages/greenplum-db-6.26.6-rhel8-x86_64.rpm
Full Path is /data/packages/greenplum-db-6.26.6-rhel8-x86_64.rpm
Do you want to install greenplum-db-6.26.6-rhel8-x86_64.rpm? (yes/no, we only support install the GPDB RPM files now): yes
Existing Greenplum RPMs found:
greenplum-db-6-6.20.3-1.el8.x86_64
Removing greenplum-db-6-6.20.3-1.el8.x86_64...
Installing /data/packages/greenplum-db-6.26.6-rhel8-x86_64.rpm...
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:greenplum-db-6-6.26.6-1.el8      ################################# [100%]
Changing ownership of /usr/local/greenplum-db-6.26.6 to gpadmin:gpadmin...
Download complete. File saved as greenplum-db-6.26.6-rhel8-x86_64.rpm
```


### How to deploy the pg_auto_failover automatically

Firstly remove all the previous installations
```
[postgres@rabbitmq2 pg_auto_failover_deployment]$ ./remove_pg_auto_failover.py
2024-11-12 01:29:51,986 - INFO - Starting cleanup process
2024-11-12 01:29:51,986 - INFO - Attempting to stop pgautofailover.service
2024-11-12 01:29:52,209 - INFO - Disabling pgautofailover.service
2024-11-12 01:29:52,343 - INFO - Removing pgautofailover.service file
2024-11-12 01:29:52,357 - INFO - Reloading systemd daemon
2024-11-12 01:29:52,485 - INFO - Resetting failed units
2024-11-12 01:29:52,503 - INFO - Folder not found: /var/lib/pgsql/monitor
2024-11-12 01:29:52,503 - INFO - Deleting folder: /var/lib/pgsql/ha
2024-11-12 01:29:52,539 - INFO - Successfully deleted /var/lib/pgsql/ha
2024-11-12 01:29:52,539 - INFO - Deleting folder: /var/lib/pgsql/.config
2024-11-12 01:29:52,540 - INFO - Successfully deleted /var/lib/pgsql/.config
2024-11-12 01:29:52,540 - INFO - Deleting folder: /var/lib/pgsql/.local
2024-11-12 01:29:52,540 - INFO - Successfully deleted /var/lib/pgsql/.local
2024-11-12 01:29:52,540 - INFO - Cleanup process completed
```

Then set up the monitor
```
[postgres@rabbitmq1 pg_auto_failover_deployment]$ ./pg_auto_failover_deploy.py
Are you deploying a monitor node or data node? (monitor/data): monitor
Environment variables set in pg_env.sh:

export PATH=$PATH:/opt/vmware/postgres/14/bin
export PGDATA=/var/lib/pgsql/monitor

To use these variables, run: source pg_env.sh  <--- Env Vars are here
Error executing command 'pg_autoctl create monitor --auth trust --ssl-self-signed --pgdata ~/monitor': 01:29:27 2935444 INFO  Using default --ssl-mode "require"
01:29:27 2935444 INFO  Using --ssl-self-signed: pg_autoctl will create self-signed certificates, allowing for encrypted network traffic
01:29:27 2935444 WARN  Self-signed certificates provide protection against eavesdropping; this setup does NOT protect against Man-In-The-Middle attacks nor Impersonation attacks.
01:29:27 2935444 WARN  See https://www.postgresql.org/docs/current/libpq-ssl.html for details
01:29:27 2935444 INFO  Initialising a PostgreSQL cluster at "/var/lib/pgsql/monitor"
01:29:27 2935444 INFO  /opt/vmware/postgres/14/bin/pg_ctl initdb -s -D /var/lib/pgsql/monitor --option '--auth=trust'
01:29:28 2935444 INFO   /bin/openssl req -new -x509 -days 365 -nodes -text -out /var/lib/pgsql/monitor/server.crt -keyout /var/lib/pgsql/monitor/server.key -subj "/CN=rabbitmq1"
01:29:28 2935444 INFO  Started pg_autoctl postgres service with pid 2935461
01:29:28 2935461 INFO   /opt/vmware/postgres/14/bin/pg_autoctl do service postgres --pgdata /var/lib/pgsql/monitor -v
01:29:28 2935444 INFO  Started pg_autoctl monitor-init service with pid 2935462
01:29:28 2935467 INFO   /opt/vmware/postgres/14/bin/postgres -D /var/lib/pgsql/monitor -p 5432 -h *
01:29:28 2935461 INFO  Postgres is now serving PGDATA "/var/lib/pgsql/monitor" on port 5432 with pid 2935467
01:29:28 2935462 WARN  NOTICE:  installing required extension "btree_gist"
01:29:28 2935462 INFO  Granting connection privileges on 10.121.163.0/25
01:29:28 2935462 INFO  Reloading Postgres configuration and HBA rules
01:29:28 2935462 INFO  Your pg_auto_failover monitor instance is now ready on port 5432.
01:29:28 2935462 INFO  Monitor has been successfully initialized.
01:29:28 2935444 WARN  pg_autoctl service monitor-init exited with exit status 0
01:29:28 2935461 INFO  Postgres controller service received signal SIGTERM, terminating
01:29:28 2935461 INFO  Stopping pg_autoctl postgres service
01:29:28 2935461 INFO  /opt/vmware/postgres/14/bin/pg_ctl --pgdata /var/lib/pgsql/monitor --wait stop --mode fast
01:29:28 2935444 INFO  Stop pg_autoctl

Error executing command 'sudo systemctl enable pgautofailover': Created symlink /etc/systemd/system/multi-user.target.wants/pgautofailover.service → /etc/systemd/system/pgautofailover.service.

Monitor Node URI:
        Type |    Name | Connection String
-------------+---------+-------------------------------
     monitor | monitor | postgres://autoctl_node@rabbitmq1:5432/pg_auto_failover?sslmode=require   <--- We need to use this URI to create the data node 
   formation | default |


2024-11-12 01:29:29,154 - INFO - Added trust entry to /var/lib/pgsql/monitor/pg_hba.conf
```

Create the Data node
```
[postgres@rabbitmq2 ~]$ ./pg_auto_failover_deploy.py
Are you deploying a monitor node or data node? (monitor/data): data
Environment variables set in pg_env.sh:

export PATH=$PATH:/opt/vmware/postgres/14/bin
export PGDATA=/var/lib/pgsql/ha

To use these variables, run: source pg_env.sh
Enter the monitor node's URI: postgres://autoctl_node@rabbitmq1:5432/pg_auto_failover?sslmode=require
Error executing command 'pg_autoctl create postgres --pgdata ha --auth trust --ssl-self-signed --username ha-admin --dbname appdb --hostname rabbitmq2 --monitor 'postgres://autoctl_node@rabbitmq1:5432/pg_auto_failover?sslmode=require'': 00:24:53 1008457 INFO  Using default --ssl-mode "require"
00:24:53 1008457 INFO  Using --ssl-self-signed: pg_autoctl will create self-signed certificates, allowing for encrypted network traffic
00:24:53 1008457 WARN  Self-signed certificates provide protection against eavesdropping; this setup does NOT protect against Man-In-The-Middle attacks nor Impersonation attacks.
00:24:53 1008457 WARN  See https://www.postgresql.org/docs/current/libpq-ssl.html for details
00:24:53 1008457 INFO  Started pg_autoctl postgres service with pid 1008459
00:24:53 1008459 INFO   /opt/vmware/postgres/14/bin/pg_autoctl do service postgres --pgdata ha -v
00:24:53 1008457 INFO  Started pg_autoctl node-init service with pid 1008460
00:24:53 1008460 INFO  Registered node 1 "node_1" (rabbitmq2:5432) in formation "default", group 0, state "single"
00:24:53 1008460 INFO  Writing keeper state file at "/var/lib/pgsql/.local/share/pg_autoctl/var/lib/pgsql/ha/pg_autoctl.state"
00:24:53 1008460 INFO  Writing keeper init state file at "/var/lib/pgsql/.local/share/pg_autoctl/var/lib/pgsql/ha/pg_autoctl.init"
00:24:53 1008460 INFO  Successfully registered as "single" to the monitor.
00:24:53 1008460 INFO  FSM transition from "init" to "single": Start as a single node
00:24:53 1008460 INFO  Initialising postgres as a primary
00:24:53 1008460 INFO  Initialising a PostgreSQL cluster at "ha"
00:24:53 1008460 INFO  /opt/vmware/postgres/14/bin/pg_ctl initdb -s -D ha --option '--auth=trust'
00:24:54 1008460 WARN  Failed to resolve hostname "rabbitmq2" to an IP address that resolves back to the hostname on a reverse DNS lookup.
00:24:54 1008460 WARN  Postgres might deny connection attempts from "rabbitmq2", even with the new HBA rules.
00:24:54 1008460 WARN  Hint: correct setup of HBA with host names requires proper reverse DNS setup. You might want to use IP addresses.
00:24:54 1008460 WARN  Using IP address "10.121.163.104" in HBA file instead of hostname "rabbitmq2"
00:24:54 1008460 INFO   /bin/openssl req -new -x509 -days 365 -nodes -text -out /var/lib/pgsql/ha/server.crt -keyout /var/lib/pgsql/ha/server.key -subj "/CN=rabbitmq2"
00:24:54 1008485 INFO   /opt/vmware/postgres/14/bin/postgres -D /var/lib/pgsql/ha -p 5432 -h *
00:24:54 1008459 INFO  Postgres is now serving PGDATA "/var/lib/pgsql/ha" on port 5432 with pid 1008485
00:24:54 1008460 INFO  CREATE USER ha-admin
00:24:54 1008460 INFO  CREATE DATABASE appdb;
00:24:54 1008460 INFO  CREATE EXTENSION pg_stat_statements;
00:24:54 1008460 INFO  Disabling synchronous replication
00:24:54 1008460 INFO  Reloading Postgres configuration and HBA rules
00:24:54 1008460 INFO   /bin/openssl req -new -x509 -days 365 -nodes -text -out /var/lib/pgsql/ha/server.crt -keyout /var/lib/pgsql/ha/server.key -subj "/CN=rabbitmq2"
00:24:54 1008460 INFO  Contents of "/var/lib/pgsql/ha/postgresql-auto-failover.conf" have changed, overwriting
00:24:54 1008460 WARN  Failed to resolve hostname "rabbitmq1" to an IP address that resolves back to the hostname on a reverse DNS lookup.
00:24:54 1008460 WARN  Postgres might deny connection attempts from "rabbitmq1", even with the new HBA rules.
00:24:54 1008460 WARN  Hint: correct setup of HBA with host names requires proper reverse DNS setup. You might want to use IP addresses.
00:24:54 1008460 WARN  Using IP address "10.121.163.38" in HBA file instead of hostname "rabbitmq1"
00:24:54 1008460 INFO  Reloading Postgres configuration and HBA rules
00:24:54 1008460 INFO  Transition complete: current state is now "single"
00:24:54 1008460 INFO  keeper has been successfully initialized.
00:24:55 1008457 WARN  pg_autoctl service node-init exited with exit status 0
00:24:55 1008459 INFO  Postgres controller service received signal SIGTERM, terminating
00:24:55 1008459 INFO  Stopping pg_autoctl postgres service
00:24:55 1008459 INFO  /opt/vmware/postgres/14/bin/pg_ctl --pgdata /var/lib/pgsql/ha --wait stop --mode fast
00:24:55 1008457 INFO  Stop pg_autoctl

Error executing command 'sudo systemctl enable pgautofailover': Created symlink /etc/systemd/system/multi-user.target.wants/pgautofailover.service → /etc/systemd/system/pgautofailover.service.

2024-11-12 00:24:55,548 - INFO - Added trust entry to /var/lib/pgsql/ha/pg_hba.conf
[postgres@rabbitmq2 ~]$ . pg_env.sh
[postgres@rabbitmq2 ~]$ pg_autoctl show state
  Name |  Node |      Host:Port |       TLI: LSN |   Connection |      Reported State |      Assigned State
-------+-------+----------------+----------------+--------------+---------------------+--------------------
node_1 |     1 | rabbitmq2:5432 |   1: 0/17625B8 |   read-write |              single |              single
```

