// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// We import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// We import help functions
import {StringUtils} from "./libraries/StringUtils.sol";
import {Base64} from "./libraries/Base64.sol";

import "hardhat/console.sol";

contract Domains is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // We'll be storing our NFT images on chain as SVGs
    string svgPartOne =
        '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none"><path fill="url(#B)" d="M0 0h270v270H0z"/><defs><filter id="A" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><path d="M72.863 42.949a4.382 4.382 0 0 0-4.394 0l-10.081 6.032-6.85 3.934-10.081 6.032a4.382 4.382 0 0 1-4.394 0l-8.013-4.721a4.52 4.52 0 0 1-1.589-1.616 4.54 4.54 0 0 1-.608-2.187v-9.31a4.27 4.27 0 0 1 .572-2.208 4.25 4.25 0 0 1 1.625-1.595l7.884-4.59a4.382 4.382 0 0 1 4.394 0l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616 4.54 4.54 0 0 1 .608 2.187v6.032l6.85-4.065v-6.032a4.27 4.27 0 0 0-.572-2.208 4.25 4.25 0 0 0-1.625-1.595L41.456 24.59a4.382 4.382 0 0 0-4.394 0l-14.864 8.655a4.25 4.25 0 0 0-1.625 1.595 4.273 4.273 0 0 0-.572 2.208v17.441a4.27 4.27 0 0 0 .572 2.208 4.25 4.25 0 0 0 1.625 1.595l14.864 8.655a4.382 4.382 0 0 0 4.394 0l10.081-5.901 6.85-4.065 10.081-5.901a4.382 4.382 0 0 1 4.394 0l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616 4.54 4.54 0 0 1 .608 2.187v9.311a4.27 4.27 0 0 1-.572 2.208 4.25 4.25 0 0 1-1.625 1.595l-7.884 4.721a4.382 4.382 0 0 1-4.394 0l-7.884-4.59a4.52 4.52 0 0 1-1.589-1.616 4.53 4.53 0 0 1-.608-2.187v-6.032l-6.85 4.065v6.032a4.27 4.27 0 0 0 .572 2.208 4.25 4.25 0 0 0 1.625 1.595l14.864 8.655a4.382 4.382 0 0 0 4.394 0l14.864-8.655a4.545 4.545 0 0 0 2.198-3.803V55.538a4.27 4.27 0 0 0-.572-2.208 4.25 4.25 0 0 0-1.625-1.595l-14.993-8.786zM245 65.274c-6.166-1.559-12.771-1.144-18.087-.811-1.795.111-3.491.219-4.986.239-.673.01-1.266-.05-1.764-.177-1.17-.295-1.794-.937-1.909-1.959-.309-2.741 2.038-7.853 5.912-9.298a.545.545 0 0 0 .309-.705c-.102-.285-.413-.467-.702-.397-.973.229-2.044.209-3.101-.059-1.842-.466-3.47-1.628-4.352-3.107-.718-1.204-.899-2.543-.523-3.871a.618.618 0 0 0-.39-.732c-.307-.108-.618.044-.71.336-.722 2.315-5.027 9.185-9.263 9.57-.977.089-1.52-.76-1.52-.76-.882-1.307-1.232-5.113-1.27-5.542-.355-4.149-.845-9.83-3.08-15.729-2.638-6.966-7.22-12.758-13.614-17.218-.249-.173-.582-.131-.758.084-.183.223-.156.556.058.774 1.438 1.464 3.769 4.992 3.37 8.935-.315 3.113-2.296 5.714-5.89 7.729a.54.54 0 0 0-.261.568c.039.234.21.427.438.494 4.493 1.309 5.569 3.621 5.534 5.33-.11 5.307-3.674 5.613-3.674 5.613-.305.027-.481.208-.513.475a.622.622 0 0 0 .4.641c4.002 1.499 9.98 8.767 12.796 15.552 1.934 4.666 2.234 8.722.849 11.422a.59.59 0 0 0 .149.711.584.584 0 0 0 .714.056c2.319-1.656 6.246-1.897 11.06-.682 4.025 1.018 8.368 2.971 11.916 5.356 3.462 2.329 5.703 4.809 5.996 6.63.044.277.283.502.564.521s.52-.167.565-.444c.29-1.733 1.365-3.271 3.026-4.332 1.808-1.152 4.05-1.547 5.998-1.055a6.144 6.144 0 0 1 3.226 2.004.613.613 0 0 0 .597.201.527.527 0 0 0 .396-.449c.271-2.075 1.564-3.978 3.645-5.359 2.938-1.954 6.957-2.612 10.486-1.721.287.072.573.156.851.249.239.08.5-.006.632-.208a.581.581 0 0 0-.048-.683c-3.269-4.07-7.667-6.826-13.072-8.192z" fill="#fff"/><defs><linearGradient id="B" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#201870"/><stop offset="1" stop-color="#6b03fc" stop-opacity=".99"/></linearGradient></defs><text x="32.5" y="231" font-size="27" fill="#fff" filter="url(#A)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
    string svgPartTwo = "</text></svg>";
    string public tld;

    mapping(string => address) public domains;
    mapping(string => string) public records;
    mapping(uint256 => string) public names;

    error Unauthorized();
    error AlreadyRegistered();
    error InvalidName(string name);

    address payable public owner;

    constructor(string memory _tld) payable ERC721("Bat Name Service", "BNS") {
        owner = payable(msg.sender);
        tld = _tld;
        console.log("%s name service deployed", _tld);
    }

    function register(string calldata name) public payable {
        if (domains[name] != address(0)) revert AlreadyRegistered();
        if (!valid(name)) revert InvalidName(name);

        require(domains[name] == address(0));

        uint256 _price = price(name);
        require(msg.value >= _price, "Not enough Matic paid");

        // Combine the name passed into the function  with the TLD
        string memory _name = string(abi.encodePacked(name, ".", tld));
        // Create the SVG (image) for the NFT with the name
        string memory finalSvg = string(
            abi.encodePacked(svgPartOne, _name, svgPartTwo)
        );
        uint256 newRecordId = _tokenIds.current();
        uint256 length = StringUtils.strlen(name);
        string memory strLen = Strings.toString(length);

        console.log(
            "Registering %s.%s on the contract with tokenID %d",
            name,
            tld,
            newRecordId
        );

        // Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                _name,
                '", "description": "A domain on the Bat name service", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(finalSvg)),
                '","length":"',
                strLen,
                '"}'
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n----------------------------------------------------");
        console.log("Final tokenURI", finalTokenUri);
        console.log("----------------------------------------------------\n");

        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokenUri);
        domains[name] = msg.sender;
        names[newRecordId] = name;
        _tokenIds.increment();
    }

    // This function will give us the price of a domain based on length
    function price(string calldata name) public pure returns (uint256) {
        uint256 len = StringUtils.strlen(name);
        require(len > 0);
        if (len == 3) {
            return 5 * 10**17; // 5 MATIC = 5 000 000 000 000 000 000 (18 decimals). We're going with 0.5 Matic cause the faucets don't give a lot
        } else if (len == 4) {
            return 3 * 10**17; // To charge smaller amounts, reduce the decimals. This is 0.3
        } else {
            return 1 * 10**17;
        }
    }

    function getAddress(string calldata name) public view returns (address) {
        // Check that the owner is the transaction sender
        return domains[name];
    }

    function setRecord(string calldata name, string calldata record) public {
        if (msg.sender != domains[name]) revert Unauthorized();
        records[name] = record;
    }

    function getRecord(string calldata name)
        public
        view
        returns (string memory)
    {
        return records[name];
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to withdraw Matic");
    }

    function getAllNames() public view returns (string[] memory) {
        console.log("Getting all names from contract");
        string[] memory allNames = new string[](_tokenIds.current());
        for (uint256 i = 0; i < _tokenIds.current(); i++) {
            allNames[i] = names[i];
            console.log("Name for token %d is %s", i, allNames[i]);
        }

        return allNames;
    }

    function valid(string calldata name) public pure returns (bool) {
        return StringUtils.strlen(name) >= 3 && StringUtils.strlen(name) <= 10;
    }
}
