// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "./Ownable.sol";

contract Constants {
    uint256 public tradeFlag = 1;
    uint256 public basicFlag = 0;
    uint256 public dividendFlag = 1;
}

contract GasContract is Ownable, Constants {
    error NameMustBeLt9();
    error InsufficientBalance();
    error NeitherAdminNorOwner();
    error AmountToSendMustBeGt3();

    uint256 public totalSupply = 0; // cannot be updated
    uint256 public paymentCounter = 0;
    mapping(address => uint256) public balances;
    mapping(address => Payment[]) public payments;
    mapping(address => uint256) public whitelist;
    uint256 private constant NUM_ADMINS = 5;
    mapping(address => bool) isAdmin;
    address[NUM_ADMINS] public administrators;
    enum PaymentType {
        Unknown,
        BasicPayment,
        Refund,
        Dividend,
        GroupPayment
    }
    History[] public paymentHistory; // when a payment was updated

    struct Payment {
        PaymentType paymentType;
        uint256 paymentID;
        bytes8 recipientName; // max 8 characters
        address recipient;
        address admin; // administrators address
        uint256 amount;
    }

    struct History {
        uint256 lastUpdate;
        address updatedBy;
        uint256 blockNumber;
    }
    bool private wasLastOdd;
    mapping(address => bool) private isOddWhitelistUser;
    struct ImportantStruct {
        uint256 valueA; // max 3 digits
        uint256 bigValue;
        uint256 valueB; // max 3 digits
    }

    mapping(address => ImportantStruct) public whiteListStruct;

    event AddedToWhitelist(address userAddress, uint256 tier);

    modifier onlyAdminOrOwner() {
        if (!isAdmin[msg.sender] && msg.sender != owner())
            revert NeitherAdminNorOwner();
        _;
    }

    modifier checkIfWhiteListed(address sender) {
        require(msg.sender == sender, "Transaction was not the sender");
        uint256 usersTier = whitelist[msg.sender];
        require(
            usersTier > 0 || usersTier < 4,
            "User not whitelisted or tier is incorrect"
        );
        _;
    }

    event supplyChanged(address indexed, uint256 indexed);
    event Transfer(address recipient, uint256 amount);
    event PaymentUpdated(
        address admin,
        uint256 ID,
        uint256 amount,
        bytes32 recipient
    );
    event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        uint256 bal;
        totalSupply = _totalSupply;

        for (uint256 i = 0; i < NUM_ADMINS; i++) {
            if (_admins[i] != address(0)) {
                administrators[i] = _admins[i];
                isAdmin[_admins[i]] = true;
                bal = 0;
                if (_admins[i] == msg.sender) {
                    balances[msg.sender] = _totalSupply;
                    bal = _totalSupply;
                }
                emit supplyChanged(_admins[i], bal);
            }
        }
    }

    function stringToBytes8(string memory _str)
        private
        pure
        returns (bytes8 result)
    {
        bytes memory strLength = bytes(_str);
        if (strLength.length == 0 || strLength.length < 9) {
            return 0x0;
        }

        assembly {
            result := mload(add(_str, 8))
        }
    }

    function balanceOf(address _user) public view returns (uint256) {
        return balances[_user];
    }

    function getTradingMode() external view returns (bool) {
        return (tradeFlag == 1 || dividendFlag == 1);
    }

    function getPayments(address _user)
        external
        view
        returns (Payment[] memory)
    {
        return payments[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) external {
        if (balances[msg.sender] < _amount) revert InsufficientBalance();
        if (bytes(_name).length >= 9) revert NameMustBeLt9();
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);
        payments[msg.sender].push(
            Payment({
                paymentType: PaymentType.BasicPayment,
                recipientName: stringToBytes8(_name),
                recipient: _recipient,
                amount: _amount,
                admin: address(0),
                paymentID: ++paymentCounter
            })
        );
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        PaymentType _type
    ) external onlyAdminOrOwner {
        assert(_ID > 0);
        assert(_amount > 0);
        assert(_user != address(0));

        for (uint256 i = 0; i < payments[_user].length; i++) {
            if (payments[_user][i].paymentID == _ID) {
                payments[_user][i].admin = _user;
                payments[_user][i].paymentType = _type;
                payments[_user][i].amount = _amount;
                paymentHistory.push(
                    History({
                        blockNumber: block.number,
                        lastUpdate: block.timestamp,
                        updatedBy: _user
                    })
                );
                emit PaymentUpdated(
                    msg.sender,
                    _ID,
                    _amount,
                    payments[_user][i].recipientName
                );
                return;
            }
        }
    }

    function addToWhitelist(address _userAddrs, uint256 _tier)
        external
        onlyAdminOrOwner
    {
        // BEFORE
        // assert(_tier < 255);
        // whitelist[_userAddrs] = _tier;
        // bool wasLastAddedOdd = wasLastOdd;
        // isOddWhitelistUser[_userAddrs] = wasLastAddedOdd;
        // wasLastOdd = !wasLastAddedOdd;
        // emit AddedToWhitelist(_userAddrs, _tier);

        // AFTER
        assembly {
            // assert(_tier < 255);
            if lt(_tier, 255) {
                // whitelist[_userAddrs] = _tier;
                mstore(0, _userAddrs)
                mstore(32, whitelist.slot)
                let whitelistMappingPos := keccak256(0, 64)
                sstore(whitelistMappingPos, _tier)

                // bool wasLastAddedOdd = wasLastOdd;
                let wasLastAddedOdd := sload(wasLastOdd.slot)

                // isOddWhitelistUser[_userAddrs] = wasLastAddedOdd;
                // We already store _userAddrs on line 209
                mstore(32, isOddWhitelistUser.slot)
                let mappingPos := keccak256(0, 64)
                sstore(mappingPos, wasLastAddedOdd)

                // wasLastOdd = !wasLastAddedOdd;
                sstore(wasLastOdd.slot, not(wasLastAddedOdd))
            }
        }
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct memory
    ) external {
        if (_amount <= 3) revert AmountToSendMustBeGt3();
        address senderOfTx = msg.sender;
        uint256 _whitelist = whitelist[senderOfTx];
        assert(_whitelist < 4);
        uint256 _senderBal = balances[senderOfTx];
        if (_senderBal < _amount) revert InsufficientBalance();
        balances[senderOfTx] = _senderBal - _amount + _whitelist;
        balances[_recipient] += _amount - _whitelist;
        emit WhiteListTransfer(_recipient);
    }
}
