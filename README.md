# database_nimbus_tools

### The Download Tool Usage

1) The script would directly ask you for the Pivnet Token
2) The script would also try to detect if there is any .pivnet token file. If it has the `.pivnet` token file, then it would bypass the authentication and directly download the GPDB

### Example: 

```
[gpadmin@cdw-rp11 database_nimbus_tools]$ ./download.py
Found the Pivnet Token on the local system, using the local token to login
Logging in the Pivnet
Warning: The use of static Pivnet API tokens is deprecated and will be removed. Please see https://network.tanzu.vmware.com/docs/api#how-to-authenticate for details on the new UAA API Token mechanism.
Logged-in successfully
Enter your OS version (redhat7, redhat8,redhat9): redhat8
Available Greenplum versions:
1:[7.2.0]  2:[7.1.0]  3:[7.0.0]  4:[6.99.89]  5:[6.99.89]  6:[6.99.89]
7:[6.99.89]  8:[6.99.89]  9:[6.99.89]  10:[6.99.89]  11:[6.99.89]  12:[6.99.89]
13:[6.27.3]  14:[6.27.2]  15:[6.27.1]  16:[6.27.0]  17:[6.26.6]  18:[6.26.5]
19:[6.26.4]  20:[6.26.3]  21:[6.26.2]  22:[6.26.1]  23:[6.26.0]  24:[6.25.5]
25:[6.25.4]  26:[6.25.3]  27:[6.25.2]  28:[6.25.1]  29:[6.24.6]  30:[6.24.5]
31:[6.24.4]  32:[6.24.3]  33:[6.23.5]  34:[6.23.4]  35:[6.23.3]  36:[6.23.1]
37:[6.23.0]  38:[6.22.3]  39:[6.22.2]  40:[6.22.1]  41:[6.22.0]  42:[6.21.3]
43:[6.21.2]  44:[6.21.1]  45:[6.21.0]  46:[6.20.5]  47:[6.20.4]  48:[6.20.3]
49:[6.20.1]  50:[6.20.0]  51:[6.19.4]  52:[6.19.3]  53:[6.19.2]  54:[6.19.1]
55:[6.19.0]  56:[6.18.2]  57:[6.18.1]  58:[6.18.0]  59:[6.17.7]  60:[6.17.6]
61:[6.17.5]  62:[6.17.4]  63:[6.17.3]  64:[6.17.2]  65:[6.17.1]  66:[6.17.0]
67:[6.16.3]  68:[6.16.2]  69:[6.16.1]  70:[6.16.0]  71:[6.15.0]  72:[6.14.1]
73:[6.14.0]  74:[6.13.0]  75:[6.12.1]  76:[6.12.0]  77:[6.11.2]  78:[6.11.1]
79:[6.11.0]  80:[6.10.1]  81:[6.10.0]  82:[6.9.1]  83:[6.9.0]  84:[6.8.1]
85:[6.8.0]  86:[6.7.1]  87:[6.7.0]  88:[6.6.0]  89:[6.5.0]  90:[6.4.0]
91:[6.3.0]  92:[6.2.1]  93:[6.1.0]  94:[6.0.1]  95:[6.0.0]  96:[5.30.0]
97:[5.29.12]  98:[5.29.11]  99:[5.29.10]  100:[5.29.8]  101:[5.29.7]  102:[5.29.6]
103:[5.29.5]  104:[5.29.4]  105:[5.29.3]  106:[5.29.2]  107:[5.29.1]  108:[5.29.0]
109:[2.11.2]
Enter the number corresponding to the Greenplum version you want to download: 1
EULA acccepted for vmware-greenplum/7.2.0
2024/07/25 11:11:50 Downloading 'greenplum-db-7.2.0-el8-x86_64.rpm' to 'greenplum-db-7.2.0-el8-x86_64.rpm'

 0 B / 160.39 MiB [----------------------------------------------------]   0.00%
 160.39 MiB / 160.39 MiB [==========================================] 100.00% 1s
2024/07/25 11:11:53 Verifying SHA256
2024/07/25 11:11:53 Successfully verified SHA256
```


### How to deploy the pg_auto_failover automatically

// Firstly remove all the previous installations
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

// Then set up the monitor
```
[postgres@rabbitmq1 pg_auto_failover_deployment]$ ./remove_pg_auto_failover.py
2024-11-12 01:29:22,562 - INFO - Starting cleanup process
2024-11-12 01:29:22,562 - INFO - Attempting to stop pgautofailover.service
2024-11-12 01:29:22,583 - INFO - Disabling pgautofailover.service
2024-11-12 01:29:22,711 - INFO - Removing pgautofailover.service file
2024-11-12 01:29:22,725 - INFO - Reloading systemd daemon
2024-11-12 01:29:22,855 - INFO - Resetting failed units
2024-11-12 01:29:22,873 - INFO - Folder not found: /var/lib/pgsql/monitor
2024-11-12 01:29:22,873 - INFO - Folder not found: /var/lib/pgsql/ha
2024-11-12 01:29:22,873 - INFO - Deleting folder: /var/lib/pgsql/.config
2024-11-12 01:29:22,873 - INFO - Successfully deleted /var/lib/pgsql/.config
2024-11-12 01:29:22,873 - INFO - Deleting folder: /var/lib/pgsql/.local
2024-11-12 01:29:22,873 - INFO - Successfully deleted /var/lib/pgsql/.local
2024-11-12 01:29:22,873 - INFO - Cleanup process completed
[postgres@rabbitmq1 pg_auto_failover_deployment]$ ./pg_auto_failover_deploy.py
Are you deploying a monitor node or data node? (monitor/data): monitor
Environment variables set in pg_env.sh:

export PATH=$PATH:/opt/vmware/postgres/14/bin
export PGDATA=/var/lib/pgsql/monitor

To use these variables, run: source pg_env.sh
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
     monitor | monitor | postgres://autoctl_node@rabbitmq1:5432/pg_auto_failover?sslmode=require
   formation | default |


2024-11-12 01:29:29,154 - INFO - Added trust entry to /var/lib/pgsql/monitor/pg_hba.conf
```

// Create the Data node
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

