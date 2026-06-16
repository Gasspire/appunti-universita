// SPDX-License-Identifier: CC-BY-SA-4.0
// SPDX-FileCopyrightText: © 2021 Mario Di Raimondo <diraimondo@dmi.unict.it>

pragma solidity ^0.8.0;

import "./exam-2021-06-22-specs.sol";

contract TrustworthyRockPaperScissorsTournament is
    TrustworthyRockPaperScissorsTournamentSpecs
{
    enum Move {Rock, Paper, Scissor}
    enum TournamentStatus {Ended, InProgress}
    struct PlayerInfo {
        address payable id;
        uint8 wins;
        Move[] moves;
    }
    address payable immutable owner;
    uint256 immutable fee;
    uint8 immutable target;
    uint8 public override disputedMatches;
    TournamentStatus status;
    mapping(Player => PlayerInfo) players;

    constructor(
        address payable firstPlayer,
        address payable secondPlayer,
        uint8 targetWins,
        uint256 singleMatchFee
    ) {
        require(
            firstPlayer != address(0) && secondPlayer != address(0),
            "Specify both players"
        );
        require(
            firstPlayer != secondPlayer,
            "The players have to be different"
        );
        require(
            targetWins > 0,
            "The number of matches to win has to be stritcly positive"
        );

        owner = payable(msg.sender);
        fee = singleMatchFee;
        target = targetWins;
        disputedMatches = 0;
        players[Player.First] = PlayerInfo({
            id: firstPlayer,
            wins: 0,
            moves: new Move[](0)
        });
        players[Player.Second] = PlayerInfo({
            id: secondPlayer,
            wins: 0,
            moves: new Move[](0)
        });
        status = TournamentStatus.InProgress;
    }

    function moveRock() public payable override {
        move(Move.Rock);
    }

    function movePaper() public payable override {
        move(Move.Paper);
    }

    function moveScissor() public payable override {
        move(Move.Scissor);
    }

    function move(Move m) internal {
        require(
            status == TournamentStatus.InProgress,
            "Tournament already ended"
        );
        require(
            msg.sender == players[Player.First].id ||
                msg.sender == players[Player.Second].id,
            "Only designated players can take part in the tournament"
        );
        require(msg.value >= fee, "Each game requires a minimum fee payment");

        Player p =
            (
                msg.sender == players[Player.First].id
                    ? Player.First
                    : Player.Second
            );

        players[p].moves.push(m);

        checkMatches();
    }

    function checkMatches() internal {
        assert(status == TournamentStatus.InProgress);

        uint8 matchesWithAllMoves =
            (uint8)(
                players[Player.First].moves.length <
                    players[Player.Second].moves.length
                    ? players[Player.First].moves.length
                    : players[Player.Second].moves.length
            );
        for (uint8 i = disputedMatches; i < matchesWithAllMoves; i++) {
            Move m1 = players[Player.First].moves[i];
            Move m2 = players[Player.Second].moves[i];
            uint8 wins;

            if (m1 != m2) {
                if (
                    (m1 == Move.Rock && m2 == Move.Scissor) ||
                    (m1 == Move.Paper && m2 == Move.Rock) ||
                    (m1 == Move.Scissor && m2 == Move.Paper)
                ) {
                    wins = ++players[Player.First].wins;
                    emit MatchWonBy(Player.First, i);
                } else {
                    wins = ++players[Player.Second].wins;
                    emit MatchWonBy(Player.Second, i);
                }
                if (wins >= target) {
                    payoutTournament();
                    break;
                }
            }
        }
        disputedMatches = matchesWithAllMoves;
    }

    function payoutTournament() internal {
        assert(status == TournamentStatus.InProgress);

        address payable winner;

        if (players[Player.First].wins >= target) {
            winner = players[Player.First].id;
            emit TournamentWonBy(Player.First);
        }
        if (players[Player.Second].wins >= target) {
            winner = players[Player.Second].id;
            emit TournamentWonBy(Player.Second);
        }

        if (winner != payable(0)) {
            status = TournamentStatus.Ended;
            if (address(this).balance > 0) {
                winner.transfer(address(this).balance);
            }

            selfdestruct(owner);
        }
    }
}
