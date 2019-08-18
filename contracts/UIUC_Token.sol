pragma solidity >=0.4.0 <0.7.0;

// Version 1.1
// Date: 08/14/19


/**
 * @dev Interace taken from OpenZeppelin template:
 * Standard interface that allows any tokens on Ethereum to be re-used by
 * other applications: from wallets to decentralized exchanges.
 * see link for OpenZeppelin Solidity contract below:
 *
 * https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
 *
 */
interface IERC20 {
    // Returns the total token supply.
    function totalSupply()
        external view returns (uint256);

    // Returns the account balance of another account with address `owner`.
    function balanceOf(address who)
        external view returns (uint256);

    // Returns the amount which `spender` is stil allowed to withdraw from `owner`
    function allowance(address owner, address spender)
        external view returns (uint256);

    /**
     * @dev Transfers `value` amount of tokens to address `to`, and MUST
     * fire the `Transfer` event. The function SHOULD `throw` if the
     * message caller's account balance does not have enough tokens to spend.
     * NOTE: Transfers of 0 values MUST be treated as normal transfers
     * and fire the `Transfer`
     */
    function transfer(address to, uint256 value)
        external returns (bool);

    /**
     * @dev Allows `spender` to withdraw from your account multiple
     * times, up to the `value` amount.
     * If this function is called again it overwrites the current allowance
     * with `value`
     */
    function approve(address spender, uint256 value)
        external returns (bool);

    /**
     * @dev Transfers `value` amount of tokens from address `from`
     * to address `to`, and MUST fire the `Transfer` event.
     * The `transferFrom` method is used for a withdraw workflow,
     * allowing contracts to transfer tokens+ on your behalf.
     * This can be used for example to allow a contract to transfer
     * tokens on your behalf and/or to charge fees in sub-currencies.
     * The function SHOULD `throw` unless the `from` account has deliberately
     * authorized the sender of the message via some mechanism.
     *     NOTE: Transfers of 0 values MUST be treated as normal Transfers
     * and fire the `Transfer` event.
     */
    function transferFrom(address from, address to, uint256)
        external returns (bool);

    /**
     * @dev MUST trigger when tokens are transferred, including
     * zero value transfers. A token contract which creates new
     * tokens SHOULD trigger a Transfer event with the `from`
     * address set to `0x0` when tokens are created.
     */
    event Transfer(
        address indexed from,
        address indexed to,

        uint256 value
    );

    /**
     * @dev MUST trigger on any successful call to
     * `approve(address spender, uint256 value)`.
     */
    event Approval(
        address indexed owner,
        address indexed spender,

        uint256 value
    );
}

/**
 * @dev see link for OpenZeppelin Solidity contract below:
 *
 * https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol
 *
 */
library SafeMath {
    /**
     * @dev Multiplies two numbers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b)
        internal pure returns (uint256) {
            if (a == 0) {
                return 0;
            }
            uint256 c = a * b;

            assert(c / a == b);

            return c;
    }

    /**
     * @dev Integer division of two numbers truncating the quotient, reverts
     * on division by zero.
     */
    function div(uint256 a, uint256 b)
        internal pure returns (uint256) {
            require(b > 0); // Solidity only automatically asserts when dividing by 0

            uint256 c = a / b;
            // assert (a == b * c + a % b); // There is no case in which this doesn't hold

            return c;
    }

    /**
     * @dev Subtracts two numbers, reverts overflow (i.e. if subtragend is greater than minuend).
     */
    function sub(uint256 a, uint256 b)
        internal pure returns (uint256) {
            require(b <= a);

            uint256 c = a - b;

            return c;
    }

    /**
     * @dev Adds two numbers, reverts on overflow.
     */
    function add(uint256 a, uint256 b)
        internal pure returns (uint256) {
            uint256 c = a + b;

            assert(c >= a);

            return c;
    }

    /**
     * @dev First division of `d` by `m`, then multiplying result by `m`.
     */
    function ceil(uint256 a, uint256 m)
        internal pure returns (uint256) {
            uint256 c = add(a, m);
            uint256 d = sub(c, 1);

            return mul(div(d, m), m);
    }
}

/**
 * @dev The decimals are only for visualization purposes.
 * All the operations are done using the smallest and indivisible token unit,
 * just as on Ethereum all the operations are done in wei.
 * For reference, see:
 *
 * https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20Detailed.sol
 *
 */
contract ERC20Detailed is IERC20 {

    string private _name;
    string private _symbol;

    uint8 private _decimals;

    constructor(string memory name, string memory symbol, uint8 decimals)
        public {
            _name = name;
            _symbol = symbol;
            _decimals = decimals;
    }

    /**
     * @return the name of the token.
     */
    function name()
        public view returns (string memory) {
            return _name;
    }

    /**
     * @return the symbol of the token.
     */
    function symbol()
        public view returns (string memory) {
            return _symbol;
    }

    /**
     * @return the number of decimals of the token.
     */
    function decimals()
        public view returns (uint8) {
            return _decimals;
    }
}

/**
 * @dev Boilerplate taken from `BOMBv3.sol`.
 * for reference, see link for Solidity contract below:
 *
 * https://etherscan.io/address/0x1C95b093d6C236d3EF7c796fE33f9CC6b8606714#code
 *
 */
contract UIUC_Token is ERC20Detailed {
    /**
     * @dev see `Using For` section under:
     *
     * https://solidity.readthedocs.io/en/v0.4.21/contracts.html#inheritance
     *
     * The directive `using A for B;` can be used to attach library functions
     * (from the library `A`) to any type (`B`).
     * These functions will receive the object they are called on as their
     * first parameter (like the `self` variable in Python).
     *
     * The effect of `using A for *;` is that the functions from the
     * library `A` are attached to any type.
     *
     * In both situations, all functions, even those where the type of
     * the first parameter does not match the type of the object, are
     * attached.
     * The type is checked at the point the function is called and function
     * overload resolution is performed.
     */
    using SafeMath for uint256;

    // Using `mapping` to map `address` type to `uint256` type with name
    // `_balances`.
    mapping (address => uint256) private _balances;

    // Using `mapping` to map `address` type to the mapping of `address`
    // type to `uint256` type with name `_allowed`.
    mapping (address => mapping (address => uint256)) private _allowed;

    string constant tokenName = "UIUC_Token";
    string constant tokenSymbol = "UIUC_Token";

    uint8 constant tokenDecimals = 0;
    uint256 _totalSupply = 2090000;
    // Total initial percent for deflation calculations.
    uint256 public basePercent = 100;

    constructor()
        public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
            // Miniting new tokens
            _mint(msg.sender, _totalSupply);
    }

    // Queries...
    function totalSupply()
        public view returns (uint256) {
            return _totalSupply;
    }

    // Queries the balance of owner of tokens
    function balanceOf(address owner)
        public view returns (uint256) {
            return _balances[owner];
    }

    function allowance(address owner, address spender)
        public view returns (uint256) {
            return _allowed[owner][spender];
    }

    /**
     * @dev Changed calculation to find 0.5 percent instead of 1 percent of
     * total supply (calcuation as follows: 2090000 * 0.05 = 10450)
     */
    function findHalfPercent(uint256 value)
        public view returns (uint256) {
            uint256 roundValue = value.ceil(basePercent);
            uint256 halfPercent = roundValue.mul(basePercent).div(10450);

            return halfPercent;
    }

    /**
     * @dev REVIEW and comment on this `transfer` function
     */
    function transfer(address to, uint256 value)
        public returns (bool) {
            require(value <= _balances[msg.sender]);
            require(to != address(0));

            uint256 tokensToBurn = findHalfPercent(value);
            uint256 tokensToTransfer = value.sub(tokensToBurn);

            _balances[msg.sender] = _balances[msg.sender].sub(value);
            _balances[to] = _balances[to].add(tokensToTransfer);

            _totalSupply = _totalSupply.sub(tokensToBurn);

            emit Transfer(msg.sender, to, tokensToTransfer);
            emit Transfer(msg.sender, address(0), tokensToBurn);

            return true;
    }

    /**
     * @dev REVIEW and comment on this `multiTransfer` function
     */
    function multiTransfer(address[] memory receivers, uint256[] memory amounts)
        public {
            for (uint256 i = 0; i < receivers.length; i++) {
                transfer(receivers[i], amounts[i]);
        }
    }

    /**
     * @dev REVIEW and comment on this `approve` function
     */
    function approve(address spender, uint256 value)
        public returns (bool) {
            require(spender != address(0));

            _allowed[msg.sender][spender] = value;

            emit Approval(msg.sender, spender, value);

            return true;
    }

    /**
     * @dev REVIEW and comment on this `transferFrom` function
     */
    function transferFrom(address from, address to, uint256 value)
        public returns (bool) {
            require(value <= _balances[from]);
            require(value <= _allowed[from][msg.sender]);
            require(to != address(0));

            _balances[from] = _balances[from].sub(value);

            uint256 tokensToBurn = findHalfPercent(value);
            uint256 tokensToTransfer = value.sub(tokensToBurn);

            _balances[to] = _balances[to].add(tokensToTransfer);
            _totalSupply = _totalSupply.sub(tokensToBurn);

            _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);

            emit Transfer(from, to, tokensToTransfer);
            emit Transfer(from, address(0), tokensToBurn);

            return true;
    }

    /**
     * @dev REVIEW and comment on this `increaseAllowance` function
     */
    function increaseAllowance(address spender, uint256 addedValue)
        public returns (bool) {
            require(spender != address(0));

            _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));

            emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);

            return true;
    }

    /**
     * @dev REVIEW and comment on this `decreaseAllowance` function
     */
    function decreaseAllowance(address spender, uint256 subtractedValue)
        public returns (bool) {
            require(spender != address(0));

            _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));

            emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);

            return true;
    }

    /**
     * @dev REVIEW Minting of new tokens by ...... account
     */
    function _mint(address account, uint256 amount)
        internal {
            require(amount != 0);

            _balances[account] = _balances[account].add(amount);

            emit Transfer(address(0), account, amount);
    }

    /**
     * @dev REVIEW and comment on this `burn` function
     */
    function burn(uint256 amount)
        external {
            _burn(msg.sender, amount);
    }

    /**
     * @dev REVIEW and comment on this `_burn` function
     */
    function _burn(address account, uint256 amount)
        internal {
            require(amount != 0);
            require(amount <= _balances[account]);

            _totalSupply = _totalSupply.sub(amount);
            _balances[account] = _balances[account].sub(amount);

            emit Transfer(account, address(0), amount);
    }

    /**
     * @dev REVIEW and comment on this `burnFrom` function
     */
    function burnFrom(address account, uint256 amount)
        external {
            require(amount <= _allowed[account][msg.sender]);

            _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
            _burn(account, amount);
    }
}

/////////////////////////////////////////////////////////////////////////////////

/**
 * @dev Old code from 08/06/19
 *
 * REVIEW if needed
 */

//   // Adding fixed supply for ERC20 token/cryptocurrency
//   constructor() public {
//     // Using the internal function `_mint` to implement fixed token supply of...
//     // in our case this is 20.9 Million -- this is excluding the effect of the
//     // deflation rate.

//     // Where is this supply stored??
//     // Need to be able to call the address where the supply is stored to
//     // later burn.
//     _mint(msg.sender, 2090000);    // 2.09 Million fixed total token supply
//   }
//     // Intuition:
//     // Encapsulating state (like done above) makes it safer to extend contracts.
//     // For instance, manually keeping `totalSupply` in sync with modified
//     // balances is easy to forget.
//     // In fact, the `Transfer` is an event required by the standard and is also
//     // easily forgetten, `Transfer` is also an event relied on by some clients.
//     // Note how the internal `_mint()` function takes care of these functions.

//     // The internal `_mint` is the key building block that allows us to write
//     // ERC20 extensions that implement a supply mechansim.
//     // The mechanism we will implement is a token reward for the miners that
//     // produce Ethereum blocks.
//     // In Solidity, we can access the address of the current block's miner in
//     // the global variable `block.coinbase`.

//     // function mintMinerReward() public {
//     //   _mint(block.coinbase, 1999);
//     // }
// }

// // This contract `MinerRewardMinter` below, when initialized with an
// // `ERC20Mintable` instance, will result in exactly the same behaviour
// // implemented in the above `UIUC_Token` contract.
// contract MinerRewardMinter {
//   ERC20Mintable _token;

//   constructor(ERC20Mintable token) public {
//     _token = token;
//   }

//   // In Solidity we can access the address of the current block's miner in
//   // the global variable `block.coinbase` -- thus, we are minting a new token
//   // reward to this `block.coinbase` address whenever someon calls the function
//   // `mintMinerReward` on our token.
//   function mintMinerReward() public {
//     // `block.coinbase` is a constantly changing address based on whoever mined
//     // the last TX in the previous block and now begins the next block with
//     // the coinbase.
//     _token.mint(block.coinbase, 1999);
//   }
// }

// // ToDo:
// // What is interesting about using `ERC20Mintable` is that we can easily
// // combine multiple supply mechanisms by assigning the role to multiple
// // contracts, and we can do this dynamically (DEFLATION!).
// contract DeflationMinter is ERC20Burnable, ERC20Detailed {
//   ERC20Mintable _token;

//   constructor(ERC20Mintable token) public {
//     _token = token;
//   }

//   function burnTokens() public {
//     // Burn 5% of total supply after every transaction
//     _burn(msg.sender, 199);    // Burning fixed supply of 199 tokens
//   }
// }
