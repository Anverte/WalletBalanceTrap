// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory);
}

contract WalletBalanceTrap is ITrap {
    // Address of the wallet whose ETH balance will be tracked
    address public constant wallet = 0x32d3526172408fb9C3d7c8b156FC23B96D1c58e8;

    function collect() external view override returns (bytes memory) {
        return abi.encode(wallet.balance);
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 2) return (false, "Insufficient data");

        uint256 current = abi.decode(data[0], (uint256));
        uint256 previous = abi.decode(data[1], (uint256));

        if (previous == 0) return (false, "Previous balance is zero");

        uint256 diff = current > previous ? current - previous : previous - current;
        uint256 percent = (diff * 1_000_000) / previous; // 6 decimal precision

        // 0.0001% = 1 (in 1,000,000 scale)
        if (percent >= 1) {
            return (true, abi.encode("Wallet ETH balance changed > 0.0001%"));
        }

        return (false, "");
    }
}
