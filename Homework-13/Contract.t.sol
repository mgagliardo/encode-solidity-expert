// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Vm.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/DeFi1.sol";
import "../src/Token.sol";

contract User {
    receive() external payable {}
}

contract ContractTest is Test {
    DeFi1 defi;
    Token token;
    User internal alice;
    User internal bob;
    User internal chloe;
    uint256 initialAmount = 1000;
    uint256 blockReward = 5;

    function setUp() public {
        defi = new DeFi1(initialAmount, blockReward);
        token = Token(defi.token.address);
        alice = new User();
        bob = new User();
        chloe = new User();
    }

    function testInitialBalance() public {
    }

    function testAddInvestor() public {
        defi.addInvestor(address(alice));
        assert(defi.investors(0) == address(alice));
    }

    function testClaim() public {
        defi.addInvestor(address(alice));
        defi.addInvestor(address(bob));
        vm.prank(address(alice));
        vm.roll(1);
        defi.claimTokens();
    }

    function testCorrectPayoutAmount() public {
        defi.addInvestor(address(alice));
        vm.startPrank(address(alice));
        vm.roll(1);
        uint256 payoutAmount = defi.calculatePayout();
        defi.claimTokens();
        uint256 aliceBalance = token.balanceOf(address(alice));
        assertEq(aliceBalance, payoutAmount);
    }

    function testAnyoneCanAddAnInvestor() public {
        vm.expectRevert();
        vm.prank(vm.addr(1));
        defi.addInvestor(vm.addr(2));
    }

    function testDivideByZeroWhenNoInvestors() public {
        vm.prank(vm.addr(1));
        uint256 payoutAmount = defi.calculatePayout();
        assert(payoutAmount == 0);
    }

    function testCalculatePayoutOver1000BlocksFails() public {
        defi.addInvestor(address(alice));
        vm.prank(address(alice));
        vm.roll(1000);
        defi.calculatePayout();
    }

    function testAddingManyInvestors() public {
        uint256 investors = 5;
        for (uint256 i = 0; i < investors; i++) {
            defi.addInvestor(vm.addr(i + 1));
            assert(defi.investors(i) == vm.addr(i + 1));
        }
    }

    function testAddingManyInvestorsAndClaiming() public {
        for (uint256 i = 0; i < initialAmount * 2; i++) {
            defi.addInvestor(vm.addr(i + 1));
            assert(defi.investors(i) == vm.addr(i + 1));
        }
    
        address investor = defi.investors(0);
        vm.startPrank(investor);
        vm.roll(1);
        uint256 payoutAmount = defi.calculatePayout();
        defi.claimTokens();
        uint256 investorBalance = token.balanceOf(investor);
        assertEq(investorBalance, payoutAmount);
    }

}
