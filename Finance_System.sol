// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserManager {
    enum Role { Administrator, Manager, RegularUser }

    mapping(address => Role) private roles;

    constructor(){
        addUser(msg.sender, Role.Administrator);
    }

    // Ensure only an administrator can perform certain actions
    modifier onlyAdministrator() {
        require(roles[msg.sender] == Role.Administrator, "Not an administrator");
        _;
    }

    // Ensure only a manager can perform certain actions
    modifier onlyManager() {
        require(roles[msg.sender] == Role.Manager, "Not a manager");
        _;
    }

    function addUser(address user, Role role) public onlyAdministrator {
        roles[user] = role;
    }

}

contract FinancialOperations is UserManager {
    uint256 internal constant DECIMALS = 6;
    uint256 internal constant UNIT = 10**DECIMALS;

    mapping(address => uint256) private balances;

    function deposit() external payable {
        increaseBalance(msg.sender, msg.value);
    }

    function withdraw(uint256 microdollarAmount) external {
        decreaseBalance(msg.sender, microdollarAmount);
        payable(msg.sender).transfer(microdollarAmount);
    }

    function increaseBalance(address user, uint256 amount) internal {
        balances[user] += amount;
    }

    function decreaseBalance(address user, uint256 amount) internal {
        require(balances[user] >= amount, "Insufficient balance");
        balances[user] -= amount;
    }

    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }
}

contract LoanSystem is FinancialOperations {
    struct Loan {
        uint256 principal; // Principal in microdollars
        uint256 interestRateBasisPoints; // Interest rate in basis points
        bool approved;
    }

    mapping(address => Loan) private loans;

    function requestLoan(uint256 microdollarAmount, uint256 interestRateBasisPoints) external {
        require(interestRateBasisPoints <= 5000, "Interest rate must be 50% or less");
        loans[msg.sender] = Loan(microdollarAmount, interestRateBasisPoints, false);
    }

    function approveLoan(address borrower) external onlyManager {
        require(loans[borrower].principal > 0, "No loan requested");
        loans[borrower].approved = true;
        increaseBalance(borrower, loans[borrower].principal);
    }

    function repayLoan() external payable {
        Loan storage loan = loans[msg.sender];
        require(loan.approved, "Loan not approved or does not exist");

        uint256 totalDebt = calculateTotalDebt(msg.sender);
        require(msg.value >= totalDebt, "Not enough Ether sent to cover the debt");

        if (msg.value > totalDebt) {
            decreaseBalance(msg.sender, totalDebt);
        }

        delete loans[msg.sender];
    }

    function calculateTotalDebt(address borrower) private view returns (uint256) {
        Loan storage loan = loans[borrower];
        uint256 interest = (loan.principal * loan.interestRateBasisPoints) / 10000;
        return loan.principal + interest;
    }
}
