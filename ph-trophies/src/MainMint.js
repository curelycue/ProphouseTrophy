import { useState } from 'react';
import { ethers, BigNumber } from 'ethers';
import { Box, Button, Flex, Input, Text } from "@chakra-ui/react";
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
        <Flex justify="center" align="center" height="100vh" paddingBottom="150px">
        <Box width="520px">
            <div>
            <Text fontSize="48px" textShadow="0 5px #000000">Evolvable Prop House Trophies</Text>
            <Text
                fontSize="30px"
                letterSpacing="-5.5%"
                fontFamily="VT323"
                textShadow="0 2px 2px #000000"
                >
                Mint your Trophy and evolve it by submiting your results now.
                </Text>
            </div>
            {isConnected ? (
                <div>
                    <div>
                        <div>
                        <button>Check if you are Eligibille</button>
                        </div>
                        <Button
                        backgroundColor="#D6517D"
                        borderRadius="5px"
                        boxShadow="0px 2px 2px 1px #0F0F0F"
                        color="white"
                        cursor="pointer"
                        fontFamily="inherit"
                        padding="15px"
                        marginTop="10px"
                        onClick={handleMint}
                        >
                            Mint Now
                            </Button>
                    </div>
                    <button>Evolve your Trophy</button>
                </div>
            ) : (
                <Text
                    marginTop="70px"
                    fontSize="30px"
                    letterSpacing="-5.5%"
                    fontFamily="VT323"
                    textShadow="0 3px #000000"
                    color="#D6517D"
                >
                    You must be connected to Mint.
                You must be a Prop House winner to Mint.
                </Text>
            )}
        </Box>
        </Flex>
    );
};

export default MainMint;