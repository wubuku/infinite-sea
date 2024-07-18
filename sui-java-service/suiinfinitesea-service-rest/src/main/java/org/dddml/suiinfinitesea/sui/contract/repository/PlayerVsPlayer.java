package org.dddml.suiinfinitesea.sui.contract.repository;

public interface PlayerVsPlayer {

    String getShipBattleId();

    String getInitiator();

    String getInitiatorPlayerId();

    String getResponder();

    String getResponderPlayer();

    Integer getWinner();

    Long getBattleEndedAt();
}
