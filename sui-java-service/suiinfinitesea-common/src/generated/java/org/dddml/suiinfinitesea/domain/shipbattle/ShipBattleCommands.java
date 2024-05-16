// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.shipbattle;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;

public class ShipBattleCommands {
    private ShipBattleCommands() {
    }

    public static class InitiateBattle extends AbstractShipBattleCommand implements ShipBattleCommand {

        public String getCommandType() {
            return "InitiateBattle";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Player
         */
        private String player;

        public String getPlayer() {
            return this.player;
        }

        public void setPlayer(String player) {
            this.player = player;
        }

        /**
         * Initiator
         */
        private RosterId initiator;

        public RosterId getInitiator() {
            return this.initiator;
        }

        public void setInitiator(RosterId initiator) {
            this.initiator = initiator;
        }

        /**
         * Responder
         */
        private RosterId responder;

        public RosterId getResponder() {
            return this.responder;
        }

        public void setResponder(RosterId responder) {
            this.responder = responder;
        }

        /**
         * Clock
         */
        private String clock;

        public String getClock() {
            return this.clock;
        }

        public void setClock(String clock) {
            this.clock = clock;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class MakeMove extends AbstractShipBattleCommand implements ShipBattleCommand {

        public String getCommandType() {
            return "MakeMove";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Player
         */
        private String player;

        public String getPlayer() {
            return this.player;
        }

        public void setPlayer(String player) {
            this.player = player;
        }

        /**
         * Initiator
         */
        private RosterId initiator;

        public RosterId getInitiator() {
            return this.initiator;
        }

        public void setInitiator(RosterId initiator) {
            this.initiator = initiator;
        }

        /**
         * Responder
         */
        private RosterId responder;

        public RosterId getResponder() {
            return this.responder;
        }

        public void setResponder(RosterId responder) {
            this.responder = responder;
        }

        /**
         * Clock
         */
        private String clock;

        public String getClock() {
            return this.clock;
        }

        public void setClock(String clock) {
            this.clock = clock;
        }

        /**
         * Attacker Command
         */
        private Integer attackerCommand;

        public Integer getAttackerCommand() {
            return this.attackerCommand;
        }

        public void setAttackerCommand(Integer attackerCommand) {
            this.attackerCommand = attackerCommand;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

    public static class TakeLoot extends AbstractShipBattleCommand implements ShipBattleCommand {

        public String getCommandType() {
            return "TakeLoot";
        }

        public void setCommandType(String commandType) {
            //do nothing
        }

        /**
         * Id
         */
        private String id;

        public String getId() {
            return this.id;
        }

        public void setId(String id) {
            this.id = id;
        }

        /**
         * Player
         */
        private String player;

        public String getPlayer() {
            return this.player;
        }

        public void setPlayer(String player) {
            this.player = player;
        }

        /**
         * Loser Player
         */
        private String loserPlayer;

        public String getLoserPlayer() {
            return this.loserPlayer;
        }

        public void setLoserPlayer(String loserPlayer) {
            this.loserPlayer = loserPlayer;
        }

        /**
         * Initiator
         */
        private RosterId initiator;

        public RosterId getInitiator() {
            return this.initiator;
        }

        public void setInitiator(RosterId initiator) {
            this.initiator = initiator;
        }

        /**
         * Responder
         */
        private RosterId responder;

        public RosterId getResponder() {
            return this.responder;
        }

        public void setResponder(RosterId responder) {
            this.responder = responder;
        }

        /**
         * Experience Table
         */
        private String experienceTable;

        public String getExperienceTable() {
            return this.experienceTable;
        }

        public void setExperienceTable(String experienceTable) {
            this.experienceTable = experienceTable;
        }

        /**
         * Clock
         */
        private String clock;

        public String getClock() {
            return this.clock;
        }

        public void setClock(String clock) {
            this.clock = clock;
        }

        /**
         * 1: Take all, 0: Leave it
         */
        private Integer choice;

        public Integer getChoice() {
            return this.choice;
        }

        public void setChoice(Integer choice) {
            this.choice = choice;
        }

        /**
         * Off Chain Version
         */
        private Long offChainVersion;

        public Long getOffChainVersion() {
            return this.offChainVersion;
        }

        public void setOffChainVersion(Long offChainVersion) {
            this.offChainVersion = offChainVersion;
        }

    }

}

