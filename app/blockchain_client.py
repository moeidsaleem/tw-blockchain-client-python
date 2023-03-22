import requests
import json
from logger import setup_logger

logger = setup_logger()

class BlockchainClient:
    def __init__(self, host):
        self.host = host
        self.headers = {'Content-Type': 'application/json'}

    def send_request(self, method, params=None, request_id=1):
        payload = {
            "jsonrpc": "2.0",
            "method": method,
            "params": params,
            "id": request_id,
        }
        response = requests.post(self.host, headers=self.headers, data=json.dumps(payload))
        response.raise_for_status()

        logger.info(f"Request: {json.dumps(payload)}")
        logger.info(f"Response: {json.dumps(response.json())}")

        return response.json()

    def get_block_number(self):
        return self.send_request("eth_blockNumber")

    def get_block_by_number(self, block_number, transaction_details=True):
        hex_block_number = hex(block_number)
        return self.send_request("eth_getBlockByNumber", [hex_block_number, transaction_details])
