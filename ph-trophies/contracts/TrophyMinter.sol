// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/utils/Strings.sol";

/// @title Prop House Trophy Minter
/// @author waterdrops.
/// @notice Barebones contract to mint Soulbound Trophies, credits to Miguel Piedrafita
contract TrophyMinter {
    /// @notice Thrown when trying to transfer a Soulbound token
    error Soulbound();

    /// @notice Emitted when minting a Soulbound NFT
    /// @param from Who the token comes from. Will always be address(0)
    /// @param to The token recipient
    /// @param id The ID of the minted token
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed id
    );

    /// @notice The symbol for the token
    string public constant symbol = "PT";

    /// @notice The name for the token
    string public constant name = "Prop House Trophy";

    /// @notice The owner of this contract (set to the deployer)
    address public immutable owner = msg.sender;

    /// @notice Get the owner of a certain tokenID
    mapping(uint256 => address) public ownerOf;

    /// @notice Get how many SoulMinter NFTs a certain user owns
    mapping(address => uint256) public balanceOf;

    /// @dev Counter for the next tokenID, defaults to 1 for better gas on first mint
    uint256 internal nextTokenId = 1;

    /// @notice This will use the Tableland gateway and query: https://testnet.tableland.network/query?mode=list&s=
    string public baseURIString;

    /// @notice The name of the main metadata table in Tableland
    string public mainTable;

    /// @notice The maximum amount of mintable tokens
    uint256 private _maxTokens;

    using Strings for uint256;

    constructor(
        string memory baseURI,
        string memory _mainTable
    ) payable {
        _maxTokens = 100;
        baseURIString = baseURI;
        mainTable = _mainTable;
    }

    /// @notice This function was disabled to make the token Soulbound. Calling it will revert
    function approve(address, uint256) public virtual {
        revert Soulbound();
    }

    /// @notice This function was disabled to make the token Soulbound. Calling it will revert
    function isApprovedForAll(address, address) public pure {
        revert Soulbound();
    }

    /// @notice This function was disabled to make the token Soulbound. Calling it will revert
    function getApproved(uint256) public pure {
        revert Soulbound();
    }

    /// @notice This function was disabled to make the token Soulbound. Calling it will revert
    function setApprovalForAll(address, bool) public virtual {
        revert Soulbound();
    }

    /// @notice This function was disabled to make the token Soulbound. Calling it will revert
    function transferFrom(
        address,
        address,
        uint256
    ) public virtual {
        revert Soulbound();
    }

    /// @notice This function was disabled to make the token Soulbound. Calling it will revert
    function safeTransferFrom(
        address,
        address,
        uint256
    ) public virtual {
        revert Soulbound();
    }

    /// @notice This function was disabled to make the token Soulbound. Calling it will revert
    function safeTransferFrom(
        address,
        address,
        uint256,
        bytes calldata
    ) public virtual {
        revert Soulbound();
    }

    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
    }

    function _baseURI() internal view returns (string memory) {
        return baseURIString;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        string memory baseURI = _baseURI();

        if (bytes(baseURI).length == 0) {
            return "";
        }

        string memory query = string(
            abi.encodePacked(
                "SELECT+json_object%28%27id%27%2Cid%2C%27name%27%2Cname%2C%27description%27%2Cdescription%2C%27image%27%2Cimage%29+FROM+",
                mainTable,
                "%2Emain_id%20WHERE%20id%3D"
            )
        );
        // Return the baseURI with a query string, which looks up the token id in a row.
        // `&mode=list` formats into the proper JSON object expected by metadata standards.
        return
            string(
                abi.encodePacked(
                    baseURI,
                    query,
                    Strings.toString(tokenId)
                )
            );
    }

    /// @notice Mint a new Soulbound NFT to `msg.sender`
    function mint() public payable {
        unchecked {
            balanceOf[msg.sender]++;
        }

        ownerOf[nextTokenId] = msg.sender;
        emit Transfer(address(0), msg.sender, nextTokenId++);
    }

    function _exists(uint256 tokenId) internal view returns (bool) { 
        address _owner = ownerOf[tokenId];
        return _owner != address(0);
    }
}