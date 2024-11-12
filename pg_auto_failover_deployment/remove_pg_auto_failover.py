#!/usr/bin/env python3
import logging
import os
import subprocess
import shutil

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def run_command(command):
    try:
        result = subprocess.run(command, check=True, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        logger.error(f"Command failed: {e}")
        return None

def remove_service():
    logger.info("Attempting to stop pgautofailover.service")
    run_command("sudo systemctl stop pgautofailover.service")
    
    logger.info("Disabling pgautofailover.service")
    run_command("sudo systemctl disable pgautofailover.service")
    
    logger.info("Removing pgautofailover.service file")
    run_command("sudo rm /etc/systemd/system/pgautofailover.service")
    
    logger.info("Reloading systemd daemon")
    run_command("sudo systemctl daemon-reload")
    
    logger.info("Resetting failed units")
    run_command("sudo systemctl reset-failed")

def delete_folders():
    home_dir = os.path.expanduser("~")
    folders_to_delete = ["monitor", "ha", ".config", ".local"]
    
    for folder in folders_to_delete:
        folder_path = os.path.join(home_dir, folder)
        if os.path.exists(folder_path):
            logger.info(f"Deleting folder: {folder_path}")
            try:
                shutil.rmtree(folder_path)
                logger.info(f"Successfully deleted {folder_path}")
            except Exception as e:
                logger.error(f"Failed to delete {folder_path}: {e}")
        else:
            logger.info(f"Folder not found: {folder_path}")

if __name__ == "__main__":
    logger.info("Starting cleanup process")
    
    remove_service()
    delete_folders()
    
    logger.info("Cleanup process completed")
