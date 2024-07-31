// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract AvaEthernity is ERC20Capped, Ownable {
    event Mint(uint indexed amount);
    event Burn(uint indexed amount);

    constructor()
        Ownable(_msgSender())
        ERC20('Ava Ethernity', 'AETH')
        ERC20Capped(1_000_000_000 * (10 ** 18))
    {}

    receive() external payable {}

    function mint(uint amount, address to) external onlyOwner {
        super._mint(to, amount);
        emit Mint(amount);
    }

    function burn(uint amount) external onlyOwner {
        super._burn(_msgSender(), amount);
        emit Burn(amount);
    }

    function withdrawTokens(address token, uint amount) external onlyOwner {
        IERC20(token).transfer(owner(), amount);
    }

    function withdrawEthers() external onlyOwner {
        (bool success, ) = owner().call{value: address(this).balance}('');
        require(success, 'Failed to withdraw');
    }
}
