#!/bin/python3
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

def pivnet_login(api_token):
    """Login to Pivotal Network (PivNet) using the provided API token."""
    command = f"pivnet login --api-token {api_token}"
    output = run_command(command)
    print(output)

def accept_eula(product_slug, release_version):
    """Accept EULA for the specified product and release version."""
    command = f"pivnet accept-eula --product-slug='{product_slug}' --release-version='{release_version}'"
    output = run_command(command)
    print(output)

def download_greenplum(product_slug, release_version, os_version):
    """Download Greenplum for the specified product, release version, and OS version."""
    if os_version == 'redhat 7':
        file_name = f"greenplum-db-{release_version}-rhel7-x86_64.rpm"
    elif os_version == 'redhat 8':
        file_name = f"greenplum-db-{release_version}-el8-x86_64.rpm"
    else:
        print(f"Unsupported OS version: {os_version}")
        sys.exit(1)

    command = f"pivnet download-product-files --product-slug='{product_slug}' --release-version='{release_version}' -g '{file_name}'"
    output = run_command(command)
    print(output)

def list_greenplum_versions(product_slug):
    """List available Greenplum versions."""
    command = f"pivnet rs --product-slug='{product_slug}' | awk -F '|' 'NR>3 && $3 != \"\" {{print $3}}' | sort -r -V"
    output = run_command(command)
    versions = [version.strip() for version in output.split('\n') if version.strip()]
    return versions

def select_greenplum_version(product_slug):
    """Ask user to select a Greenplum version."""
    versions = list_greenplum_versions(product_slug)
    if not versions:
        print("No Greenplum versions found.")
        sys.exit(1)

    while True:
        print("Available Greenplum versions:")
        for idx, version in enumerate(versions, start=1):
            print(f"{idx}. {version}")
        
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
        os_version = input("Enter your OS version (redhat 7, redhat 8): ").strip().lower()
        if os_version in ['redhat 7', 'redhat 8']:
            return os_version
        else:
            print("Unsupported OS version. Please choose from redhat 7 or redhat 8.")

def main():
    try:
        # Ask for PivNet token
        pivnet_token = input("Enter your PivNet API token: ").strip()
        pivnet_login(pivnet_token)

        # Ask for OS version
        os_version = select_os_version()

        # Select Greenplum version
        product_slug = 'vmware-greenplum'
        greenplum_version = select_greenplum_version(product_slug)

        # Accept EULA and download Greenplum
        accept_eula(product_slug, greenplum_version)
        download_greenplum(product_slug, greenplum_version, os_version)

    except KeyboardInterrupt:
        print("\nProcess interrupted. Exiting...")
        sys.exit(1)

if __name__ == "__main__":
    main()

