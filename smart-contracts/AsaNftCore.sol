// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Awsan Sultan Art (ASA) - Core NFT Smart Contract
 * @dev Intellectual Property of ENG AWSAN ADEL ABDULBARI AHMED SULTAN
 * @notice Manages the minting, ownership, and tracking of the 45,000 next-gen digital artworks.
 */
contract AsaNftCore {

    // توثيق المالك والمبتكر الرئيسي للمجموعة لحفظ الحقوق برمجياً داخل البلوكشين للأبد
    string public constant CREATOR = "ENG AWSAN ADEL ABDULBARI AHMED SULTAN";
    string public constant CREATOR_ID = "01010305468";

    string public name = "Awsan Sultan Art";
    string public symbol = "ASA";
    
    uint256 public constant MAX_SUPPLY = 45000; // الحد الأقصى للمجموعة الفنية كما هو محدد بمشروعك
    uint256 public currentSupply = 0;
    
    address public owner;
    string public baseURI = "ipfs://QmAwsanSultanArtBaseCID/"; // رابط التخزين اللامركزي الافتراضي للفنون

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => string) private _tokenURIs;

    event NFTMinted(address indexed player, uint256 indexed tokenId, string tokenURI);
    event BaseURIUpdated(string newBaseURI);

    modifier onlyOwner() {
        require(msg.sender == owner, "Error: Only ENG AWSAN SULTAN can execute this administrative function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice دالة صك العمل الفني وتوزيعه للاعب عند تحقيق شروط اللعبة (مثل تخطي 500 XP)
     * @param _player محفظة اللاعب المستحق للفن الرقمي كمكافأة
     * @param _customMetadata الرابط النصي لخصائص الفن ومميزات الـ RTX Boost الخاصة به
     */
    function mintAsaNft(address _player, string memory _customMetadata) external onlyOwner returns (uint256) {
        require(currentSupply < MAX_SUPPLY, "Error: All 45,000 artworks in the ASA collection have been minted");
        require(_player != address(0), "Invalid player address");

        currentSupply += 1;
        uint256 newTokenId = currentSupply;

        _owners[newTokenId] = _player;
        _balances[_player] += 1;
        _tokenURIs[newTokenId] = _customMetadata;

        emit NFTMinted(_player, newTokenId, _customMetadata);
        return newTokenId;
    }

    /**
     * @notice دالة لاستعراض مالك قطعة فنية معينة من الـ 45 ألفاً
     */
    function ownerOf(uint256 _tokenId) external view returns (address) {
        address nftOwner = _owners[_tokenId];
        require(nftOwner != address(0), "Token ID does not exist");
        return nftOwner;
    }

    /**
     * @notice دالة لاستعراض عدد الفنون الرقمية التي تمتلكها محفظة معينة
     */
    function balanceOf(address _player) external view returns (uint256) {
        require(_player != address(0), "Invalid player address");
        return _balances[_player];
    }

    /**
     * @notice دالة لقراءة الرابط النصي والبيانات الوصفية (Metadata) الخاصة بالـ NFT ليعرضها محرك اللعبة بدقة
     */
    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        require(_owners[_tokenId] != address(0), "Token ID does not exist");
        return _tokenURIs[_tokenId];
    }

    /**
     * @notice دالة إدارية لتحديث رابط التخزين الرئيسي عند الحاجة لتغيير سيرفرات الـ IPFS
     */
    function updateBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
        emit BaseURIUpdated(_newBaseURI);
    }
}
