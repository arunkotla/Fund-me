// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

  import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
  //import "./PriceConvertot.sol"

    contract FundMe {

        //using PriceConvertot for uint;


    uint public MinimumUSD = 50 * 1e18;

    address public owner;

    constructor(){
        owner = payable(msg.sender);
    }

   

    address[] public funders;
    mapping(address => uint) public addressToamountfunded;

    function Fund() public payable {
        require(GetConversionRate(msg.value) > MinimumUSD, "Not enough eth");
        funders.push(msg.sender);
        addressToamountfunded[msg.sender] += msg.value;

    }

    function getEthPriceinUSD () public view returns(uint){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (, int price, , , ) = priceFeed.latestRoundData();
        return uint(price * 1e10);
    }

    function GetConversionRate(uint ethamount) public view returns (uint){
        uint EthpriceinUSD = getEthPriceinUSD();
        uint ethamountinUSD = (EthpriceinUSD * ethamount)/ 1e18;
        return ethamountinUSD;
    }


    function Withdraw() onlyOwner public {
        for (uint funderIndex =0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToamountfunded[funder] = 0;    
        }
        payable(msg.sender).transfer(address(this).balance);
        funders = new address[](0);

    }

    modifier onlyOwner {
        require(msg.sender == owner, "only owner can withdraw");
        _;
    }

}