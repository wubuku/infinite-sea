package org.dddml.suiinfinitesea.sui.contract.repository;

public interface PlayerVsEnvironment {

    String getShipBattleId();

    String getInitiator();

    String getResponder();

    String getPlayerId();

    Integer getWinner();

    String getPlayerAddress();

    Long getBattleEndedAt();

}
