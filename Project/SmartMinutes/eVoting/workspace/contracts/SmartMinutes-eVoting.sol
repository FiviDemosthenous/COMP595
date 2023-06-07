pragma solidity >=0.8.0;
// SPDX-License-Identifier: UNLICENSED
contract VotingContract {

    address private owner;

    mapping (string => bytes32) suggestionId;
    mapping (string => uint) suggestionVotes;
    string[] suggestions;
    bytes32[] participants;


    constructor() {
        owner = msg.sender;
    }

    function MeetingSuggestions(string memory _suggestionId, string memory _suggestion) public {

        bytes32 _Hash = keccak256(abi.encodePacked(_suggestion, _suggestionId));
        suggestionId[_suggestion] = _Hash;
        suggestions.push(_suggestion);

    }

    function ShowSuggestions() public view returns (string[] memory) {
        return suggestions;
    }

    function Vote(string memory _suggestionId) public onlyOnce {
        suggestionVotes[_suggestionId] ++;
    }

    modifier onlyOnce() {

        bytes32 _votantHash = keccak256(abi.encodePacked(msg.sender));

        for(uint256 i = 0; i < participants.length; i++) {
            require(participants[i] != _votantHash, "Participant has already voted.");
        }

        participants.push(_votantHash);
        _;

    }

    function ShowSuggestionsVotes(string memory _suggestion) public view returns (uint) {
        return suggestionVotes[_suggestion];
    }

    function ShowVoteResults() public view returns(string memory) {

        string memory _result = "";

        for(uint i = 0; i < suggestions.length; i++) {
            _result = string(abi.encodePacked(_result, "( ", suggestions[i], ", ", uint2str(ShowSuggestionsVotes(suggestions[i])), " ) "));
        }

        return _result;

    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
       
        if (_i == 0) {
            return "0";
        }

        uint j = _i;
        uint len;

        while (j != 0) {
            len++;
            j /= 10;
        }

        bytes memory bstr = new bytes(len);
        uint k = len;

        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }

        return string(bstr);
    }

    function MostVoted() public view returns (string memory) {

        require(suggestions.length > 0, "No Meeting Suggestions.");
        string memory _mostvoted = suggestions[0];
        bool flag;

        for (uint i = 1; i < suggestions.length; i++) {
            if (suggestionVotes[suggestions[i]] > suggestionVotes[_mostvoted]) {
                _mostvoted = suggestions[i];
                flag = false;
            } else if (suggestionVotes[suggestions[i]] == suggestionVotes[_mostvoted]) {
                flag = true;
            }
        }
        if (flag) {
            _mostvoted = "It is a Draw";
        }

        return _mostvoted;
    }

}