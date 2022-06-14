//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;
// ----------------------------------------------------------------------------
// EIP-20: ERC-20 Token Standard
// https://eips.ethereum.org/EIPS/eip-20
// -----------------------------------------
 
interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool success);
    
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Amigos is ERC20Interface {
    string public name = "Amigos";
    string public symbol = "AMG";
    uint public decimals = 0; //18 is most commonly used 
    uint public override totalSupply; //Here since it is public therefore it will set getter function for totalSupply thats why we have use override here
    address public founder;
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) allowed;
    constructor () {
        totalSupply = 1000000;
        founder = msg.sender; 
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public virtual override returns (bool success) {
        require(balances[msg.sender] >= tokens, "You dont have enough token to transfer");

        balances[to] += tokens;
        balances[msg.sender] = balances[msg.sender] - tokens;
        emit Transfer(msg.sender, to, tokens);

        return true;

    }

    function allowance(address tokenOwner, address spender) public override view returns (uint remaining){
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) public override returns (bool success) {
        require(balances[msg.sender] >= tokens, "You dont have enough tokens!");
        require(tokens > 0);

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender,spender, tokens);

        return true;

    }

    function transferFrom(address from, address to, uint tokens) public virtual override returns (bool success) {
        require(allowed[from][to] >= tokens, "Your are not allowed by the owner");
        require(balances[from] >= tokens, "The owner does not sufficient balance");

        allowed[from][to] -= tokens;
        balances[from] -= tokens;

        balances[to] += tokens;

        return true;

    }

}

contract AmigosICO is Amigos {

    address public admin;
    address payable public deposit;
    uint tokenPrice = 0.001 ether;
    uint public hardCap = 300 ether;
    uint public reaisedAmount;
    uint public saleStart = block.timestamp;
    uint public saleEnd = block.timestamp + 604800; //ICO ends in 1 week
    uint public tokenTradeStart = saleEnd + 604800; //The tokens will be transferable 1 week after sales end 
    uint public maxInvestment = 5 ether;
    uint public minInvestment = 0.1 ether;

    enum State {beforeStart, running , afterEnd, halted}
    State public icoState;

    constructor(address payable  _deposit) {
        admin = msg.sender;
        deposit = _deposit;
        icoState = State.beforeStart;
    }

    modifier onlyAdmin () {
        require(msg.sender == admin, "You are not admin of the contract");
        _;
    }

    function halt() public onlyAdmin {
        icoState = State.halted;
    }

    function resume() public onlyAdmin {
        icoState = State.running;
    }

    function changeDepositAdress(address payable _newDeposit) public onlyAdmin {
        deposit = _newDeposit;
    }

    function getCurrentState() public view returns(State) {
        if(icoState == State.halted){
            return State.halted;
        }else if(block.timestamp < saleStart){
            return State.beforeStart;
        }else if(block.timestamp >= saleStart && block.timestamp <= saleEnd ){
            return State.running;
        }else {
            return State.afterEnd;
        }
    }

    event Invest(address Invetor, uint value, uint tokenValue);

    function invest() public payable returns(bool) {
        icoState = getCurrentState();
        require(icoState == State.running , "The ico is not running");
        require(msg.value >= minInvestment && msg.value <= maxInvestment, "You can invest min of 0.1Eth and max 5eth!");

        reaisedAmount += msg.value;

        require(reaisedAmount <= hardCap, "Hardcap is already reached!");

        uint totalTokensToDeposit = msg.value / tokenPrice;

        balances[msg.sender] += totalTokensToDeposit;
        balances[founder] -= totalTokensToDeposit;

        deposit.transfer(msg.value);

        emit Invest(msg.sender, msg.value, totalTokensToDeposit);

        return true;

    }

    receive() payable external {
        invest();
    }


    function transfer(address to, uint tokens) public override returns (bool success)  {

        require(block.timestamp > tokenTradeStart, "You cannot trade token now, wait for some time");
        Amigos.transfer(to, tokens); //super.transfer(to, tokens)

        return true;

    }

    function transferFrom(address from, address to, uint tokens) public override returns (bool success) {
        require(block.timestamp > tokenTradeStart, "You cannot trade token now, wait for some time");
        Amigos.transferFrom(from, to, tokens);
        return true;
    }

    function burn() public returns(bool){
        icoState = getCurrentState();
        require(icoState == State.afterEnd , "The ico is not over yet");
        balances[founder] = 0;
        return true;

    }

}