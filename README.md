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
