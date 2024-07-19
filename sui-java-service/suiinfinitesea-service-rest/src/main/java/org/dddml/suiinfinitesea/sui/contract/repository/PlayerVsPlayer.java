package org.dddml.suiinfinitesea.sui.contract.repository;

public interface PlayerVsPlayer {

    String getShipBattleId();

    String getInitiator();

    String getInitiatorPlayerId();

    String getInitiatorSenderAddress();

    String getResponder();

    String getResponderPlayerId();

    String getResponderSenderAddress();

    Integer getWinner();

    Long getBattleEndedAt();
}
