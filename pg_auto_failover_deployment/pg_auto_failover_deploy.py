#!/usr/bin/env python3
import os
import subprocess
import glob 
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Define ANSI escape codes for colors
RED = '\033[91m'
RESET = '\033[0m'

def run_command(command):
    try:
        result = subprocess.run(command, check=True, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
        return result.stdout, result.stderr
    except subprocess.CalledProcessError as e:
        logger.error(f"Command failed: {e}")
        return None, str(e)

def get_postgres_version():
    postgres_dirs = glob.glob('/opt/vmware/postgres/*')
    if not postgres_dirs:
        raise Exception("No PostgreSQL installation found in /opt/vmware/postgres/")

    versions = [os.path.basename(dir) for dir in postgres_dirs]
    versions.sort(key=lambda v: [int(x) for x in v.split('.')], reverse=True)
    return versions[0]

def deploy_pg_auto_failover():
    # Ask user for node type
    node_type = input("Are you deploying a monitor node or data node? (monitor/data): ").strip().lower()
    if node_type not in ['monitor', 'data']:
        print("Invalid node type. Please enter 'monitor' or 'data'.")
        return

    # Set up environment variables
    main_version = get_postgres_version() 
    bin_path = f'/opt/vmware/postgres/{main_version}/bin'
    os.environ['PATH'] += f':{bin_path}'
    pgdata_dir = os.path.expanduser('~') + ('/monitor' if node_type == 'monitor' else '/ha')
    os.environ['PGDATA'] = pgdata_dir

    env_script = f"""
export PATH=$PATH:{bin_path}
export PGDATA={pgdata_dir}
"""

    # Write the environment script
    with open('pg_env.sh', 'w') as f:
        f.write(env_script)

    print(f"Environment variables set in pg_env.sh:")
    print(env_script)
    print(f"{RED}To use these variables, run: source pg_env.sh{RESET}")


    # Continue with the rest of your deployment logic here
    # ...

    #DEBUG Print is here
    #print(f"Exporting environment variables:\nexport PATH=$PATH:{bin_path}\nexport PGDATA={pgdata_dir}")

    # Check and delete existing folders
    for folder in ["~/monitor", "~/ha"]:
        if os.path.exists(os.path.expanduser(folder)):
            delete_confirmation = input(f"Directory {folder} exists. Do you want to delete it? (yes/no): ").strip().lower()
            if delete_confirmation == 'yes':
                os.system(f'rm -rf {os.path.expanduser(folder)}')

    for config_folder in ["~/.config", "~/.local"]:
        if os.path.exists(os.path.expanduser(config_folder)):
            delete_confirmation = input(f"Directory {config_folder} exists. Do you want to delete it? (yes/no): ").strip().lower()
            if delete_confirmation == 'yes':
                os.system(f'rm -rf {os.path.expanduser(config_folder)}')

    # Deploy based on node type
    if node_type == 'monitor':
        deploy_monitor_node()
    else:
        deploy_data_node()

def deploy_monitor_node():
    commands = [
        'pg_autoctl create monitor --auth trust --ssl-self-signed --pgdata ~/monitor',
        'pg_autoctl -q show systemd --pgdata ~/monitor > pgautofailover.service',
        'sudo mv pgautofailover.service /etc/systemd/system',
        'sudo restorecon -v /etc/systemd/system/pgautofailover.service',
        'sudo systemctl daemon-reload',
        'sudo systemctl enable pgautofailover',
        'sudo systemctl start pgautofailover'
    ]

    for cmd in commands:
        stdout, stderr = run_command(cmd)
        if stderr:
            print(f"Error executing command '{cmd}': {stderr}")

    # Print monitor node URI
    stdout, stderr = run_command('pg_autoctl show uri')
    if stdout:
        print("Monitor Node URI:")
        print(stdout)
    else:
        print("Error retrieving monitor node URI:", stderr)

def deploy_data_node():
    monitor_uri = input("Enter the monitor node's URI: ").strip()
    hostname = os.popen('hostname').read().strip()

    commands = [
        f"pg_autoctl create postgres --pgdata ~/ha --auth trust --ssl-self-signed --username ha-admin --dbname appdb --hostname {hostname} --monitor '{monitor_uri}'",
        'pg_autoctl -q show systemd --pgdata ~/ha > pgautofailover.service',
        'sudo mv pgautofailover.service /etc/systemd/system',
        'sudo restorecon -v /etc/systemd/system/pgautofailover.service',
        'sudo systemctl daemon-reload',
        'sudo systemctl enable pgautofailover',
        'sudo systemctl start pgautofailover'
    ]

    for cmd in commands:
        stdout, stderr = run_command(cmd)
        if stderr:
            print(f"Error executing command '{cmd}': {stderr}")

def add_trust_entry_to_pg_hba():
    def identify_pgdata_directory():
        home_dir = os.path.expanduser('~')
        possible_directories = [os.path.join(home_dir, 'ha'), os.path.join(home_dir, 'monitor')]
        for directory in possible_directories:
            if os.path.exists(directory):
                return directory
        return None

    pgdata_directory = identify_pgdata_directory()
    if not pgdata_directory:
        logger.error("PGDATA directory not found in ~/ha or ~/monitor")
        return

    pg_hba_path = os.path.join(pgdata_directory, 'pg_hba.conf')
    trust_entry = "host all all 0.0.0.0/0 trust\n"

    try:
        if not os.path.exists(pg_hba_path):
            logger.error(f'pg_hba.conf not found at {pg_hba_path}')
            return

        with open(pg_hba_path, 'a') as pg_hba_file:
            pg_hba_file.write(trust_entry)
        logger.info(f'Added trust entry to {pg_hba_path}')
    except Exception as e:
        logger.error(f'Error modifying pg_hba.conf: {e}')

if __name__ == "__main__":
    deploy_pg_auto_failover()
    add_trust_entry_to_pg_hba()


