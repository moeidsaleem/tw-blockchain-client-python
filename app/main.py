from blockchain_client import BlockchainClient

def main():
    client = BlockchainClient("https://polygon-rpc.com/")
    block_number = client.get_block_number()
    print("Block number:", block_number)

    block = client.get_block_by_number(int(block_number["result"], 16))
    print("Block details:", block)

if __name__ == "__main__":
    main()