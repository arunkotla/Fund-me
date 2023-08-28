// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

  import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint public MinimumUSD = 50 * 1e18;

    function Fund() public payable {
        require(GetConversionRate(msg.value) > 1e18, "Not enough eth");
    }

    function getEthPrice () public view returns(uint){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (, int price, , , ) = priceFeed.latestRoundData();
        return uint(price * 1e10);
    }

    function GetConversionRate(uint ethamount) public view returns (uint){
        uint Ethprice = getEthPrice();
        uint ethamountinUSD = (Ethprice * ethamount)/ 1e18;
        return ethamountinUSD;
    }


    function Withdraw() public {

    }

}