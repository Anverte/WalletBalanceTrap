// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AlertLogger {
    event Alert(string message);

    function logAnomaly(string calldata message) external {
        emit Alert(message);
    }
}
