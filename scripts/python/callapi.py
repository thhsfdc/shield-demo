import requests
import json
import os
import datetime
import logging

# --- Configuration for Logging ---
script_dir = os.path.dirname(os.path.abspath(__file__))
script_name = os.path.splitext(os.path.basename(__file__))[0]
current_time_str = datetime.datetime.now().strftime("%y%m%d%H%M%S")
LOG_FILE_NAME = f"{script_name}-{current_time_str}.log"
LOG_FILE_PATH = os.path.join(script_dir, LOG_FILE_NAME)

# --- Set up Logging ---
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

fh = logging.FileHandler(LOG_FILE_PATH)
fh.setLevel(logging.DEBUG)

ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)

formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
fh.setFormatter(formatter)
ch.setFormatter(formatter)

logger.addHandler(fh)
logger.addHandler(ch)

# --- Salesforce API Configuration ---
CONFIG_FILE_NAME = 'sforginfo.json'
config_file_path = os.path.join(script_dir, CONFIG_FILE_NAME)
API_ENDPOINT_PATH = '/services/apexrest/OrgInfoAPI'

def load_config(file_path):
    """
    Loads Salesforce credentials from a JSON configuration file.
    """
    logger.debug(f"Attempting to load configuration from: {file_path}")
    try:
        with open(file_path, 'r') as f:
            config = json.load(f)
        logger.info(f"Configuration loaded successfully from {file_path}")
        # Log config details, but mask sensitive information
        debug_config = config.copy()
        if 'SALESFORCE_CONSUMER_SECRET' in debug_config:
            debug_config['SALESFORCE_CONSUMER_SECRET'] = '********'
        logger.debug(f"Loaded config: {debug_config}")
        return config
    except FileNotFoundError:
        logger.error(f"Configuration file '{file_path}' not found. Please create it.")
        return None
    except json.JSONDecodeError as e:
        logger.error(f"Could not decode JSON from '{file_path}'. Check file format. Error: {e}")
        return None
    except Exception as e:
        logger.error(f"An unexpected error occurred while loading config: {e}")
        return None

def get_salesforce_access_token_client_credentials(config):
    """
    Authenticates with Salesforce using the OAuth 2.0 Client Credentials Flow
    and returns an access token.
    """
    if not config:
        logger.warning("Cannot get access token: Configuration not loaded.")
        return None, None

    token_url = f"{config['SALESFORCE_LOGIN_URL']}/services/oauth2/token"
    logger.debug(f"Authentication URL: {token_url}")

    headers = {'Content-Type': 'application/x-www-form-urlencoded'}
    payload = {
        'grant_type': 'client_credentials', # Key change for Client Credentials Flow
        'client_id': config['SALESFORCE_CONSUMER_KEY'],
        'client_secret': config['SALESFORCE_CONSUMER_SECRET']
    }
    # Create a debug-friendly version of the payload
    debug_payload = payload.copy()
    if 'client_secret' in debug_payload:
        debug_payload['client_secret'] = '********' # Mask secret in logs
    logger.debug(f"Authentication Request Headers: {headers}")
    logger.debug(f"Authentication Request Payload (masked): {debug_payload}")

    try:
        logger.info("Attempting to get Salesforce access token using Client Credentials flow...")
        response = requests.post(token_url, headers=headers, data=payload)

        # Log full response details
        logger.debug(f"Authentication Response Status Code: {response.status_code}")
        logger.debug(f"Authentication Response Headers: {response.headers}")
        logger.debug(f"Authentication Response Body: {response.text}")

        response.raise_for_status() # Raise an exception for HTTP errors (4xx or 5xx)
        token_data = response.json()
        logger.info("Access token obtained successfully.")
        logger.debug(f"Received Token Data: {token_data}")
        
        # The 'instance_url' in client credentials flow might be a bit different,
        # often it's the login_url or the base URL. For OrgInfoAPI, we prefer My Domain.
        # So we'll use the configured SALESFORCE_INSTANCE_URL from config.json.
        instance_url_from_response = token_data.get('instance_url', config['SALESFORCE_INSTANCE_URL'])
        
        return token_data['access_token'], instance_url_from_response
    except requests.exceptions.RequestException as e:
        logger.error(f"Error getting Salesforce access token via Client Credentials: {e}")
        if response is not None:
            logger.error(f"Authentication Response Error (from server): {response.text}")
        return None, None

# The call_org_info_api function remains exactly the same as it just needs the token and instance URL.
def call_org_info_api(access_token, instance_url):
    """
    Calls the Salesforce OrgInfoAPI endpoint using the obtained access token.
    """
    if not access_token or not instance_url:
        logger.warning("Cannot call API: Missing access token or instance URL.")
        return

    api_url = f"{instance_url}{API_ENDPOINT_PATH}"
    logger.debug(f"API Call URL: {api_url}")

    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    }
    logger.debug(f"API Call Request Headers: {headers}")

    try:
        logger.info(f"Calling OrgInfoAPI: {api_url}")
        response = requests.get(api_url, headers=headers)

        # Log full response details
        logger.debug(f"API Call Response Status Code: {response.status_code}")
        logger.debug(f"API Call Response Headers: {response.headers}")
        logger.debug(f"API Call Response Body: {response.text}")

        response.raise_for_status() # Raise an exception for HTTP errors
        return response.json()
    except requests.exceptions.RequestException as e:
        logger.error(f"Error calling OrgInfoAPI: {e}")
        if response is not None:
            logger.error(f"API Call Response Error (from server): {response.text}")
        return None

if __name__ == "__main__":
    logger.info(f"Script started. Logging to: {LOG_FILE_PATH}")

    # Load configuration
    salesforce_config = load_config(config_file_path)

    if salesforce_config:
        # Get access token using Client Credentials flow
        access_token, instance_url = get_salesforce_access_token_client_credentials(salesforce_config)
        logger.debug(f"Access Token (first 10 chars): {access_token[:10]}...")
        logger.debug(f"Instance URL: {instance_url}")

        if access_token and instance_url:
            # Call the Apex REST API
            org_info = call_org_info_api(access_token, instance_url)

            if org_info:
                logger.info("\n--- Org Information Retrieved Successfully ---")
                logger.info(json.dumps(org_info, indent=4))
            else:
                logger.error("Failed to retrieve Org Information.")
        else:
            logger.error("Authentication failed. Cannot proceed with API call.")
    else:
        logger.critical("Script cannot run without valid configuration.")
    logger.info("Script finished.")