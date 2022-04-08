// SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;

contract testsiii is ERC721, Ownable {
    using Strings for uint256;
    uint256 public cost = 0.06969 ether;
    uint256 public maxSupply = 6969;
    uint256 public maxMintAmount = 5;
    uint256 public tokenCount = 0;
    bool public paused = true;
    bool public reveal;
    string public baseURI;
    string public notRevealedUri;

    mapping(address => uint256) public addressMintedBalance;

    constructor(string memory _initBaseURI, string memory _initNotRevealedUri)
        ERC721("qushtapa", "quush")
    {
        baseURI = _initBaseURI;
        notRevealedUri = _initNotRevealedUri;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        if (reveal) {
            return
                bytes(baseURI).length > 0
                    ? string(
                        abi.encodePacked(
                            baseURI,
                            "/",
                            tokenId.toString(),
                            ".json"
                        )
                    )
                    : "";
        } else {
            return bytes(notRevealedUri).length > 0 ? notRevealedUri : "";
        }
    }

    function mint(uint256 _amount) external payable {
        require(!paused, " - The Contract is Paused");
        require(
            tokenCount + _amount <= maxSupply,
            " - max NFT limit exceeded"
        );
        if (msg.sender != owner()) {
            require(
                _amount <= maxMintAmount,
                " - max mint amount limit exceeded"
            );
            uint256 ownerMintedCount = addressMintedBalance[msg.sender];
            require(
                ownerMintedCount + _amount <= maxMintAmount,
                " - max NFT per address exceeded"
            );
            require(
                msg.value >= cost * _amount,
                " - insufficient ethers"
            );
        }
        for (uint256 i = 1; i <= _amount; i++) {
            addressMintedBalance[msg.sender]++;
            _safeMint(msg.sender, ++tokenCount);
        }
    }

    //only owner
    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
        maxMintAmount = _maxMintAmount;
    }

    function setBaseURI(string memory _baseURI) public onlyOwner {
        baseURI = _baseURI;
    }

    function pause() public onlyOwner {
        paused = !paused;
    }

    function revealNFT() external onlyOwner {
        reveal = !reveal;
    }

    function withdraw() public onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }
}