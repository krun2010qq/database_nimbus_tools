#!/bin/python3
import json
import os
import subprocess
import sys

def run_command(command):
    """Run shell command and capture output."""
    try:
        result = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error executing command '{command}': {e.stderr}")
        sys.exit(1)

def download_greenplum(product_slug, release_version, os_version, pivnet_token):
    """Download Greenplum for the specified product, release version, and OS version."""
    if release_version.startswith('6') or release_version.startswith('5'):
        if os_version == 'redhat7':
            file_name = f"greenplum-db-{release_version}-rhel7-x86_64.rpm"
        elif os_version == 'redhat8':
            file_name = f"greenplum-db-{release_version}-rhel8-x86_64.rpm"
        elif os_version == 'redhat9':
            file_name = f"greenplum-db-{release_version}-rhel9-x86_64.rpm"
        else:
            print(f"Unsupported OS version: {os_version}")
            sys.exit(1)
    elif release_version.startswith('7'):
        if os_version == 'redhat8':
            file_name = f"greenplum-db-{release_version}-el8-x86_64.rpm"
        elif os_version == 'redhat9':
            file_name = f"greenplum-db-{release_version}-el8-x86_64.rpm"
        else:
            print(f"Unsupported OS version: {os_version}")
            sys.exit(1)
    else:
        print (f"Something is wrong,release version:{release_version}, os: {os_version}")
        sys.exit(1)

#    command = f"pivnet download-product-files --product-slug='{product_slug}' --release-version='{release_version}' -g '{file_name}'"
    print("Starting to run the OM CLI")
    command = f"om download-product --pivnet-product-slug='vmware-greenplum' --product-version='{release_version}' --file-glob='{file_name}' --output-directory=./ --pivnet-api-token='{pivnet_token}'"
    output = run_command(command)
    print(output)

def list_greenplum_versions(product_slug):
    """List available Greenplum versions."""
    curl_command = f"curl -s https://network.tanzu.vmware.com/api/v2/products/{product_slug}/releases"
    result = subprocess.run(curl_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)

    # Debugging: Print stdout and stderr
    # print("stdout:", result.stdout)
    # print("stderr:", result.stderr)

    if result.returncode != 0:
        print("Curl command failed.")
        return []

    # Check if stdout is empty
    if not result.stdout:
        print("No output from curl command.")
        return []

    # Parse the JSON output
    try:
        data = json.loads(result.stdout)
    except json.JSONDecodeError as e:
        print(f"JSON decoding failed: {e}")
        return []

    # Extract versions
    releases = data.get('releases', [])
    versions = [release['version'] for release in releases]

    return versions


def select_greenplum_version(product_slug):
    """Ask user to select a Greenplum version."""
    versions = list_greenplum_versions(product_slug)
    if not versions:
        print("No versions found.")
        sys.exit(1)
    while True:
        print("Available versions:")
        for idx in range(0, len(versions), 6):
            line = versions[idx:idx + 6]
            print("  ".join(f"{i+1}:[{v}]" for i, v in enumerate(line, start=idx)))

        version_choice = input("Enter the number corresponding to the Greenplum version you want to download: ").strip()
        try:
            version_index = int(version_choice) - 1
            if 0 <= version_index < len(versions):
                return versions[version_index]
            else:
                print("Invalid choice. Please enter a valid number.")
        except ValueError:
            print("Invalid input. Please enter a valid number.")

def select_os_version():
    """Ask user to select an OS version."""
    while True:
        os_version = input("Enter your OS version (redhat7, redhat8,redhat9): ").strip().lower()
        if os_version in ['redhat7', 'redhat8','redhat9']:
            return os_version
        else:
            print("Unsupported OS version. Please choose from redhat7,redhat8,redhat9.")

def main():
    try:
        # Ask for PivNet token
        if os.path.exists('.pivnet_token'):
            print("Found the Pivnet Token on the local system, using the local token to login")
            with open('.pivnet_token', 'r') as file:
                pivnet_token = file.read().strip()
        else:
           pivnet_token = input("Enter your PivNet API token: ").strip()
	# Ask for OS version
        print("Logging in the Pivnet")
        os_version = select_os_version()

        # Select Greenplum version
        product_slug = 'vmware-greenplum'
        greenplum_version = select_greenplum_version(product_slug)

        # Accept EULA and download Greenplum
        #accept_eula(product_slug, greenplum_version)
        download_greenplum(product_slug, greenplum_version, os_version, pivnet_token)

    except KeyboardInterrupt:
        print("\nProcess interrupted. Exiting...")
        sys.exit(1)

if __name__ == "__main__":
    main()

