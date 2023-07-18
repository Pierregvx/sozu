import { ConnectWallet, useAddress, useUser } from "@thirdweb-dev/react";
import { NextPage } from "next";
import { ThirdwebSDK } from "@thirdweb-dev/sdk";
import { ethers } from "ethers";
import abi from "./abi.json";
import styles from "../styles/Home.module.css";
import Image from "next/image";

const Home: NextPage = () => {
  const contractAddress = "0xBc5e74A60B4774931EaF5a5FC484d3cE0334601e";
  const caller = new ethers.Wallet("pr_key");

  const sdk = ThirdwebSDK.fromSigner(caller, "mantle");
  const uri = "https://drive.google.com/uc?export=download&id=1n5h_vehv648X_kRohYaoMU-z2lU2Oh1d"

  async function signMessage() {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const message = ethers.utils.solidityKeccak256(
      ['address', 'uint256', 'string', 'address'],
      [address?.toString(), 1, "https:", contractAddress]
    ); 
    const signer = provider.getSigner();
    const signature = await signer.signMessage(message);
    const contract = await sdk.getContract(contractAddress, abi);
    const tx = await contract.call("metaMint", [1, address?.toString(), 1, signature, uri]);
    console.log(tx);
    return tx;
  }

  const address = useAddress();
  const isConnected = !!address;
  const { user, isLoggedIn } = useUser();

  return (
    <main className={styles.main}>
      <div className={styles.container}>
        <div className={styles.header}>
          <div className={styles.connect}>
            <ConnectWallet
              dropdownPosition={{
                side: "bottom",
                align: "center",
              }}
            />
          </div>
          
          {isConnected && (
            <div className={styles.address}>
              <button className={styles.mintButton} onClick={signMessage}>
                Mint NFT
              </button>
              <img src={uri}></img>
               </div>
          )}
        </div>
      </div>
    </main>
  );
};

export default Home;
