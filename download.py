#! /usr/bin/python3
import subprocess
import os
import requests
import json
from tabulate import tabulate

BASE_URL = "https://network.tanzu.vmware.com/api/v2"

def get_refresh_token():
    home = os.path.expanduser("~")
    token_file = os.path.join(home, ".REFRESH_TOKEN")
    if os.path.exists(token_file):
        with open(token_file, 'r') as f:
            return f.read().strip()
    else:
        return input("Please enter your REFRESH_TOKEN: ")

def get_access_token(refresh_token):
    url = f"{BASE_URL}/authentication/access_tokens"
    headers = {"Content-Type": "application/json"}
    data = {"refresh_token": refresh_token}
    response = requests.post(url, headers=headers, json=data)
    return response.json()['access_token']

def get_products(access_token):
    url = f"{BASE_URL}/products"
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }
    response = requests.get(url, headers=headers)
    products = response.json()['products']
    filtered_products = [p for p in products if 'greenplum' in p['name'].lower() or 'postgres' in p['name'].lower() or 'rabbit' in p['name'].lower() or 'data' in p['name'].lower()] 
    return filtered_products

def get_releases(access_token, product_slug):
    url = f"{BASE_URL}/products/{product_slug}/releases"
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }
    response = requests.get(url, headers=headers)
    return response.json()['releases']

def accept_eula(access_token, eula_url):
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }
    response = requests.post(eula_url, headers=headers)
    return response.status_code == 200

def get_product_files(access_token, product_files_url):
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }
    response = requests.get(product_files_url, headers=headers)
    return response.json()['product_files']

def get_download_url(access_token, download_url):
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }
    response = requests.post(download_url, headers=headers, allow_redirects=False)
    return response.headers['Location']

def download_file(url, filename):
# Ensure the target directory exists
    target_dir = "/data/packages"
    os.makedirs(target_dir, exist_ok=True)
    
    # Full path for the downloaded file
    full_path = os.path.join(target_dir, filename)
    
    response = requests.get(url, stream=True)
    with open(full_path, 'wb') as f:
        for chunk in response.iter_content(chunk_size=8192):
            f.write(chunk)
    print(f"File downloaded to: {full_path}")
    return full_path

def install_rpm_if_needed(filename):
    # Check if the downloaded file is a Greenplum RPM
    if "greenplum-db-" in filename and any(rhel_version in filename for rhel_version in ["rhel7", "rhel8", "rhel9","el8","el9"]):
        # Check for existing Greenplum RPM installations
        installed_rpms = subprocess.getoutput("rpm -qa | grep greenplum-db")
        if installed_rpms:
            print("Existing Greenplum RPMs found:")
            print(installed_rpms)
            # Remove existing RPMs
            for rpm in installed_rpms.splitlines():
                print(f"Removing {rpm}...")
                subprocess.run(["sudo","rpm", "-e", "--justdb", rpm], check=True)

        # Prompt user to install the new RPM
        print(f"Installing {filename}...")
        subprocess.run(["sudo","rpm", "-ivh", filename], check=True)

        # Change ownership of the installed directory
        version = filename.split('-')[2]  # Extract version from filename
        directory = f"/usr/local/greenplum-db-{version}"
        print(f"Changing ownership of {directory} to gpadmin:gpadmin...")
        subprocess.run(["sudo","chown", "-R", "gpadmin:gpadmin", directory], check=True)


def main():
    refresh_token = get_refresh_token()
    access_token = get_access_token(refresh_token)

    products = get_products(access_token)
    print("Available products:")
    for i, product in enumerate(products, 1):
        print(f"{i}. {product['name']} ({product['slug']})")

    product_choice = int(input("Enter the number of the product you want to download: ")) - 1
    chosen_product = products[product_choice]

    releases = get_releases(access_token, chosen_product['slug'])
    print("\nAvailable releases:")
    release_data = []
    for i, release in enumerate(releases, 1):
        release_data.append([i, release['version'], release['end_of_support_date']])
    print(tabulate(release_data, headers=["#", "Version", "End of Support"]))

    release_choice = int(input("Enter the number of the release you want to download: ")) - 1
    chosen_release = releases[release_choice]

    if not accept_eula(access_token, chosen_release['_links']['eula_acceptance']['href']):
        print("Failed to accept EULA. Exiting.")
        return

    product_files = get_product_files(access_token, chosen_release['_links']['product_files']['href'])
    print("\nAvailable files:")
    for i, file in enumerate(product_files, 1):
        print(f"{i}. {file['name']}")

    file_choice = int(input("Enter the number of the file you want to download: ")) - 1
    chosen_file = product_files[file_choice]

    download_url = get_download_url(access_token, chosen_file['_links']['download']['href'])
    filename = chosen_file['aws_object_key'].split('/')[-1]
    print(f"Downloading {filename}...")
    full_path = download_file(download_url, filename)
    print (f"Full Path is {full_path}")
    if "greenplum-db-" in filename and any(rhel_version in filename for rhel_version in ["rhel7", "rhel8", "rhel9","el8","el9"]):
        install_choice = input(f"Do you want to install {filename}? (yes/no, we only support install the GPDB RPM files now): ").strip().lower()
        if install_choice == 'yes':
            install_rpm_if_needed(full_path)
            
    print(f"Download complete. File saved as {filename}")

if __name__ == "__main__":
    main()
