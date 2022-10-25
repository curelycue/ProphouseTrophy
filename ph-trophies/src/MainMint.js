import { useState } from 'react';
import { ethers, BigNumber } from 'ethers';
import TrophyMinter from './TrophyMinter.json';

const TrophyMinterAddress = "";

const MainMint = ({ accounts, setAccounts }) => {
    const isConnected = Boolean(accounts[0]);

    async function handleMint() {
        if (window.ethereum) {
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            const contract = new ethers.Contract(
                TrophyMinterAddress,
                TrophyMinter.abi,
                signer
            );
            try {
                const response = await contract.mint();
                console.log('response: ', response);
            }   catch (err) {
                console.log("err: ", err)
            }
        }
    }

    return (
        <div>
            <h1>Evolvable Prop House Trophies</h1>
            <p>Mint your Trophy and evolve it by submiting your results now.</p>
            {isConnected ? (
                <div>
                    <div>
                        <div>
                        <button>Check if you are Eligibille</button>
                        </div>
                        <button onClick={handleMint}>Mint Now</button>
                    </div>
                    <button>Evolve your Trophy</button>
                </div>
            ) : (
                <p>You must be connected to Mint.
                You must be a Prop House winner to Mint.</p>
            )}
        </div>
    );
};

export default MainMint;