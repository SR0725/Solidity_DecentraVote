// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    // 發起人 (合約的擁有者)
    address public owner;

    // 投票的主題或問題
    string public question;

    // 投票選項 (例如: ["Option1", "Option2", "Option3"])
    string[] public options;

    // 投票開始與結束時間 (Unix Timestamp)
    uint public startTime;
    uint public endTime;

    // 紀錄某個地址是否投過票
    mapping(address => bool) public hasVoted;

    // 紀錄每個選項的投票數： voteCount[選項 index] = 票數
    mapping(uint => uint) public voteCount;

    // 建構子：在部署時設定投票主題、選項、開始及結束時間
    constructor(
        string memory _question,
        string[] memory _options,
        uint _startTime,
        uint _endTime
    ) {
        require(_endTime > _startTime, "End time must be greater than start time");

        owner = msg.sender;
        question = _question;
        options = _options;
        startTime = _startTime;
        endTime = _endTime;
    }

    // 投票函式
    function vote(uint _optionIndex) external {
        // 確認目前時間在投票範圍內
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting period not active");

        // 確認呼叫者尚未投票
        require(!hasVoted[msg.sender], "You have already voted");

        // 確認選項索引正確
        require(_optionIndex < options.length, "Invalid option");

        // 標記投票
        hasVoted[msg.sender] = true;
        voteCount[_optionIndex]++;
    }

    // 取得所有選項投票數 (方便前端顯示)
    function getResults() external view returns (uint[] memory) {
        uint[] memory results = new uint[](options.length);
        for (uint i = 0; i < options.length; i++) {
            results[i] = voteCount[i];
        }
        return results;
    }

    // 取得所有選項 (方便前端顯示)
    function getOptions() external view returns (string[] memory) {
        return options;
    }
}
