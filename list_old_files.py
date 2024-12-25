#!/usr/bin/env python3

import os
import time
import argparse

def list_old_files(directory, days_threshold):
    try:
        # Convert the days threshold to seconds
        threshold_time = time.time() - (days_threshold * 86400)

        # Walk through the directory and its subdirectories
        for root, dirs, files in os.walk(directory):
            for file in files:
                file_path = os.path.join(root, file)

                # Get the last modification time of the file
                file_mtime = os.path.getmtime(file_path)

                # Compare with the threshold time
                if file_mtime < threshold_time:
                    print(file_path)
    except Exception as e:
        print(f"Error: {e}")

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="List files older than a specified number of days.")
    parser.add_argument("directory", type=str, help="Path to the directory to scan.")
    parser.add_argument("days", type=int, help="Age threshold in days.")
    
    # Parse arguments
    args = parser.parse_args()
    directory = args.directory
    days = args.days

    # Validate directory
    if not os.path.isdir(directory):
        print(f"Error: The provided path '{directory}' is not a valid directory.")
        exit(1)

    # Run the listing function
    print(f"Listing files older than {days} days in '{directory}':")
    list_old_files(directory, days)

if __name__ == "__main__":
    main()
