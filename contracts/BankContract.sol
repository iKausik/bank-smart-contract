// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    address public bankOwner;
    string public bankName;
    mapping(address => uint256) public customerBalance;

    constructor() {
        bankOwner = msg.sender;
    }

    // deposit
    function depositMoney() public payable {
        require(msg.value != 0, "You need to deposit some amount of money");
        customerBalance[msg.sender] += msg.value;
    }

    // set bank name
    function setBankName(string memory _name) external {
        require(
            msg.sender == bankOwner,
            "You must be the owner to set the name of the bank"
        );
        bankName = _name;
    }

    // withdraw
    function withdrawMoney(address payable _to, uint256 _total) public {
        require(
            _total <= customerBalance[msg.sender],
            "You have insufficient balance to withdraw"
        );

        customerBalance[msg.sender] -= _total;

        // it's the recommended and more secure way to sent money using call instead of transfer ot send
        (bool success, ) = _to.call{value: _total}("");
        require(success, "Transfer Failed");
    }

    // get customer balance
    function getCustomerBalance() external view returns (uint256) {
        return customerBalance[msg.sender];
    }

    // get bank balance
    function getBankbalance() public view returns (uint256) {
        require(
            msg.sender == bankOwner,
            "You must be the owner of the bank to see all balances"
        );
        return address(this).balance;
    }
}
